// 定义通用的消息类型（根据你的业务调整）
export interface WsMessage<T = any> {
    type: string; // 消息类型（如 "chat"、"notify"、"heartbeat"）
    data: T;      // 消息内容
    timestamp: number; // 时间戳
  }
  
  // 定义 WebSocket 配置项
  interface WsOptions {
    url: string; // WebSocket 服务地址（如 ws://localhost:8080/ws）
    reconnectInterval?: number; // 重连间隔（默认 3000ms）
    maxReconnectAttempts?: number; // 最大重连次数（默认无限）
    heartbeatInterval?: number; // 心跳间隔（默认 10000ms）
    heartbeatMsg?: WsMessage; // 心跳消息（默认心跳包）
  }
  
  export class WebSocketClient{
    private ws: WebSocket | null = null;
    private options: Required<WsOptions>;
    private reconnectAttempts = 0; // 当前重连次数
    private heartbeatTimer: NodeJS.Timeout | null = null; // 心跳定时器
    private reconnectTimer: NodeJS.Timeout | null = null; // 重连定时器
  
    // 事件回调（供外部监听）
    onOpen?: () => void;
    onMessage?: <T>(message: WsMessage<T>) => void;
    onError?: (error: Event) => void;
    onClose?: (code: number, reason: string) => void;
  
    constructor(options: WsOptions) {
      // 默认配置
      this.options = {
        reconnectInterval: 3000,
        maxReconnectAttempts: Infinity,
        heartbeatInterval: 10000,
        heartbeatMsg: {
          type: "heartbeat",
          data: "ping",
          timestamp: Date.now()
        },
        ...options
      };
  
      // 初始化连接
      this.connect();
    }
  
    /**
     * 建立 WebSocket 连接
     */
    private connect(): void {
      try {
        this.ws = new WebSocket(this.options.url);
  
        // 连接成功
        this.ws.onopen = () => {
          console.log("WebSocket 连接成功");
          this.reconnectAttempts = 0; // 重置重连次数
          this.onOpen?.();
          this.startHeartbeat(); // 启动心跳
        };
  
        // 接收消息
        this.ws.onmessage = (event: MessageEvent) => {
          try {
            // 解析消息（保证类型安全）
            const message: WsMessage = JSON.parse(event.data);
            this.onMessage?.(message);
          } catch (error) {
            console.error("WebSocket 消息解析失败:", error, event.data);
          }
        };
  
        // 连接错误
        this.ws.onerror = (error) => {
          console.error("WebSocket 错误:", error);
          this.onError?.(error);
        };
  
        // 连接关闭
        this.ws.onclose = (event) => {
          console.log("WebSocket 关闭:", event.code, event.reason);
          this.onClose?.(event.code, event.reason);
          
          // 停止心跳
          this.stopHeartbeat();
          
          // 自动重连（排除手动关闭的情况）
          if (event.code !== 1000 && this.reconnectAttempts < this.options.maxReconnectAttempts) {
            this.reconnectTimer = setTimeout(() => {
              this.reconnectAttempts++;
              console.log(`WebSocket 重连中（第 ${this.reconnectAttempts} 次）`);
              this.connect();
            }, this.options.reconnectInterval);
          }
        };
      } catch (error) {
        console.error("WebSocket 初始化失败:", error);
        this.onError?.(error as Event);
      }
    }
  
    /**
     * 发送消息
     * @param message 要发送的消息（自动包装为 WsMessage 格式）
     */
    public send<T>(type: string, data: T): void {
      if (!this.ws || this.ws.readyState !== WebSocket.OPEN) {
        console.error("WebSocket 未连接，无法发送消息");
        return;
      }
  
      const message: WsMessage<T> = {
        type,
        data,
        timestamp: Date.now()
      };
  
      try {
        this.ws.send(JSON.stringify(message));
      } catch (error) {
        console.error("WebSocket 发送消息失败:", error);
      }
    }
  
    /**
     * 启动心跳（防止连接断开）
     */
    private startHeartbeat(): void {
      this.stopHeartbeat(); // 先停止旧的心跳
      this.heartbeatTimer = setInterval(() => {
        this.send(this.options.heartbeatMsg.type, this.options.heartbeatMsg.data);
      }, this.options.heartbeatInterval);
    }
  
    /**
     * 停止心跳
     */
    private stopHeartbeat(): void {
      if (this.heartbeatTimer) {
        clearInterval(this.heartbeatTimer);
        this.heartbeatTimer = null;
      }
    }
  
    /**
     * 手动关闭连接（不会触发重连）
     */
    public close(): void {
      // 清除定时器
      if (this.reconnectTimer) clearTimeout(this.reconnectTimer);
      this.stopHeartbeat();
  
      // 关闭连接
      if (this.ws) {
        this.ws.close(1000, "手动关闭");
        this.ws = null;
      }
    }
  }

  export default WebSocketClient;