<script setup lang="tsx">
import { ContentWrap } from '@/components/ContentWrap'
import { ElTree, ElMessage, ElMessageBox, ElTable } from 'element-plus'
import { ref, onMounted, unref } from 'vue'
import request from '@/axios'

const tableData = ref<any>([

])

onMounted(() => {
    initData()
})

const tableRef = ref<InstanceType<typeof ElTable> | null>(null);
const initData = async () => {
    let res = await request.post({ url: '/api/users/getRoles', data: {} })
    tableData.value = res.data || []
    if (res.data && res.data.length > 0) {
        currentRow.value = tableData.value[0]
        tableRef.value?.setCurrentRow(tableData.value[0])
        initTree();
    }
}
const treeData = ref<any[]>([])
const allObjects = ref<string[]>([])
const initTree = async () => {
    let res = await request.post({ url: '/api/users/getObjectsTree', data: {} })
    treeData.value = res.data || []
    expanded.value = treeData.value.map(o => o.objid)
    res = await request.post({ url: '/api/users/getObjects', data: {} })
    allObjects.value = res.data.map(o => o.objid) || []
    setDef()
}

const setDef = async () => {
    let res = await request.post({ url: '/api/users/getPower', data: { roleId: currentRow.value.code } })
    defchecked.value = res.data.map(o => o.objid);
    treeRef.value?.setCheckedKeys(defchecked.value);
}


const currentRow = ref<any>()
const rowClick = (row: any) => {
    currentRow.value = row
    setDef()
}



const expanded = ref<string[]>([])
const defchecked = ref<string[]>([])
const defaultProps = {
    children: 'children',
    label: 'objname',
}
const setCheck = (item: any, checked: boolean, indeterminate: boolean) => {
    let ischeck = false;
    if (defchecked.value.some(o => o == item.objid)) {
        defchecked.value = defchecked.value.filter(o => o != item.objid);
    } else {
        ischeck = true;
        defchecked.value.push(item.objid);
    }
    if (item.children != null && item.children.length > 0) {
        for (let i = 0; i < item.children.length; i++) {
            let cid = item.children[i].objid;
            if (ischeck) {
                if (!defchecked.value.some(o => o == cid)) {
                    defchecked.value.push(cid);
                }
            } else {
                if (defchecked.value.some(o => o == cid)) {
                    defchecked.value = defchecked.value.filter(o => o != cid);
                }
            }

        }
        treeRef.value?.setCheckedKeys(defchecked.value);
    }
}
const checkAll = () => {
    defchecked.value = allObjects.value
    treeRef.value?.setCheckedKeys(allObjects.value)
}
const uncheckAll = () => {
    defchecked.value = []
    treeRef.value?.setCheckedKeys([])
}
const savePower = async () => {
    console.log(defchecked.value)
    let res = await request.post({ url: '/api/users/savePower', data: { roleId: currentRow.value.code, powers: defchecked.value } })
    ElMessage.success('保存成功')
    setDef()
}

const treeRef = ref<InstanceType<typeof ElTree> | null>(null);



import { Edit, Check, Close } from '@element-plus/icons-vue'
</script>

<template>
    <ContentWrap>
       
            <el-container style="display: flex;">
                <el-aside width="200px" style="border-right: 1px solid #e4e7ed;width: 200px;">
                    <el-table :data="tableData" highlight-current-row style="width: 100%"
                        :header-cell-style="{ color: '#000000' }" ref="tableRef" @row-click="rowClick">
                        <el-table-column prop="name" label="角色列表" width="180" />
                    </el-table>

                </el-aside>
                <el-main style="padding: 0px;width: calc(100% - 200px);padding-left: 10px;">

                    <div style="display: flex;">
                        <el-button type="primary" :icon="Check" @click="checkAll">全选中</el-button>
                        <el-button type="info" :icon="Close" @click="uncheckAll">全不选</el-button>
                        <el-button type="success" :icon="Edit" @click="savePower">保存权限</el-button>
                    </div>

                    <el-divider content-position="left">
                        当前角色：{{ currentRow?.name || '请选择角色' }}
                    </el-divider>

                    <el-tree style="max-width: 600px" check-strictly show-checkbox :default-expanded-keys="expanded"
                        node-key="objid" :default-checked-keys="defchecked" :data="treeData" :props="defaultProps"
                        @check="setCheck" ref="treeRef" />

                </el-main>
            </el-container>
        
    </ContentWrap>
</template>

<style lang="less" scoped>
.avatar-uploader {
    width: 178px;
    height: 178px;
    position: relative;
    border: 1px dashed var(--el-border-color);
}

.avatar-uploader .el-upload {
    border: 1px dashed var(--el-border-color);
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;

    transition: var(--el-transition-duration-fast);
}

.avatar-uploader .el-upload:hover {
    border-color: var(--el-color-primary);
}

.el-icon.avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 178px;
    height: 178px;
    text-align: center;
}

.avatarimg {
    width: 178px;
    height: 178px;
    color: #8c939d;
    text-align: center;
}

.delete-btn {
    position: absolute;
    top: 1px;
    right: 1px;
    width: 24px;
    height: 24px;
    border-radius: 50%;
    background: #f56c6c;
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    font-size: 16px;
    border: 2px solid white;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
    z-index: 10;
}


</style>
