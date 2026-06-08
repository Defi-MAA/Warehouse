// 1. 基础使用（无缓存和限制）
const res1 = await http.get({
    url: '/user/info',
    params: { id: 1 }
  })
  
  // 2. 启用缓存（5分钟）
  const res2 = await http.get({
    url: '/user/info',
    params: { id: 1 },
    cache: {
      enabled: true,
      expireTime: 5 * 60 * 1000  // 5分钟
    }
  })
  
  // 3. 启用频率限制（每分钟最多3次）
  const res3 = await http.get({
    url: '/user/info',
    params: { id: 1 },
    rateLimit: {
      enabled: true,
      maxRequests: 3,
      interval: 60 * 1000
    }
  })
  
  // 4. 同时启用缓存和频率限制
  const res4 = await http.post({
    url: '/user/search',
    data: { keyword: 'vue' },
    cache: {
      enabled: true,
      expireTime: 3 * 60 * 1000
    },
    rateLimit: {
      enabled: true,
      maxRequests: 5,
      interval: 60 * 1000
    }
  })
  
  // 5. 强制刷新（跳过缓存）
  const res5 = await http.get({
    url: '/user/info',
    params: { id: 1 },
    cache: { enabled: true },
    forceRefresh: true
  })
  
  // 6. 跳过缓存（这次请求不使用缓存）
  const res6 = await http.get({
    url: '/user/info',
    params: { id: 1 },
    cache: { enabled: true },
    skipCache: true
  })
  
  // 7. 自定义缓存key
  const res7 = await http.post({
    url: '/user/update',
    data: { id: 1, name: '张三' },
    cache: {
      enabled: true,
      key: 'user_update_1',  // 自定义key
      expireTime: 60 * 1000
    }
  })
  
  // 8. 清除特定缓存
  http.clearCache('get:/user/info:{"id":1}:undefined')
  
  // 9. 重置频率限制
  http.resetRateLimit('/user/info')