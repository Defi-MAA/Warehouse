<script setup lang="ts">

import { ElRow, ElCol, ElSkeleton, ElCard, ElDivider } from 'element-plus'

import { ref } from 'vue'
import { CountTo } from '@/components/CountTo'

import { useUserStoreWithOut } from '@/store/modules/user'
import { onMounted } from 'vue'
const userStore = useUserStoreWithOut()
const userInfo = ref(userStore.userInfo)
const loading = ref(true)

const totalSate = ref({
  project: 0,
  todo: 0,
  access: 0
})

onMounted(() => {
  loading.value = false
  userInfo.value = userStore.userInfo
})

</script>

<template>
  <div>
    <ElCard shadow="never">
      <ElSkeleton :loading="loading" animated>
        <ElRow :gutter="20" justify="space-between">
          <ElCol :xl="12" :lg="12" :md="12" :sm="24" :xs="24">
            <div class="flex items-center">
              <img
                :src="userInfo?.headimg || '@/assets/imgs/avatar.jpg'"
                alt=""
                class="w-70px h-70px rounded-[50%] mr-20px"
              />
              <div>
                <div class="text-20px">
                  {{ userInfo?.name || '' }}
                </div>
                
              </div>
            </div>
          </ElCol>
          <ElCol :xl="12" :lg="12" :md="12" :sm="24" :xs="24">
            <div class="flex h-70px items-center justify-end lt-sm:mt-20px">
              <div class="px-8px text-right">
                <div class="text-14px text-gray-400 mb-20px">待审核</div>
                <CountTo
                  class="text-20px"
                  :start-val="0"
                  :end-val="totalSate.project"
                  :duration="2600"
                />
              </div>
              <ElDivider direction="vertical" />
              <div class="px-8px text-right">
                <div class="text-14px text-gray-400 mb-20px">待过账</div>
                <CountTo
                  class="text-20px"
                  :start-val="0"
                  :end-val="totalSate.todo"
                  :duration="2600"
                />
              </div>
             
            </div>
          </ElCol>
        </ElRow>
      </ElSkeleton>
    </ElCard>
  </div>

  
</template>
