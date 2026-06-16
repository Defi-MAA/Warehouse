import request from '@/axios'

// 系统设置完整配置类型
export interface AppSettingConfig {
  // 界面显示
  breadcrumb: boolean
  breadcrumbIcon: boolean
  hamburger: boolean
  screenfull: boolean
  size: boolean
  locale: boolean
  tagsView: boolean
  tagsViewIcon: boolean
  logo: boolean
  uniqueOpened: boolean
  fixedHeader: boolean
  footer: boolean
  greyMode: boolean
  layout: string
  isDark: boolean
  currentSize: string
  // 主题配色
  theme: {
    elColorPrimary: string
    leftMenuBorderColor: string
    leftMenuBgColor: string
    leftMenuBgLightColor: string
    leftMenuBgActiveColor: string
    leftMenuCollapseBgActiveColor: string
    leftMenuTextColor: string
    leftMenuTextActiveColor: string
    logoTitleTextColor: string
    logoBorderColor: string
    topHeaderBgColor: string
    topHeaderTextColor: string
    topHeaderHoverColor: string
    topToolBorderColor: string
  }
}

/**
 * 获取用户保存的系统配置
 */
export function getSettingConfigApi() {
  return request.post({url:'/api/config/getTheme',data:{}})
}

/**
 * 保存系统配置到后端
 * @param data 完整配置对象
 */
export function saveSettingConfigApi(data: AppSettingConfig) {
  return request.post({url:'/api/config/saveTheme',data})
}