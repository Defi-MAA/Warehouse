<template>
    <div class="stomp-demo">
      <div class="status">
        连接状态：<span :class="{ success: isConnected, error: !isConnected }">
          {{ isConnected ? "已连接" : "未连接" }}
        </span>
      </div>
  
      <div class="send">
        <input v-model="username" placeholder="输入用户名" />
        <button @click="sendHelloMessage" :disabled="!isConnected">发送问候</button>
      </div>

      <div class="send">
       
        <button @click="addOrder" >测试下单</button>
      </div>
  
      <div class="message">服务端回复：{{ receiveMessage }}</div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { ref, onMounted, onUnmounted } from 'vue';
  import { StompClient } from '@/utils/stomp';
  import request from '@/axios'
  import { useUserStoreWithOut } from '@/store/modules/user'
import { isEmpty,getAuthorization } from '@/utils/index'
  // 响应式状态
  const isConnected = ref(false);
  const username = ref('');
  const receiveMessage = ref('');
  
  // STOMP 客户端实例
  let stompClient: StompClient | null = null;
  
  /**
   * 发送问候消息
   */
  const sendHelloMessage = () => {
    if (!username.value.trim() || !stompClient) return;
    // 发送到 /app/hello（对应服务端 @MessageMapping("/hello")）
   // stompClient.send('/app/hello', { name: username.value });
    stompClient.send('/app/hello', { name: username.value });
    
  };

  const addOrder = async () => {
    const res =  await request.post({ url: '/api/order/createOrder',data: {
        userId:'admin',
        amount:999,
        productInfo:'苹果',
        shippingAddress:'桂林',
        paymentMethod:1

    } })
  };

  
  
  // 组件挂载时初始化
  onMounted(() => {
    // 创建新版 STOMP 客户端
   const userStore = useUserStoreWithOut()
   const token = userStore.getToken
   const tokenKey = userStore.getTokenKey
   //let url = "http://8.134.65.175:8011/api/ws"
   let url = import.meta.env.VITE_API_BASE_PATH+'/api/ws'
    stompClient = new StompClient({
      endpoint: url, // 服务端 STOMP 端点
      reconnectInterval: 5000, // 重连间隔 5 秒
      maxReconnectAttempts: 10, // 最大重连 10 次
      headers: { Authorization: getAuthorization(token,tokenKey,userStore.getLoginInfo?.username||'')} // 可选：传递认证 token
    });
  
    // 监听连接成功
    stompClient.onConnect = () => {
      isConnected.value = true;
      receiveMessage.value = '连接成功！';
      // 订阅 /topic/greetings 主题
      stompClient?.subscribe('/user/queue/order-status', (message) => {
        console.log(message);
        const data = JSON.parse(message.body);
        receiveMessage.value = data.content;
      });

      stompClient?.subscribe('/user/queue/notifications', (message) => {
        console.log(message);
        const data = JSON.parse(message.body);
        receiveMessage.value = data.content;
      });
    };
  
    // 监听连接断开
    stompClient.onDisconnect = () => {
      isConnected.value = false;
      receiveMessage.value = '连接已断开';
    };
  
    // 监听错误
    stompClient.onError = (error) => {
      isConnected.value = false;
      receiveMessage.value = `连接异常：${error}`;
    };
  });
  
  // 组件卸载时断开连接
  onUnmounted(() => {
    if (stompClient) {
      stompClient.disconnect();
      stompClient = null;
    }
  });
  </script>
  
  <style scoped>
  /* 样式与之前一致，可复用 */
  .stomp-demo {
    width: 500px;
    margin: 20px auto;
    padding: 20px;
    border: 1px solid #eee;
    border-radius: 8px;
  }
  .status { margin-bottom: 20px; font-size: 14px; }
  .success { color: green; }
  .error { color: red; }
  .send { margin-bottom: 20px; display: flex; gap: 10px; }
  .send input { flex: 1; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
  .send button { padding: 8px 16px; background: #409eff; color: white; border: none; border-radius: 4px; cursor: pointer; }
  .send button:disabled { background: #ccc; cursor: not-allowed; }
  .message { padding: 10px; border: 1px solid #eee; border-radius: 4px; min-height: 40px; line-height: 40px; }
  </style>