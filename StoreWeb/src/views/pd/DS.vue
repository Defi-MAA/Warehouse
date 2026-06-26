<template>
    <ContentWrap>
        <div>


            <div style="border-bottom: 1px solid #e4e7ed;">
                <Search show-expand expand-field="status" :schema="searchSchema" @reset="setSearchParams"
                    @search="setSearchParams" />
            </div>
            <div class="mb-10px" style="margin-top: 10px;">
                <BaseButton type="primary" :icon="Plus" @click="add">增加</BaseButton>
                <BaseButton type="success" :icon="Check" @click="checkTrans">成批审核</BaseButton>
                <BaseButton type="danger" :icon="Check" @click="passTrans">成批生成</BaseButton>
                <BaseButton type="warning" :icon="Document" @click="handleDownload">导出</BaseButton>
            </div>


            <el-table v-loading="listLoading" :data="list" @sort-change="sort" border fit highlight-current-row
                style="width: 100%" :height="tableHeight - 50" @selection-change="setCheck" @row-dblclick="showEdit"
                id="out-table" :header-cell-style="{ color: '#000000' }" ref="tableRef" :default-sort="{
                    prop: 'tcode',
                    order: 'descending'
                }">
                <el-table-column type="selection" width="35" />
                <el-table-column prop="status" label="生成" width="60px">
                    <template #default="{ row }">
                        {{ row.crtstat == '1' ? '是' : '否' }}
                    </template>

                </el-table-column>
                <el-table-column prop="tdate" label="事务日期" sortable="custom" show-overflow-tooltip width="120px">
                </el-table-column>
                <el-table-column prop="tcode" label="事务编号" sortable="custom" show-overflow-tooltip width="130px">
                </el-table-column>
                <el-table-column prop="TypeName" label="事务类别" width="100px">
                </el-table-column>
               
                <el-table-column prop="wrname" label="仓库" sortable="custom" width="100px">
                </el-table-column>
                <el-table-column prop="amt" label="金额" sortable="custom" width="80px">
                </el-table-column>
                <el-table-column prop="memo" label="备注" show-overflow-tooltip width="150px">
                </el-table-column>
                <el-table-column prop="man1Name" label="主管" sortable="custom" show-overflow-tooltip width="90px">
                </el-table-column>
                <el-table-column prop="man2Name" label="审核" sortable="custom" show-overflow-tooltip width="90px">
                </el-table-column>
                <el-table-column prop="man3Name" label="经手" sortable="custom" show-overflow-tooltip width="90px">
                </el-table-column>
                <el-table-column prop="man4Name" label="制单" sortable="custom" show-overflow-tooltip width="90px">
                </el-table-column>
                <el-table-column prop="man5Name" label="记账" sortable="custom" show-overflow-tooltip width="100px">
                </el-table-column>

                <el-table-column prop="pstdate" label="过账日期" sortable="custom" width="160px">
                </el-table-column>

                <el-table-column label="操作" fixed="right" width="320">
                    <template #default="{ row }">
                        <el-button type="primary" link :icon="Edit" @click="edit(row)">
                            编辑
                        </el-button>

                        <el-button type="danger" link :icon="Delete" @click="doDelete(row)">
                            删除
                        </el-button>
                        <el-dropdown style="padding-left: 10px;padding-top: 2px;">
                            <el-button type="primary" link style="padding-left: 10px;">
                                更多操作<el-icon>
                                    <ArrowDown />
                                </el-icon>
                            </el-button>
                            <template #dropdown>
                                <el-dropdown-menu>
                                 
                                    <el-dropdown-item @click="doPrint(row)">打印</el-dropdown-item>
                                    <el-dropdown-item @click="doCheck(row)" v-if="isNull(row.man2)" divided>审核
                                    </el-dropdown-item>
                                    <el-dropdown-item @click="doUnCheck(row)" v-if="!isNull(row.man2)">取消审核
                                    </el-dropdown-item>
                                    <el-dropdown-item @click="doPass(row)" divided
                                        v-if="row.crtstat == '0'">生成 </el-dropdown-item>

                                    <el-dropdown-item v-if="row.ttype == 'PQ' || row.ttype == 'PM'"
                                        @click="doUpdate(row)" divided>单价更新</el-dropdown-item>

                                </el-dropdown-menu>
                            </template>
                        </el-dropdown>
                    </template>
                </el-table-column>
            </el-table>

            <el-pagination style="margin-top: 8px;" v-model:current-page="page" v-model:page-size="limit"
                :page-sizes="[100, 200, 300, 400]" :size="size" :disabled="total === 0" :background="background"
                layout="total, sizes, prev, pager, next, jumper" :total="total" @size-change="handleSizeChange"
                @current-change="handleCurrentChange" />



        </div>

        <Dialog v-model="dlgEdit" :title="dlgTitle" width="1300px" maxHeight="580px">
            <el-container style="width: 100%;">
                <el-header>
                    <el-row>
                        <div style="display:inline-block;">
                            <label class="radio-label" style="padding-left:10px;">编号</label>
                            <el-input v-model="form.tcode" readonly placeholder="" style="width: 120px; " />
                        </div>
                        <div style="display:inline-block;">
                            <label class="radio-label" style="padding-left:10px;">日期</label>

                            <el-date-picker style="width: 190px; " v-model="form.tdate" type="date"
                                value-format="YYYY-MM-DD" placeholder="选择日期">
                            </el-date-picker>
                        </div>




                        <div style="display:inline-block;">
                            <label class="radio-label" style="padding-left:10px;">价格日期</label>
                            <el-date-picker style="width: 140px; " v-model="form.pricedate" type="date"
                                value-format="YYYY-MM-DD" placeholder="选择日期">
                            </el-date-picker>
                        </div>
                    </el-row>
                    <el-row>


                        <div style="display:inline-block;">
                            <label class="radio-label" style="padding-left:10px;">部门</label>
                            <el-select style="width: 120px; " v-model="form.dept" @change="changeStore"
                                placeholder="请选择">
                                <el-option v-for="(item, index) in deptlist" :key="index" :label="item.name"
                                    :value="item.code">
                                </el-option>
                            </el-select>
                        </div>
                        <div style="display:inline-block;">
                            <label class="radio-label" style="padding-left:10px;">备注</label>
                            <el-input v-model="form.memo" placeholder="" style="width: 490px; " />
                        </div>
                    </el-row>
                </el-header>
                <el-main>
                    <el-table v-loading="listLoading1" :data="items" :border="true" fit highlight-current-row
                        style="width: 100%" height="330px" id="out-table1" ref="gitems"
                        @current-change="rowChage" :header-cell-style="{ color: '#000000' }">
                        <el-table-column prop="item" show-overflow-tooltip label="" width="90px">
                            <template #header>
                                <el-button type="primary" size="small" @click="addGoods">增加物资</el-button>
                            </template>
                        </el-table-column>
                        <el-table-column prop="name" label="品名" show-overflow-tooltip width="120px">

                        </el-table-column>
                        <el-table-column prop="spec" label="规格" show-overflow-tooltip width="70px">

                        </el-table-column>
                        <el-table-column prop="unit" label="单位" show-overflow-tooltip width="70px">

                        </el-table-column>
                        <el-table-column prop="lot" label="批次" width="150px">
                            <!-- <template #default="{ row }">
                              <el-input v-model="row.lot" type="text" placeholder="" />
                          </template> -->
                        </el-table-column>

                        <el-table-column prop="price" label="单价" width="90px">
                           
                        </el-table-column>
                        <el-table-column prop="qty0" label="财存数量" width="90px">
                          
                        </el-table-column>
                        
                        <el-table-column prop="qty" label="实存数量" width="160px">
                            <template #default="{ row }">

                                <div style="display:flex;justify-content: flex-start;">
                                    <el-input v-model="row.qty" @change="setAmt(row)" type="number"
                                        @focus="focus" placeholder="" />
                                    <el-button type="primary" style="margin-top: 4px;" size="small"
                                        @click="showPieQty(row)">辅助</el-button>
                                </div>

                            </template>
                        </el-table-column>
                        <el-table-column prop="qtys" label="盈亏数量" width="90px">
                            <template #default="{ row }">
                                {{ row.qty - row.qty0 }}
                            </template>
                        </el-table-column>
                        <el-table-column prop="amt" label="盈亏金额" width="120px">
                            <template #default="{ row }">
                                {{ (row.price * (row.qty - row.qty0)).toFixed(2) }}
                            </template>
                        </el-table-column>
                        <el-table-column prop="factamt" label="实存金额" width="120px">
                            <template #default="{row}">
                                {{ (row.price * row.qty).toFixed(2) }}
							</template>
                        </el-table-column>
                        <el-table-column align="center"   fixed="right" width="100px">
                            <template #default="{ row }"  v-if="form.status == '0'" >
                                <el-button type="danger" size="small"   @click="delGoods(row)">
                                    删除
                                </el-button>
                            </template>
                        </el-table-column>  
                    </el-table>
                </el-main>
                <el-footer style="height: 140px;">
                    <el-row>
                        <div style="display:inline-block;">
                            <label class="radio-label" style="padding-left:10px;">当前库存</label>
                            <el-input v-model="numinfo.StockQty" placeholder="" readonly style="width: 120px; " />
                        </div>
                        <div style="display:inline-block;">
                            <label class="radio-label" style="padding-left:10px;">平均单价</label>
                            <el-input v-model="numinfo.Price" placeholder="" readonly style="width: 120px; " />
                        </div>
                        <div style="display:inline-block;">
                            <label class="radio-label" style="padding-left:10px;">再订购点</label>
                            <el-input v-model="numinfo.reorder" placeholder="" readonly style="width: 120px; " />
                        </div>
                        <div style="display:inline-block;">
                            <label class="radio-label" style="padding-left:10px;">最高库存</label>
                            <el-input v-model="numinfo.MaxQty" placeholder="" readonly style="width: 120px; " />
                        </div>
                        <div style="display:inline-block;">
                            <label class="radio-label" style="padding-left:10px;">最低库存</label>
                            <el-input v-model="numinfo.MinQty" placeholder="" readonly style="width: 120px; " />
                        </div>
                        <div style="display:inline-block;">
                            <el-button @click="viewGoods" style="margin-left: 10px;" type="primary" :icon="Document"
                                title="查看商品详情"></el-button>
                        </div>
                        
                    </el-row>
                    <el-row>
                        <div style="display:inline-block;">
                            <label class="radio-label" style="padding-left:10px;">主管</label>
                            <el-select style="width: 120px; " v-model="form.man1" placeholder="请选择">
                                <el-option v-for="(item, index) in userlist" :key="index" :label="item.name"
                                    :value="item.code">
                                </el-option>
                            </el-select>
                        </div>
                        <div style="display:inline-block;">
                            <label class="radio-label" style="padding-left:10px;">审核</label>
                            <el-select style="width: 120px; " v-model="form.man2" placeholder="请选择">
                                <el-option v-for="(item, index) in userlist" :key="index" :label="item.name"
                                    :value="item.code">
                                </el-option>
                            </el-select>
                        </div>
                        <div style="display:inline-block;">
                            <label class="radio-label" style="padding-left:10px;">经手</label>
                            <el-select style="width: 120px; " v-model="form.man3" placeholder="请选择">
                                <el-option v-for="(item, index) in userlist" :key="index" :label="item.name"
                                    :value="item.code">
                                </el-option>
                            </el-select>
                        </div>
                        <div style="display:inline-block;">
                            <label class="radio-label" style="padding-left:10px;">制单</label>
                            <el-select style="width: 120px; " v-model="form.man4" placeholder="请选择">
                                <el-option v-for="(item, index) in userlist" :key="index" :label="item.name"
                                    :value="item.code">
                                </el-option>
                            </el-select>
                        </div>
                        <div style="display:inline-block;">
                            <label class="radio-label" style="padding-left:10px;">过账</label>
                            <el-select style="width: 120px; " v-model="form.man5" placeholder="请选择">
                                <el-option v-for="(item, index) in userlist" :key="index" :label="item.name"
                                    :value="item.code">
                                </el-option>
                            </el-select>
                        </div>
                        <div style="display:inline-block;">
                            <label class="radio-label" style="padding-left:10px;">修改</label>
                            <el-select style="width: 120px; " v-model="form.editor" placeholder="请选择">
                                <el-option v-for="(item, index) in userlist" :key="index" :label="item.name"
                                    :value="item.code">
                                </el-option>
                            </el-select>
                        </div>
                    </el-row>
                    <el-row style="text-align: right;margin-top:10px;display: flex; justify-content: flex-end;">
                        <el-button type="primary" @click="doPrint(form)" :disabled="!isedit"
                            :icon="Printer">打印</el-button>
                        <el-button type="warning" @click="doCheck(form)" :disabled="!isedit"
                            v-if="isNull(form.man2) && form.crtstat == '0'" :icon="Check">审核</el-button>
                        <el-button type="warning" @click="doUnCheck(form)" :disabled="!isedit"
                            v-if="!isNull(form.man2) && form.crtstat == '0'" :icon="Check">取消审核</el-button>
                        <el-button type="primary" @click="doPass(form)" :disabled="!isedit" v-if="form.crtstat == '0'"
                            :icon="Coordinate">生成</el-button>
                        <el-button type="success" :icon="Edit" @click="saveData"
                            v-if="(form.crtstat == '0' && isNull(form.man2)) || !isedit">保存</el-button>
                        <el-button type="danger" :icon="Close" @click="dlgEdit = false">退出</el-button>
                    </el-row>
                </el-footer>
            </el-container>
        </Dialog>

        <Dialog v-model="dlgGoods" width="900px" maxHeight="450px" title="选择商品">
            <Goods @setGoods="setGoods" @setMoreGoods="setMoreGoods" @goodsClose="goodsClose"></Goods>
        </Dialog>

        <Dialog v-model="dlgReport" width="65%" maxHeight="500px" :title="rptTitle">
            <Report ref="myrpt1"></Report>
        </Dialog>


        <Dialog v-model="dlgItem" title="查看" width="1100px" maxHeight="500px">

            <Item :form="itemInfo"></Item>
            <el-row style="margin-bottom: -20px; margin-top: 10px; display: flex; justify-content: flex-end;">
                <el-button @click="dlgItem = false">关 闭</el-button>
            </el-row>
        </Dialog>
        <Dialog v-model="dlgLot" width="70%" :show-close="false" :close-on-click-modal="false" top="50px">
            <div slot="title"
                style="display: flex;height: 40px; line-height: 40px;background-color: #409EFF;margin: -20px;">
                <div style="flex: 1;text-align: left;color: #FFFFFF;margin-left: 20px;">选择批次</div>
                <div style="flex: 1;text-align: center;color: #FFFFFF;"></div>
                <div style="flex: 1;text-align: right;">
                    <i class="el-icon-close closeico"
                        style="color: #FFFFFF; font-size: 20px;line-height: 40px;margin-right: 20px;"
                        @click="dlgLot = false"></i>
                </div>
            </div>
            <Lot ref="lot" @setlot="setlot" @lotClose="lotClose"></Lot>

        </Dialog>
        <PieQty ref="pieQtyRef" :pie-data="pieData" @confirm="confirmPieQty"></PieQty>

    </ContentWrap>
</template>

<script setup lang="tsx">
import { ContentWrap } from '@/components/ContentWrap'
import { FormSchema } from '@/components/Form'
import { Search } from '@/components/Search'
import { ref, reactive, onMounted, nextTick, watch, onUpdated } from 'vue'
import { ElMessage, ElMessageBox, ComponentSize, ElTable } from 'element-plus'
import { Dialog } from '@/components/Dialog'
import { useUserStoreWithOut } from '@/store/modules/user'
import Goods from '../dialog/goods.vue'
import Report from '../dialog/report.vue'
import Item from '../dialog/item.vue'
import Lot from '../dialog/lot.vue'
import PieQty from '../dialog/pieqty.vue'

import { formatToDate } from '@/utils/dateUtil'
import { exportTable } from '@/utils/export.js'
import { isEmpty } from '@/utils'
import { Plus, View, Refresh, Delete, Printer, Check, Coordinate, Menu, Close, Edit, Document, Notebook, ArrowRight, ArrowDown } from '@element-plus/icons-vue'

import request from '@/axios'

const size = ref<ComponentSize>('default')
const background = ref(false)
// 定义组件名称
defineOptions({
    name: 'DS'
})

const confirmPieQty = (qty: number) => {
    pieRow.value.qty = qty
}
const pieRow = ref<any>({})
const pieQtyRef = ref(PieQty)
const pieData = ref<any>({})
const showPieQty = (row: any) => {
    pieRow.value = row
    pieData.value = { ...row }
    pieData.value.qty =  undefined   
    pieQtyRef.value.dlgPie = true
}



const userStore = useUserStoreWithOut()
const typeids = ref<any[]>([{
    value: '-1',
    label: '全部'
},
{
    value: '0',
    label: '否'
},
{
    value: '1',
    label: '是'
}
])

const searchSchema = reactive<FormSchema[]>([
    {
        field: 'tdate',
        label: '日期',
        component: 'DatePicker',
        componentProps: {
            type: 'date',
            valueFormat: 'YYYY-MM-DD'
        }
    },
    {
        field: 'wrhs',
        label: '仓库',
        component: 'Select',
        optionApi: async () => {
            let data = storelist.value.map((v: any) => ({
                label: v.name,
                value: v.code
            }))
            return data
        }
    },

    {
        field: 'tcode',
        label: '事务编号',
        component: 'Input'
    },
    {
        field: 'status',
        label: '过账',
        component: 'Select',
        optionApi: async () => {
            return typeids.value
        },
        value: '-1'
    },
    {
        field: 'wrhs',
        label: '仓库',
        component: 'Select',
        optionApi: async () => {
            let data = storelist.value.map((v: any) => ({
                label: v.name,
                value: v.code
            }))
            return data
        }
    },
    {
        field: 'dept',
        label: '部门',
        component: 'Select',
        optionApi: async () => {
            let data = deptlist.value.map((v: any) => ({
                label: v.name,
                value: v.code
            }))
            return data
        }
    },
    {
        field: 'man4',
        label: '制单人',
        component: 'Select',
        optionApi: async () => {
            let data = userlist.value.map((v: any) => ({
                label: v.name,
                value: v.code
            }))
            return data
        }
    },
    {
        field: 'man3',
        label: '经手人',
        component: 'Select',
        optionApi: async () => {
            let data = userlist.value.map((v: any) => ({
                label: v.name,
                value: v.code
            }))
            return data
        }
    },
    {
        field: 'man5',
        label: '过账人',
        component: 'Select',
        optionApi: async () => {
            let data = userlist.value.map((v: any) => ({
                label: v.name,
                value: v.code
            }))
            return data
        }
    },
    {
        field: 'man2',
        label: '审核人',
        component: 'Select',
        optionApi: async () => {
            let data = userlist.value.map((v: any) => ({
                label: v.name,
                value: v.code
            }))
            return data
        }
    },
    {
        field: 'man1',
        label: '主管人',
        component: 'Select',
        optionApi: async () => {
            let data = userlist.value.map((v: any) => ({
                label: v.name,
                value: v.code
            }))
            return data
        }
    },

])


const currentPage = ref(1)
const handleSizeChange = (val: number) => {
    currentPage.value = 1
    getList()
}
const isInit = ref(true)
const handleCurrentChange = (val: number) => {
    if (isInit.value) return
    getList()
}

const searchParams = ref({})
const setSearchParams = (data: any) => {
    searchParams.value = data
    currentPage.value = 1
    getList()
}



// 类型定义
interface OptionItem {
    code: string
    name: string
    spec?: string
    unit?: string
    purunit?: string
    cvrnum?: number


}

interface FormData {
    tcode?: string
    tdate?: Date | string
    apitem?: string
    refno?: string
    pricedate?: Date | string
    Back?: boolean
    vndr?: string
    wrhs?: string
    memo?: string
    man1?: string
    man2?: string
    man3?: string
    man4?: string
    man5?: string
    editor?: string
    fistmp?: boolean
    ttype?: string
    version?: number,
    [key: string]: any
}

interface ItemData {
    item?: string
    name?: string
    spec?: string
    unit?: string
    lot?: string
    qty?: number
    price?: number
    amt?: number
    expdate?: string
    memo?: string
    tline?: string
    pieqty?: number
    purunit?: string
    cvrnum?: number
    [key: string]: any
}

interface KeysData {
    vndr?: string
    status?: number
    tdate?: string
    wrhs?: string
    dept?: string
    man1?: string
    man2?: string
    man3?: string
    man4?: string
    man5?: string
    ttype?: string
    expdate?: string
    [key: string]: any
}

interface NumInfo {
    StockQty?: number
    Price?: number
    reorder?: number
    MaxQty?: number
    MinQty?: number
    [key: string]: any
}

// 响应式数据
const ttype = ref('DS')
const dlgGoods = ref(false)
const tableHeight = ref(window.innerHeight - 230)
const mainHeight = ref(window.innerHeight - 50)
const scode = ref('')
const list = ref<any[]>([])
const list1 = ref<any[]>([])
const page = ref(1)
const limit = ref(100)
const total = ref(0)
const listLoading = ref(false)
const listLoading1 = ref(false)
const downloadLoading = ref(false)
const dlgEdit = ref(false)
const form = ref<FormData>({})
const dlgTitle = ref('新增')
const isedit = ref(false)
const orders = ref('')
const keys = ref<KeysData>({})
const loading = ref(false)
const dialogWidth = ref(0)
const goods = ref({})
const custlist = ref<OptionItem[]>([])
const userlist = ref<OptionItem[]>([])
const deptlist = ref<OptionItem[]>([])
const storelist = ref<OptionItem[]>([])
    const storelista = ref<OptionItem[]>([])
const settlelist = ref<OptionItem[]>([])
const items = ref<ItemData[]>([])
const numinfo = ref<NumInfo>({})
const dlgReport = ref(false)
const rptTitle = ref('')
const curitem = ref<ItemData>({})
const dlgItem = ref(false)
const dlgLot = ref(false)

// Refs
const gitems = ref<any>(null)
const myrpt1 = ref<InstanceType<typeof Report> | null>(null);
const itemRef = ref<any>(null)
const lotRef = ref<any>(null)

const usercode = ref('')


// 方法
const isNull = (value: any) => {
    return isEmpty(value)
}

const initData = () => {
    usercode.value = userStore.userInfo.code || ''
    request.post({ url: '/api/config/getAllData', data: {} }).then(res => {
        custlist.value = res.data.custs
        userlist.value = res.data.usrs
        deptlist.value = res.data.depts
        storelist.value = res.data.stores
        storelista.value = res.data.storesdepts
        settlelist.value = res.data.settles
    }).catch(error => { })
}

const focus = (event: any) => {
    // 拿到真正的 input 元素
    const realInput = (event.currentTarget as HTMLElement).querySelector('input')
    realInput?.select()
}

const addGoods = () => {
    if (isEmpty(form.value.dept)) {
        ElMessage.error('请选择部门')
        return
    }
    ElMessageBox.confirm('是否加载部门中的全部物资？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
    }).then(async () => {
        getData([], true)
    }).catch(async () => {
        dlgGoods.value = true
    })
}
const changeStore = () => {
    items.value = []
}

const goodsClose = () => {
    dlgGoods.value = false
}

const setGoods = (item: OptionItem) => {
    dlgGoods.value = false
    getData([item.code],false)
}

const setMoreGoods = (rows: OptionItem[]) => {
    dlgGoods.value = false
    const objs = JSON.parse(JSON.stringify(rows))
    getData(objs.map((item: OptionItem) => item.code),false)
}

const getData = (codes: String[], isall?: boolean) => {
    request.post({
        url: '/api/store/selectICData', data: {
            location: form.value.dept,
            items: codes,
            isall: isall
        }
    }).then(res => {
        let data = res.data || []
        data.forEach((item: any) => {
            if (!items.value.some((i: ItemData) => i.item == item.item)) {
                item.qty = item.qty || 0
                const obj: ItemData = {
                    item: item.item,
                    name: item.name,
                    spec: item.spec,
                    unit: item.unit,
                    lot: '',
                    qty: item.qty,
                    qty0: item.qty0,
                    price: item.price,
                    amt: undefined,
                    expdate: '',
                    memo: '',
                    tline: '',
                    pieqty: undefined,
                    purunit: item.purunit,
                    cvrnum: item.cvrnum,
                    index: addIndex.value++
                }
                items.value.push(obj)
            }
        })
        nextTick(() => {
            if (gitems.value && gitems.value.data) {
                gitems.value.setCurrentRow(gitems.value.data[items.value.length - 1])
            }
        })

    }).catch(error => { })

}
const delGoods = (row: ItemData) => {       
    items.value = items.value.filter((item: any) => item.index != row.index)
}


const checkList = ref<FormData[]>([])
const setCheck = (val: FormData[]) => {
    checkList.value = val
}

const rowChage = (currentRow: ItemData) => {
    curitem.value = currentRow
    if (currentRow && currentRow.item) {
        request.post({
            url: '/api/ivitem/getItemNum', data: {
                code: currentRow.item
            }
        }).then(res => {
            numinfo.value = {}
            if (res.data && res.data[0]) {
                numinfo.value = res.data[0]
            }
        }).catch(error => { })
    }
}



const sort = (obj: { order: string | null; prop: string }) => {
    let order = obj.order
    if (order) {
        let prop = obj.prop
        console.log(order)
        if (order == "descending") {
            order = "desc"
        } else if (order == "ascending") {
            order = "asc"
        }
        orders.value = prop + " " + order
        refData()
    }
}

const refData = (pg?: number) => {
    if (pg) page.value = pg
    else page.value = 1
    list.value = []
    getList()
}
const tableRef = ref<InstanceType<typeof ElTable> | null>(null);
onUpdated(async () => {
    // Vue3 的 nextTick 是独立 API，返回 Promise，推荐用 await 替代回调
    await nextTick();
    // 类型守卫：避免 ref 为空或 doLayout 方法不存在导致报错
    if (tableRef.value && typeof tableRef.value.doLayout === 'function') {
        tableRef.value.doLayout(); // 调用表格的 doLayout 方法
    }
});

const getList = () => {
    listLoading.value = true
    let params = { ...searchParams.value }
    params.ttype = ttype.value
    request.post({
        url: '/api/tran/selectTranWRPage', data: {
            page: page.value,
            limit: limit.value,
            keys: params,
            orders: orders.value
        }
    }).then(res => {
        listLoading.value = false
        list.value = res.data.records
        total.value = res.data.totalPage
    }).catch(error => {
        listLoading.value = false
        console.log(error)
    })
}

const search = () => {
    getList()
}

const reload = () => {
    keys.value = {}
    refData()
}

const getCurDate = async () => {
    let res = await request.post({ url: '/api/tran/getCurDate', data: {} })
    if (res.data) {
        return res.data
    }
    return ''
}
const GetDateStatus = async (date) => {
    let res = await request.post({ url: '/api/tran/getDateStatus', data: { date: date } })
    if (res.data) {
        return res.data
    }
    return false
}

const checkStatus = async () => {
    let curDate = await getCurDate()
    console.log(11122)
    console.log(curDate)
    if (isEmpty(curDate)) {
        ElMessage.error('当前会计期间未设置，请到会计管理中设置会计期间！')
        return false;
    }
    let status = await GetDateStatus(curDate)
    if (status) {
        ElMessage.error('当前会计期间已关帐!')
        return false;
    }

    return true
}

const add = async () => {
    if (!await checkStatus()) {
        return;
    }

    dlgTitle.value = '新增'
    isedit.value = false
    form.value = {
        tdate: new Date(),
        man4: usercode.value || '',
        tdate: formatToDate(new Date(), 'YYYY-MM-DD HH:mm:ss'),
        version: 0,
        fistmp: false,
        status: '0'
    }
    items.value = []
    dlgEdit.value = true
}

const showEdit = (row: any) => {
    edit(row)
}

const addIndex = ref(0)

const edit = (item: any) => {
    dlgTitle.value = '编辑'
    isedit.value = true
    form.value = {}
    dlgEdit.value = true
    loadInfo(item.tcode)
}
const loadInfo = (tcode: string) => {
    request.post({ url: '/api/tran/getIvtran', data: { tcode: tcode } }).then(res => {
        
        form.value = res.data
        form.value.editor = usercode.value || ''
        showGrid(form.value.tcode || '')
    })

}

const doCopy = (item: any) => {
    console.log(item)
    dlgTitle.value = '新增'
    isedit.value = false
    const tmp: FormData = { ...item }
    tmp.tcode = ''
    tmp.editor = ''
    tmp.man1 = ''
    tmp.man2 = ''
    tmp.man3 = ''
    tmp.man4 = ''
    tmp.man5 = ''
    tmp.fistmp = false
    tmp.version = 0
    form.value = tmp
    showGrid(item.tcode)
    dlgEdit.value = true
}

const showGrid = (code: string) => {
    items.value = []
    request.post({
        url: '/api/tran/selectTranItem', data: {
            code: code
        }
    }).then(res => {
        res.data.forEach((item: any) => {
            item.index = addIndex.value++
        })  
        items.value = res.data
        if (items.value.length > 0) {
            nextTick(() => {
                if (gitems.value && gitems.value.data) {
                    gitems.value.setCurrentRow(gitems.value.data[0])
                }
            })
        }
    }).catch(error => { })
}

const setAmt = (row: ItemData) => {
    if (row.qty && row.price) {
        row.amt = row.qty * row.price
    } else {
        row.amt = 0
    }
}

const saveData = () => {
    if (items.value.length == 0) {
        ElMessage.error('请添加物资')
        return;
    }

    request.post({ url: '/api/tran/checkLot', data: items.value }).then(res => {
        let datas = res.data;
        if (datas.length > 0) {
            ElMessageBox.confirm('单据存在与其他单据批次相同单价不同的物资，是否查看明细？', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(async () => {
                viewGoods()
                return;
            })
        }
        form.value.ttype = ttype.value
        if (isedit.value) {
            editData()
        } else {
            addData()
        }

    }).catch(error => { })
}

const addData = () => {
    loading.value = true
    request.post({
        url: '/api/tran/addTran', data: {
            trans: form.value,
            details: items.value
        }
    }).then(res => {
        if (res.code == 0) {
            loading.value = false
            ElMessage.success('保存成功')
            isedit.value = true
            dlgTitle.value = '编辑'
            form.value.tcode = res.data.tcode
            loadInfo(res.data.tcode)
            showGrid(res.data.tcode)
            refData(page.value)
        }
    }).catch(error => {
        loading.value = false
        console.log(error)
    })
}

const editData = () => {
    loading.value = true
    request.post({
        url: '/api/tran/editTran', data: {
            trans: form.value,
            details: items.value
        }
    }).then(res => {
        loading.value = false
        if (res.code == 0) {
            ElMessage.success('保存成功')
            showGrid(form.value.tcode || '')
            refData(page.value)
            if (dlgEdit.value)
                loadInfo(form.value.tcode)
        }
    }).catch(error => {
        loading.value = false
        console.log(error)
    })
}

const handleDownload = () => {
    exportTable("#out-table", "table")
    return
}
const itemInfo = ref<any>({})
const viewGoods = () => {
    if (isEmpty(curitem.value.item)) {
        ElMessage.error('请选择商品！')
        return
    }
    dlgItem.value = true
    nextTick(() => {
        request.post({
            url: '/api/ivitem/getIvitem', data: {
                code: curitem.value.item
            }
        }
        ).then(res => {
            itemInfo.value = res.data
        })
    })
}

const viewReport = () => {
    if (isEmpty(curitem.value.item)) {
        ElMessage.error('请选择商品！')
        return
    }
    console.log(curitem.value)
    dlgReport.value = true
    rptTitle.value = "供应商供货明细表"
    console.log(myrpt1)
    nextTick(() => {
        if (myrpt1.value) {
            myrpt1.value.loadReportData(
                'Vdr05',
                { Vndr: form.value.vndr }
            )
        }
    })
}

const doPrint = (item: any) => {
    dlgReport.value = true
    rptTitle.value = "盘点单"
    console.log(myrpt1)
    nextTick(() => {
        if (myrpt1.value) {
            myrpt1.value.loadReportData(
                'DSBill',
                { TCode: form.value.tcode }
            )
        }
    })
}

const doCheck = (item: any) => {
    ElMessageBox.confirm('是否确定审核单据?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
    }).then(() => {
        request.post({
            url: '/api/tran/verifyTran', data: {
                tcode: item.tcode
            }
        }).then(res => {
            if (res.code == 0) {
                ElMessage.success('审核成功')
                refData()
                if (dlgEdit.value)
                    loadInfo(item.tcode)
            }
        }).catch(error => { })
    }).catch(() => { })
}

const doUnCheck = (item: any) => {
    ElMessageBox.confirm('是否确定恢复审核单据?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
    }).then(() => {
        request.post({
            url: '/api/tran/UnVerifyTran', data: {
                tcode: item.tcode
            }
        }).then(res => {
            if (res.code == 0) {
                ElMessage.success('取消审核成功')
                refData()
                if (dlgEdit.value)
                    loadInfo(item.tcode)
            }
        }).catch(error => { })
    }).catch(() => { })
}

const doPass = (item: any) => {
    ElMessageBox.confirm('是否确定生成盘盈单/盘亏单?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
    }).then(() => {
        request.post({
            url: '/api/tran/passTranIC', data: {
                tcode: item.tcode
            }
        }).then(res => {
            if (res.code == 0) {
                ElMessage.success('生成成功')
                refData()
                if (dlgEdit.value)
                    loadInfo(item.tcode)
            }
        }).catch(error => { })
    }).catch(() => { })
}
const passTrans = () => {
    let n = checkList.value.length
    if (n == 0) {
        ElMessage.success('请勾选数据！')
        return
    }
    let fnum = 0;
    ElMessageBox.confirm('是否确定生成盘盈单/盘亏单?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
    }).then(() => {
        checkList.value.forEach(o => {
            request.post({
                url: '/api/tran/passTranIC', data: {
                    tcode: o.tcode
                }
            }).then(res => {
                fnum++
                if (fnum >= n) {
                    ElMessage.success('过账成功')
                    refData()
                }
            }).catch(error => {
                fnum++
                if (fnum >= n) {
                    ElMessage.success('过账成功')
                    refData()
                }
            })
        })

    }).catch(() => { })
}

const checkTrans = () => {
    let n = checkList.value.length
    if (n == 0) {
        ElMessage.success('请勾选数据！')
        return
    }
    let fnum = 0;
    ElMessageBox.confirm('是否确定审核单据?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
    }).then(() => {
        checkList.value.forEach(o => {
            request.post({
                url: '/api/tran/verifyTran', data: {
                    tcode: o.tcode
                }
            }).then(res => {
                fnum++
                if (fnum >= n) {
                    ElMessage.success('过账成功')
                    refData()
                }
            }).catch(error => {
                fnum++
                if (fnum >= n) {
                    ElMessage.success('过账成功')
                    refData()
                }
            })
        })

    }).catch(() => { })
}





const doDelete = (item: any) => {
    ElMessageBox.confirm('是否确定删除单据?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
    }).then(() => {
        request.post({
            url: '/api/tran/deleteTran', data: {
                tcode: item.tcode
            }
        }).then(res => {
            if (res.code == 0) {
                ElMessage.success('删除成功')
                refData()
                if (dlgEdit.value)
                    loadInfo(item.tcode)
            }
        }).catch(error => { })
    }).catch(() => { })
}

const doUpdate = (item: any) => {
    ElMessageBox.confirm('是否确定更新单价?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
    }).then(() => {
        request.post({
            url: '/api/tran/updatePrice', data: {
                tcode: item.tcode
            }
        }).then(res => {
            if (res.code == 0) {
                ElMessage.success('更新成功')
                refData()
                if (dlgEdit.value)
                    loadInfo(item.tcode)
            }
        }).catch(error => { })
    }).catch(() => { })
}

const setlot = (row: any) => {
    dlgLot.value = false
    curitem.value.lot = row.lot
    curitem.value.price = row.price
    curitem.value.expdate = row.expdate
}

const lotClose = () => {
    dlgLot.value = false
}

const showLot = (item: ItemData) => {
    dlgLot.value = true
    nextTick(() => {
        if (lotRef.value) {
            lotRef.value.loadData(item.item, form.value.wrhs)
        }
    })
}



// 生命周期
onMounted(() => {
    getList()
    initData()
})

</script>

<style lang="less" scoped>
.radio-label {
    font-size: 14px;
    color: #000;
    font-weight: normal;
    line-height: 40px;
    padding: 0 12px 0 30px;
}

::v-deep .el-form-item__label {
    text-align: right;
    font-weight: normal;
    vertical-align: middle;
    float: left;
    font-size: 14px;
    color: #606266;
    line-height: 40px;
    padding: 0 12px 0 0;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
}

.closeico:hover {
    cursor: pointer;
}

::v-deep .el-drawer {
    .el-drawer__header {
        height: 0;
        padding: 0;
        margin: 0;
        overflow: hidden;
    }
}
</style>