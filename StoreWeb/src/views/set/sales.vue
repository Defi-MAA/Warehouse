<template>
	<ContentWrap>

		<div style="border-bottom: 1px solid #e4e7ed;">
			<Search show-expand expand-field="cisdtl" :schema="searchSchema" @reset="setSearchParams"
				@search="setSearchParams" />
		</div>
		<div class="mb-10px" style="margin-top: 10px;">
			<BaseButton type="primary" :icon="Plus" @click="AddAction">增加</BaseButton>
			<BaseButton :loading="delLoading" :icon="Delete" type="danger" @click="delData(null)">
				删除
			</BaseButton>
			<BaseButton type="warning" :icon="Document" @click="exportExcel">导出</BaseButton>
		</div>

		<el-table :data="tableData" @sort-change="handleSortChange" :default-sort="{
			prop: 'cclas',
			order: 'descending'
		}" style="width: 100%" :height="tableHeight" :header-cell-style="{ color: '#000000' }"
			@selection-change="handleSelectionChange" @row-dblclick="editData" id="out-table" stripe :border="true"
			ref="tableRef">
			<el-table-column type="selection" width="55" />
			<el-table-column align="center" prop="ccode" label="销售编码" sortable="custom" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="cname" label="销售名称" sortable="custom" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="cisdtl" label="明细" sortable="custom" width="150px">
				<template #default="{ row }">
					<el-checkbox v-model="row.cisdtl" onclick="return false; "></el-checkbox>
				</template>
			</el-table-column>
			<el-table-column align="center" prop="clevels" label="级别" sortable="custom" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="cstatus" label="状态" sortable="custom" width="150px">
				<template #default="{ row }">
					<el-checkbox v-model="row.cstatus" onclick="return false; "></el-checkbox>
				</template>
			</el-table-column>
			<el-table-column align="center" prop="ccategory" label="类型" sortable="custom" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="cbal" label="应付金额" sortable="custom" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="ccredit" label="信用限额" sortable="custom" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="cbegdt" label="有效期起" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="cenddt" label="有效期止" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="cbankname" label="开户银行" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="cbankacc" label="帐号" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="ctaxid" label="税号" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="caddress" label="地址" sortable="custom" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="czipcode" label="邮编" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="ctel" label="电话" sortable="custom" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="ccontact" label="联系人" sortable="custom" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="caccno" label="应付帐款科目" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="cpreaccno" label="预付帐款科目" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="cinterval" label="结算周期" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="cdiscount" label="折扣条件" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="cmemo" label="备注" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="cmodpsn" label="修改人" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="ctax" label="是否计税" width="150px">
				<template #default="{ row }">
					<el-checkbox v-model="row.ctax" onclick="return false; "></el-checkbox>
				</template>
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

	<Dialog v-model="dialogVisible" :title="dialogTitle" width="1100px">
		<el-form :model="form" label-width="auto" ref="ruleFormRef" :rules="rules">
			<el-row :gutter="10">

				<el-col :span="6">
					<el-form-item label="销售编码" prop="ccode">
						<el-input v-model="form.ccode"></el-input>
					</el-form-item>
				</el-col>

				<el-col :span="12">
					<el-form-item label="销售名称" prop="cname">
						<el-input v-model="form.cname"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="应付余额" prop="cbal">
						<el-input v-model="form.cbal"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="助记号" prop="pym">
						<el-input v-model="form.pym"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="" prop="cisdtl" label-width="80px">

						<el-checkbox v-model="form.cisdtl">明细</el-checkbox>
					</el-form-item>
				</el-col>

				<el-col :span="6">
					<el-form-item label="信用额度" prop="spec">
						<el-input v-model="form.ccredit"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="级别" prop="clevels">

						<el-select v-model="form.clevels" placeholder="请选择">
							<el-option label="一级" value="0">
							</el-option>
							<el-option label="二级" value="1">
							</el-option>
							<el-option label="三级" value="2">
							</el-option>
							<el-option label="四级" value="3">
							</el-option>
							<el-option label="五级" value="4">
							</el-option>
							<el-option label="六级" value="5">
							</el-option>
							<el-option label="七级" value="6">
							</el-option>
							<el-option label="八级" value="7">
							</el-option>
							<el-option label="九级" value="8">
							</el-option>
						</el-select>
					</el-form-item>
				</el-col>


				<el-col :span="6">
					<el-form-item label="" prop="cstatus" label-width="80px">

						<el-checkbox v-model="form.cstatus">有效</el-checkbox>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="有效期起" prop="cbegdt">
						<el-date-picker v-model="form.cbegdt" style="width: 140px;" type="date"
							value-format="YYYY-MM-DD" placeholder="选择日期">
						</el-date-picker>

					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="有效期止" prop="cenddt">
						<el-date-picker v-model="form.cenddt" style="width: 140px;" type="date"
							value-format="YYYY-MM-DD" placeholder="选择日期">
						</el-date-picker>
					</el-form-item>
				</el-col>

				<el-col :span="6">
					<el-form-item label="销售类别" prop="ccategory">
						<el-select v-model="form.ccategory" placeholder="请选择">
							<el-option v-for="(item, index) in category" :label="item.name" :value="item.code">
							</el-option>
						</el-select>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="开户银行" prop="cbankname">
						<el-input v-model="form.cbankname"></el-input>
					</el-form-item>
				</el-col>
				
				<el-col :span="6">
					<el-form-item label="帐号" prop="cbankacc">
						<el-input v-model="form.cbankacc"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="邮编" prop="czipcode">
						<el-input v-model="form.czipcode"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="税务登记号" prop="ctaxid">
						<el-input v-model="form.ctaxid"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="地址1" prop="caddress">
						<el-input v-model="form.caddress"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="地址2" prop="caddress1">
						<el-input v-model="form.caddress1"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="地址3" prop="caddress2">
						<el-input v-model="form.caddress2"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="地址4" prop="caddress3">
						<el-input v-model="form.caddress3"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="电话" prop="ctel">
						<el-input v-model="form.ctel"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="传真" prop="cfax">
						<el-input v-model="form.cfax"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="Email" prop="cemail">
						<el-input v-model="form.cemail"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="联系人" prop="ccontact">
						<el-input v-model="form.ccontact"></el-input>
					</el-form-item>
				</el-col>


				<el-col :span="6">
					<el-form-item label="预付账款科目" prop="cpreaccno">
						
						<el-cascader filterable v-model="form.cpreaccno" :show-all-levels="false" :options="treeitem"
							:props="{ expandTrigger: 'hover' }">
						</el-cascader>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="应付账款科目" prop="caccno">
						
						<el-cascader filterable v-model="form.caccno" :show-all-levels="false" :options="treeitem"
							:props="{ expandTrigger: 'hover' }">
						</el-cascader>
					</el-form-item>
				</el-col>

				<el-col :span="6">
					<el-form-item label="销售类型" prop="ccusttype">
						<el-select v-model="form.ccusttype" placeholder="请选择">
							<el-option label="内部" value="0">
							</el-option>
							<el-option label="外部" value="1">
							</el-option>
							<el-option label="自购" value="2">
							</el-option>
						</el-select>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="结算周期" prop="cinterval">

						<el-select v-model="form.cinterval" @change="setMeno" style="width: 100px;" placeholder="请选择">
							<el-option value="Y" label="年">
							</el-option>
							<el-option value="M" label="月">
							</el-option>
							<el-option value="S" label="季">
							</el-option>
							<el-option value="D" label="旬">
							</el-option>
							<el-option value="W" label="周">
							</el-option>
							<el-option value="C" label="自定义">
							</el-option>
						</el-select>

						<el-input v-model="form.cmemo" v-show="cshow" style="width: 35%;"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="折扣条件" prop="cdiscount">
						<el-input v-model="form.cdiscount"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="" prop="ctax" label-width="80px">

						<el-checkbox v-model="form.ctax">计税</el-checkbox>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="修改人" prop="cmodpsn">
						<el-input readonly v-model="form.cmodpsn"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="12">
					<el-form-item label="备注" prop="cdscr">
						<el-input v-model="form.cdscr"></el-input>
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
import { isEmpty, getAuthorization, removeUnderscoreFromKeys } from '@/utils/index'
import { formatToDate } from '@/utils/dateUtil'
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
const category = ref<any[]>([])
const treeitem = ref<any[]>([])

const initData = async () => {
	let res = await request.post({ url: '/api/cust/getTClass', data: { cclas: '2' } })
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
	cabbr?: string,
	caccno?: string[],
	caccnos?: string,
	caddress?: string,
	caddress1?: string,
	caddress2?: string,
	caddress3?: string,
	cbal?: string,
	cbankacc?: string,
	cbankname?: string,
	cbegdt?: string,
	ccategory?: string,
	cclas?: string,
	ccode?: string,
	ccontact?: string,
	ccredit?: string,
	ccusttype?: string,
	cdiscount?: string,
	cdscr?: string,
	cemail?: string,
	cenddt?: string,
	cfax?: string,
	cflag?: string,
	cinterval?: string,
	cisdtl?: boolean,
	clevels?: string,
	cmemo?: string,
	cmodpsn?: string,
	cname?: string,
	cphoto?: string,
	cpreaccno?: string[],	
	cpreaccnos?: string,
	csigners?: string,
	cstatus?: boolean,
	ctax?: boolean,
	ctaxid?: string,
	ctel?: string,
	czipcode?: string,
	FisCreditCard?: string,
	pym?: string
	cmeno?: string

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
const sorts = ref({ order: 'descending', prop: 'cclas' })
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

	let params = { ...searchParams.value }
	params.cclas = '2'
	let data = {
		page: unref(currentPage),
		limit: unref(pageSize),
		keys: params,
		orders: getSorts()
	}
	const res = await request.post({ url: '/api/cust/selectCustPage', data })
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
	cabbr: '',
	caccno: [],
	caccnos: '',
	caddress: '',
	caddress1: '',
	caddress2: '',
	caddress3: '',
	cbal: '',
	cbankacc: '',
	cbankname: '',
	cbegdt: '',
	ccategory: '',
	cclas: '',
	ccode: '',
	ccontact: '',
	ccredit: '',
	ccusttype: '',
	cdiscount: '',
	cdscr: '',
	cemail: '',
	cenddt: '',
	cfax: '',
	cflag: '0',
	cinterval: '',
	cisdtl: false,
	clevels: '',
	cmemo: '',
	cmodpsn: '',
	cname: '',
	cphoto: '',
	cpreaccno: [],
	cpreaccnos: '',
	csigners: '',
	cstatus: true,
	ctax: true,
	ctaxid: '',
	ctel: '',
	czipcode: '',
	FisCreditCard: '',
	pym: '',

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
		field: 'ccategory',
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
		field: 'ccode',
		label: '编码',
		component: 'Input'
	},
	{
		field: 'cname',
		label: '名称',
		component: 'Input'
	},
	{
		field: 'cisdtl',
		label: '类型',
		component: 'Select',
		optionApi: async () => {
			return typeids.value
		},
		value: -1
	}


])

const cshow = ref(false)
const setMeno = async (e: any) => {
	console.log(e)
	if (e == 'Y') {
		form.value.cmeno = "365";
		cshow.value = false;
	} else if (e == 'M') {
		form.value.cmeno = "30";
		cshow.value = false;
	} else if (e == 'D') {
		form.value.cmeno = "10";
		cshow.value = false;
	} else if (e == 'S') {
		form.value.cmeno = "90";
		cshow.value = false;
	} else if (e == 'W') {
		form.value.cmeno = "7";
		cshow.value = false;
	} else if (e == 'C') {
		cshow.value = true;
	}
}

const searchParams = ref<any>({})
const setSearchParams = (data: any) => {
	searchParams.value = data
	currentPage.value = 1
	getList()
}

const editData = async (row: any) => {
	dialogTitle.value = '修改'
	actionType.value = 'edit'
	const res = await request.post({ url: '/api/cust/getCust', data: { cclas: row.cclas, ccode: row.ccode } })
	if (!isEmpty(res.data.cpreaccnos)) {
		res.data.cpreaccno = res.data.cpreaccnos.split(',')
	} else {
		res.data.cpreaccno = []
	}
	if (!isEmpty(res.data.caccnos)) {
		res.data.caccno = res.data.caccnos.split(',')
	} else {
		res.data.caccno = []
	}
	form.value = res.data || {};
	dialogVisible.value = true

}

const delLoading = ref(false)
const ids = ref<string[]>([])
const delData = async (row: any | null) => {
	if (row == null) {
		ids.value = checkData.value.map((v: any) => v.cclas) || []
	} else {
		ids.value = [row.cclas]
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
				url: '/api/cust/deleteCusts',
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
		cabbr: '',
		caccno: [],
		caccnos: '',
		caddress: '',
		caddress1: '',
		caddress2: '',
		caddress3: '',
		cbal: '',
		cbankacc: '',
		cbankname: '',
		cbegdt: formatToDate(new Date()),
		ccategory: '',
		cclas: '2',
		ccode: '',
		ccontact: '',
		ccredit: '',
		ccusttype: '0',
		cdiscount: '',
		cdscr: '',
		cemail: '',
		cenddt: formatToDate(new Date()),
		cfax: '',
		cflag: '0',
		cinterval: 'Y',
		cisdtl: true,
		clevels: '0',
		cmemo: '',
		cmodpsn: '',
		cname: '',
		cphoto: '',
		cpreaccno: [],
		cpreaccnos: '',
		csigners: '',
		cstatus: true,
		ctax: false,
		ctaxid: '',
		ctel: '',
		czipcode: '',
		FisCreditCard: '',
		pym: '',

	};

	dialogVisible.value = true
}

const saveLoading = ref(false)
const saveData = async (formEl: FormInstance | undefined) => {
	if (!formEl) return
	await formEl.validate(async (valid) => {
		if (valid) {
			let formData = { ...form.value }
			if (Array.isArray(formData.cpreaccno) && formData.cpreaccno.length > 0) {
				formData.cpreaccnos = formData.cpreaccno.join(',')
				formData.cpreaccno = formData.cpreaccno[formData.cpreaccno.length - 1]
			} else {
				formData.cpreaccnos = ''
				formData.cpreaccno = ''
			}
			if (Array.isArray(formData.caccno) && formData.caccno.length > 0) {
				formData.caccnos = formData.caccno.join(',')
				formData.caccno = formData.caccno[formData.caccno.length - 1]
			} else {
				formData.caccnos = ''
				formData.caccno = ''
			}
			if (formData) {
				saveLoading.value = true
				const res = await request.post({
					url: actionType.value === 'edit' ? '/api/cust/updateCust' : '/api/cust/insertCust',
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