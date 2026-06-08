<script setup lang="ts">
import { useTagsViewStore } from '@/store/modules/tagsView'
import { useAppStore } from '@/store/modules/app'
import { Footer } from '@/components/Footer'
import { computed, ref, nextTick } from 'vue'

import { isEmpty,param2Obj} from '@/utils'
import Report1 from '@/views/dialog/report.vue'
import { Dialog } from '@/components/Dialog'
import { ElMessage, ElMessageBox } from 'element-plus'

const appStore = useAppStore()

const footer = computed(() => appStore.getFooter)

const tagsViewStore = useTagsViewStore()

const getCaches = computed((): string[] => {
  return tagsViewStore.getCachedViews
})

// 保存原始方法
const originalPushState = history.pushState
const myrpt0 = ref<InstanceType<typeof Report1> | null>(null)
const rptTitle = ref('')
const dlgReport = ref(false)
const currentUrl = ref('')
// 重写 pushState
history.pushState = function (...args: Parameters<typeof originalPushState>) {
  const params = param2Obj(args[2])
  if(params!=null&&params.optype === 'viewreport'){
     currentUrl.value = args[2].split('?')[0]
  
    viewReport(params)
  }
  const result = originalPushState.apply(this, args);
  return result;
};
const closeDlg = () => {
    history.replaceState(null, '', currentUrl.value);
}

const viewReport =  (params) => {

  dlgReport.value = true
  rptTitle.value = "报表"
  nextTick(async () => {
    if (myrpt0.value) {
     await    myrpt0.value.loadReportData(
        params.rptcode,
        params
      )
    }
  })
}

</script>

<template>
  <section
    :class="[
      'box-border p-[var(--app-content-padding)] w-full bg-[var(--app-content-bg-color)] dark:bg-[var(--el-bg-color)]',
      {
        '!min-h-[calc(100vh-var(--top-tool-height)-var(--tags-view-height)-var(--app-footer-height))] pb-0':
          footer
      }
    ]"
  >
    <router-view>
      <template #default="{ Component, route }">
        <keep-alive :include="getCaches">
          <component :is="Component" :key="route.fullPath" />
        </keep-alive>
      </template>
    </router-view>
  </section>
  <!-- <Footer v-if="footer" /> -->
     <Dialog v-model="dlgReport" width="65%" maxHeight="500px" :title="rptTitle" @close="closeDlg">
       <Report1 ref="myrpt0"></Report1>
     </Dialog>
</template>
