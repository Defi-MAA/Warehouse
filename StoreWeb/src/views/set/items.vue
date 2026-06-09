<template>
	<ContentWrap>
		<div style="border-bottom: 1px solid #e4e7ed;">
			<Search show-expand expand-field="flag" :schema="searchSchema" @reset="setSearchParams"
				@search="setSearchParams" @register="searchRegister" />
		</div>
		<div class="mb-10px" style="margin-top: 10px;">
			<BaseButton type="primary" :icon="Plus" @click="AddAction">增加</BaseButton>
			<BaseButton :loading="delLoading" :icon="Delete" type="danger" @click="delData(null)">
				删除
			</BaseButton>
			<BaseButton type="warning" :icon="Document" @click="exportExcel">导出</BaseButton>
		</div>

		<el-table :data="tableData" @sort-change="handleSortChange" :default-sort="{
			prop: 'code',
			order: 'descending'
		}" style="width: 100%;" :height="tableHeight" :header-cell-style="{ color: '#000000' }"
			@selection-change="handleSelectionChange" @row-dblclick="editData" id="out-table" stripe :border="true"
			ref="tableRef">
			<el-table-column type="selection" width="55" />
			<el-table-column align="center" prop="code" label="物资编码" sortable="custom" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="name" label="物资名称" sortable="custom" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="spec" label="型号规格" sortable="custom" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="EnSpec" label="英文规格" sortable="custom" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="unit" label="库存单位" sortable="custom" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="purunit" label="辅助单位" sortable="custom" width="150px">
			</el-table-column>
			
			<el-table-column align="center" prop="cvrnum" label="转换因子" width="150px">
			</el-table-column>
						
			<el-table-column align="center" prop="category" label="物资类别" sortable="custom" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="maxqty" label="最高存量" sortable="custom" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="minqty" label="最低存量" sortable="custom" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="reorder" label="再订购点" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="oqnum" label="经济批量" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="costing" label="计价方法" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="levels" label="级别" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="stat" label="状态" sortable="custom" width="150px">
				<template #default="{ row }">
					<el-checkbox v-model="row.stat" onclick="return false; "></el-checkbox>
				</template>
			</el-table-column>
			<el-table-column align="center" prop="flag" label="明细" sortable="custom" width="150px">
				<template #default="{ row }">
					<el-checkbox v-model="row.flag" onclick="return false; "></el-checkbox>
				</template>
			</el-table-column>
			<el-table-column align="center" prop="accno" label="库存商品科目" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="cust4" label="辅助帐号项目" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="Overacc" label="短益科目" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="priceedit" label="修改单价" width="150px">
			</el-table-column>
			<!-- 	<el-table-column align="center" prop="usage" label="用途" width="150px">
				</el-table-column> -->



			<el-table-column align="center" prop="piece" label="计件" width="150px">
				<template #default="{ row }">
					<el-checkbox v-model="row.piece" onclick="return false; "></el-checkbox>
				</template>
			</el-table-column>
			<el-table-column align="center" prop="semigoods" label="半成品" width="150px">
				<template #default="{ row }">
					<el-checkbox v-model="row.semigoods" onclick="return false; "></el-checkbox>
				</template>
			</el-table-column>
			<el-table-column align="center" prop="pieunit" label="件单位" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="memo" label="备注" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="ahnum" label="提前期" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="wrhsstat" label="采购属性" width="150px">
			</el-table-column>



			<el-table-column label="操作" min-width="180" fixed="right">
				<template #default="{ row }">
					<el-button type="primary" link :icon="Edit" @click="editData(row)" style="margin-right: 10px;">
						编辑
					</el-button>
					<el-button type="danger" link :icon="Delete" @click="delData(row)">删除</el-button>
				</template>
			</el-table-column>
		</el-table>
		<el-pagination style="margin-top: 8px;" v-model:current-page="currentPage" v-model:page-size="pageSize"
			:page-sizes="[100, 200, 300, 400]" :size="size" :disabled="total === 0" :background="background"
			layout="total, sizes, prev, pager, next, jumper" :total="total" @size-change="handleSizeChange"
			@current-change="handleCurrentChange" />

	</ContentWrap>

	<Dialog v-model="dialogVisible" width="1100px" :title="dialogTitle">

		<el-form :model="form" label-width="auto" ref="ruleFormRef" :rules="rules">
			<el-row :gutter="10">

				<el-col :span="6">
					<el-form-item label="物资编码" prop="code">
						<el-input v-model="form.code"></el-input>
					</el-form-item>
				</el-col>

				<el-col :span="12">
					<el-form-item label="物资名称" prop="name">
						<el-input v-model="form.name"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="英文名称" prop="EnName">
						<el-input v-model="form.EnName"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="助记号" prop="pym">
						<el-input v-model="form.pym"></el-input>
					</el-form-item>
				</el-col>
				<!-- <el-col :span="12">
						<el-form-item label="用途"  prop="usage">
							<el-input v-model="form.usage"></el-input>
						</el-form-item>
					</el-col> -->
				<el-col :span="6">
					<el-form-item label="型号规格" prop="spec">
						<el-input v-model="form.spec"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="英文规格" prop="EnSpec">
						<el-input v-model="form.EnSpec"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="级别" prop="levels">
						<el-input type="number" v-model="form.levels"></el-input>
					</el-form-item>
				</el-col>

				<el-col :span="6">
					<el-form-item label="物资类别" prop="category">

						<el-select v-model="form.category" placeholder="请选择">
							<el-option v-for="(item, index) in category" :label="item.name" :value="item.code">
							</el-option>

						</el-select>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="计价方式" prop="costing">

						<el-select v-model="form.costing" placeholder="请选择">
							<el-option label="先进先出" value="FIFO">
							</el-option>
							<el-option label="后进先出" value="LIFO">
							</el-option>
							<el-option label="个别计价" value="SI">
							</el-option>
							<el-option label="移动平均" value="WMA">
							</el-option>
						</el-select>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="提前期" prop="ahnum">
						<el-input type="number" v-model="form.ahnum"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="再定购点" prop="reorder">
						<el-input v-model="form.reorder"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="库存单位" prop="maxqty">
						<el-input v-model="form.unit"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="辅助单位" prop="maxqty">
						<el-input v-model="form.purunit"></el-input>
					</el-form-item>
				</el-col>
				
				<el-col :span="6">
					<el-form-item label="转换因子" prop="cvrnum">
						<el-input v-model="form.cvrnum" type="number" placeholder="库存数量/转换因子=辅助单位数量"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="最高存量" prop="maxqty">
						<el-input type="number" v-model="form.maxqty"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="最低存量" prop="minqty">
						<el-input type="number" v-model="form.minqty"></el-input>
					</el-form-item>
				</el-col>
				
				<el-col :span="6">
					<el-form-item label="短益科目" prop="Overacc">
						<el-cascader filterable v-model="form.Overacc" :show-all-levels="false" :options="treeitem"
							:props="{ expandTrigger: 'hover' }">
						</el-cascader>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="库存商品科目" prop="accno">
						<el-cascader filterable v-model="form.accno" :show-all-levels="false" :options="treeitem"
							:props="{ expandTrigger: 'hover' }">
						</el-cascader>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="辅助帐号项目" prop="cust4">
						<el-cascader filterable v-model="form.cust4" :show-all-levels="false" :options="treeitem"
							:props="{ expandTrigger: 'hover' }">
						</el-cascader>
					</el-form-item>
				</el-col>

				<el-col :span="6">
					<el-form-item label="货架号" prop="GoodsNo">
						<el-input v-model="form.GoodsNo"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="" prop="semigoods">

						<el-checkbox v-model="form.semigoods">半成品</el-checkbox>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="" prop="stat">

						<el-checkbox v-model="form.stat">有效</el-checkbox>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="" prop="piece">

						<el-checkbox v-model="form.piece">计件</el-checkbox>
					</el-form-item>
				</el-col>

				
				<el-col :span="6">
					<el-form-item label="收货浮动" prop="pvftrate">
						<el-input v-model="form.pvftrate" type="number"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="经济批量" prop="oqnum">
						<el-input v-model="form.oqnum" type="number"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="转换比率" prop="convrate">
						<el-input v-model="form.convrate" type="number"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="慢移天数" prop="movedays">
						<el-input v-model="form.movedays" type="number"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="采购属性" prop="wrhsstat">

						<el-select v-model="form.wrhsstat" placeholder="请选择">
							<el-option label="仓库" value="0">
							</el-option>
							<el-option label="部门" value="1">
							</el-option>
						</el-select>
					</el-form-item>
				</el-col>

				<el-col :span="12">
					<el-form-item label="备注" prop="memo">
						<el-input v-model="form.memo"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="" prop="flag">
						<el-checkbox v-model="form.flag" style="margin-left: 30px;">明细</el-checkbox>
					</el-form-item>
				</el-col>

			</el-row>
		</el-form>
		<template #footer>
			<BaseButton v-if="actionType !== 'detail'" type="primary" :loading="saveLoading"
				@click="saveData(ruleFormRef)">
				保存
			</BaseButton>
			<BaseButton @click="dialogVisible = false">关闭</BaseButton>
		</template>
	</Dialog>
</template>
<script setup lang="tsx">
import { ContentWrap } from '@/components/ContentWrap'
import { reactive, ref, unref, nextTick, onMounted, onUpdated } from 'vue'
import { FormSchema } from '@/components/Form'
import { Search } from '@/components/Search'
import { BaseButton } from '@/components/Button'
import { Dialog } from '@/components/Dialog'
import type { UploadProps } from 'element-plus'
import { createImageViewer } from '@/components/ImageViewer'
import { ElMessage, ElMessageBox, FormRules, FormInstance, ComponentSize, ElTable } from 'element-plus'
import { Icon } from '@/components/Icon'
import { useUserStoreWithOut } from '@/store/modules/user'
import { isEmpty, getAuthorization } from '@/utils/index'

import request from '@/axios'
import {
	exportTable
} from '@/utils/export'

const exportExcel = (() => {
	exportTable("#out-table", "table");
})

const getAuth = (() => {
	const userStore = useUserStoreWithOut()
	const token = userStore.getToken
	const tokenKey = userStore.getTokenKey
	return getAuthorization(token, tokenKey, userStore.getLoginInfo?.username || '')

})
const headers = ref({
	'Authorization': 'Bearer ' + getAuth()
})


const typeids = ref<any[]>([{
	value: -1,
	label: '全部'
},
{
	value: 0,
	label: '分类'
},
{
	value: 1,
	label: '明细'
}
])
import { useSearch } from '@/hooks/web/useSearch'
const { searchRegister, searchMethods } = useSearch()
const { setSchema, setProps, setValues, getFormData } = searchMethods

const category = ref<any[]>([])
const treeitem = ref<any[]>([])
const initData = async () => {
	setValues({
		typeid: -1
	})
	let res = await request.post({ url: '/api/ivitem/getTClass', data: {} })
	category.value = res.data || []
	res = await request.post({ url: '/api/config/getAccTree', data: {} })
	treeitem.value = res.data || []
}
const isInit = ref(true)
onMounted(async () => {
	initData()
	await getList()
	nextTick(() => {
		isInit.value = false
	})
})
interface RuleForm {
	name: string
}
const ruleFormRef = ref<FormInstance>()
const rules = reactive<FormRules<RuleForm>>({
	name: [
		{ required: true, message: '请输入名称', trigger: 'blur' }
	]
})

const tableRef = ref<InstanceType<typeof ElTable> | null>(null);
onUpdated(async () => {
	// Vue3 的 nextTick 是独立 API，返回 Promise，推荐用 await 替代回调
	await nextTick();
	// 类型守卫：避免 ref 为空或 doLayout 方法不存在导致报错
	if (tableRef.value && typeof tableRef.value.doLayout === 'function') {
		tableRef.value.doLayout(); // 调用表格的 doLayout 方法
	}
});

const openView = (src) => {
	createImageViewer({
		urlList: [
			src
		]
	})
}


interface formData {
	accno?: string[],
	accnos?: string,
	accprec?: string,
	ahnum?: string,
	category?: string,
	categoryname?: string,
	code?: string,
	convrate?: string,
	costing?: string,
	cmeno?: string,
	cust1?: string,
	cust2?: string,
	cust3?: string,
	cust4?: string[],
	cust4s?: string,
	cust5?: string,
	cust6?: string,
	cust7?: string,
	cust8?: string,
	cust9?: string,
	cvrnum?: string,
	EnName?: string,
	EnSpec?: string,
	flag?: string,
	GoodsNo?: string,
	levels?: string,
	maxqty?: string,
	memo?: string,
	minqty?: string,
	movedays?: string,
	name?: string,
	oqnum?: string,
	Overacc?: string,
	photo?: string,
	piece?: boolean,
	pieunit?: string,
	priceedit?: string,
	purunit?: string,
	pvftrate?: string,
	pym?: string,
	reorder?: string,
	semigoods?: boolean,
	spec?: string,
	stat?: boolean,
	unit?: string,
	usage?: string,
	wrhs?: string,
	wrhsstat?: string,
	Overaccs?: string[],

}

const tableHeight = ref(window.innerHeight - 300)
const tableData = ref<formData[]>([])
const currentPage = ref(1)
const pageSize = ref(100)
const size = ref<ComponentSize>('default')
const total = ref(0)
const background = ref(false)
const handleSizeChange = (val: number) => {
	currentPage.value = 1
	getList()
}
const handleCurrentChange = (val: number) => {
	if (isInit.value) return
	getList()
}
const sorts = ref({ order: 'descending', prop: 'code' })
const getSorts = () => {
	let order = "";
	if (sorts.value.order === 'descending') {
		order = 'desc'
	} else if (sorts.value.order === 'ascending') {
		order = 'asc'
	}
	return sorts.value.prop + ' ' + order
}
const getList = async () => {
	let params = await getFormData()
	//let params = { ...searchParams.value }
	let data = {
		page: unref(currentPage),
		limit: unref(pageSize),
		keys: params,
		orders: getSorts()
	}
	const res = await request.post({ url: '/api/ivitem/selectIvitemPage', data })
	tableData.value = res.data.records || []
	total.value = res.data.totalRow
}

const handleSortChange = (sort: any) => {
	sorts.value = sort
	getList();
}
const checkData = ref<formData[]>([])
const handleSelectionChange = (val: formData[]) => {
	checkData.value = val
}

const form = ref<formData>({
	accno: [],
	accnos: '',
	accprec: '',
	ahnum: '',
	category: '',
	code: '',
	convrate: '',
	costing: 'FIFO',
	cust1: '',
	cust2: '',
	cust3: '',
	cust4: [],
	cust4s: '',
	cust5: '',
	cust6: '',
	cust7: '',
	cust8: '',
	cust9: '',
	cvrnum: '',
	EnName: '',
	EnSpec: '',
	flag: '',
	GoodsNo: '',
	levels: '',
	maxqty: '',
	memo: '',
	minqty: '',
	movedays: '',
	name: '',
	oqnum: '',
	Overacc: '',
	photo: '',
	piece: false,
	pieunit: '',
	priceedit: '',
	purunit: '',
	pvftrate: '1',
	pym: '',
	reorder: '',
	semigoods: false,
	spec: '',
	stat: true,
	unit: '',
	usage: '',
	wrhs: '',
	wrhsstat: '',
	Overaccs: [],

})
const actionType = ref('')
const actionUrl = ref(import.meta.env.VITE_API_BASE_PATH + '/api/file/imgupload')
const handleAvatarSuccess: UploadProps['onSuccess'] = (
	response
) => {
	//form.value. = response.url
}

const beforeAvatarUpload: UploadProps['beforeUpload'] = (rawFile) => {
	if (!rawFile.type.includes('image')) {
		ElMessage.error('请上传图片格式文件!')
		return false
	} else if (rawFile.size / 1024 / 1024 > 2) {
		ElMessage.error('图片大小不能超过2MB!')
		return false
	}
	return true
}



const searchSchema = reactive<FormSchema[]>([
	{
		field: 'category',
		label: '类别',
		component: 'Select',
		optionApi: async () => {
			let data = category.value.map((v: any) => ({
				label: v.name,
				value: v.code
			}))
			return data
		}
	},

	{
		field: 'code',
		label: '编码',
		component: 'Input'
	},

	{
		field: 'name',
		label: '名称',
		component: 'Input'
	},
	{
		field: 'flag',
		label: '类型',
		component: 'Select',
		componentProps: {
			options: typeids.value
		},
		value: -1
	}

])

const searchParams = ref({})
const setSearchParams = (data: any) => {
	searchParams.value = data
	currentPage.value = 1
	getList()
}

const editData = async (row: any) => {
	dialogTitle.value = '修改'
	actionType.value = 'edit'
	const res = await request.post({ url: '/api/ivitem/getIvitem', data: { code: row.code } })
	if (!isEmpty(res.data.accnos)) {
		res.data.accno = res.data.accnos.split(',')
	} else {
		res.data.accno = []
	}
	if (!isEmpty(res.data.cust4s)) {
		res.data.cust4 = res.data.cust4s.split(',')
	} else {
		res.data.cust4 = []
	}
	if (!isEmpty(res.data.Overaccs)) {
		res.data.Overacc = res.data.Overaccs.split(',')
	} else {
		res.data.Overacc = []
	}
	console.log(res.data)
	form.value = res.data || {};
	dialogVisible.value = true

}

const delLoading = ref(false)
const ids = ref<string[]>([])
const delData = async (row: any | null) => {
	if (row == null) {
		ids.value = checkData.value.map((v: any) => v.code) || []
	} else {
		ids.value = [row.code]
	}
	if (ids.value.length == 0) {
		ElMessage.error('请选择要删除的数据')
		return
	} else {
		ElMessageBox.confirm('确定删除选中的数据吗？', '删除确认', {
			confirmButtonText: '确定',
			cancelButtonText: '取消',
			type: 'warning'
		}).then(async () => {
			delLoading.value = true
			const res = await request.post({
				url: '/api/ivitem/deleteIvitems',
				data: {
					ids: ids.value
				}
			}).catch(() => {
				ElMessage.error('删除失败')
			}).finally(() => {
				delLoading.value = false
			})
			if (res && res.code === 0) {
				ElMessage.success('删除成功')
				getList()
			}
		})
	}

}

const dialogVisible = ref(false)
const dialogTitle = ref('')
const AddAction = async () => {
	dialogTitle.value = '增加'
	actionType.value = ''
	form.value = {
		accno: [],
		accnos: '',
		accprec: '',
		ahnum: '0',
		category: '',
		code: '',
		convrate: '1',
		costing: 'FIFO',
		cust1: '',
		cust2: '',
		cust3: '',
		cust4: [],
		cust4s: '',
		cust5: '',
		cust6: '',
		cust7: '',
		cust8: '',
		cust9: '',
		cvrnum: '',
		EnName: '',
		EnSpec: '',
		flag: '',
		GoodsNo: '',
		levels: '',
		maxqty: '',
		memo: '',
		minqty: '',
		movedays: '1',
		name: '',
		oqnum: '1',
		Overacc: '',
		photo: '',
		piece: false,
		pieunit: '',
		priceedit: '',
		purunit: '',
		pvftrate: '0',
		pym: '',
		reorder: '',
		semigoods: false,
		spec: '',
		stat: true,
		unit: '',
		usage: '',
		wrhs: '',
		wrhsstat: '0',
		Overaccs: [],

	};

	dialogVisible.value = true
}

const saveLoading = ref(false)
const saveData = async (formEl: FormInstance | undefined) => {
	if (!formEl) return
	await formEl.validate(async (valid) => {
		if (valid) {
			let formData = { ...form.value }
			if (Array.isArray(formData.Overacc) && formData.Overacc.length > 0) {
				formData.Overaccs = formData.Overacc.join(',')
				formData.Overacc = formData.Overacc[formData.Overacc.length - 1]
			} else {
				formData.Overaccs = ''
				formData.Overacc = ''
			}
			if (Array.isArray(formData.cust4) && formData.cust4.length > 0) {
				formData.cust4s = formData.cust4.join(',')
				formData.cust4 = formData.cust4[formData.cust4.length - 1]
			} else {
				formData.cust4s = ''
				formData.cust4 = ''
			}
			if (Array.isArray(formData.accno) && formData.accno.length > 0) {
				formData.accnos = formData.accno.join(',')
				formData.accno = formData.accno[formData.accno.length - 1]
			} else {
				formData.accnos = ''
				formData.accno = ''
			}

			if (formData) {
				saveLoading.value = true
				const res = await request.post({
					url: actionType.value === 'edit' ? '/api/ivitem/updateIvitem' : '/api/ivitem/insertIvitem',
					data: formData
				}).catch(() => {
					ElMessage.error('保存失败')
				}).finally(() => {
					saveLoading.value = false
				})
				if (res && res.code === 0) {
					ElMessage.success('保存成功')
					dialogVisible.value = false
					getList()
					initData()
				}
			}
		}
	})
}
import { Plus, View, Refresh, Delete, Document, Edit } from '@element-plus/icons-vue'
import { de } from 'element-plus/es/locale'
</script>


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

::v-deep .el-table .el-table__cell {
	z-index: inherit !important;
}
</style>