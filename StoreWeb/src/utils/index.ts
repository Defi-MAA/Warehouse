import  CryptoJS from 'crypto-js';
/**
 *
 * @param component 需要注册的组件
 * @param alias 组件别名
 * @returns any
 */
export const withInstall = <T>(component: T, alias?: string) => {
  const comp = component as any
  comp.install = (app: any) => {
    app.component(comp.name || comp.displayName, component)
    if (alias) {
      app.config.globalProperties[alias] = component
    }
  }
  return component as T & Plugin
}

/**
 * @param str 需要转下划线的驼峰字符串
 * @returns 字符串下划线
 */
export const humpToUnderline = (str: string): string => {
  return str.replace(/([A-Z])/g, '-$1').toLowerCase()
}

/**
 * @param str 需要转驼峰的下划线字符串
 * @returns 字符串驼峰
 */
export const underlineToHump = (str: string): string => {
  if (!str) return ''
  return str.replace(/\-(\w)/g, (_, letter: string) => {
    return letter.toUpperCase()
  })
}

/**
 * 驼峰转横杠
 */
export const humpToDash = (str: string): string => {
  return str.replace(/([A-Z])/g, '-$1').toLowerCase()
}

export const setCssVar = (prop: string, val: any, dom = document.documentElement) => {
  dom.style.setProperty(prop, val)
}

export const getCssVar = (prop: string, dom = document.documentElement) => {
  return getComputedStyle(dom).getPropertyValue(prop)
}

/**
 * 查找数组对象的某个下标
 * @param {Array} ary 查找的数组
 * @param {Functon} fn 判断的方法
 */
export const findIndex = <T = Recordable>(ary: Array<T>, fn: Fn): number => {
  if (ary.findIndex) {
    return ary.findIndex(fn)
  }
  let index = -1
  ary.some((item: T, i: number, ary: Array<T>) => {
    const ret: T = fn(item, i, ary)
    if (ret) {
      index = i
      return ret
    }
  })
  return index
}

export const trim = (str: string) => {
  return str.replace(/(^\s*)|(\s*$)/g, '')
}


export const isEmpty = (value: any) => {
  return (
    value === undefined ||
    value === null ||
    (typeof value === "object" && Object.keys(value).length === 0) ||
    (typeof value === "string" && value.trim().length === 0)
  );
}

/**
 * 移除对象键名中的下划线
 */
export const removeUnderscoreFromKeys = (obj: any) => {
  if (obj === null || typeof obj !== 'object') {
    return obj;
  }
  
  if (Array.isArray(obj)) {
    return obj.map(item => removeUnderscoreFromKeys(item));
  }
  
  const newObj = {};
  for (const [key, value] of Object.entries(obj)) {
    const newKey = key.replace(/_/g, '');
    newObj[newKey] = removeUnderscoreFromKeys(value);
  }
  return newObj;
}


export const getTimestamp = () => {  
  let myTimestamp = (Date.now() + '').substr(0, 10);
  let timestamp = (parseInt(myTimestamp));
  return timestamp;
}

/**
 * @param {Date | number | string} time 需要转换的时间
 * @param {String} fmt 需要转换的格式 如 yyyy-MM-dd、yyyy-MM-dd HH:mm:ss
 */
export function formatTime(time: Date | number | string, fmt: string) {
  if (!time) return ''
  else {
    const date = new Date(time)
    const o = {
      'M+': date.getMonth() + 1,
      'd+': date.getDate(),
      'H+': date.getHours(),
      'm+': date.getMinutes(),
      's+': date.getSeconds(),
      'q+': Math.floor((date.getMonth() + 3) / 3),
      S: date.getMilliseconds()
    }
    if (/(y+)/.test(fmt)) {
      fmt = fmt.replace(RegExp.$1, (date.getFullYear() + '').substr(4 - RegExp.$1.length))
    }
    for (const k in o) {
      if (new RegExp('(' + k + ')').test(fmt)) {
        fmt = fmt.replace(
          RegExp.$1,
          RegExp.$1.length === 1 ? o[k] : ('00' + o[k]).substr(('' + o[k]).length)
        )
      }
    }
    return fmt
  }
}

/**
 * 生成随机字符串
 */
export function toAnyString() {
  const str: string = 'xxxxx-xxxxx-4xxxx-yxxxx-xxxxx'.replace(/[xy]/g, (c: string) => {
    const r: number = (Math.random() * 16) | 0
    const v: number = c === 'x' ? r : (r & 0x3) | 0x8
    return v.toString()
  })
  return str
}

/**
 * 首字母大写
 */
export function firstUpperCase(str: string) {
  return str.toLowerCase().replace(/( |^)[a-z]/g, (L) => L.toUpperCase())
}

/**
 * 把对象转为formData
 */
export function objToFormData(obj: Recordable) {
  const formData = new FormData()
  Object.keys(obj).forEach((key) => {
    formData.append(key, obj[key])
  })
  return formData
}

export function getTimes() {
  let myTimestamp = getTimestamp();
  let dateDiff = localStorage.getItem('dateDiff')||'0';
  if (isEmpty(dateDiff))
    dateDiff = '0';
  let timestamp = (myTimestamp + parseInt(dateDiff));
  return timestamp;
}

/**
 * Base64 加密（支持中文）
 * @param str 待加密的字符串
 * @returns 加密后的 Base64 字符串
 */
export function base64Encode(str: string): string {
  try {
    // 先将字符串转为 UTF-8 编码（解决中文乱码），再进行 Base64 加密
    const utf8Str = unescape(encodeURIComponent(str));
    return btoa(utf8Str);
  } catch (error) {
    console.error('Base64 加密失败：', error);
    return '';
  }
}

/**
 * Base64 解密（支持中文）
 * @param base64Str 待解密的 Base64 字符串
 * @returns 解密后的原始字符串
 */
export function base64Decode(base64Str: string): string {
  try {
    // 先解密 Base64，再转回 UTF-8 编码
    const utf8Str = atob(base64Str);
    return decodeURIComponent(escape(utf8Str));
  } catch (error) {
    console.error('Base64 解密失败：', error);
    return '';
  }
}

export function getAuthorization(token:string,tokenKey: string,username: string) {
  const data = token +'^@^'+getTimes()+'^@^'+username;
  const AES_KEY_256 = CryptoJS.enc.Utf8.parse(base64Decode(tokenKey));  
  const encryptedParams = CryptoJS.AES.encrypt(data, AES_KEY_256, {
    mode: CryptoJS.mode.ECB,
    padding: CryptoJS.pad.Pkcs7
  });
  return encryptedParams.toString();
}


export const param2Obj = (url: any) => {
  const search = decodeURIComponent(url.split('?')[1]).replace(/\+/g, ' ')
  if (!search) {
    return {}
  }
  const obj = {}
  const searchArr = search.split('&')
  searchArr.forEach(v => {
    const index = v.indexOf('=')
    if (index !== -1) {
      const name = v.substring(0, index)
      const val = v.substring(index + 1, v.length)
      obj[name] = val
    }
  })
  return obj
}



