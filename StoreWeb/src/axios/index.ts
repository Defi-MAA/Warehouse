// utils/cacheManager.ts
class CacheManager {
  private cache = new Map<string, { data: any; timestamp: number }>();
  
  set(key: string, data: any, expireTime: number) {
    this.cache.set(key, {
      data,
      timestamp: Date.now() + expireTime
    });
  }
  
  get(key: string) {
    const item = this.cache.get(key);
    if (!item) return null;
    
    // 检查是否过期
    if (Date.now() > item.timestamp) {
      this.cache.delete(key);
      return null;
    }
    
    return item.data;
  }
  
  clear(key?: string) {
    if (key) {
      this.cache.delete(key);
    } else {
      this.cache.clear();
    }
  }
}

// utils/rateLimiter.ts
class RateLimiter {
  private requests = new Map<string, number[]>();
  
  check(key: string, maxRequests: number, interval: number): boolean {
    const now = Date.now();
    const windowStart = now - interval;
    
    if (!this.requests.has(key)) {
      this.requests.set(key, []);
    }
    
    const timestamps = this.requests.get(key)!;
    // 清理过期的请求记录
    const validTimestamps = timestamps.filter(t => t > windowStart);
    
    if (validTimestamps.length >= maxRequests) {
      return false; // 超过限制
    }
    
    validTimestamps.push(now);
    this.requests.set(key, validTimestamps);
    return true; // 允许请求
  }
  
  reset(key?: string) {
    if (key) {
      this.requests.delete(key);
    } else {
      this.requests.clear();
    }
  }
}

const cacheManager = new CacheManager();
const rateLimiter = new RateLimiter();

// 生成缓存key
const generateCacheKey = (option: AxiosConfig): string => {
  const { url, method, params, data } = option;
  return `${method}:${url}:${JSON.stringify(params)}:${JSON.stringify(data)}`;
};

// 扩展AxiosConfig接口
interface AxiosConfig {
  url: string;
  method?: string;
  params?: any;
  data?: any;
  headers?: any;
  responseType?: any;
  cache?: {
    enabled?: boolean;      // 是否启用缓存
    expireTime?: number;    // 过期时间(ms)，默认5分钟
    key?: string;           // 自定义缓存key
  };
  rateLimit?: {
    enabled?: boolean;      // 是否启用频率限制
    maxRequests?: number;   // 最大请求次数，默认10次
    interval?: number;      // 时间窗口(ms)，默认1分钟
    key?: string;           // 自定义限制key
  };
  skipCache?: boolean;      // 是否跳过缓存
  forceRefresh?: boolean;   // 强制刷新（跳过缓存）
}

import service from './service'
import { CONTENT_TYPE } from '@/constants'
import { useUserStoreWithOut } from '@/store/modules/user'
import { isEmpty, getAuthorization } from '@/utils/index'
import { ElMessage } from 'element-plus'

const request = async (option: AxiosConfig) => {
  const { 
    url, 
    method, 
    params, 
    data, 
    headers, 
    responseType,
    cache = { enabled: false, expireTime: 5 * 60 * 1000 },
    rateLimit = { enabled: false, maxRequests: 10, interval: 60 * 1000 },
    skipCache = false,
    forceRefresh = false
  } = option
  
  const PATH_URL = import.meta.env.VITE_API_BASE_PATH
  
  // 1. 频率限制检查
  if (rateLimit.enabled) {
    const limitKey = rateLimit.key || url || 'default'
    const maxRequests = rateLimit.maxRequests || 10
    const interval = rateLimit.interval || 60 * 1000
    
    const isAllowed = rateLimiter.check(limitKey, maxRequests, interval)
    if (!isAllowed) {
      ElMessage.error(`请求过于频繁，请稍后再试。`)
      return Promise.reject({
        message: `请求过于频繁，请稍后再试（限制：${maxRequests}次/${interval/1000}秒）`,
        code: 'RATE_LIMIT_EXCEEDED',
        url
      })
    }
  }
  
  // 2. 缓存检查
  const cacheKey = cache.key || generateCacheKey(option)
  const cacheEnabled = cache.enabled && !skipCache
  
  if (cacheEnabled && !forceRefresh) {
    const cachedData = cacheManager.get(cacheKey)
    if (cachedData) {
      console.log(`[Cache] 命中缓存: ${method}:${url}`)
      return Promise.resolve(cachedData)
    }
  }
  
  // 3. 处理token和headers
  const userStore = useUserStoreWithOut()
  const token = userStore.getToken
  const tokenKey = userStore.getTokenKey
  const header = headers ?? {}
  
  if (!isEmpty(token) && !isEmpty(tokenKey)) {
    const autho = getAuthorization(token, tokenKey, userStore.getLoginInfo?.username || '')
    header['Authorization'] = "Bearer " + autho
  }
  
  // 4. 发起请求
  try {
    const response = await service.request({
      url: PATH_URL + url,
      method,
      params,
      data: data,
      responseType: responseType,
      headers: {
        'Content-Type': CONTENT_TYPE,
        ...header
      }
    })
    
    // 5. 缓存响应数据
    if (cacheEnabled && response && typeof response === 'object') {
      const expireTime = cache.expireTime || 5 * 60 * 1000
      const dataToCache = 'data' in response ? response.data : response
      cacheManager.set(cacheKey, dataToCache, expireTime)
      console.log(`[Cache] 缓存数据: ${method}:${url}, 过期时间: ${expireTime/1000}秒`)
    }
    
    return response
  } catch (error) {
    console.error(`[Request] 请求失败: ${method}:${url}`, error)
    return Promise.reject(error)
  }
}

export function extractIvAndCipher(encryptedStr: string): { iv: string; cipherText: string } {
  if (!encryptedStr || encryptedStr.length < 16) {
    throw new Error('加密字符串格式错误，长度不足');
  }
  const iv = encryptedStr.substring(0, 16);
  const cipherText = encryptedStr.substring(16);
  return { iv, cipherText };
}

// 导出带缓存和频率限制的请求方法
export default {
  get: <T = any>(option: AxiosConfig) => {
    return request({ method: 'get', ...option }) as Promise<IResponse<T>>
  },
  post: <T = any>(option: AxiosConfig) => {
    return request({ method: 'post', ...option }) as Promise<IResponse<T>>
  },
  delete: <T = any>(option: AxiosConfig) => {
    return request({ method: 'delete', ...option }) as Promise<IResponse<T>>
  },
  put: <T = any>(option: AxiosConfig) => {
    return request({ method: 'put', ...option }) as Promise<IResponse<T>>
  },
  cancelRequest: (url: string | string[]) => {
    return service.cancelRequest(url)
  },
  cancelAllRequest: () => {
    return service.cancelAllRequest()
  },
  // 新增：清除缓存的方法
  clearCache: (key?: string) => {
    return cacheManager.clear(key)
  },
  // 新增：重置频率限制
  resetRateLimit: (key?: string) => {
    return rateLimiter.reset(key)
  }
}