import 'vue/jsx'

// 引入windi css
import '@/plugins/unocss'

// 导入全局的svg图标
import '@/plugins/svgIcon'

// 初始化多语言
import { setupI18n } from '@/plugins/vueI18n'

// 引入状态管理
import { setupStore } from '@/store'

// 全局组件
import { setupGlobCom } from '@/components'

// 引入element-plus
import { setupElementPlus } from '@/plugins/elementPlus'

// 引入全局样式
import '@/styles/index.less'

// 引入动画
import '@/plugins/animate.css'

// 路由
import { setupRouter } from './router'

// 权限
import { setupPermission } from './directives'

import { createApp } from 'vue'

import App from './App.vue'

import './permission'

import ElementPlus from 'element-plus'

// 引入打印插件
import { hiPrintPlugin } from 'vue-plugin-hiprint'

// 取消自动连接直接打印客户端
if (hiPrintPlugin.disAutoConnect) {
  hiPrintPlugin.disAutoConnect();
}


// 创建实例
const setupAll = async () => {
  const app = createApp(App)

  await setupI18n(app)

  setupStore(app)

  setupGlobCom(app)

  setupElementPlus(app)

  setupRouter(app)

  setupPermission(app)


  app.use(ElementPlus)
  // 注册插件，第二个参数是给插件起的别名（可选），之后可以通过 this.$hiprint 访问
  app.use(hiPrintPlugin, '$hiprint')
 

  app.mount('#app')
}

setupAll()
