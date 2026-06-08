<template>
	<view>
		<u-navbar title-color="#fff" back-icon-color="#ffffff" :is-fixed="isFixed" :is-back="isBack"
			:background="background" :back-text-style="{color: '#fff'}" :title="htitle" :back-icon-name="backIconName"
			:back-text="backText">

		</u-navbar>
		<form>
			<view class="cu-form-group margin-top">
				<view class="title">服务地址：</view>
				<input v-model="apiurl" placeholder="请输入服务地址,如:http://xxx.com/" type="text"></input>
			</view>
			<view class="padding flex flex-direction margin-top">
				<button class="cu-btn bg-blue margin-tb-sm lg" @click="submit">保存</button>
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
				apiurl: ''
			}
		},
		onLoad() {
			this.apiurl = uni.getStorageSync('apiurl');
		},
		methods: {
			submit() {
				if (this.apiurl == null || this.apiurl.length == 0) {
					this.$api.msg('请输入服务地址！');
					return;
				}
				uni.setStorageSync('apiurl', this.apiurl);
				this.$api.msg('保存成功');
				setTimeout(() => {
					uni.navigateBack({

					})
				}, 1000);
			}
		}
	}
</script>

<style>

</style>
