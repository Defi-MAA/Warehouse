<script setup lang="ts">
import { reactive, ref, unref } from 'vue'
import { FormSchema } from '@/components/Form'
import { Search } from '@/components/Search'
import { useSearch } from '@/hooks/web/useSearch'


import { Table, TableColumn } from '@/components/Table'
import { useTable } from '@/hooks/web/useTable'

import request from '@/axios'

//import Write from './components/Write.vue'
//import Detail from './components/Detail.vue'
//import { CrudSchema, useCrudSchemas } from '@/hooks/web/useCrudSchemas'


import { useI18n } from '@/hooks/web/useI18n'

const { t } = useI18n()




const { tableRegister, tableState, tableMethods } = useTable({
    fetchDataApi: async () => {
        // const res = await getRoleListApi()
        // return {
        //   list: res.data.list || [],
        //   total: res.data.total
        // }
        return {
            list: [],
            total: 0
        }
    }
})


const { dataList, loading, total } = tableState
const { getList } = tableMethods



//const { searchRegister, searchMethods } = useSearch()
//const { setSchema, setProps, setValues, getFormData } = searchMethods

// const schema = ref<FormSchema[]>([


// ])

const searchSchema = reactive<FormSchema[]>([
    {
        field: 'roleName',
        label: '日期',
        component: 'Input'
    },
    {
        field: 'roleName',
        label: '日期',
        component: 'Input'
    }, {
        field: 'roleName',
        label: '日期',
        component: 'Input'
    }, {
        field: 'roleName4',
        label: '日期',
        component: 'Input'
    }, {
        field: 'roleName',
        label: '日期',
        component: 'Input'
    }, {
        field: 'roleName',
        label: '日期',
        component: 'Input'
    }, {
        field: 'roleName',
        label: '日期',
        component: 'Input'
    }, {
        field: 'roleName',
        label: '日期',
        component: 'Input'
    }, {
        field: 'roleName',
        label: '日期',
        component: 'Input'
    }, {
        field: 'roleName',
        label: '日期',
        component: 'Input'
    }, {
        field: 'roleName1',
        label: '日期',
        component: 'Input'
    }
])

const searchParams = ref({})
const setSearchParams = (data: any) => {
    searchParams.value = data
    getList()
}

const tableColumns = reactive<TableColumn[]>([
    {
        field: 'index',
        label: t('userDemo.index'),
        type: 'index'
    },
    {
        field: 'roleName',
        label: t('role.roleName')
    }

])


//const { allSchemas } = useCrudSchemas(crudSchemas)
const delLoading = ref(false)
const ids = ref<string[]>([])
const delData = async (row) => {
    // const elTableExpose = await getElTableExpose()
    // ids.value = row
    //     ? [row.id]
    //     : elTableExpose?.getSelectionRows().map((v) => v.id) || []
    // delLoading.value = true
    // await delList(unref(ids).length).finally(() => {
    //     delLoading.value = false
    // })
}


const dialogVisible = ref(false)
const dialogTitle = ref('')

const currentRow = ref<  null>(null)
const actionType = ref('')

const AddAction = () => {
    dialogTitle.value = t('exampleDemo.add')
    currentRow.value = null
    dialogVisible.value = true
    actionType.value = ''
}

const saveLoading = ref(false)

const save = async () => {
//   const write = unref(writeRef)
//   const formData = await write?.submit()
//   if (formData) {
//     saveLoading.value = true
//     const res = await saveDepartmentApi(formData)
//       .catch(() => {})
//       .finally(() => {
//         saveLoading.value = false
//       })
//     if (res) {
//       dialogVisible.value = false
//       currentPage.value = 1
//       getList()
//     }
//   }
}

</script>

<template>
    <ContentWrap>
        <Search show-expand expand-field="roleName4" :schema="searchSchema" @reset="setSearchParams"
            @search="setSearchParams" />
        <div class="mb-10px">
            <BaseButton type="primary" @click="AddAction">{{ t('exampleDemo.add') }}</BaseButton>
            <BaseButton :loading="delLoading" type="danger" @click="delData(null)">
                {{ t('exampleDemo.del') }}
            </BaseButton>
        </div>
        <Table :columns="tableColumns" default-expand-all node-key="id" :data="dataList" :loading="loading" :pagination="{
            total
        }" @register="tableRegister" />
    </ContentWrap>

    <Dialog v-model="dialogVisible" :title="dialogTitle">
        <!-- <Write v-if="actionType !== 'detail'" ref="writeRef" :form-schema="allSchemas.formSchema"
            :current-row="currentRow" />

        <Detail v-if="actionType === 'detail'" :detail-schema="allSchemas.detailSchema" :current-row="currentRow" /> -->

        <template #footer>
            <BaseButton v-if="actionType !== 'detail'" type="primary" :loading="saveLoading" @click="save">
                {{ t('exampleDemo.save') }}
            </BaseButton>
            <BaseButton @click="dialogVisible = false">{{ t('dialogDemo.close') }}</BaseButton>
        </template>
    </Dialog>
</template>