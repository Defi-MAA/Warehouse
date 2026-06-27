<script setup lang="ts">
import { ElRow, ElCol, ElCard, ElSkeleton } from 'element-plus'
import { CountTo } from '@/components/CountTo'
import { useDesign } from '@/hooks/web/useDesign'
import { useI18n } from '@/hooks/web/useI18n'
import { ref, reactive, nextTick } from 'vue'
import request from '@/axios'
import type { AnalysisTotalTypes } from '@/api/dashboard/analysis/types'
import Report2 from '@/views/dialog/report.vue'
import { Dialog } from '@/components/Dialog'
import { useRouter } from 'vue-router'
const { push } = useRouter()
const { t } = useI18n()

const { getPrefixCls } = useDesign()

const prefixCls = getPrefixCls('panel')

const loading = ref(true)

let totalState = reactive<AnalysisTotalTypes>({
  totalAmt: 0,
  totalQty: 0,
  minQty: 0,
  maxQty: 0,
  noCheck: 0,
  noPass: 0,
  saleAmt: 0,
  saleQty: 0
})

const getCount = async () => {
  const res = await request.post({ url: '/api/config/getNumInfo', data: {} })
  totalState = Object.assign(totalState, res?.data || {})
  loading.value = false
}

const toPage = (path: string) => {
  push(path)
}

getCount()

const dlgReport = ref(false)
const myrpt2 = ref<InstanceType<typeof Report2> | null>(null)
const viewReport = (rptcode,params) => {
  console.log(rptcode,params)
  dlgReport.value = true
  nextTick(async () => {
    if (myrpt2.value) {
      await myrpt2.value.loadReportData(
        rptcode,
        params
      )
    }
  })
}

</script>

<template>
  <ElRow :gutter="20" justify="space-between" :class="prefixCls">
    <ElCol :xl="6" :lg="6" :md="12" :sm="12" :xs="24">
      <ElCard shadow="hover" class="mb-20px handfocus" @click="viewReport('Itm01',{})">
        <ElSkeleton :loading="loading" animated :rows="2">
          <template #default>
            <div :class="`${prefixCls}__item flex justify-between`">
              <div>
                <div :class="`${prefixCls}__item--icon ${prefixCls}__item--peoples p-16px inline-block rounded-6px`">
                  <Icon icon="svg-icon:money" :size="40" />
                </div>
              </div>
              <div class="flex flex-col justify-between">
                <div :class="`${prefixCls}__item--text text-16px text-gray-500 text-right`">库存总金额</div>
                <CountTo class="text-20px font-700 text-right" :start-val="0" :end-val="totalState.totalAmt"
                  :duration="2600" />
              </div>
            </div>
          </template>
        </ElSkeleton>
      </ElCard>
    </ElCol>
    <ElCol :xl="6" :lg="6" :md="12" :sm="12" :xs="24">
      <ElCard shadow="hover" class="mb-20px handfocus" @click="viewReport('Itm01',{})">
        <ElSkeleton :loading="loading" animated :rows="2">
          <template #default>
            <div :class="`${prefixCls}__item flex justify-between`">
              <div>
                <div :class="`${prefixCls}__item--icon ${prefixCls}__item--shopping p-16px inline-block rounded-6px`">
                  <Icon icon="svg-icon:shopping" :size="40" />
                </div>
              </div>
              <div class="flex flex-col justify-between">
                <div :class="`${prefixCls}__item--text text-16px text-gray-500 text-right`">库存总数量</div>
                <CountTo class="text-20px font-700 text-right" :start-val="0" :end-val="totalState.totalQty"
                  :duration="2600" />
              </div>
            </div>
          </template>
        </ElSkeleton>
      </ElCard>

    </ElCol>

    <ElCol :xl="6" :lg="6" :md="12" :sm="12" :xs="24">
      <ElCard shadow="hover" class="mb-20px handfocus" @click="viewReport('whs14',{})">
        <ElSkeleton :loading="loading" animated :rows="2">
          <template #default>
            <div :class="`${prefixCls}__item flex justify-between`">
              <div>
                <div :class="`${prefixCls}__item--icon ${prefixCls}__item--message p-16px inline-block rounded-6px`">
                  <Icon icon="svg-icon:money" :size="40" />
                </div>
              </div>
              <div class="flex flex-col justify-between">
                <div :class="`${prefixCls}__item--text text-16px text-gray-500 text-right`">销售总金额</div>
                <CountTo class="text-20px font-700 text-right" :start-val="0" :end-val="totalState.saleAmt"
                  :duration="2600" />
              </div>
            </div>
          </template>
        </ElSkeleton>
      </ElCard>
    </ElCol>

    <ElCol :xl="6" :lg="6" :md="12" :sm="12" :xs="24">
      <ElCard shadow="hover" class="mb-20px handfocus"  @click="viewReport('whs14',{})">
        <ElSkeleton :loading="loading" animated :rows="2">
          <template #default>
            <div :class="`${prefixCls}__item flex justify-between`">
              <div>
                <div :class="`${prefixCls}__item--icon ${prefixCls}__item--money p-16px inline-block rounded-6px`">
                  <Icon icon="svg-icon:shopping" :size="40" />
                </div>
              </div>
              <div class="flex flex-col justify-between">
                <div :class="`${prefixCls}__item--text text-16px text-gray-500 text-right`">销售总数量</div>
                <CountTo class="text-20px font-700 text-right" :start-val="0" :end-val="totalState.saleQty"
                  :duration="2600" />
              </div>
            </div>
          </template>
        </ElSkeleton>
      </ElCard>
    </ElCol>


    <ElCol :xl="6" :lg="6" :md="12" :sm="12" :xs="24">
      <ElCard shadow="hover" class="mb-20px handfocus" @click="toPage('/action/actiontrans')">
        <ElSkeleton :loading="loading" animated :rows="2">
          <template #default>
            <div :class="`${prefixCls}__item flex justify-between`">
              <div>
                <div :class="`${prefixCls}__item--icon ${prefixCls}__item--shopping p-16px inline-block rounded-6px`">
                  <Icon icon="svg-icon:check" :size="40" />
                </div>
              </div>
              <div class="flex flex-col justify-between">
                <div :class="`${prefixCls}__item--text text-16px text-gray-500 text-right`">待审核</div>
                <CountTo class="text-20px font-700 text-right" :start-val="0" :end-val="totalState.noCheck"
                  :duration="2600" />
              </div>
            </div>
          </template>
        </ElSkeleton>
      </ElCard>

    </ElCol>
    <ElCol :xl="6" :lg="6" :md="12" :sm="12" :xs="24">
      <ElCard shadow="hover" class="mb-20px handfocus" @click="toPage('/action/actiontrans')">
        <ElSkeleton :loading="loading" animated :rows="2">
          <template #default>
            <div :class="`${prefixCls}__item flex justify-between`">
              <div>
                <div :class="`${prefixCls}__item--icon ${prefixCls}__item--shopping p-16px inline-block rounded-6px`">
                  <Icon icon="svg-icon:pass" :size="40" />
                </div>
              </div>
              <div class="flex flex-col justify-between">
                <div :class="`${prefixCls}__item--text text-16px text-gray-500 text-right`">待过账</div>
                <CountTo class="text-20px font-700 text-right" :start-val="0" :end-val="totalState.noPass"
                  :duration="2600" />
              </div>
            </div>
          </template>
        </ElSkeleton>
      </ElCard>

    </ElCol>
    <ElCol :xl="6" :lg="6" :md="12" :sm="12" :xs="24">
      <ElCard shadow="hover" class="mb-20px handfocus" @click="viewReport('Itm10',{})">
        <ElSkeleton :loading="loading" animated :rows="2">
          <template #default>
            <div :class="`${prefixCls}__item flex justify-between`">
              <div>
                <div :class="`${prefixCls}__item--icon ${prefixCls}__item--shopping p-16px inline-block rounded-6px`">
                  <Icon icon="svg-icon:small" :size="40" />
                </div>
              </div>
              <div class="flex flex-col justify-between">
                <div :class="`${prefixCls}__item--text text-16px text-gray-500 text-right`">物资短缺总数</div>
                <CountTo class="text-20px font-700 text-right" :start-val="0" :end-val="totalState.minQty"
                  :duration="2600" />
              </div>
            </div>
          </template>
        </ElSkeleton>
      </ElCard>

    </ElCol>
    <ElCol :xl="6" :lg="6" :md="12" :sm="12" :xs="24">
      <ElCard shadow="hover" class="mb-20px handfocus" @click="viewReport('Itm11',{})">
        <ElSkeleton :loading="loading" animated :rows="2">
          <template #default>
            <div :class="`${prefixCls}__item flex justify-between`">
              <div>
                <div :class="`${prefixCls}__item--icon ${prefixCls}__item--shopping p-16px inline-block rounded-6px`">
                  <Icon icon="svg-icon:mall" :size="40" />
                </div>
              </div>
              <div class="flex flex-col justify-between">
                <div :class="`${prefixCls}__item--text text-16px text-gray-500 text-right`">物资超量总数</div>
                <CountTo class="text-20px font-700 text-right" :start-val="0" :end-val="totalState.maxQty"
                  :duration="2600" />
              </div>
            </div>
          </template>
        </ElSkeleton>
      </ElCard>

    </ElCol>
  </ElRow>
  <Dialog v-model="dlgReport" width="65%" maxHeight="500px" title="报表">
    <Report2 ref="myrpt2"></Report2>
  </Dialog>
</template>

<style lang="less" scoped>
@prefix-cls: ~'@{adminNamespace}-panel';

.@{prefix-cls} {
  &__item {
    &--peoples {
      color: #40c9c6;
    }

    &--message {
      color: #36a3f7;
    }

    &--money {
      color: #f4516c;
    }

    &--shopping {
      color: #34bfa3;
    }

    &:hover {
      :deep(.@{adminNamespace}-icon) {
        color: #fff !important;
      }

      .@{prefix-cls}__item--icon {
        transition: all 0.38s ease-out;
      }

      .@{prefix-cls}__item--peoples {
        background: #40c9c6;
      }

      .@{prefix-cls}__item--message {
        background: #36a3f7;
      }

      .@{prefix-cls}__item--money {
        background: #f4516c;
      }

      .@{prefix-cls}__item--shopping {
        background: #34bfa3;
      }
    }
  }
}

.handfocus:hover {
  cursor: pointer;
}
</style>
