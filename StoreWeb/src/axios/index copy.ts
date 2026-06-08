import service from './service'

import { CONTENT_TYPE } from '@/constants'
import { useUserStoreWithOut } from '@/store/modules/user'
import { isEmpty,getAuthorization } from '@/utils/index'

const request = (option: AxiosConfig) => {
  const { url, method, params, data, headers, responseType } = option
  const PATH_URL = import.meta.env.VITE_API_BASE_PATH
  //console.log(PATH_URL + url)
  const userStore = useUserStoreWithOut()
  const token = userStore.getToken
  const tokenKey = userStore.getTokenKey
  const header = headers ?? {}
  if (!isEmpty(token)&&!isEmpty(tokenKey)) {
    const autho =  getAuthorization(token,tokenKey,userStore.getLoginInfo?.username||'')
    header['Authorization'] = "Bearer " + autho
  }
  return service.request({
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
}



export function extractIvAndCipher(encryptedStr: string): { iv: string; cipherText: string } {
  if (!encryptedStr || encryptedStr.length < 16) {
    throw new Error('加密字符串格式错误，长度不足');
  }
  // 截取前16位作为IV，剩余部分为密文
  const iv = encryptedStr.substring(0, 16);
  const cipherText = encryptedStr.substring(16);
  return { iv, cipherText };
}



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
  }
}


