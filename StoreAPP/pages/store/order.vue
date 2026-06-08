<template>
	<view>
		<view class="wrap">
			<u-navbar title-color="#fff" back-icon-color="#ffffff" :is-fixed="isFixed" :is-back="isBack"
				:background="background" :back-text-style="{color: '#fff'}" :title="htitle"
				:back-icon-name="backIconName" :back-text="backText">
				<view class="navbar-right" slot="right" @click="dropShow=true">
					<view class="message-box right-item">

						过滤
						<u-icon name="arrow-down" size="38"></u-icon>
					</view>

				</view>
			</u-navbar>
			<tui-top-dropdown :show="dropShow" :paddingbtm="110" :translatey="90" @close="btnCloseDrop">
				<scroll-view class="tui-scroll-box" scroll-y scroll-with-animation :scroll-top="scrollTop">
					<view class="tui-seizeaseat-20"></view>
					<view class="tui-drop-item" :class="[item.selected?'tui-bold':'']"
						v-for="(item,index) in proDropData" :key="index" @tap.stop="btnSelected" :data-index="index">
						<tui-icon name="check" :size="16" color="#5677fc" :bold="true" v-if="item.selected"></tui-icon>
						<text class="tui-ml tui-middle">{{item.name}}</text>
					</view>
					<view class="tui-seizeaseat-30"></view>
				</scroll-view>
				<view class="tui-drop-btnbox">
					<view class="tui-drop-btn tui-button-white" hover-class="tui-button-white_hover"
						:hover-stay-time="150" @tap="reset">重置</view>
					<view class="tui-drop-btn tui-button-primary" hover-class="tui-button-hover" :hover-stay-time="150"
						@tap="btnCloseDrop1">确定</view>
				</view>
			</tui-top-dropdown>
			<view class="u-tabs-box">
				<u-tabs-swiper activeColor="#f29100" ref="tabs" :list="list" :current="current" @change="change"
					:is-scroll="false" swiperWidth="750"></u-tabs-swiper>
			</view>
			<swiper class="swiper-box" :current="swiperCurrent" @transition="transition"
				@animationfinish="animationfinish">
				<swiper-item class="swiper-item" v-for="(it,i1) in orderList">
					<scroll-view scroll-y style="height: 100%;width: 100%;" @scrolltolower="reachBottom">
						<view class="page-box">
							<view class="order" v-for="(res, index) in it.data" :key="res.id" @click="toDetail(res)">
								<view class="top">
									<view class="left">

										<view class="store">{{index+1}}.批次号：{{ res.iost_no }}</view>
										<u-icon name="arrow-right" color="rgb(203,203,203)" :size="26"></u-icon>
									</view>
									<view class="right">{{ res.status }}</view>
								</view>
								<view class="item">
									<!-- <view class="left">
										<image :src="item.goodsUrl" mode="aspectFill"></image>
									</view> -->
									<view class="content">
										<!-- <view class="title u-line-2">供应商：{{ res.proname||res.proname1 }}</view> -->
										<!-- <view class="title u-line-2">货品类别：{{ res.classname }}</view> -->
										<view class="title u-line-2">下单时间：{{ res.addtime }} {{res.usercode}}</view>
										<view class="title u-line-2">确定时间： {{res.chktime }} {{res.chkcode}}</view>
										<!-- delivery-time -->
										<view class="title u-line-2">收货时间： {{res.rectime }} {{res.reccode}}</view>
									</view>
									<!-- <view class="right">
										<view class="price">
											￥{{ priceInt(item.price) }}
											<text class="decimal">.{{ priceDecimal(item.price) }}</text>
										</view>
										<view class="number">x{{ item.number }}</view>
									</view> -->
								</view>
								<view class="total">
									共{{ res.num}}件商品 合计:
									<text class="total-price">
										￥{{ res.amt}}
										<text class="decimal">{{ }}</text>
									</text>
								</view>
								<!-- <view class="bottom">
									<view class="more">
										<u-icon name="more-dot-fill" color="rgb(203,203,203)"></u-icon>
									</view>
									<view class="logistics btn">查看物流</view>
									<view class="exchange btn">卖了换钱</view>
									<view class="evaluate btn">评价</view>
								</view> -->
							</view>
							<u-loadmore :status="it.curStatus" class="margin-top" bgColor="#ffffff"></u-loadmore>
						</view>
					</scroll-view>
				</swiper-item>
			</swiper>
		</view>
	</view>
</template>

<script>
	export default {
		data() {
			return {
				//navbar*********************
				htitle: '采购清单',
				backText: '返回',
				backIconName: 'nav-back',
				background: {
					'background-color': '#ffcc00'
				},
				isBack: true,
				isFixed: true,
				//navbar*********************
				orderList: [{
						page: 1,
						rows: 20,
						islast: false,
						data: [],
						curStatus: 'nomore'
					},
					{
						page: 1,
						rows: 20,
						islast: false,
						data: [],
						curStatus: 'nomore'
					},
					{
						page: 1,
						rows: 20,
						islast: false,
						data: [],
						curStatus: 'nomore'
					},
					{
						page: 1,
						rows: 20,
						islast: false,
						data: [],
						curStatus: 'nomore'
					}

				],
				dataList: [],
				list: [{
						name: '全部'
					},
					{
						name: '下单'
					},
					{
						name: '已确定'
					},
					{
						name: '已收货'
					}
				],
				current: 0,
				swiperCurrent: 0,
				tabsHeight: 0,
				dx: 0,

				loadStatus: ['loadmore', 'loading', 'nomore'],
				dropShow: false,
				scrollTop: 0,
				proDropData: [],
			};
		},
		onLoad() {
			this.initClass();
			this.getOrderList();
		},
		computed: {
			// 价格小数
			priceDecimal() {
				return val => {
					if (val !== parseInt(val)) return val.slice(-2);
					else return '00';
				};
			},
			// 价格整数
			priceInt() {
				return val => {
					if (val !== parseInt(val)) return val.split('.')[0];
					else return val;
				};
			}
		},
		onPullDownRefresh() {
			this.refData();
			setTimeout(() => {
				uni.stopPullDownRefresh();
			}, 1200);
		},
		methods: {
			async initClass() {

				let obj = await this.$api.ajax('/api/Store/GetClass', {

				});
				obj.data.forEach(o => {
					this.proDropData.push({
						name: o.label,
						value: o.value,
						selected: false
					})
				});


			},
			btnSelected: function(e) {
				let index = e.currentTarget.dataset.index;
				let obj = this.proDropData[index];
				this.$set(obj, 'selected', !obj.selected)
			},
			btnCloseDrop() {
				this.scrollTop = 1;
				this.$nextTick(() => {
					this.scrollTop = 0
				});
				this.dropShow = false;
			},
			btnCloseDrop1() {
				this.scrollTop = 1;
				this.$nextTick(() => {
					this.scrollTop = 0
				});
				this.dropShow = false;
				this.refData();
			},
			reset() {
				let arr = this.proDropData;
				for (let item of arr) {
					item.selected = false;
				}
				this.proDropData = arr;
				this.dropShow = false;
				this.refData();
			},
			refData() {
				let idx = this.current;
				this.orderList[idx].page = 1;
				this.orderList[idx].data = [];
				this.orderList[idx].curStatus = this.loadStatus[0];
				this.getOrderList();
			},

			reachBottom() {
				// 此tab为空数据
				if (this.current != 2) {
					this.loadStatus.splice(this.current, 1, "loading")
					setTimeout(() => {
						this.getOrderList(this.current);
					}, 1200);
				}
			},
			// 页面数据
			async getOrderList() {
				let idx = this.current;
				let that = this;
				let page = this.orderList[idx].page;
				this.orderList[idx].page++;
				this.orderList[idx].curStatus = this.loadStatus[1];
				let sels = this.proDropData.filter(o => o.selected);
				let types = sels.map(o => o.value);
				let obj = await that.$api.ajax('/api/Store/GetStoreByStore', {
					page: page,
					rows: this.orderList[idx].rows,
					status: idx,
					types: types
				});
				this.orderList[idx].curStatus = this.loadStatus[0];
				this.orderList[idx].data = this.orderList[idx].data.concat(obj.data);
				if (this.orderList[idx].data.length >= obj.total) {
					that.orderList[idx].islast = true;
					that.orderList[idx].curStatus = this.loadStatus[2];
				}
			},
			// 总价
			totalPrice(item) {
				let price = 0;
				item.map(val => {
					price += parseFloat(val.price);
				});
				return price.toFixed(2);
			},
			// 总件数
			totalNum(item) {
				let num = 0;
				item.map(val => {
					num += val.number;
				});
				return num;
			},
			// tab栏切换
			change(index) {
				this.swiperCurrent = index;
				this.getOrderList();
			},
			transition({
				detail: {
					dx
				}
			}) {
				this.$refs.tabs.setDx(dx);
			},
			animationfinish({
				detail: {
					current
				}
			}) {
				this.$refs.tabs.setFinishCurrent(current);
				this.swiperCurrent = current;
				this.current = current;
				this.getOrderList();
			},
			toDetail(item) {
				uni.navigateTo({
					url: '/pages/store/detail?iost_no=' + item.iost_no
				})
			}
		}
	};
</script>

<style>
	/* #ifndef H5 */
	page {
		height: 100%;
		background-color: #f2f2f2;
	}

	/* #endif */
</style>

<style lang="scss" scoped>
	.order {
		width: 710rpx;
		background-color: #ffffff;
		margin: 20rpx auto;
		border-radius: 20rpx;
		box-sizing: border-box;
		padding: 20rpx;
		font-size: 28rpx;

		.top {
			display: flex;
			justify-content: space-between;

			.left {
				display: flex;
				align-items: center;

				.store {
					margin: 0 10rpx;
					font-size: 32rpx;
					font-weight: bold;
				}
			}

			.right {
				color: $u-type-warning-dark;
			}
		}

		.item {
			display: flex;
			margin: 20rpx 0 0;

			.left {
				margin-right: 20rpx;

				image {
					width: 200rpx;
					height: 200rpx;
					border-radius: 10rpx;
				}
			}

			.content {
				.title {
					font-size: 28rpx;
					line-height: 50rpx;
				}

				.type {
					margin: 10rpx 0;
					font-size: 24rpx;
					color: $u-tips-color;
				}

				.delivery-time {
					color: #e5d001;
					font-size: 24rpx;
				}
			}

			.right {
				margin-left: 10rpx;
				padding-top: 20rpx;
				text-align: right;

				.decimal {
					font-size: 24rpx;
					margin-top: 4rpx;
				}

				.number {
					color: $u-tips-color;
					font-size: 24rpx;
				}
			}
		}

		.total {
			margin-top: 20rpx;
			text-align: right;
			font-size: 24rpx;

			.total-price {
				font-size: 32rpx;
			}
		}

		.bottom {
			display: flex;
			margin-top: 40rpx;
			padding: 0 10rpx;
			justify-content: space-between;
			align-items: center;

			.btn {
				line-height: 52rpx;
				width: 160rpx;
				border-radius: 26rpx;
				border: 2rpx solid $u-border-color;
				font-size: 26rpx;
				text-align: center;
				color: $u-type-info-dark;
			}

			.evaluate {
				color: $u-type-warning-dark;
				border-color: $u-type-warning-dark;
			}
		}
	}

	.centre {
		text-align: center;
		margin: 200rpx auto;
		font-size: 32rpx;

		image {
			width: 164rpx;
			height: 164rpx;
			border-radius: 50%;
			margin-bottom: 20rpx;
		}

		.tips {
			font-size: 24rpx;
			color: #999999;
			margin-top: 20rpx;
		}

		.btn {
			margin: 80rpx auto;
			width: 200rpx;
			border-radius: 32rpx;
			line-height: 64rpx;
			color: #ffffff;
			font-size: 26rpx;
			background: linear-gradient(270deg, rgba(249, 116, 90, 1) 0%, rgba(255, 158, 1, 1) 100%);
		}
	}

	.wrap {
		display: flex;
		flex-direction: column;
		height: calc(100vh - var(--window-top));
		width: 100%;
	}

	.swiper-box {
		flex: 1;
	}

	.swiper-item {
		height: 100%;
	}

	.navbar-right {
		margin-right: 24rpx;
		display: flex;
	}

	.search-wrap {
		margin: 0 20rpx;
		flex: 1;
	}

	.right-item {
		margin: 0 12rpx;
		position: relative;
		color: #ffffff;
		display: flex;
	}

	.tui-scroll-box {
		width: 100%;
		height: 480rpx;
		box-sizing: border-box;
		position: relative;
		z-index: 99;
		color: #fff;
		font-size: 30rpx;
		word-break: break-all;
	}

	.tui-drop-item {
		color: #333;
		height: 80rpx;
		font-size: 28rpx;
		padding: 20rpx 40rpx 20rpx 40rpx;
		box-sizing: border-box;
		display: inline-block;
		width: 50%;
	}

	.tui-drop-btnbox {
		width: 100%;
		height: 100rpx;
		position: absolute;
		left: 0;
		bottom: 0;
		box-sizing: border-box;
		display: flex;
	}

	.tui-drop-btn {
		width: 50% !important;
		border-radius: 0 !important;
		font-size: 32rpx !important;
		text-align: center;
		height: 100rpx;
		line-height: 100rpx;
		border: 0;
	}
</style>
