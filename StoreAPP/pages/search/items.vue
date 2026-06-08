<template>
	<view class="container">
		<u-navbar title-color="#fff" back-icon-color="#ffffff" :is-fixed="isFixed" :is-back="isBack"
			:background="background" :back-text-style="{color: '#fff'}" :title="htitle" :back-icon-name="backIconName"
			:back-text="backText">
		
		</u-navbar>
		<view class="tui-searchbox">
			<view class="tui-search-input">
				<icon type="search" :size='13' color='#333'></icon>
				<input confirm-type="search" placeholder="输入查询条件" :focus="true" auto-focus
					placeholder-class="tui-input-plholder" class="tui-input" v-model.trim="key" @input="inputKey" />
				<icon type="clear" :size='13' color='#bcbcbc' @tap="cleanKey" v-show="key"></icon>
			</view>
			<view class="tui-cancle" @tap="back">取消</view>
		</view>

		<view class="tui-search-history" v-show="history.length>0 && !key">
			<view class="tui-history-header">
				<view class="tui-search-title">搜索历史</view>
				<tui-icon name="delete" :size='14' color='#333' @tap="openActionSheet" class="tui-icon-delete">
				</tui-icon>
			</view>
			<view class="tui-history-content">
				<block v-for="(item,index) in history" :key="index">
					<tui-tag margin="0 24rpx 24rpx 0" type="gray" shape="circle" @click="setSearch(item)">{{item.label}}
					</tui-tag>
				</block>
			</view>
		</view>
		<view v-show="key">
			<view class="tui-header">
				<view class="tui-header-left tui-noboredr">搜索 “{{key}}”</view>
			</view>
			<view class="tui-result-box">
				<block v-for="(item,index) in searchList" :key="index">
					<view class="tui-result-item" @click="setSearch(item)" hover-class="tui-opcity"
						:hover-stay-time="150">
						<rich-text :nodes="item.showKey"></rich-text>
					</view>
				</block>
			</view>
		</view>

		<!-- <view class="tui-search-hot">
			<view class="tui-hot-header">
				<view class="tui-search-title">大家正在搜</view>
			</view>
			<view class="tui-hot-content">
				<block v-for="(item,index) in hot" :key="index">
					<tui-tag type="gray" shape="circle">{{item}}</tui-tag>
				</block>
			</view>
		</view> -->
		<tui-actionsheet :show="showActionSheet" :tips="tips" @click="itemClick" @cancel="closeActionSheet">
		</tui-actionsheet>
	</view>

</template>

<script>
	const util = require("@/utils/util.js")
	export default {
		data() {

			return {
				//navbar*********************
				htitle: '查询',
				backText: '返回',
				backIconName: 'nav-back',
				background: {
					'background-color': '#ffcc00'
				},
				isBack: true,
				isFixed: true,
				//navbar*********************
				history: [],
				key: "",
				showActionSheet: false,
				tips: "确认清空搜索历史吗？",
				datas: [],
				searchResult: [],
				searchList: [],
				type: 'dept'
			}
		},
		onLoad(op) {
			this.type = op.type;
			let his = uni.getStorageSync(this.type);
			if (his == null || !Array.isArray(his)) {
				his = [];
			}
			this.history = his;
			this.initData();
		},
		methods: {
			async initData() {
				this.$api.loading(true);
				let url = '/api/store/GetDepartment';
				if (this.type == 'provider')
					url = '/api/store/GetProvider';
				else if (this.type == 'store')
					url = '/api/store/GetStorenum';

				let obj = await this.$api.ajax(url, {
					key: this.key
				});
				let arr = [];
				this.datas = obj.data;

				this.$api.loading(false);
			},
			back: function() {
				uni.navigateBack();
			},
			cleanKey: function() {
				this.key = ''
			},
			closeActionSheet: function() {
				this.showActionSheet = false
			},
			openActionSheet: function() {
				this.showActionSheet = true
			},
			itemClick: function(e) {
				let index = e.index;
				if (index == 0) {
					this.showActionSheet = false;
					this.history = [];
					uni.removeStorageSync(this.type);
				}
			},
			setSearch(item) {
				let his = uni.getStorageSync(this.type);
				if (his == null || !Array.isArray(his)) {
					his = [];
				}
				if (!his.some(o => o.value == item.value))
					his.push(item);
				uni.setStorageSync(this.type, his);
				this.$api.prePage().setSearch(this.type, item);
				uni.navigateBack({

				})
			},
			inputKey: async function(e) {
				this.key = util.trim(e.detail.value);
				if (!this.key) {
					this.searchList = [];
					return;
				}
				// let url = '/api/store/GetDepartment';
				// if (this.type == 'provider')
				// 	url = '/api/store/GetProvider';
				// else if (this.type == 'store')
				// 	url = '/api/store/GetStorenum';

				// let obj = await this.$api.ajax(url, {
				// 	key: this.key
				// });
				let arr = [];
				this.searchResult = this.datas.filter(o => o.label.indexOf(this.key) >= 0);

				//根据关键词查找

				//实际开发中，根据搜索返回结果集，此处只是做展示提示搜索哪些文字
				this.searchResult.forEach((item) => {
					arr.push({
						value: item.value,
						label: item.label,
						showKey: util.replaceAll(item.label, this.key,
							`<label style="color:#E41F19">${this.key}</label>`)
					})
				})

				this.searchList = arr;
			}
		}
	}
</script>

<style>
	page {
		color: #333;
		background: #fff;
	}

	.container {
		padding: 0 30rpx 30rpx 30rpx;
		box-sizing: border-box;
	}

	.tui-searchbox {
		padding: 30rpx 0;
		box-sizing: border-box;
		display: flex;
		align-items: center;
	}

	.tui-search-input {
		width: 100%;
		height: 66rpx;
		border-radius: 35rpx;
		padding: 0 30rpx;
		box-sizing: border-box;
		background: #f2f2f2;
		display: flex;
		align-items: center;
		flex-wrap: nowrap;
	}

	.tui-input {
		flex: 1;
		color: #333;
		padding: 0 16rpx;
		font-size: 28rpx;
	}

	.tui-input-plholder {
		font-size: 28rpx;
		color: #b2b2b2;
	}

	.tui-cancle {
		color: #888;
		font-size: 28rpx;
		padding-left: 30rpx;
		flex-shrink: 0;
	}

	.tui-history-header {
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 30rpx 0;
	}

	.tui-history-content {
		display: flex;
		align-items: center;
		flex-wrap: wrap;
	}

	.tui-icon-delete {
		padding: 10rpx;
	}

	.tui-search-title {
		font-size: 28rpx;
		font-weight: bold;
	}

	.tui-hot-header {
		padding: 30rpx 0;
	}

	.tui-header {
		padding: 26rpx 0;
		box-sizing: border-box;
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.tui-header-left {
		font-size: 30rpx;
		color: #222;
		border-left: 4rpx solid #EB0909;
		padding-left: 10rpx;
		word-break: break-all;
	}

	.tui-noboredr {
		border-left: 0 !important;
	}

	.tui-result-box {
		font-size: 28rpx;
	}

	.tui-result-item {
		line-height: 28rpx;
		padding: 28rpx 0;
	}
</style>
