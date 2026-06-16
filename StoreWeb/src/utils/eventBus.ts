import mitt, { Emitter } from 'mitt'

// 1. 定义全局所有事件名 + 对应参数类型
export type GlobalEvents = {
  // 事件名: 参数类型
  openSetting: void
  refreshList: { page: number; size: number }
  logout: void // 无参数
  changeTheme: 'light' | 'dark'
}

// 2. 创建带类型的总线
export const eventBus: Emitter<GlobalEvents> = mitt<GlobalEvents>()