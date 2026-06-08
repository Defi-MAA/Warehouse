<template>
	<ContentWrap>
		<div style="border-bottom: 1px solid #e4e7ed;">
			<Search show-expand expand-field="flag" :schema="searchSchema" @reset="setSearchParams" @search="setSearchParams" />
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
		}" style="width: 100%" :height="tableHeight" :header-cell-style="{ color: '#000000' }"
			@selection-change="handleSelectionChange" @row-dblclick="editData" id="out-table" stripe :border="true"
			ref="tableRef">
			<el-table-column type="selection" width="55" />

			<el-table-column align="center" prop="code" label="仓库编码" sortable="custom"  width="150px">
			</el-table-column>
			<el-table-column align="center" prop="name" label="仓库名称" sortable="custom"  width="150px">

			</el-table-column>
			<el-table-column align="center" prop="wrhsstat" label="仓库类型" sortable="custom"  width="150px">				
				<template #default="scope">{{ scope.row.wrhsstat == '0' ? '仓库' : '部门' }}</template>
			</el-table-column>
			<el-table-column align="center" prop="manager" label="主管" width="150px">
			</el-table-column>

			<el-table-column align="center" prop="place" label="位置" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="area" label="面积(平方米)" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="accno" label="对应科目" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="wrhslevel" label="级别" sortable="custom"  width="150px">
			</el-table-column>
			<el-table-column align="center" prop="status" label="状态" sortable="custom"  width="150px">
				<template #default="{ row }">
					<el-checkbox v-model="row.status" onclick="return false; "></el-checkbox>
				</template>
			</el-table-column>
			<el-table-column align="center" prop="memo" label="备注" width="150px">
			</el-table-column>
			<el-table-column align="center" prop="flag" label="标志" sortable="custom"  width="150px">
				<template #default="{ row }">
					<el-checkbox v-model="row.flag" onclick="return false; "></el-checkbox>
				</template>
			</el-table-column>
			<el-table-column align="center" prop="ictowi" label="盘点生成领料" width="150px">
				<template #default="{ row }">
					<el-checkbox v-model="row.ictowi" onclick="return false; "></el-checkbox>
				</template>
			</el-table-column>
			<el-table-column align="center" prop="widept" label="对应部门" width="150px">
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
					<el-form-item label="仓库编码"  prop="code">
						<el-input v-model="form.code"></el-input>
					</el-form-item>
				</el-col>

				<el-col :span="12">
					<el-form-item label="仓库名称"  prop="name">
						<el-input v-model="form.name"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="仓库类型"  prop="wrhsstat">
						<el-select v-model="form.wrhsstat" placeholder="请选择">
							<el-option label="仓库" value="0">
							</el-option>
							<el-option label="部门" value="1">
							</el-option>
						</el-select>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="仓库类别"  prop="category">
						<el-select v-model="form.category" placeholder="请选择">
							<el-option v-for="item in category" :label="item.name" :value="item.code">
							</el-option>
						</el-select>
					</el-form-item>
				</el-col>

				<el-col :span="6">
					<el-form-item label="主管"  prop="manager">
						<el-input v-model="form.manager"></el-input>
					</el-form-item>
				</el-col>

				<el-col :span="6">
					<el-form-item label="位置"  prop="place">
						<el-input v-model="form.place"></el-input>
					</el-form-item>
				</el-col>

				<el-col :span="6">
					<el-form-item label="面积(平方米)"  prop="area">
						<el-input v-model="form.area"></el-input>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label="对应科目"  prop="accno">
						<el-cascader filterable v-model="form.accno" :show-all-levels="false" :options="treeitem"
							:props="{ expandTrigger: 'hover' }">
						</el-cascader>
					</el-form-item>
				</el-col>


				<el-col :span="6">
					<el-form-item label="仓库级别"  prop="wrhslevel">

						<el-select v-model="form.wrhslevel" placeholder="请选择">
							<el-option v-for="item in storetype" :label="item.name" :value="item.code">
							</el-option>
						</el-select>
					</el-form-item>
				</el-col>


				<el-col :span="6">
					<el-form-item label=""  prop="status">

						<el-checkbox v-model="form.status">有效</el-checkbox>
					</el-form-item>
				</el-col>

				<el-col :span="6">
					<el-form-item label=""  prop="semigoods">

						<el-checkbox v-model="form.flag">明细</el-checkbox>
					</el-form-item>
				</el-col>
				<el-col :span="6">
					<el-form-item label=""  prop="ictowi">

						<el-checkbox v-model="form.ictowi">盘点生成领料</el-checkbox>
					</el-form-item>
				</el-col>

				<el-col :span="12">
					<el-form-item label="备注"  prop="memo">
						<el-input v-model="form.memo"></el-input>
					</el-form-item>
				</el-col>

				<el-col :span="6">
					<el-form-item label="对应部门"  prop="widept">
						<el-input v-model="form.widept"></el-input>
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
const category = ref<any[]>([])
const storetype = ref<any[]>([])
const treeitem = ref<any[]>([])

const initData = async () => {
	let res = await request.post({ url: '/api/ivwrhs/getTClass',data:{} })
	category.value = res.data || []
	res = await request.post({ url: '/api/config/getCodes',data:{category:'4'} })
	storetype.value = res.data || []
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
	area?: string,
	category?: string,
	code?: string,
	flag?: boolean,
	ictowi?: boolean,
	levels?: string,
	manager?: string,
	memo?: string,
	name?: string,
	place?: string,
	status?: boolean,
	widept?: string,
	wrhslevel?: string,
	wrhsstat?: string,

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

	let params = { ...searchParams.value }
	let data = {
		page: unref(currentPage),
		limit: unref(pageSize),
		keys: params,
		orders: getSorts()
	}
	const res = await request.post({ url: '/api/ivwrhs/selectIvwrhsPage', data })
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
	area: '',
	category: '',
	code: '',
	flag: true,
	ictowi: true,
	levels: '',
	manager: '',
	memo: '',
	name: '',
	place: '',
	status: true,
	widept: '',
	wrhslevel: '',
	wrhsstat: '',

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
		field: 'flag',
		label: '类型',
		component: 'Select',
		optionApi: async () => {
			return typeids.value
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
	const res = await request.post({ url: '/api/ivwrhs/getIvwrhs', data: { code: row.code } })
	if (!isEmpty(res.data.accnos)) {
		res.data.accno = res.data.accnos.split(',')
	} else {
		res.data.accno = []
	}
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
				url: '/api/ivwrhs/deleteIvwrhss',
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
		accnos: [],
		area: '',
		category: '',
		code: '',
		flag: true,
		ictowi: true,
		levels: '',
		manager: '',
		memo: '',
		name: '',
		place: '',
		status: true,
		widept: '',
		wrhslevel: '',
		wrhsstat: '0',

	};

	dialogVisible.value = true
}

const saveLoading = ref(false)
const saveData = async (formEl: FormInstance | undefined) => {
	if (!formEl) return
	await formEl.validate(async (valid) => {
		if (valid) {
			let formData = { ...form.value }
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
					url: actionType.value === 'edit' ? '/api/ivwrhs/updateIvwrhs' : '/api/ivwrhs/insertIvwrhs',
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