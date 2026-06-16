<script setup lang="ts">
import { ElDrawer, ElDivider, ElMessage } from 'element-plus'
import { ref, unref,onMounted,onUnmounted } from 'vue'
import { useI18n } from '@/hooks/web/useI18n'
import { ThemeSwitch } from '@/components/ThemeSwitch'
import { useCssVar } from '@vueuse/core'
import { useAppStore } from '@/store/modules/app'
import { trim, setCssVar } from '@/utils'
import ColorRadioPicker from './components/ColorRadioPicker.vue'
import InterfaceDisplay from './components/InterfaceDisplay.vue'
import LayoutRadioPicker from './components/LayoutRadioPicker.vue'
import { useStorage } from '@/hooks/web/useStorage'
import { useClipboard } from '@vueuse/core'
import { useDesign } from '@/hooks/web/useDesign'
import { getSettingConfigApi, saveSettingConfigApi, type AppSettingConfig } from './setting'
const { clear: storageClear } = useStorage('localStorage')
import { eventBus } from '@/utils/eventBus'

const { getPrefixCls } = useDesign()

const prefixCls = getPrefixCls('setting')

const appStore = useAppStore()

const { t } = useI18n()

const drawer = ref(false)

// 主题色相关
const systemTheme = ref(appStore.getTheme.elColorPrimary)

const setSystemTheme = (color: string) => {
  setCssVar('--el-color-primary', color)
  appStore.setTheme({ elColorPrimary: color })
  const leftMenuBgColor = useCssVar('--left-menu-bg-color', document.documentElement)
  setMenuTheme(trim(unref(leftMenuBgColor) as string))
}

// 头部主题相关
const headerTheme = ref(appStore.getTheme.topHeaderBgColor || '')

const setHeaderTheme = (color: string) => {
  appStore.setHeaderTheme(color)
}

// 菜单主题相关
const menuTheme = ref(appStore.getTheme.leftMenuBgColor || '')

const setMenuTheme = (color: string) => {
  appStore.setMenuTheme(color)
}

// 监听layout变化，重置一些主题色
// watch(
//   () => layout.value,
//   (n) => {
//     if (n === 'top' && !appStore.getIsDark) {
//       headerTheme.value = '#fff'
//       setHeaderTheme('#fff')
//     } else {
//       setMenuTheme(unref(menuTheme))
//     }
//   }
// )

// 拷贝
const copyConfig = async () => {
  const { copy, copied, isSupported } = useClipboard({
    source: `
      // 面包屑
      breadcrumb: ${appStore.getBreadcrumb},
      // 面包屑图标
      breadcrumbIcon: ${appStore.getBreadcrumbIcon},
      // 折叠图标
      hamburger: ${appStore.getHamburger},
      // 全屏图标
      screenfull: ${appStore.getScreenfull},
      // 尺寸图标
      size: ${appStore.getSize},
      // 多语言图标
      locale: ${appStore.getLocale},
      // 标签页
      tagsView: ${appStore.getTagsView},
      // 标签页图标
      getTagsViewIcon: ${appStore.getTagsViewIcon},
      // logo
      logo: ${appStore.getLogo},
      // 菜单手风琴
      uniqueOpened: ${appStore.getUniqueOpened},
      // 固定header
      fixedHeader: ${appStore.getFixedHeader},
      // 页脚
      footer: ${appStore.getFooter},
      // 灰色模式
      greyMode: ${appStore.getGreyMode},
      // layout布局
      layout: '${appStore.getLayout}',
      // 暗黑模式
      isDark: ${appStore.getIsDark},
      // 组件尺寸
      currentSize: '${appStore.getCurrentSize}',
      // 主题相关
      theme: {
        // 主题色
        elColorPrimary: '${appStore.getTheme.elColorPrimary}',
        // 左侧菜单边框颜色
        leftMenuBorderColor: '${appStore.getTheme.leftMenuBorderColor}',
        // 左侧菜单背景颜色
        leftMenuBgColor: '${appStore.getTheme.leftMenuBgColor}',
        // 左侧菜单浅色背景颜色
        leftMenuBgLightColor: '${appStore.getTheme.leftMenuBgLightColor}',
        // 左侧菜单选中背景颜色
        leftMenuBgActiveColor: '${appStore.getTheme.leftMenuBgActiveColor}',
        // 左侧菜单收起选中背景颜色
        leftMenuCollapseBgActiveColor: '${appStore.getTheme.leftMenuCollapseBgActiveColor}',
        // 左侧菜单字体颜色
        leftMenuTextColor: '${appStore.getTheme.leftMenuTextColor}',
        // 左侧菜单选中字体颜色
        leftMenuTextActiveColor: '${appStore.getTheme.leftMenuTextActiveColor}',
        // logo字体颜色
        logoTitleTextColor: '${appStore.getTheme.logoTitleTextColor}',
        // logo边框颜色
        logoBorderColor: '${appStore.getTheme.logoBorderColor}',
        // 头部背景颜色
        topHeaderBgColor: '${appStore.getTheme.topHeaderBgColor}',
        // 头部字体颜色
        topHeaderTextColor: '${appStore.getTheme.topHeaderTextColor}',
        // 头部悬停颜色
        topHeaderHoverColor: '${appStore.getTheme.topHeaderHoverColor}',
        // 头部边框颜色
        topToolBorderColor: '${appStore.getTheme.topToolBorderColor}'
      }
    `,
    legacy: true
  })
  if (!isSupported) {
    ElMessage.error(t('setting.copyFailed'))
  } else {
    await copy()
    if (unref(copied)) {
      ElMessage.success(t('setting.copySuccess'))
    }
  }
}

/**
 * 组装当前完整配置对象（传给后端接口）
 */
 function getCurrentFullConfig(): AppSettingConfig {
  const theme = appStore.getTheme
  return {
    breadcrumb: appStore.getBreadcrumb,
    breadcrumbIcon: appStore.getBreadcrumbIcon,
    hamburger: appStore.getHamburger,
    screenfull: appStore.getScreenfull,
    size: appStore.getSize,
    locale: appStore.getLocale,
    tagsView: appStore.getTagsView,
    tagsViewIcon: appStore.getTagsViewIcon,
    logo: appStore.getLogo,
    uniqueOpened: appStore.getUniqueOpened,
    fixedHeader: appStore.getFixedHeader,
    footer: appStore.getFooter,
    greyMode: appStore.getGreyMode,
    layout: appStore.getLayout,
    isDark: appStore.getIsDark,
    currentSize: appStore.getCurrentSize,
    theme: { ...theme }
  }
}

const loading = ref(false)
/**
 * 后端加载配置，覆盖本地store状态
 */
async function loadConfigFromApi() {
  try {
    loading.value = true
    const res = await getSettingConfigApi()
    const config = res.data
    if (!config) return

    // 批量更新界面显示配置
    appStore.setBreadcrumb(config.breadcrumb)
    appStore.setBreadcrumbIcon(config.breadcrumbIcon)
    appStore.setHamburger(config.hamburger)
    appStore.setScreenfull(config.screenfull)
    appStore.setSize(config.size)
    appStore.setLocale(config.locale)
    appStore.setTagsView(config.tagsView)
    appStore.setTagsViewIcon(config.tagsViewIcon)
    appStore.setLogo(config.logo)
    appStore.setUniqueOpened(config.uniqueOpened)
    appStore.setFixedHeader(config.fixedHeader)
    appStore.setFooter(config.footer)
    appStore.setGreyMode(config.greyMode)
    appStore.setLayout(config.layout)
    appStore.setIsDark(config.isDark)
    appStore.setCurrentSize(config.currentSize)

    // 更新主题配色
    appStore.setTheme(config.theme)
    appStore.setHeaderTheme(config.theme.topHeaderBgColor)
    appStore.setMenuTheme(config.theme.leftMenuBgColor)

    // 同步页面本地绑定变量
    systemTheme.value = config.theme.elColorPrimary
    headerTheme.value = config.theme.topHeaderBgColor
    menuTheme.value = config.theme.leftMenuBgColor

    // 实时更新CSS变量
    setCssVar('--el-color-primary', config.theme.elColorPrimary)
  } catch (err) {
    // 无后端配置时静默使用本地默认，无需报错
    console.log('暂无保存的后台配置，使用本地默认', err)
  } finally {
    loading.value = false
  }
}

/**
 * 保存配置到后端接口（替换原复制逻辑）
 */
async function saveConfigToApi() {
  try {
    loading.value = true
    const fullConfig = getCurrentFullConfig()
    await saveSettingConfigApi(fullConfig)
    ElMessage.success(t('setting.saveSuccess', '配置保存成功'))
  } catch (err){
    ElMessage.error(t('setting.saveFailed', '配置保存失败，请重试'))
    console.error('保存配置接口异常', err)
  } finally {
    loading.value = false
  }
}

const handleOpenModal = () => {
  drawer.value = true
 }
// 页面挂载时加载后端配置
onMounted(() => {
  eventBus.on('openSetting', handleOpenModal)
  loadConfigFromApi()
})

onUnmounted(() => {
  eventBus.off('openSetting', handleOpenModal)
})



// 清空缓存
const clear = () => {
  storageClear()
  window.location.reload()
}
</script>

<template>
  <!-- <div
    :class="prefixCls"
    class="fixed top-[45%] right-0 w-40px h-40px flex items-center justify-center bg-[var(--el-color-primary)] cursor-pointer z-10"
    @click="drawer = true"
  >
    <Icon icon="vi-ant-design:setting-outlined" color="#fff" />
  </div> -->

  <ElDrawer v-model="drawer" direction="rtl" size="350px" :z-index="4000">
    <template #header>
      <span class="text-16px font-700">布局主题</span>
    </template>

    <div class="text-center">
      <!-- 主题 -->
      <!-- <ElDivider>{{ t('setting.theme') }}</ElDivider>
      <ThemeSwitch /> -->

      <!-- 布局 -->
      <ElDivider>{{ t('setting.layout') }}</ElDivider>
      <LayoutRadioPicker />

      <!-- 系统主题 -->
      <ElDivider>{{ t('setting.systemTheme') }}</ElDivider>
      <ColorRadioPicker
        v-model="systemTheme"
        :schema="[
          '#409eff',
          '#009688',
          '#536dfe',
          '#ff5c93',
          '#ee4f12',
          '#0096c7',
          '#9c27b0',
          '#ff9800'
        ]"
        @change="setSystemTheme"
      />

      <!-- 头部主题 -->
      <ElDivider>{{ t('setting.headerTheme') }}</ElDivider>
      <ColorRadioPicker
        v-model="headerTheme"
        :schema="[
          '#fff',
          '#151515',
          '#5172dc',
          '#e74c3c',
          '#24292e',
          '#394664',
          '#009688',
          '#383f45'
        ]"
        @change="setHeaderTheme"
      />

      <!-- 菜单主题 -->
      <ElDivider>{{ t('setting.menuTheme') }}</ElDivider>
      <ColorRadioPicker
        v-model="menuTheme"
        :schema="[
          '#fff',
          '#001529',
          '#212121',
          '#273352',
          '#191b24',
          '#383f45',
          '#001628',
          '#344058'
        ]"
        @change="setMenuTheme"
      />
    </div>

    <!-- 界面显示 -->
    <ElDivider>{{ t('setting.interfaceDisplay') }}</ElDivider>
    <InterfaceDisplay />

    <ElDivider />
    <div>
      <BaseButton type="primary" class="w-full" @click="saveConfigToApi">
        保存配置
      </BaseButton>
    </div>
    <!-- <div class="mt-5px">
      <BaseButton type="danger" class="w-full" @click="clear">
        {{ t('setting.clearAndReset') }}
      </BaseButton>
    </div> -->
  </ElDrawer>
</template>

<style lang="less" scoped>
@prefix-cls: ~'@{adminNamespace}-setting';

.@{prefix-cls} {
  border-radius: 6px 0 0 6px;
}
</style>
