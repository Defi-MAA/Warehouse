<template>
	<view>
		<u-navbar title-color="#fff" back-icon-color="#ffffff" :is-fixed="isFixed" :is-back="isBack"
			:background="background" :back-text-style="{color: '#fff'}" :title="htitle" :back-icon-name="backIconName"
			:back-text="backText">

		</u-navbar>
		<swiper class="screen-swiper" :class="dotStyle?'square-dot':'round-dot'" :indicator-dots="true" :circular="true"
			:autoplay="true" interval="5000" duration="500">
			<swiper-item @click="viewImages(index)" v-for="(item,index) in swiperList" :key="index">
				<image :src="item.src" mode="aspectFill"></image>

			</swiper-item>
		</swiper>

		<view
			style="margin-top: 60rpx; padding-bottom: 40rpx; border-bottom: 1rpx solid #EEEEEE; display: flex; justify-content:space-around; align-items:center; flex-direction: row;">

			<view v-if="userinfo.ispro" @click="navto('/pages/provider/order')"
				style="display: flex; justify-content:center; align-items:center; flex-direction: column;">
				<view class="v-btn1">
					<image src="/static/pro.png" style="width: 60rpx;height: 60rpx;"></image>
				</view>
				<text style="font-size: 32rpx;">供应商</text>
			</view>
			<view v-if="userinfo.iszb" @click="navto('/pages/store/myorder')"
				style="display: flex; justify-content:center; align-items:center; flex-direction: column;">
				<view class="v-btn1">
					<image src="/static/detail.png" style="width: 60rpx;height: 60rpx;"></image>
				</view>
				<text style="font-size: 32rpx;">我的采购</text>
			</view>

			<view v-if="userinfo.iszb" @click="navto('/pages/store/add')"
				style="display: flex; justify-content:center; align-items:center; flex-direction: column;">
				<view class="v-btn1">
					<image src="/static/car.png" style="width: 60rpx;height: 60rpx;"></image>
				</view>
				<text style="font-size: 32rpx;">厨房下单</text>
			</view>

			<view v-if="userinfo.isstore" @click="navto('/pages/store/order')"
				style="display: flex; justify-content:center; align-items:center; flex-direction: column;">
				<view class="v-btn1">
					<image src="/static/st.png" style="width: 60rpx;height: 60rpx;"></image>
				</view>
				<text style="font-size: 32rpx;">仓库收货</text>
			</view>

			<!-- <view v-if="userinfo.isstore||debug" @click="navto('/pages/store/set')"
				style="display: flex; justify-content:center; align-items:center; flex-direction: column;">
				<view class="v-btn1">
					<image src="/static/set.png" style="width: 60rpx;height: 60rpx;"></image>
				</view>
				<text style="font-size: 32rpx;">设置</text>
			</view>
 -->
		</view>
		<!-- <view class="flex flex-wrap   justify-center margin-top">
			<view class="basis-df  text-center">
				<button @click="navto('/pages/booking/add')" class="cu-btn bg-gradual-green margin-tb-sm lg"
					style="width: 90%;height: 45px;">供应商</button>
			</view>
			<view class="basis-df  text-center">
				<button @click="navto('/pages/booking/dish')" class="cu-btn bg-gradual-blue margin-tb-sm lg"
					style="width: 90%;height: 45px;">采购下单 </button>
			</view>
			<view class="basis-df  text-center">
				<button @click="navto('/pages/booking/bookings')" class="cu-btn bg-gradual-red margin-tb-sm lg"
					style="width: 90%;height: 45px;">仓库收货</button>
			</view>
			<view class="basis-df  text-center">
				<button @click="navto('/pages/my/command')" class="cu-btn bg-gradual-pink margin-tb-sm lg"
					style="width: 90%;height: 45px;">
					查询
				</button>
			</view>
		</view> -->

	</view>
</template>

<script>
	export default {
		data() {
			return {
				debug: true,
				//navbar*********************
				htitle: '首页',
				backText: '返回',
				backIconName: 'nav-back',
				background: {
					'background-color': '#ffcc00'
				},
				isBack: false,
				isFixed: true,
				//navbar*********************
				cardCur: 0,
				swiperList: [],
				dotStyle: false,
				userinfo: {},

			}
		},
		onLoad() {
			this.swiperList = [];
			let apiurl = uni.getStorageSync('apiurl');
			this.swiperList.push({
				src: apiurl + 'TempFiles/1.jpg'
			});
			this.swiperList.push({
				src: apiurl + 'TempFiles/2.jpg'
			});
			this.swiperList.push({
				src: apiurl + 'TempFiles/3.jpg'
			});
			this.swiperList.push({
				src: apiurl + 'TempFiles/4.jpg'
			});
		},
		onShow() {

			this.checkToken();
			this.getInfo();
		},
		methods: {
			checkToken() {
				this.$api.checkToken();
			},
			viewImages(index) {
				let srcs = this.swiperList.map(o => o.src);
				uni.previewImage({
					urls: srcs,
					current: index
				})
			},
			getInfo() {
				this.userinfo = uni.getStorageSync('userInfo');
			},
			navto(url) {
				//this.$api.navto(url);
				uni.navigateTo({
					url: url
				})
			}
		}
	}
</script>

<style lang="scss">
	.v-btn1 {
		display: flex;
		justify-content: center;
		align-items: center;
		width: 120rpx;
		height: 120rpx;
		background: $base-color;
		border-radius: 50%;
		margin-bottom: 20rpx;
	}
</style>
