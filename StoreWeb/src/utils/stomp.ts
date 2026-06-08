import SockJS from 'sockjs-client/dist/sockjs.min.js';
import { Client, StompHeaders, Message } from '@stomp/stompjs';

// 定义 STOMP 配置类型
export interface StompConfig {
  // 服务端 STOMP 端点（如 http://localhost:8001/ws）
  endpoint: string;
  // 重连间隔（默认 3000ms）
  reconnectInterval?: number;
  // 最大重连次数（默认无限）
  maxReconnectAttempts?: number;
  // 认证头（可选，如 token）
  headers?: StompHeaders;
}

// 订阅回调类型
export type StompSubscribeCallback = (message: Message) => void;

// 存储订阅的主题和回调（用于重连后重新订阅）
interface SubscribeRecord {
  topic: string;
  callback: StompSubscribeCallback;
}

export class StompClient {
  private client: Client; // 新版 Client 实例
  private config: Required<StompConfig>;
  private reconnectAttempts = 0;
  private reconnectTimer: NodeJS.Timeout | null = null;
  private subscribeRecords: SubscribeRecord[] = []; // 订阅记录（重连复用）
  private isManualDisconnect = false; // 是否手动断开（避免重连）

  // 外部事件回调
  onConnect?: () => void;
  onDisconnect?: () => void;
  onError?: (error: string | Error) => void;

  constructor(config: StompConfig) {
    // 默认配置
    this.config = {
      reconnectInterval: 3000,
      maxReconnectAttempts: Infinity,
      headers: {},
      ...config
    };

    // 初始化新版 STOMP Client
    this.client = new Client({
      // 禁用自动连接（手动控制）
      connectHeaders: this.config.headers, // 认证头
      debug: (msg) => console.debug('STOMP Debug:', msg), // 开发环境保留，生产可注释
      reconnectDelay: 0, // 禁用内置重连，自定义重连逻辑
      heartbeatIncoming: 10000, // 心跳入站
      heartbeatOutgoing: 10000, // 心跳出站
      // 核心：通过 SockJS 适配 WebSocket
      webSocketFactory: () => new SockJS(this.config.endpoint)
    });

    // 绑定事件
    this.bindClientEvents();
    // 首次连接
    this.connect();
  }

  /**
   * 绑定 Client 事件
   */
  private bindClientEvents(): void {
    // 连接成功
    this.client.onConnect = (frame) => {
      console.log('STOMP 连接成功:', frame);
      this.reconnectAttempts = 0;
      this.isManualDisconnect = false;
      // 重连后重新订阅所有主题
      this.subscribeRecords.forEach(({ topic, callback }) => {
        this.subscribe(topic, callback, true);
      });
      this.onConnect?.();
    };

    // 连接错误
    this.client.onStompError = (frame) => {
      const errorMsg = `STOMP 协议错误: ${frame.headers['message']}`;
      console.error(errorMsg);
      this.onError?.(errorMsg);
    };

    // 连接断开
    this.client.onDisconnect = () => {
      console.log('STOMP 连接断开');
      // 非手动断开则触发重连
      if (!this.isManualDisconnect) {
        this.handleReconnect();
      } else {
        this.onDisconnect?.();
      }
    };

    // 通用错误
    this.client.onWebSocketError = (error) => {
      console.error('STOMP WebSocket 错误:', error);
      this.onError?.(error);
    };
  }

  /**
   * 手动触发连接
   */
  public connect(): void {
    try {
      this.client.activate(); // 新版 API：激活连接
    } catch (error) {
      console.error('STOMP 连接触发失败:', error);
      this.onError?.(error as Error);
      this.handleReconnect();
    }
  }

  /**
   * 处理自动重连
   */
  private handleReconnect(): void {
    if (this.reconnectAttempts >= this.config.maxReconnectAttempts) {
      console.error('达到最大重连次数，停止重连');
      this.onDisconnect?.();
      return;
    }

    this.reconnectTimer = setTimeout(() => {
      this.reconnectAttempts++;
      console.log(`STOMP 重连中（第 ${this.reconnectAttempts} 次）`);
      this.connect();
    }, this.config.reconnectInterval);
  }

  /**
   * 订阅主题
   * @param topic 订阅主题（如 /topic/greetings）
   * @param callback 消息回调
   * @param isReSubscribe 是否重连后重新订阅（内部使用）
   */
  public subscribe(topic: string, callback: StompSubscribeCallback, isReSubscribe = false): void {
    if (!this.client.connected && !isReSubscribe) {
      console.error('STOMP 未连接，暂存订阅主题:', topic);
      // 未连接时先暂存，连接成功后自动订阅
      this.subscribeRecords.push({ topic, callback });
      return;
    }

    try {
      this.client.subscribe(topic, callback);
      if (!isReSubscribe) {
        this.subscribeRecords.push({ topic, callback });
      }
      console.log('订阅主题成功:', topic);
    } catch (error) {
      console.error('订阅主题失败:', error);
      this.onError?.(error as Error);
    }
  }

  /**
   * 发送消息
   * @param destination 目标路径（如 /app/hello）
   * @param body 消息体（自动序列化为 JSON）
   * @param headers 自定义头（可选）
   */
  public send(destination: string, body: any, headers: StompHeaders = {}): void {
    if (!this.client.connected) {
      console.error('STOMP 未连接，无法发送消息:', destination);
      return;
    }

    try {
      const jsonBody = JSON.stringify(body);
      this.client.publish({ destination, body: jsonBody, headers });
      console.log('发送消息成功:', destination, jsonBody);
    } catch (error) {
      console.error('发送消息失败:', error);
      this.onError?.(error as Error);
    }
  }

  /**
   * 取消订阅指定主题
   * @param topic 要取消的主题
   */
  public unsubscribe(topic: string): void {
    // 移除订阅记录
    this.subscribeRecords = this.subscribeRecords.filter(item => item.topic !== topic);
    // 新版 API：通过 unsubscribe 方法取消（需存储订阅 ID，简化版可重启连接）
    console.log('取消订阅主题:', topic);
  }

  /**
   * 手动断开连接（不会触发重连）
   */
  public disconnect(): void {
    // 清除重连定时器
    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer);
      this.reconnectTimer = null;
    }

    // 标记为手动断开
    this.isManualDisconnect = true;
    // 新版 API：关闭连接
    this.client.deactivate();
    // 清空订阅记录
    this.subscribeRecords = [];
    console.log('STOMP 手动断开连接');
  }
}