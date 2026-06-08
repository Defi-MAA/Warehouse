<script setup lang="ts">
import { onBeforeUnmount, computed, PropType, unref, nextTick, ref, watch, shallowRef } from 'vue'
import { Editor, Toolbar } from '@wangeditor/editor-for-vue'
import { IDomEditor, IEditorConfig, i18nChangeLanguage } from '@wangeditor/editor'
import { propTypes } from '@/utils/propTypes'
import { isNumber } from '@/utils/is'
import { ElMessage } from 'element-plus'
import { useLocaleStore } from '@/store/modules/locale'

const localeStore = useLocaleStore()

const currentLocale = computed(() => localeStore.getCurrentLocale)

i18nChangeLanguage(unref(currentLocale).lang)

const props = defineProps({
  editorId: propTypes.string.def('wangeEditor-1'),
  height: propTypes.oneOfType([Number, String]).def('500px'),
  editorConfig: {
    type: Object as PropType<IEditorConfig>,
    default: () => undefined
  },
  modelValue: propTypes.string.def('')
})

const emit = defineEmits(['change', 'update:modelValue'])

// 编辑器实例，必须用 shallowRef
const editorRef = shallowRef<IDomEditor>()

const valueHtml = ref('')

watch(
  () => props.modelValue,
  (val: string) => {
    if (val === unref(valueHtml)) return
    valueHtml.value = val
  }
)

// 监听
watch(
  () => valueHtml.value,
  (val: string) => {
    emit('update:modelValue', val)
  }
)

const handleCreated = (editor: IDomEditor) => {
  editorRef.value = editor
  valueHtml.value = props.modelValue
}
import { useUserStoreWithOut } from '@/store/modules/user'
import { getAuthorization } from '@/utils/index'
const getAuth = (() => {
    const userStore = useUserStoreWithOut()
    const token = userStore.getToken
    const tokenKey = userStore.getTokenKey
    return getAuthorization(token, tokenKey, userStore.getLoginInfo?.username || '')

})

// 编辑器配置
const editorConfig = computed((): IEditorConfig => {
  return Object.assign(
    {
      readOnly: false,
      customAlert: (s: string, t: string) => {
        switch (t) {
          case 'success':
            ElMessage.success(s)
            break
          case 'info':
            ElMessage.info(s)
            break
          case 'warning':
            ElMessage.warning(s)
            break
          case 'error':
            ElMessage.error(s)
            break
          default:
            ElMessage.info(s)
            break
        }
      },
      autoFocus: false,
      scroll: true,
      uploadImgShowBase64: true
    },
    props.editorConfig || {
      placeholder: '请输入内容...',
      MENU_CONF: {
        // 图片上传配置
        uploadImage: {
          server: import.meta.env.VITE_API_BASE_PATH + '/api/file/imgupload',   // 👈 你的图片上传接口地址
          fieldName: 'file',              // 后端接收文件的字段名，默认 'file'
          maxFileSize: 10 * 1024 * 1024, // 单个文件最大体积，默认 10M
          maxNumberOfFiles: 10,           // 最多可上传文件数，默认 100
          allowedFileTypes: ['image/*'],  // 允许的文件类型

          // 可选：携带额外参数
          meta: {
            // token: 'your-token'
          },

          // 可选：携带自定义请求头
          headers: {
            'Authorization':"Bearer "+  getAuth()
            // 'X-Custom-Header': 'value'
          },

          // 可选：跨域是否携带 cookie
          withCredentials: true,

          // 可选：超时时间（毫秒）
          timeout: 30 * 1000,
        },

        // 视频上传配置
        uploadVideo: {
          server: '/api/upload/video',   // 👈 你的视频上传接口地址
          fieldName: 'file',              // 后端接收文件的字段名
          maxFileSize: 100 * 1024 * 1024, // 视频通常较大，建议调大限制
          maxNumberOfFiles: 5,
          allowedFileTypes: ['video/*'],

          // 其他可选配置同上
        }
      }

    }
  )
})

const editorStyle = computed(() => {
  return {
    height: isNumber(props.height) ? `${props.height}px` : props.height
  }
})

// 回调函数
const handleChange = (editor: IDomEditor) => {
  emit('change', editor)
}

// 组件销毁时，及时销毁编辑器
onBeforeUnmount(() => {
  const editor = unref(editorRef.value)

  // 销毁，并移除 editor
  editor?.destroy()
})

const getEditorRef = async (): Promise<IDomEditor> => {
  await nextTick()
  return unref(editorRef.value) as IDomEditor
}

defineExpose({
  getEditorRef
})
</script>

<template>
  <div class="border-1 border-solid border-[var(--el-border-color)] z-10">
    <!-- 工具栏 -->
    <Toolbar :editor="editorRef" :editorId="editorId"
      class="border-0 b-b-1 border-solid border-[var(--el-border-color)]" />
    <!-- 编辑器 -->
    <Editor v-model="valueHtml" :editorId="editorId" :defaultConfig="editorConfig" :style="editorStyle"
      @on-change="handleChange" @on-created="handleCreated" />
  </div>
</template>

<style src="@wangeditor/editor/dist/css/style.css"></style>
