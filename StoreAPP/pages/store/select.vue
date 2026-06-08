<template>
	<view class="wrap">

		<u-navbar title-color="#fff" back-icon-color="#ffffff" :is-fixed="isFixed" :is-back="isBack"
			:background="background" :back-text-style="{color: '#fff'}" :title="htitle" :back-icon-name="backIconName"
			:back-text="backText">
			<view class="slot-wrap" style="width: 95%;">
				<view class="search-wrap" style="width: 100%;">
					<!-- 如果使用u-search组件，必须要给v-model绑定一个变量 -->
					<u-search v-model="condition" @custom="serData" @clear="reLoad" :show-action="true" height="56"
						:action-style="{color: '#fff'}">
					</u-search>
				</view>
			</view>
		</u-navbar>
		<view class="goods-box">

			<view class="sub-list valid" :class="subState">
				<scroll-view scroll-y="true" @scroll="scrollP" :scroll-top="tabScrollTop" @scrolltolower="loadMore()"
					class="goods-list-scroll">

					<view class="goods-list">
						<view class="box" v-for="(rowData,i) in ticketList" :key="i">

							<view class="m-store-item">

								<view class="m-text">
									<view class="m-title">
										{{rowData.name}}
									</view>
									<view class="m-price">{{rowData.unit}}  {{rowData.size}}</view>
									<view class="m-price-box">
										<view class="symbol">￥</view>
										
										<view class="m-price">{{rowData.price}}</view>

									</view>
									<view class="m-distance">
										<view :class="'addEle2_' + i" class="jumpPosition">
										</view>

										<tui-numberbox :step="1" :point="2" :min="0" :rowdata="rowData" :value="rowData.number"
											@change="change" :key="i">
										</tui-numberbox>

									</view>
								</view>

							</view>
						</view>
					</view>
					<view class="tis" v-if="isend">没有数据~</view>
				</scroll-view>

			</view>
		</view>
		<jumpBall :start.sync="num" :element.sync="element" @msg="jbMsg" :speed="animaTime" :index="9999" />

		<view class="footer" :style="{bottom:footerbottom}">

			<view class="settlement">

				<view class="cart"  @click="showShoppingCar" :animation="cartAnimationData">
					<view class="tag cartNum " v-if="goodsTotalNumber>0">
						<text style="margin: 0 auto;">{{goodsTotalNumber}}</text>
					</view>
					<image :src="goodsTotalNumber ? '/static/cart.png' : '/static/cart2.png'" mode=""></image>

				</view>
				<view class="cart1" :animation="cartAnimationData">
					<view @click="clearShoppingCart">
						<text class="cuIcon-delete"></text>
						<text>清空</text>
					</view>
				</view>

				<view class="sum">

					合计:<view class="money">￥{{goodsTotal.toFixed(2)}}</view>
				</view>

				<view class="btn" @click="toInfo">确认选择</view>
			</view>


		</view>

		<view class="cart-box" :style="{display: showCar ? 'flex' : 'none'}">
			
			<view class="box-container rebate-box">
				<text class="text-white text-bold">
					购物车
				</text>
			</view>
			<view class="box-container operating-box">
				<view class="operating-box_right">
		
				</view>
				<view class="operating-box_left clear" @click="clearShoppingCart">
					<text class="hxicon cuIcon-delete "></text>
					<text>清空购物车</text>
				</view>
			</view>
			<view class=" goods-box">
				<view class="" style="flex: 1;">
					<scroll-view scroll-y="true" class="goods-list-scroll" >
						<view class="goods-list">
							<view class="box" v-for="(rowData,i) in shoppCart" :key="i">
		
								<view class="m-store-item">
									
									<view class="m-text">
										<view class="m-title">
											{{rowData.name}}
										</view>
										<view
											style="width: 68vw; flex: 1 1 auto; font-size: 20rpx; color: #888;padding-top: 8rpx;overflow: hidden;white-space: nowrap;text-overflow: ellipsis;">
											{{rowData.descripe||''}}
										</view>
										<view
											style="width: 68vw; flex: 1 1 auto; font-size: 20rpx; color: #ff9800;padding-top: 8rpx;overflow: hidden;white-space: nowrap;text-overflow: ellipsis;">
											{{rowData.names||''}}
										</view>
										<view class="m-price-box" v-if="rowData.price>0">
											<view class="symbol">￥</view>
											<view class="m-price">{{rowData.price}}</view>
											<view class="m-old-price" v-if="rowData.oldprice">
												<text>￥{{rowData.oldprice}}</text>
											</view>
										</view>
										<view class="m-distance">
											<view :class="'addEle2_' + i" class="jumpPosition"></view>
											<tui-numberbox :min="0"  :rowdata="rowData" :value="rowData.number"
												@change="change" :key="i">
											</tui-numberbox>											
										</view>
									</view>		
								</view>
							</view>
						</view>
					</scroll-view>
				</view>
		
			</view>
		<view style="position: fixed;left: 0;top:0;bottom: 0;right:0;z-index: -1;" @click="showCar=false">
			
		</view>
		
		</view>
		
	</view>
</template>

<script>
	import jumpBall from '@/components/hx-jump-ball/hx-jump-ball.vue';
	import hxNumberBox from "@/components/uni-number-box/uni-number-box1.vue";
	export default {
		components: {
			jumpBall,
			hxNumberBox
		},
		data() {
			return {
				//navbar*********************
				htitle: '',
				backText: '',
				backIconName: 'nav-back',
				background: {
					'background-color': '#ffcc00'
				},
				isBack: true,
				isFixed: true,
				//navbar********************
				ticketList: [],
				shoppCart: [],
				headerTop: 0,
				//控制滑动效果
				typeClass: 'valid',
				subState: '',
				theIndex: null,
				oldIndex: null,
				isStop: false,
				num: 0,
				element: [],
				cartAnimation: {},
				cartAnimationData: {},
				animaTime: 300,
				goodsTotalNumber: 0,
				goodsTotal: 0,
				showCar: false,
				TabCur: 0,
				scrollLeft: 0,
				footerbottom: 0,
				days: [],
				wechatinfo: {},
				condition: '',
				class: '',
				page: 1,
				rows: 20,
				isend: false,
				step: 0.1,
				bgColor: "#F2F3F5",
				color: '#323233',
				tabScrollTop: 0,
				old: {
					scrollTop: 0
				},
			}
		},
		onPageScroll(e) {

		},
		//下拉刷新，需要自己在page.json文件中配置开启页面下拉刷新 "enablePullDownRefresh": true
		onPullDownRefresh() {
			setTimeout(function() {
				uni.stopPullDownRefresh();
			}, 1000);
		},
		onLoad(op) {
			this.class = op.class;
			this.initTicket();
			this.initShopcart();

		},
		onShow() {},
		methods: {
			loadMore() {
				if (!this.isend) {
					this.initTicket();
				}
			},
			reLoad() {
				this.condition = '';

				this.refData();
			},
			serData(e) {
				this.refData();
			},
			scrollP(e) {
				this.old.scrollTop = e.detail.scrollTop;
			},
			refData() {
				//this.tabScrollTop=0;
				this.page = 1;
				this.isend = false;

				this.ticketList = [];
				this.initTicket();
				this.tabScrollTop = this.old.scrollTop
				this.$nextTick(() => {
					this.tabScrollTop = 0;
				});
			},
			initTicket() {
				let that = this;
				uni.showLoading({
					mask: true,
					title: '加载中..'
				})
				this.$api.mypost({
					url: "/api/Store/GetItemByClass",
					data: {
						class: this.class,
						condition: this.condition,
						page: this.page,
						rows: this.rows
					},
					success: (res) => {
						uni.hideLoading();
						console.log(res);
						this.page++;
						res.data.forEach(item => {
							if (that.shoppCart.length > 0) {
								let findex = that.shoppCart.findIndex(n => n.id == item.id);
								if (findex != -1)
									item.number = that.shoppCart[findex].number;
								else
									item.number = 0;
							} else
								item.number = 0;
						});
						that.ticketList = that.ticketList.concat(res.data);
						if (that.ticketList.length >= res.total)
							this.isend = true;
					},
					fail: (res) => {
						uni.hideLoading();
						console.log(res);
					}
				});
			},
			change(e, index) {
				console.log(e);
				console.log(this.ticketList);
				let findex = this.ticketList.findIndex(n => n.id == e.rowdata.id);
				if (findex != -1)
					this.ticketList[findex].number = parseFloat(e.value.toFixed(2));
				if (this.shoppCart == null || !Array.isArray(this.shoppCart))
					this.shoppCart = [];
				console.log(this.shoppCart)
				let findex1 = this.shoppCart.findIndex(n => n.id == e.rowdata.id);
				if (findex1 != -1) {
					this.shoppCart[findex1].number = parseFloat(e.value.toFixed(2));
					if (e.value == 0)
						this.shoppCart = this.shoppCart.filter(o => o.id != e.rowdata.id);
				} else {
					this.shoppCart.push({
						...this.ticketList[findex]
					});
				}
				uni.setStorageSync("shoppCart", this.shoppCart);
				this.initShopcart();
			},
			initShopcart() {
				this.shoppCart = uni.getStorageSync("shoppCart");
				console.log(this.shoppCart);
				if (this.shoppCart && this.shoppCart.length > 0) {
					let num = 0;
					let total = 0;
					this.shoppCart.forEach(item => {
						num += item.number;
						total += item.price * item.number;
					});
					this.goodsTotalNumber = parseFloat(num.toFixed(2)); //eval(this.shoppCart.map(n => n.number).join("+"));
					this.goodsTotal = parseFloat(total.toFixed(
						2)); //eval(this.shoppCart.map(n => n.number * n.Price).join("+"));
				
				} else {
					this.goodsTotalNumber = 0;
					this.goodsTotal = 0;
				}

			},
			clearShoppingCart() {
				let that = this;
				uni.showModal({
					title: '确认',
					content: '是否确定清空数据',
					success: function(res) {
						if (res.confirm) {
							uni.removeStorageSync("shoppCart");
							that.shoppCart = [];
							that.ticketList.forEach(item => {
								item.number = 0;
							});
							that.goodsTotalNumber = 0;
							that.goodsTotal = 0;
						}
					}
				});

			},
			toInfo() {
				this.hideShoppingCar();
				this.$api.prePage().setItem(this.shoppCart);
				uni.removeStorageSync("shoppCart");
				uni.navigateBack({
				
				});
			},

			jbMsg(res) {
				let that = this;

				that.cartAnimation.matrix(1, 0, 0, 0.7, 0, 7).step({
					duration: 100
				})
				that.cartAnimationData = that.cartAnimation.export();
				//动画在app端有bug，所以必须写延迟才能解决
				setTimeout(function() {
					that.cartAnimation.matrix(1, 0, 0, 1, 0, 0).step({
						duration: 150
					});
					that.cartAnimationData = that.cartAnimation.export();
				}, 100);
			},
			//小球跳跃动画
			touchOnAddGoods(ele, data) {
				this.element = [ele, '.cart'];
				this.num++;
				this.addGoodsChange(data);
			},
			switchType(type) {
				if (this.typeClass == type) {
					return;
				}
				uni.pageScrollTo({
					scrollTop: 0,
					duration: 0
				})
				this.typeClass = type;
				this.subState = this.typeClass == '' ? '' : 'show' + type;
				setTimeout(() => {
					this.oldIndex = null;
					this.theIndex = null;
					this.subState = this.typeClass == 'valid' ? '' : this.subState;
				}, 200)
			},
			//控制左滑删除效果-begin
			touchStart(index, event) {
				//多点触控不触发
				if (event.touches.length > 1) {
					this.isStop = true;
					return;
				}
				this.oldIndex = this.theIndex;
				this.theIndex = null;
				//初始坐标
				this.initXY = [event.touches[0].pageX, event.touches[0].pageY];
			},
			touchMove(index, event) {
				//多点触控不触发
				if (event.touches.length > 1) {
					this.isStop = true;
					return;
				}
				let moveX = event.touches[0].pageX - this.initXY[0];
				let moveY = event.touches[0].pageY - this.initXY[1];

				if (this.isStop || Math.abs(moveX) < 5) {
					return;
				}
				if (Math.abs(moveY) > Math.abs(moveX)) {
					// 竖向滑动-不触发左滑效果
					this.isStop = true;
					return;
				}

				if (moveX < 0) {
					this.theIndex = index;
					this.isStop = true;
				} else if (moveX > 0) {
					if (this.theIndex != null && this.oldIndex == this.theIndex) {
						this.oldIndex = index;
						this.theIndex = null;
						this.isStop = true;
						setTimeout(() => {
							this.oldIndex = null;
						}, 150)
					}
				}
			},

			touchEnd(index, $event) {
				//解除禁止触发状态
				this.isStop = false;
			},

			//删除商品
			deleteCoupon(id, List) {
				let len = List.length;
				for (let i = 0; i < len; i++) {
					if (id == List[i].id) {
						List.splice(i, 1);
						break;
					}
				}
				this.oldIndex = null;
				this.theIndex = null;
			},

			discard() {
				//丢弃
			},
			//显示购物车
			showShoppingCar() {
				// if (this.goodsTotalNumber == 0) {
				// 	return;
				// }
				//this.footHeight = '100%';
				this.showCar = !this.showCar;
				console.log(11111)
			},
			//隐藏购物车
			hideShoppingCar() {
				//this.footHeight = '0';
				console.log(2222)
				this.showCar = false;
			},


		}
	}
</script>
<style lang="scss">
	.wrap {
		display: flex;
		flex-direction: column;
		height: calc(100vh - var(--window-top));
		width: 100%;
	}

	page {
		position: relative;
		background-color: #f5f5f5;
	}

	.hidden {
		display: none !important;
	}

	.place {
		width: 100%;
		height: 95upx;
	}

	.tabr {
		background-color: #fff;
		width: 94%;
		height: 95upx;
		padding: 0 3%;
		border-bottom: solid 1upx #dedede;
		position: fixed;
		top: 0;
		z-index: 10;

		view {
			width: 50%;
			height: 90upx;
			justify-content: center;
			align-items: center;
			font-size: 32upx;
			color: #999;
		}

		.on {
			color: #f06c7a;
		}

		.border {
			height: 4upx;
			background-color: #f06c7a;
			transition: all .3s ease-out;

			&.invalid {
				transform: translate3d(100%, 0, 0);
			}
		}

	}

	.list {
		width: 100%;
		display: block;
		position: relative;
	}

	@keyframes showValid {
		0% {
			transform: translateX(-100%);
		}

		100% {
			transform: translateX(0);
		}
	}

	@keyframes showInvalid {
		0% {
			transform: translateX(0);
		}

		100% {
			transform: translateX(-100%);
		}
	}

	.sub-list {
		&.invalid {
			position: absolute;
			top: 0;
			left: 100%;
			display: none;
		}

		&.showvalid {
			display: flex;
			animation: showValid 0.20s linear both;
		}

		&.showinvalid {
			display: flex;
			animation: showInvalid 0.20s linear both;
		}

		width: 100%;
		padding: 20upx 0 120upx 0;

		.tis {
			width: 100%;
			height: 60upx;
			justify-content: center;
			align-items: center;
			font-size: 32upx;
			margin: 0 auto;
			text-align: center;
		}

		.row {
			width: 92%;
			height: 19vw;
			margin: 20upx auto 10upx auto;
			border-radius: 8upx;
			// box-shadow: 0upx 0 10upx rgba(0,0,0,0.1);
			align-items: center;
			position: relative;
			overflow: hidden;
			z-index: 4;
			border: 0;

			.menu {
				.icon {
					color: #fff;
					font-size: 50upx;
				}

				position: absolute;
				width: 28%;
				height: 100%;
				right: 0;
				justify-content: center;
				align-items: center;
				background-color: red;
				color: #fff;
				z-index: 2;
			}

			.carrier {
				@keyframes showMenu {
					0% {
						transform: translateX(0);
					}

					100% {
						transform: translateX(-28%);
					}
				}

				@keyframes closeMenu {
					0% {
						transform: translateX(-28%);
					}

					100% {
						transform: translateX(0);
					}
				}

				&.open {
					animation: showMenu 0.25s linear both;
				}

				&.close {
					animation: closeMenu 0.15s linear both;
				}

				background-color: #fff;
				position: absolute;
				width: 100%;
				padding: 0 0;
				height: 100%;
				z-index: 3;
				flex-wrap: nowrap;

				.left {
					width: 100%;

					.title {
						padding-top: 3vw;
						width: 90%;
						margin: 0 5%;
						font-size: 36upx;
					}

					.term {
						width: 90%;
						margin: 0 5%;
						font-size: 26upx;
						color: #999;
					}

					position: relative;

					.gap-top,
					.gap-bottom {
						position: absolute;
						width: 20upx;
						height: 20upx;
						right: -10upx;
						border-radius: 100%;
						background-color: #f5f5f5;
					}

					.gap-top {
						top: -10upx;
					}

					.gap-bottom {
						bottom: -10upx;
					}

					.shixiao {
						position: absolute;
						right: 20upx;
						font-size: 150upx;
						z-index: 6;
						color: rgba(153, 153, 153, 0.2)
					}
				}

				.right {
					flex-shrink: 0;
					width: 28%;
					color: #fff;
					background: linear-gradient(to right, #ec625c, #ee827f);

					&.invalid {
						background: linear-gradient(to right, #aaa, #999);

						.use {

							color: #aaa;
						}
					}

					justify-content: center;

					.ticket,
					.criteria {
						width: 100%;
					}

					.ticket {
						padding-top: 4vw;
						justify-content: center;
						align-items: baseline;
						height: 6vw;

						.num {
							font-size: 42upx;
							font-weight: 600;
						}

						.unit {
							font-size: 24upx;
						}
					}

					.criteria {
						justify-content: center;

						font-size: 28upx;
					}

					.use {
						width: 50%;
						height: 40upx;
						justify-content: center;
						align-items: center;
						font-size: 24upx;
						background-color: #fff;
						color: #ee827f;
						border-radius: 40upx;
						padding: 0 10upx;
					}
				}
			}


		}
	}

	.footer {
		width: 100%;
		padding: 0 0%;
		background-color: #fbfbfb;
		height: 100upx;
		display: flex;
		justify-content: space-between;
		align-items: center;
		font-size: 28upx;
		position: fixed;
		bottom: 0upx;
		z-index: 99;

		.delBtn {
			border: solid 1upx #f06c7a;
			color: #f06c7a;
			padding: 0 30upx;
			height: 50upx;
			border-radius: 30upx;
			display: flex;
			justify-content: center;
			align-items: center;
		}

		.settlement {
			width: 100%;
			display: flex;
			justify-content: flex-end;
			align-items: center;

			.cart {
				position: relative;
				width: 36px;
				height: 36px;

				image {
					width: 100%;
					height: 100%;
				}

				.tag {
					position: absolute;
					right: 12upx;
					top: 16upx;
					height: 18px;
					width: 18px;
					background-color: #ff4000;
					color: #ffffff;
					border-radius: 50%;
					z-index: 1;
					font-size: 10px;
					text-align: center;
					line-height: 18px;
				}
			}

			.cart1 {
				position: relative;
				width: 40px;
				height: 36px;
				line-height: 36px;
				margin-left: 10px;
			}

			.sum {
				width: 40%;
				font-size: 28upx;
				margin-right: 10upx;
				display: flex;
				justify-content: flex-end;

				.money {
					font-weight: 600;
					color: $base-color;
				}
			}

			.btn {
				//padding: 0 30upx;
				height: 100upx;
				width: 250upx;
				background-color: #1AAD19;
				color: #fff;
				display: flex;
				font-weight: bold;
				justify-content: center;
				align-items: center;

				//border-radius: 30upx;
			}
		}
	}

	.jumpPosition {
		position: absolute;
		bottom: 23px;
		right: 0;
		z-index: 2;
		width: 28px;
		height: 28px;
	}

	.cart-box {
		display: flex;
		justify-content: flex-start;
		flex-flow: column;
		background: #ffffff;
		position: absolute;
		bottom: 0;
		z-index: 100;
		//max-height: 66%;
		height: 600upx;
		//padding-bottom: 62px;
		margin-bottom: 100upx;
		border-top-left-radius: 16px;
		border-top-right-radius: 16px;
		overflow: hidden;
		width: 100%;

		.rebate-box {
			height: 30px;
			background: #FFC107;
			color: #FF9900;
			text-align: center;
			line-height: 30px;
			font-size: 14px;
		}

		.box-container {
			box-sizing: border-box;
			padding: 0 16px;
		}

		.operating-box {
			font-size: 12px;
			line-height: 40px;
			height: 40px;
			border-bottom: 1px solid #f6f6f6;
			color: #666666;
			display: flex;
			flex-direction: row;
			background-color: #E4E7ED;

			&_right {
				flex: 1;
			}

			&_left {
				display: flex;
				flex-direction: row;
			}

		}

	}

	.goods-box {
		height: 100%;
		overflow: hidden;
		flex: 1;
		display: flex;

		.goods-list-scroll {
			height: 100%;

			.goods-list {

				width: 100%;
				display: flex;
				flex-wrap: wrap;

				.box {
					width: 100%;
					border-bottom: 1px solid #f6f6f6;
					box-sizing: border-box;
					padding: 0 16px;

					.m-store-item {
						display: flex;
						flex-direction: row;
						width: 100%;
						justify-content: space-between;
						align-items: flex-end;
						padding-top: 15px;
						padding-bottom: 15px;

						.m-img {
							flex: 0 0 85px;
							height: 85px;
							background: #eee;
							border-radius: 4px;
						}

						.m-text {
							flex: 1;
							position: relative;
							height: 85px;
							padding: 0 6px;
							display: flex;
							align-content: space-between;
							flex-direction: column;

							.m-title {
								font-size: 16px;
								color: #555555;
								height: 21px;
								font-weight: bold;
							}

							.m-descripe {
								font-size: 12px;
								color: #999999;
								margin-top: 5px;
								height: 35px;
							}

							.m-price-box {
								height: 24px;
								font-weight: bold;
								display: flex;
								flex-direction: row;
								align-items: flex-end;

								.symbol {
									color: #ff582b;
									font-size: 12px;
								}

								.m-price {
									position: relative;
									top: 2px;
									font-size: 18px;
									color: #ff582b;
								}

								.m-old-price {
									margin-left: 3px;
									display: flex;
									flex-direction: row;
									font-size: 10px;
									color: #999999;
									margin-top: 5upx;
									text-decoration: line-through;
									font-weight: normal;
								}
							}

							.m-distance {
								position: absolute;
								right: 0;
								bottom: 30px;
								z-index: 16;
								color: #b2b2b2;
								font-size: 20upx;
								text-align: right;

								.jumpPosition {
									position: absolute;
									bottom: 23px;
									right: 0;
									z-index: 2;
									width: 28px;
									height: 28px;
								}
							}

						}

					}
				}
			}

		}
	}
</style>
