<template>
	<view>
		<u-navbar title-color="#fff" back-icon-color="#ffffff" :is-fixed="isFixed" :is-back="isBack"
			:background="background" :back-text-style="{color: '#fff'}" :title="htitle" :back-icon-name="backIconName"
			:back-text="backText">

		</u-navbar>
		<form>
			<view class="cu-form-group ">
				<view class="title">类别： </view>
				<view style="width: 100%;" @click="show=true">{{info.classname}}</view>
				<u-select v-model="show" :list="classS" @confirm="confirm"></u-select>

			</view>

			<view class="cu-form-group ">
				<view class="title">品名： </view>
				<input v-model="info.name" placeholder="请输入品名" type="text"></input>
			</view>
			<view class="cu-form-group ">
				<view class="title">单位： </view>
				<view style="width: 100%;" @click="show1=true">{{info.unitname}}</view>
				<u-select v-model="show1" :list="units" @confirm="confirm1"></u-select>

			</view>
			<view class="cu-form-group ">
				<view class="title">单价： </view>
				<input v-model="info.unitprice" placeholder="请输入单价" type="number"></input>
			</view>
			<view class="cu-form-group ">
				<view class="title">规格： </view>
				<input v-model="info.size"  placeholder="请输入规格" type="text"></input>
			</view>
			<view class="padding flex flex-direction margin-top">
				<button class="cu-btn bg-blue margin-tb-sm lg" @click="submit">提交</button>
			</view>
		</form>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				//navbar*********************
				htitle: '设置',
				backText: '返回',
				backIconName: 'nav-back',
				background: {
					'background-color': '#ffcc00'
				},
				isBack: true,
				isFixed: true,
				//navbar*********************
				show: false,
				show1: false,
				info: {
					classname: '请选择',
					unitname: '请选择'
				},
				datas: [],
				classS:[],
				units:[]
			}
		},
		onLoad() {
			this.initData()
		},
		methods: {
			async initData() {
				let obj = await this.$api.ajax('/api/store/GetClass', {

				});
				this.classS = obj.data;
				 obj = await this.$api.ajax('/api/store/GetUnits', {
				
				});
				this.units = obj.data;
			},
			confirm(e) {
				e.map((val, index) => {
					console.log(val);
					this.info.classcode = val.value;
					this.info.classname = val.label;
				})
			},
			confirm1(e) {
				e.map((val, index) => {
					console.log(val);
					this.info.unit = val.value;
					this.info.unitname = val.label;
				})
			},
			async submit() {
				this.$api.loading(true);
				let obj = await this.$api.ajax('/api/store/AddItems', 
					this.info
				);
				this.$api.loading(false);
				if (obj.success) {
					this.$api.msg('提交成功');
					setTimeout(() => {
						uni.navigateBack({
			
						})
					}, 1000);
				} else
					this.$api.msg(obj.msg);
			}
		}
	}
</script>

<style>
	.cu-form-group .title {
		min-width: calc(4em + 25px);
		text-align: right;
	}
</style>
