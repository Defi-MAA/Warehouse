<template>
	<div class="app-container">
		<div>
			<el-tabs v-model="activeName" @tab-click="handleClick">
				<el-tab-pane label="基本信息" name="first">
					<!-- <div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">物资系统图片目录: </label>
						<el-input v-model="params.bitmap_m" placeholder="" style="width:200px;" />
					</div>
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">单据附件存放目录: </label>
						<el-input v-model="params.docpath" placeholder="" style="width:200px;" />
					</div>
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">扫描未审批单据间隔时间(秒): </label>
						<el-input v-model="params.myaudit" type="number" placeholder="" style="width:200px;" />
					</div>
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">单据打印行数: </label>
						<el-input v-model="params.prn_line" type="number" placeholder="" style="width:200px;" />
					</div> 
					<div style="display:inline-block;">
						<el-checkbox v-model="params.ivucvch" style="padding-left:20px;">启用一体化制证</el-checkbox>
					</div>
					<div style="display:inline-block;">
						<el-checkbox v-model="params.wri_memo" style="padding-left:20px;">单据录入时是否自动生成备注内容</el-checkbox>
					</div>-->
					<div style="display:inline-block;">
						<el-checkbox v-model="params.autopost" style="padding-left:20px;">自动审核和过账</el-checkbox>
					</div>
					<!-- <div style="display:inline-block;">
						<el-checkbox v-model="params.inhrtval" style="padding-left:20px;">继承上次输入的值</el-checkbox>
					</div>
					<div style="display:inline-block;">
						<el-checkbox v-model="params.modtcode" style="padding-left:20px;">允许输入事务编号</el-checkbox>
					</div>
					<div style="display:inline-block;">
						<el-checkbox v-model="params.prtpost" style="padding-left:20px;">打印的过账检查</el-checkbox>
					</div> 

					<div style="display:inline-block;">
						<el-checkbox v-model="params.modtdate" style="padding-left:20px;">允许修改单据日期</el-checkbox>
					</div>-->

				</el-tab-pane>
				<el-tab-pane label="编码设置" name="second">
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">金额精度: </label>
						<el-input v-model="params.MoneyPre" type="number" placeholder="" style="width:200px;" />
					</div>
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">单价精度: </label>
						<el-input v-model="params.PricePre" type="number" placeholder="" style="width:200px;" />
					</div>
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">数量精度: </label>
						<el-input v-model="params.QtyPre" type="number" placeholder="" style="width:200px;" />
					</div>
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">物资编码规则: </label>
						<el-input v-model="params.coderule" placeholder="" style="width:200px;" />
					</div>

				</el-tab-pane>
				<!-- <el-tab-pane label="采购设置" name="third">
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">报价单复制时本期报价值: </label>
						<el-select v-model="params.pqcpyprc" placeholder="请选择" style="width:200px;">
							<el-option label="清空" value="0">
							</el-option>
							<el-option label="保留" value="1">
							</el-option>
						</el-select>
					</div>
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">定价单复制时本期定价值: </label>
						<el-select v-model="params.pmcpyprc" placeholder="请选择" style="width:200px;">
							<el-option label="清空" value="0">
							</el-option>
							<el-option label="保留" value="1">
							</el-option>
						</el-select>
					</div>

					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">设定定价单默认供应商: </label>
						<el-input v-model="params.pmvndr" placeholder="" style="width:200px;" />
					</div>
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">初始价格: </label>
						<el-select v-model="params.setpmpri" placeholder="请选择" style="width:200px;">
							<el-option label="定价单" value="1">
							</el-option>
							<el-option label="报价单" value="2">
							</el-option>
						</el-select>
					</div>

					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">是否允许修改审核后的采购类单据: </label>
						<el-select v-model="params.auditmdf" placeholder="请选择" style="width:200px;">
							<el-option label="不能修改" value="0">
							</el-option>
							<el-option label="任意人修改" value="1">
							</el-option>
							<el-option label="审批人修改" value="2">
							</el-option>

						</el-select>
					</div>
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">请购单单价及建议供应权限用户: </label>
						<el-input v-model="params.prprice" placeholder="" style="width:200px;" />
					</div>
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">收货有效期天数: </label>
						<el-input v-model="params.pvindays" type="number" placeholder="" style="width:200px;" />
					</div>
					<div style="display:inline-block;">
						<el-checkbox v-model="params.editpri" style="padding-left:20px;">是否允许编辑单价</el-checkbox>
					</div>
					<div style="display:inline-block;">
						<el-checkbox v-model="params.clearpri" style="padding-left:20px;">切换供应商时是否清除原有单价</el-checkbox>
					</div>
					<div style="display:inline-block;">
						<el-checkbox v-model="params.chkstep" style="padding-left:20px;">采购单据审批步骤检查</el-checkbox>
					</div>

				</el-tab-pane>
				<el-tab-pane label="库存设置" name="fourth">
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">检查进价: </label>
						<el-input v-model="params.chkprice" type="number" placeholder="" style="width:200px;" />
					</div>
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">订货单至入库/直接单路径: </label>
						<el-select v-model="params.mrproute" placeholder="请选择" style="width:200px;">
							<el-option label="服务器日期" value="0">
							</el-option>
							<el-option label="本地日期" value="1">
							</el-option>

						</el-select>
					</div>
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">单据窗口上当前库存显示内容: </label>
						<el-select v-model="params.stockdisp" placeholder="请选择" style="width:200px;">
							<el-option label="当前实际库存数" value="1">
							</el-option>
							<el-option label="当前库存试算数" value="2">
							</el-option>

						</el-select>
					</div>
					<div style="display:inline-block;">
						<el-checkbox v-model="params.adtchk" style="padding-left:20px;">入库、直拨审核时检查单价</el-checkbox>
					</div>
					<div style="display:inline-block;">
						<el-checkbox v-model="params.chkusage" style="padding-left:20px;">领料／直拨是否校验用途</el-checkbox>
					</div>
					<div style="display:inline-block;">
						<el-checkbox v-model="params.DualUnit" style="padding-left:20px;">是否双单位核算</el-checkbox>
					</div>
					<div style="display:inline-block;">
						<el-checkbox v-model="params.ivadtmdf" style="padding-left:20px;">是否允许修改审核后的库存类单据</el-checkbox>
					</div>
					<div style="display:inline-block;">
						<el-checkbox v-model="params.aplit" style="padding-left:20px;">照部门和仓库进</el-checkbox>
					</div>
					<div style="display:inline-block;">
						<el-checkbox v-model="params.autoprnt" style="padding-left:20px;">过帐后自动打印</el-checkbox>
					</div>
					<div style="display:inline-block;">
						<el-checkbox v-model="params.needsa" style="padding-left:20px;">是否启用销售单</el-checkbox>
					</div>
					<div style="display:inline-block;">
						<el-checkbox v-model="params.WIQtyChk" style="padding-left:20px;">领用单保存时是否检查领用数量</el-checkbox>
					</div>
				</el-tab-pane>
				<el-tab-pane label="应付设置" name="fird">
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">应付结算单中支票项目对应的编号: </label>
						<el-input v-model="params.apcheck" placeholder="" style="width:200px;" />
					</div>

					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">未收到发票货物中转科目: </label>
						<el-input v-model="params.apacctmp" placeholder="" style="width:200px;" />
					</div>
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">应付折扣金额对应科目: </label>
						<el-input v-model="params.apdisacc" placeholder="" style="width:200px;" />
					</div>
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">应付税额对应的会计科目: </label>
						<el-input v-model="params.aptaxacc" placeholder="" style="width:200px;" />
					</div>
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">应付凭证必需录入字段列表: </label>
						<el-input v-model="params.apmustin" placeholder="" style="width:200px;" />
					</div>

					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">支票打印INVOICE明细可打印行数: </label>
						<el-input v-model="params.apptline" type="number" placeholder="" style="width:200px;" />
					</div>
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">挂账税率: </label>
						<el-input v-model="params.taxrate" type="number" placeholder="" style="width:200px;" />
					</div>
					<div style="display:inline-block;">
						<label class="radio-label" style="padding-left:10px;">应付系统冲减凭证的日期取值: </label>
						<el-input v-model="params.apvdate" placeholder="" style="width:200px;" />
					</div>

					<div style="display:inline-block;">
						<el-checkbox v-model="params.apautowo" style="padding-left:20px;">应付自动核销</el-checkbox>
					</div>
					<div style="display:inline-block;">
						<el-checkbox v-model="params.ihandate" style="padding-left:20px;">是否允许修改库存挂应付凭证日期</el-checkbox>
					</div>
					<div style="display:inline-block;">
						<el-checkbox v-model="params.chkinvno" style="padding-left:20px;">是否供应商检查发票号重复</el-checkbox>
					</div>

				</el-tab-pane> -->

			</el-tabs>

			<el-button :loading="isloading" style="margin:0 0 20px 20px;" type="success" :icon="Edit" @click="saveData">
				保存
			</el-button>
		</div>
	</div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import request from '@/axios'
import { Edit } from '@element-plus/icons-vue'

// 定义参数接口类型
interface ParamsType {
	bitmap_m?: string
	docpath?: string
	myaudit?: string | number
	prn_line?: string | number
	ivucvch?: boolean
	wri_memo?: boolean
	autopost?: boolean
	inhrtval?: boolean
	modtcode?: boolean
	prtpost?: boolean
	modtdate?: boolean
	MoneyPre?: string | number
	PricePre?: string | number
	QtyPre?: string | number
	coderule?: string
	pqcpyprc?: string
	pmcpyprc?: string
	pmvndr?: string
	setpmpri?: string
	auditmdf?: string
	prprice?: string
	pvindays?: string | number
	editpri?: boolean
	clearpri?: boolean
	chkstep?: boolean
	chkprice?: string | number
	mrproute?: string
	stockdisp?: string
	adtchk?: boolean
	chkusage?: boolean
	DualUnit?: boolean
	ivadtmdf?: boolean
	aplit?: boolean
	autoprnt?: boolean
	needsa?: boolean
	WIQtyChk?: boolean
	apcheck?: string
	apacctmp?: string
	apdisacc?: string
	aptaxacc?: string
	apmustin?: string
	apptline?: string | number
	taxrate?: string | number
	apvdate?: string
	apautowo?: boolean
	ihandate?: boolean
	chkinvno?: boolean
	[key: string]: any
}

// 状态定义
const params = reactive<ParamsType>({})
const isloading = ref<boolean>(false)
const activeName = ref<string>('first')
const token = ref<string>('')

// 方法定义
const handleClick = () => {
	// tab切换时的逻辑
}

const saveData = () => {
	isloading.value = true
	let data = { ...params };
	data.ivucvch = toStr(data.ivucvch)
	data.wri_memo = toStr(data.wri_memo)
	data.autopost = toStr(data.autopost)
	data.inhrtval = toStr(data.inhrtval)
	data.modtcode = toStr(data.modtcode)
	data.prtpost = toStr(data.prtpost)
	data.modtdate = toStr(data.modtdate)

	data.editpri = toStr(data.editpri)
	data.clearpri = toStr(data.clearpri)
	data.chkstep = toStr(data.chkstep)

	data.adtchk = toStr(data.adtchk)
	data.chkusage = toStr(data.chkusage)
	data.DualUnit = toStr(data.DualUnit)
	data.ivadtmdf = toStr(data.ivadtmdf)
	data.aplit = toStr(data.aplit)
	data.autoprnt = toStr(data.autoprnt)
	data.needsa = toStr(data.needsa)
	data.WIQtyChk = toStr(data.WIQtyChk)

	data.apautowo = toStr(data.apautowo)
	data.ihandate = toStr(data.ihandate)
	data.chkinvno = toStr(data.chkinvno)
	request.post({ url: '/api/config/setParams', data }).then(res => {
		isloading.value = false
		ElMessage.success("保存成功")
	}).catch(error => {
		isloading.value = false
		console.error(error)
	})
}

// 辅助函数：将字符串转换为布尔值
const toBoolean = (value: any): boolean => {
	return value === "1" || value === true
}

const toStr = (value: any): string => {
	return value ? "1" : "0"
}

interface InputItem {
	code: string;
	memo: string;
}
const transformToObject=(items: InputItem[]): Record<string, string>=> {
	return Object.fromEntries(items.map(({ code, memo }) => [code, memo]));
}

const initData = () => {
	request.post({ url: '/api/config/getParams', data: {} }).then(res => {

		const data = transformToObject(res.data)
		// 转换布尔值字段
		data.ivucvch = toBoolean(data.ivucvch)
		data.wri_memo = toBoolean(data.wri_memo)
		data.autopost = toBoolean(data.autopost)
		data.inhrtval = toBoolean(data.inhrtval)
		data.modtcode = toBoolean(data.modtcode)
		data.prtpost = toBoolean(data.prtpost)
		data.modtdate = toBoolean(data.modtdate)

		data.editpri = toBoolean(data.editpri)
		data.clearpri = toBoolean(data.clearpri)
		data.chkstep = toBoolean(data.chkstep)

		data.adtchk = toBoolean(data.adtchk)
		data.chkusage = toBoolean(data.chkusage)
		data.DualUnit = toBoolean(data.DualUnit)
		data.ivadtmdf = toBoolean(data.ivadtmdf)
		data.aplit = toBoolean(data.aplit)
		data.autoprnt = toBoolean(data.autoprnt)
		data.needsa = toBoolean(data.needsa)
		data.WIQtyChk = toBoolean(data.WIQtyChk)

		data.apautowo = toBoolean(data.apautowo)
		data.ihandate = toBoolean(data.ihandate)
		data.chkinvno = toBoolean(data.chkinvno)

		// 将数据赋值到响应式对象
		Object.assign(params, data)
	}).catch(error => {
		console.error(error)
	})
}

// 获取 token
token.value = (window as any).$store?.getters?.token || ''

// 生命周期
onMounted(() => {
	initData()
})
</script>

<style scoped>
.radio-label {
	font-size: 14px;
	color: #606266;
	line-height: 40px;
	padding: 0 12px 0 30px;
}

.avatar-uploader {
	border: 1px dashed #d9d9d9;
	width: 178px;
	height: 178px;
	border-radius: 6px;
	cursor: pointer;
	position: relative;
	overflow: hidden;
}

.avatar-uploader .el-upload:hover {
	border-color: #409EFF;
}

.avatar-uploader-icon {
	font-size: 28px;
	color: #8c939d;
	width: 178px;
	height: 178px;
	line-height: 178px;
	text-align: center;
}

.avatar-uploader-icon1 {
	font-size: 28px;
	color: red;
	text-align: center;
	position: absolute;
	top: 2px;
	right: 2px;
	z-index: 111;
}

.avatar {
	width: 178px;
	height: 178px;
	display: block;
}
</style>