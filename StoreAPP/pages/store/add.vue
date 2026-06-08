<template>
	<view>
		<u-navbar title-color="#fff" back-icon-color="#ffffff" :is-fixed="isFixed" :is-back="isBack"
			:background="background" :back-text-style="{color: '#fff'}" :title="htitle" :back-icon-name="backIconName"
			:back-text="backText">

		</u-navbar>

		<form>
			<view class="cu-form-group ">
				<view class="title">建单日期：</view>
				<text style="width: 100%;" @click="show=true">{{info.crdate}}</text>
				<u-picker mode="time" v-model="show" :params="params" @confirm="confirm"></u-picker>

			</view>
			<view class="cu-form-group ">
				<view class="title">收货部门：</view>
				<view style="width: 100%;" @click="show1=true">{{info.deptname}}</view>
				<u-select v-model="show1" :list="datas.dept" @confirm="confirm1"></u-select>
				<button class='cu-btn bg-blue  sm' @click="search('dept')"><text class="cuIcon-search"></text></button>

			</view>
			<view class="cu-form-group ">
				<view class="title">仓库：</view>
				<view style="width: 100%;" @click="show2=true">{{info.storename}}</view>
				<u-select v-model="show2" :list="datas.store" @confirm="confirm2"></u-select>
				<button class='cu-btn bg-blue  sm' @click="search('store')"><text class="cuIcon-search"></text></button>
			</view>
			<!-- <view class="cu-form-group ">
				<view class="title">账月：</view>
				<text style="width: 100%;" @click="showy=true">{{info.actyyyymm}}</text>
				<u-picker mode="time" v-model="showy" :params="params" @confirm="confirmy"></u-picker>

			</view> -->
			<view class="cu-form-group ">
				<view class="title">货品类别：</view>
				<view style="width: 100%;" @click="show4=true">{{info.classname}}</view>
				<u-select v-model="show4" :list="datas.class" @confirm="confirm4"></u-select>
				<!-- <button class='cu-btn bg-blue  sm' @click="search('store')"><text class="cuIcon-search"></text></button> -->
			</view>

			<!-- 	<view class="cu-form-group ">
				<view class="title">供应商：</view>
				<view style="width: 100%;" @click="show3=true">{{info.proname}}</view>
				<u-select v-model="show3" :list="datas.provider" @confirm="confirm3"></u-select>
				<button class='cu-btn bg-blue  sm' @click="search('provider')"><text
						class="cuIcon-search"></text></button>
			</view> -->
			<view class="cu-bar bg-white solid-bottom margin-top">
				<view class="action">
					<text class="cuIcon-title text-orange "></text> 货品列表
				</view>
				<view class="action">
					<!-- <button class="cu-btn bg-green shadow"  @tap="addDef" data-target="gridModal">
						<text class="cuIcon-add"></text>自定义
					</button> -->
					<button class="cu-btn bg-blue shadow margin-left" @tap="selGoods" data-target="gridModal">
						<text class="cuIcon-add"></text>选择货品
					</button>
				</view>
			</view>

			<view class="flex solid-bottom  justify-start text-bold bg-gray">
				<view class=" padding-sm  solid-right text-center" style="width: 25%;">货品名称</view>
				<view class=" padding-sm  solid-right text-center" style="width: 15%;">数量</view>
				<view class=" padding-sm  solid-right text-center" style="width: 15%;">单位</view>
				<view class=" padding-sm  solid-right text-center" style="width: 25%;">规格</view>
				<view class=" padding-sm  solid-right text-center" style="width: 20%;">操作</view>
			</view>
			<view class=" flex solid-bottom justify-start " v-for="(item,index) in items">

				<view class=" padding-sm  solid-right text-center bg-white" style="width: 20%;">
					{{item.name}}
					<!-- <input v-model="item.name" type="text"></input> -->
				<button class=" cu-btn bg-red  round sm" style="font-size: 5px;width: 40px;margin-top:5px"
					@click="del(item)">删除</button>

				</view>
				<view class=" padding-sm  solid-right text-center bg-white" style="width: 20%;">
					<input v-model="item.number" type="number"></input>
				</view>
				<view class=" padding-sm  solid-right text-center bg-white" style="width: 20%;">
					{{item.unit}}
					<!-- 	<input v-model="item.unit" type="text"></input> -->
				</view>
				<view class=" padding-sm  solid-right text-center bg-white" style="width: 20%;">
					{{item.size}}
					<!-- <input v-model="item.size" type="text"></input> -->
				</view>

				<!-- <view class=" padding-sm  solid-right text-center bg-white" style="width: 20%;">
					<input v-model="item.price"></input>
				</view>
				<view class=" padding-sm  solid-right text-center bg-white" style="width: 20%;">
					<text>{{(item.number*item.price).toFixed(2)}}</text>
				</view> -->
				<view class=" padding-sm  text-center" style="width: 20%;">
					<button class=" cu-btn bg-blue   round sm" style="font-size: 5px;width: 40px; "
						@click="setRemarks(item)">备注</button>
				</view>
			</view>

			<view class="cu-form-group margin-top">
				<view class="title">备注：</view>
				<textarea maxlength="-1" v-model="info.remarks" placeholder="请输入备注"></textarea>
			</view>
			<view class="padding flex flex-direction ">
				<button class="cu-btn bg-blue margin-tb-sm lg" @click="submit">提交</button>
			</view>
		</form>
		<view class="cu-modal bottom-modal" :class="showModel?'show':''">
			<view class="cu-dialog">
				<view class="cu-bar bg-white">

					<view class="action text-blue" @tap="closeDlg">关闭</view>
					<view class="action text-green" @tap="setRe">确定</view>
				</view>
				<view class="padding-xl" style="text-align: left;">
					<textarea maxlength="-1" v-model="remark1" placeholder="请输入备注内容"></textarea>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
	import TUtil from '@/common/timeUtil.js'
	export default {
		data() {
			return {
				//navbar*********************
				htitle: '厨房下单',
				backText: '返回',
				backIconName: 'nav-back',
				background: {
					'background-color': '#ffcc00'
				},
				isBack: true,
				isFixed: true,
				//navbar*********************
				info: {
					deptname: '请选择',
					storename: '请选择',
					proname: '请选择',
					classname: '请选择',
					actyyyymm: ''
				},
				datas: {},
				params: {
					year: true,
					month: true,
					day: true,
					hour: false,
					minute: false,
					second: false,
					province: false,
					city: false,
					area: false,
					timestamp: false,
				},

				curitem: {},
				show: false,
				show1: false,

				show2: false,

				show3: false,
				show4: false,
				items: [],
				showy: false,
				showModel: false,
				remark1: ''
			}
		},
		onLoad() {
			this.info.crdate = TUtil.mathChangeDate(TUtil.getDate(), '+', 1).substring(0, 10);
			this.initData();
			this.getyymm();
		},

		methods: {
			confirm(e) {
				this.info.crdate = e.year + '-' + e.month + '-' + e.day;
			},
			confirmy(e) {
				this.info.actyyyymm = e.year + e.month;
			},
			confirm1(e) {
				e.map((val, index) => {
					console.log(val);
					this.info.deptcode = val.value;
					this.info.deptname = val.label;
				})
			},
			confirm2(e) {
				e.map((val, index) => {
					console.log(val);
					this.info.storecode = val.value;
					this.info.storename = val.label;
					this.getyymm();
				})
			},
			confirm3(e) {
				e.map((val, index) => {
					console.log(val);
					this.info.procode = val.value;
					this.info.proname = val.label;
				})
			},
			confirm4(e) {
				e.map((val, index) => {
					console.log(val);
					this.info.classcode = val.value;
					this.info.classname = val.label;
					this.items = [];
				})
			},
			search(type) {
				uni.navigateTo({
					url: '/pages/search/items?type=' + type
				})
			},
			setSearch(type, item) {
				//console.log(type)
				//console.log(item)
				if (type == 'dept') {
					this.info.deptname = item.label;
					this.info.deptcode = item.value;
				}
				if (type == 'provider') {
					this.info.proname = item.label;
					this.info.procode = item.value;
				} else if (type == 'store') {
					this.info.storename = item.label;
					this.info.storecode = item.value;
				}
			},
			addDef() {
				if (this.$api.isEmpty(this.info.classcode)) {
					this.$api.msg('请选择货品类别！');
					return;
				}
				let newobj = {
					odes: null,
					descripe: "",
					id: "",
					img: "",
					name: "",
					names: null,
					number: 1,
					price: 0,
					shopspec: false,
					size: "",
					specnum: 0,
					specs: [],
					type_id: this.info.classcode,
					unit: "",
					remark: ""
				};
				this.items.unshift(newobj);
			},
			selGoods() {
				if (this.$api.isEmpty(this.info.classcode)) {
					this.$api.msg('请选择货品类别！');
					return;
				}
				uni.navigateTo({
					url: '/pages/store/select?class=' + this.info.classcode
				})
			},
			setItem(its) {
				let news = {
					...its
				};
				this.items = this.items.concat(its);

				console.log(this.items);
			},
			del(item) {
				let that = this;
				uni.showModal({
					title: '提示',
					content: '是否确定删除数据？',
					success: function(res) {
						if (res.confirm) {
							let index = that.items.findIndex(o => o.id == item.id);
							that.items.splice(index, 1);
						} else if (res.cancel) {
							console.log('用户点击取消');
						}
					}
				});

			},
			async initData() {
				this.$api.loading(true);
				let obj = await this.$api.ajax('/api/store/GetAllData', {

				});
				this.datas = obj.data;
				this.$api.loading(false);
			},
			async getyymm() {
				let obj = await this.$api.ajax('/api/store/GetYYMM', {
					stno: this.info.storecode
				});
				console.log(obj.data);
				this.info.actyyyymm = obj.data;
			},
			async submit() {
				this.items.forEach(o => {
					if (this.$api.isEmpty(o.name)) {
						this.$api.msg('名称不能为空！');
						return;
					}
					if (this.$api.isEmpty(o.number)) {
						this.$api.msg('数量不能为空！');
						return;
					}

					if (this.$api.isEmpty(o.unit)) {
						this.$api.msg('单位不能为空！');
						return;
					}
				})

				this.$api.loading(true);

				let obj = await this.$api.ajax('/api/store/AddStore', {
					info: this.info,
					items: this.items
				});
				this.$api.loading(false);
				if (obj.success) {
					this.$api.msg('提交成功');
					setTimeout(() => {
						uni.navigateBack({

						})
					}, 1000);
				} else
					this.$api.msg(obj.msg);
			},
			setRemarks(item) {
				this.curitem = item;
				this.remark1 = item.remark;
				console.log(this.remark1)
				this.showModel = true;
			},
			setRe() {

				this.showModel = false;
				this.curitem.remark = this.remark1;
			},
			closeDlg() {
				this.remark1 = '';
				this.showModel = false;
			}
		}
	}
</script>

<style>
	.cu-form-group .title {
		min-width: calc(4em + 35px);
		text-align: right;
	}
</style>