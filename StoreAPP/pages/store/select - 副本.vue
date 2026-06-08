<template>
	<view  @touchstart="touchStart" @touchend="touchEnd">

		<u-navbar title-color="#fff" back-icon-color="#ffffff" :is-fixed="isFixed" :is-back="isBack"
			:background="background" :back-text-style="{color: '#fff'}" :title="htitle" :back-icon-name="backIconName"
			:back-text="backText">
			<view class="slot-wrap" style="width: 95%;">
				<view class="search-wrap">
					<!-- 如果使用u-search组件，必须要给v-model绑定一个变量 -->
					<u-search v-model="condition" @custom="loadItem1" @clear="reLoad" :show-action="true" height="56"
						:action-style="{color: '#fff'}">
					</u-search>
				</view>
			</view>
		</u-navbar>
		<!-- <jumpBall :start.sync="num" :element.sync="element" @msg="jbMsg" :speed="animaTime" :index="9999" />
 -->


		<!-- 主体 -->
		<view class="main" :style="{height: mainHeight}">
			<!-- <view class="" :style="{display:showZz}" style="position: absolute;top: 0;bottom: 0;left: 0;width: 100%; background: #3F536E;z-index: 999;opacity: 0.5;">
				遮罩
			</view> -->
			<view class="QS-tabs-box"
				:style="{'top': 'calc(44px + ' + statusBarHeight + 'px)','background-color':'rgba(245,245,245,'+ navSearchBgOpacity +')'}">
				<view class="" style="width: 210px;height: 100%;">

					<view class="hx-tabs">
						<view class="hx-tabs-item" v-for="(item,i) in tabs" :key="i"
							:class="{'hx-tabs-active': swiperCurrent == i}" @click="swiperChange(i)"
							:style="{transition: transtionTime + 'ms'}">
							<text>{{item.name}}</text>
						</view>
						<view class="hx-tabs-slider-box"
							:style="{transition: transtionTime + 'ms',left:swiperCurrentSliderLeft + 'px'}">
							<view class="hx-tabs-slider"></view>
						</view>
					</view>
				</view>
			</view>
			<swiper id="mainSwiper" style="height: 100%;" :current="swiperCurrent" :duration="transtionTime"
				@transition="transition" @animationfinish="animationfinish">
				<!-- 购物 -->
				<swiper-item class="swiper-item">

					<view class="scroll-items">

						<view class="category-list">
							<!-- 左侧分类导航 -->
							<scroll-view :scroll-y="true" class="left">

								<view :ref="'item'+cindex" v-for="(item,cindex) in categoryList" :key="item.id"
									class="row" :class="{active: item.id == currentId}" @click="showCategory(item)">
									<view :class="item.id == currentId?'text1':'text'">
										{{item.name}}
									</view>
									<view class="row-number" v-if="item.number">
										{{item.number}}
									</view>
								</view>
							</scroll-view>
							<!-- 右侧子导航 -->
							<scroll-view scroll-with-animation :scroll-y="true" class="right" @scroll="asideScroll"
								:scroll-top="tabScrollTop">
								<view class="goodsListBox">


									<view class="category" v-for="item in categoryList" :key="item.id"
										:id="'goodsBox'+item.id">
										<view class="s-item">{{item.name}}</view>
										<view class="list">
											<view class="box" v-for="(rowData,i) in goodsList" :key="rowData.id"
												v-if="item.id == rowData.type_id">
												<!-- 商品列表 -->
												<!-- <m-store-pro @touchOnGoods="touchOnGoods" :rowData="box"></m-store-pro>
													 -->
												<!-- 商品列表 -->
												<view class="m-store-item">
													<!-- <view class="m-img" @click="preViews(rowData.img)">
														<image style="width: 100%;height: 100%;" :src="rowData.img"
															mode="aspectFit"></image>
													</view> -->
													<view class="m-text">
														<view class="m-title" @click="hrefGoodsInfo(rowData.id)">
															{{rowData.name}}
														</view>
														<view class="m-descripe">
															{{rowData.descripe}}
														</view>
														<view class="m-price-box" v-if="rowData.price>0">
															<view class="symbol">￥</view>
															<view class="m-price">{{rowData.price}}</view>
															<view class="m-old-price" v-if="rowData.oldprice">
																<text>￥{{rowData.oldprice}}</text>
															</view>
														</view>
														<view class="m-distance">
															<block v-if="rowData.shopspec">
																<view class="myselect" @click="open(rowData)">
																	<text v-if="rowData.specnum>0"
																		class="tip">{{rowData.specnum}}</text>
																	选规格
																</view>
															</block>
															<block v-else>
																<view :class="'addEle_' + i" class="jumpPosition">
																</view>
																<hx-number-box @change="addGoodsChange"
																	:value="rowData.number" :rowData="rowData">
																</hx-number-box>
															</block>
														</view>

													</view>

												</view>
											</view>
										</view>
									</view>
								</view>
							</scroll-view>
						</view>
					</view>

				</swiper-item>

				<!-- 评价 -->
				<!-- <swiper-item class="swiper-item">
					<scroll-view scroll-y style="height: 100%;width: 100%;background-color: #ffffff;"
						@scroll="asideScroll">
						<view class="scroll-items evaluate-box">
							<view class="evaluate-box-header">

							</view>
							<view class="evaluate-box-body">

							</view>
							<hx-comment :myd="storeData.myd" :pf="storeData.pf" :listData="commentList"></hx-comment>
						</view>
					</scroll-view>
				</swiper-item> -->


			</swiper>
		</view>

		<!-- 购物车 -->
		<view class="foot" @touchmove.stop.prevent="mpClear" :style="{height: footHeight}" v-if="showFoot">
			<view class="zz" @click="hideShoppingCar"></view>
			<view class="btn-box">
				<view class="btn-box-left" @click="contact">
					<view class="imgBox">
						<!-- <image src="../../static/store/contact.png" mode=""></image> -->
						<uni-icons type="back" size="20" color="#f6d200;"></uni-icons>
					</view>
					<text>返回</text>
				</view>
				<view class="btn-box-line"></view>
				<view class="btn-box-center" @click="showShoppingCar">
					<view class="cart" :animation="cartAnimationData">
						<view class="tag cartNum" v-if="goodsTotalNumber>0">{{goodsTotalNumber}}</view>
						<image :src="goodsTotalNumber ? '/static/cart.png' : '/static/cart2.png'" mode="">
						</image>
					</view>
					<view class="priceBox">
						<view class="hx-txt-18 hx-color-white" v-if="goodsTotalPrice>0">
							￥{{goodsTotalPrice}}
						</view>
						<view class="hx-txt-10 hx-color-gray">
							<!-- 另需配送费￥{{shippingDees}} -->
						</view>
					</view>
				</view>
				<view class="btn-box-right">
					<view class="jiesuan" @click="jiesuan">
						确认
					</view>

				</view>
			</view>
			<view class="cart-box" :style="{display: showCar ? 'flex' : 'none'}">
				<view class="box-container rebate-box" v-if="showDiscount">
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
						<scroll-view scroll-y="true" class="goods-list-scroll" :scroll-top="carGoodsScrollTop">
							<view class="goods-list">
								<view class="box" v-for="(rowData,i) in shoppCart" :key="i">

									<view class="m-store-item">
										<view class="m-img">
											<image style="width: 100%;height: 100%;" :src="rowData.img"
												mode="aspectFit"></image>
										</view>
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
												<!-- <hx-number-box @change="addGoodsChange2" :value="rowData.number"
													:rowData="rowData" :clickTime="animaTime + 100" :max="1"
													@addChange="touchOnAddGoods('.addEle2_' + i,rowData)">
												</hx-number-box> -->
												<button class="cu-btn round sm bg-red"
													@click="delItem(rowData)">删除</button>

											</view>
										</view>

									</view>
								</view>
							</view>
						</scroll-view>
					</view>

				</view>
			</view>

		</view>


		<uni-popup ref="popup1" type="center">
			<block v-if="dish!=null">
				<view style="width: 84vw; background: #FFFFFF; padding:5vw 3vw; border-radius: 10rpx;">
					<view class="dishname">{{dish.name}}</view>
					<block v-if="dish.specs.length>=1">
						<view class="typename">规格</view>
						<view style=" display: flex; flex-wrap:wrap;">
							<block v-for="(item,index) in dish.specs" :key="index">
								<text :class="item.checked?'btn1 color':'btn1'"
									@click="choice(item,'1')">{{item.name}}</text>
							</block>
						</view>
					</block>


					<view class="selectType" style="background: #f8f8f8; padding: 10rpx; border-radius: 6rpx;">
						<text class="tit">已选规格:</text>
						<view class="val">
							{{specname}}
							<!-- {{obj1==''?'':obj1.name}}
							 -->
						</view>
					</view>
					<view class="selectType">
						<view class="val">

						</view>
						<view class="tit">
							<!-- <button class="btn2">+加入购物车</button> -->
							<!-- {{dish.number}} -->
							<view class="jumpPosition"></view>
							<!-- <hx-number-box @change="addGoodsChange" :value="dish.number" :rowData="dish" :max="1"
								:clickTime="animaTime + 100" @addChange="touchOnAddGoods('.myPosition',dish)">
							</hx-number-box> -->
							<button class="cu-btn round bg-yellow" @click="addItem(dish)">确定</button>
							<view class="myPosition" style=" position: absolute; right: 10vw; bottom: 8vh;"></view>
						</view>
					</view>
				</view>
			</block>
		</uni-popup>
	</view>
</template>

<script>
	import uniPopup from '@/components/uni-popup/uni-popup.vue';
	import uniIcons from '@/components/uni-icons/uni-icons.vue';
	import jumpBall from '@/components/hx-jump-ball/hx-jump-ball.vue';
	import hxNumberBox from "@/components/uni-number-box/uni-number-box.vue";
	import hxComment from "@/components/hx-comment/hx-comment.vue";
	//引入测试数据
	// import testData from "@/common/testdata.js";

	var statusBarHeight = uni.getSystemInfoSync().statusBarHeight;

	export default {
		components: {
			uniPopup,
			jumpBall,

			uniIcons,
			hxNumberBox,
			hxComment
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
				wechatinfo: {},
				//商家信息
				storeData: [],
				//商品列表
				goodsList: [],
				//商品分类信息列表
				categoryList: [],
				//评论列表
				commentList: [],

				navSearchWidth: 10,
				navSearchBgOpacity: 0,
				navSearchColor: '#ffffff',
				navHeadHeight: 44,
				//默认禁止商品栏滚动
				goodsBoxScroll: false,
				statusBarHeight,
				//动画时间
				animaTime: 300,
				//商家盒子高度
				storeInfoBoxHeight: 100,
				//展开门店信息容器
				showStoreBox: false,

				num: 1,
				element: [],
				cartAnimation: {},
				cartAnimationData: {},

				//tabs
				tabs: [{
						name: '选择'
					},
					// {
					// 	name: '评价'
					// },
					// {
					// 	name: '商家'
					// },
				],
				swiperCurrent: 0,
				dx: 0,
				swiperCurrentSliderLeft: 0,
				transtionTime: 100,

				//购物车
				shoppingCartAll: [],
				//显示购物车
				showFoot: true,

				//配送费
				shippingDees: 0,
				//配送起步价
				startingPrice: 0,

				//购物车商品价格合计
				goodsTotalPrice: 0,
				//购物车商品数量合计
				goodsTotalNumber: 0,
				//购物车
				shoppCart: [],
				//foot 高度
				footHeight: '0',
				//显示购物车
				showCar: false,
				//购物车中商品滚动条位置
				carGoodsScrollTop: 0,
				//购物车缓存 Storage 名称
				shoppingCartStorageName: 'shopping_cart',

				sizeCalcState: false,
				tabScrollTop: 0,

				mainHeight: 0,
				currentId: 1,


				//购物车显示折扣
				showDiscount: true,
				//手指触摸滑动
				touchData: {},
				//页面滚动条距离顶部的距离
				pageScrollTop: 0,


				dish: null,
				obj1: '',
				obj2: '',
				obj3: '',
				price: 0,
				mynumber: 0,

				trans: [],
				rmno: '',
				isuse: false,
				condition: '',
				specname: ''
			}
		},
		onLoad() {
			let that = this;
			console.log(uni.getStorageSync("storefront"));
			that.rmno = uni.getStorageSync("storefront").rmno;
			console.log(uni.getStorageSync('objInfo'));
			that.cartAnimation = uni.createAnimation({
				duration: 800,
				timingFunction: "ease",
				delay: 0
			});
			let sysInfo = uni.getSystemInfoSync();
			//屏幕高度 - 头部导航高度 - 状态栏高度 - 分页高度
			that.mainHeight = sysInfo.screenHeight - 43 - statusBarHeight - 40 + 'px';



			that.loadData();
		},
		watch: {
			showStoreBox(val, oldVal) {
				// if (val == true) {
				// 	this.showStoreBoxFunc();
				// } else {
				// 	this.hiddenStoreBoxFunc();
				// }
			}
		},
		onPageScroll(e) {
			let that = this;
		},
		onShow() {
			let that = this;
			that.init();
			//that.calcSize();
		},
		methods: {


			open(obj) {
				let that = this;

				that.dish = obj;
				that.dish.specs.forEach(item => {
					if (item.checked)
						that.specname = item.name;
				})
				that.obj1 = that.dish.specs.length != 0 ? that.dish.specs[0] : '';

				let l = that.shoppCart.filter(n => n.id == obj.id);
				console.log(l)
				for (let item of l) {
					if (item.number != 0) {
						that.dish = item;
						that.obj1 = that.dish.obj1;
					}
				}
				that.$refs["popup1"].open();
			},
			choice(obj, t) {
				let that = this;
				that['obj' + t] = obj;

				console.log(obj)
				that.dish.specs.forEach(item => {
					if (item.code == obj.code) {
						item.checked = true;
						that.specname = item.name;
					} else
						item.checked = false;
				})
				let codes = "";
				console.log(that.shoppCart);
				console.log(codes);
				let l = that.shoppCart.filter(n => n.codes == codes && n.id == that.dish.id);

				console.log(l.length != 0)
				if (l.length != 0) {
					that.dish = l[0];
				} else {
					that.dish = {
						id: that.dish.id,
						total: 0,
						codes: codes,
						names: '',
						name: that.dish.name,
						specs: that.dish.specs,
						specnum: that.dish.specnum,
						purchases: that.dish.purchases,
						type_id: that.dish.type_id,
						shopspec: that.dish.shopspec,
						img: that.dish.img,
						descripe: that.dish.descripe,
						number: 0
					};

					console.log(that.dish.number)
				}
			},
			async loadData() {
				let that = this;
				that.storeData = {
					//商家唯一标识
					hotelid: '888888',
					//商家名称
					storeName: '888888',
					descript: '',
					//头像
					avatar: '',
					//横幅图片
					banner: '',
					//商家住址
					address: '',
					//配送时间
					deliveryTime: '11:00~20:30',
					//联系电话
					telephone: '',
					//商家购物车
					shoppingCart: [],
					//配送费
					shippingDees: 0,
					//配送起步价
					startingPrice: 0,
					longitude: 0,
					latitude: 0,
					myd: '',
					pf: ''

				};

				//商品分类信息列表
				let obj = await that.$api.ajax('/api/Store/GetItemType');
				that.categoryList = obj.data;
				// console.log(obj);
				//商品列表
				that.loadItem();
			},
			reLoad() {
				this.condition = '';
				this.loadItem();
			},
			async loadItem() {
				let that = this;
				uni.showLoading({
					mask: true,
					title: '加载中'
				});
				let obj = await that.$api.ajax('/api/Store/GetItem', {
					condition: that.condition
				});
				uni.hideLoading();
				//that.condition = "";
				that.goodsList = obj.data;
				that.init();
			},
			loadItem1(e) {
				// if (this.condition.length == 0) {
				// 	//this.$api.msg('请输入查询条件！');
				// 	return;
				// }
				this.loadItem();
			},
			init() {
				let that = this;
				// console.log(that.categoryList[0].id)
				if (that.categoryList.length == 0)
					return;
				that.currentId = that.categoryList[0].id;
				//假设这是从后台获取的商品数据
				let goods = that.goodsList;
				//商品初始化

				for (let i in goods) {

					goods[i].purchases = 3
				}

				let carts = []; //uni.getStorageSync(that.shoppingCartStorageName) || [];
				//根据缓存数据 获取购物车中属于本商店的商品

				that.shoppCart = carts;


				that.goodsTotalPrice = 0;
				that.goodsTotalNumber = 0;
				for (let i in that.shoppCart) {
					for (let j in goods) {
						// if (goods[j].id == that.shoppCart[i].id) {
						// 	goods[j].number = that.shoppCart[i].number
						// }
						let l = that.shoppCart.filter(n => n.id == goods[j].id);
						let tns = l.map(n => n.number);
						let atn = 0;
						tns.forEach(item => {
							atn += item;
						})
						goods[j].number = atn || 0;
					}
					//计算商品总价
					that.goodsTotalPrice += that.shoppCart[i].total
					//商品总数量
					that.goodsTotalNumber += that.shoppCart[i].number
				}
				//初始化商品列表
				that.goodsList = goods;

				//初始化起步价和配送费
				that.startingPrice = that.storeData.startingPrice || 0;
				that.shippingDees = that.storeData.shippingDees || 0;

				that.setLabelNumber();

				// console.log(that.$refs.item0)
				this.$nextTick(() => {
					that.calcSize();
				});

			},
			//导航栏滑动时的操作
			navbarScroll(scroll) {
				let that = this
				let top = scroll.scrollTop || scroll.scroll;
				console.log(top)
				if (!top) {
					that.navSearchWidth = 100
					that.navSearchBgOpacity = 1
					that.navSearchColor = '#888888'
				} else {
					that.pageScrollTop = top;
					if (top < 120) {
						if (that.navSearchWidth >= 3) {
							if (top < 3) {
								that.navSearchWidth = 3
								that.navSearchBgOpacity = 0
								that.navSearchColor = '#ffffff'
							} else {
								let n = top * (120 / 100)
								if (n > 100) {
									n = 100
								}
								that.navSearchWidth = n
								that.navSearchBgOpacity = top * (1 / 100)
								that.navSearchColor = '#888888'
							}

						}

					} else {
						that.navSearchWidth = 100
						that.navSearchBgOpacity = 1
						that.navSearchColor = '#888888'
					}
				}
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

			swiperChange(index) {
				this.swiperCurrent = index;
				this.swiperCurrentSliderLeft = 70 * index;
			},
			transition({
				detail: {
					dx
				}
			}) {
				// this.$refs.tabs.setDx(dx);
			},
			animationfinish({
				detail: {
					current
				}
			}) {
				/* this.$refs.tabs.setFinishCurrent(current); */
				this.swiperCurrent = current;
				this.current = current;
				this.swiperChange(current);
				this.showFoot = current == 0 && this.showStoreBox != true ? true : false;

			},


			//一级分类点击
			showCategory(item) {
				this.calcSize();
				this.currentId = item.id;
				let index = this.categoryList.findIndex(sitem => sitem.id === item.id);
				this.tabScrollTop = this.categoryList[index].top;
				//console.log(this.tabScrollTop)
			},
			//右侧栏滚动
			asideScroll(e) {
				let that = this;
				// that.calcSize();
				let scrollTop = Math.round(e.detail.scrollTop);
				let tabs = that.categoryList.filter(item => item.top <= scrollTop).reverse();
				if (tabs.length > 0) {
					that.currentId = tabs[0].id;
				}

				if (scrollTop > 0) {
					uni.createSelectorQuery().select(".main").fields({
						scrollOffset: true,
						rect: true,
					}, (res) => {
						res.top = Math.round(res.top)
						if (res.top > 111) {
							console.log(6666)
							that.navbarScroll({
								scroll: 150
							})
							uni.pageScrollTo({
								duration: 0,
								scrollTop: res.top
							})

						}

					}).exec()
				}
			},
			//计算右侧栏每个tab的高度等信息
			calcSize(event) {
				let h = 0;
				this.categoryList.forEach(item => {
					let view = uni.createSelectorQuery().select("#goodsBox" + item.id);
					view.fields({
						size: true
					}, data => {
						item.top = h;
						h += Math.round(data.height);
						item.bottom = h;
					}).exec();
				})
				this.sizeCalcState = true;
			},

			//小球跳跃动画
			touchOnAddGoods(ele, data) {
				// console.log(99999)
				// console.log(this.shoppCart)
				// this.element = [ele, '.cart'];
				// this.num++;
			},
			addItem(rowData) {
				console.log(rowData);
				let that = this;
				//let sel = rowData.specs.find(o => o.checked);
				let gindex = this.shoppCart.findIndex(o => o.id == rowData.id && o.codes == sel.code);
				console.log(777);
				console.log(gindex);
				if (gindex == -1) {
					let goods = {
						...rowData
					};
					goods.number = 1;
					//goods.codes = sel.code;
					//goods.names = sel.name;
					that.shoppCart.push(goods);
				}
				//rowData.specnum = that.shoppCart.filter(n => n.id == rowData.id).length;
				//console.log(rowData.specnum);
				if (that.shoppCart.length > 0) {
					let tns = that.shoppCart.map(n => n.number);
					let atn = 0;
					tns.forEach(item => {
						atn += item;

					})
					that.goodsTotalNumber = atn;
				} else
					that.goodsTotalNumber = 0;

				console.log(that.goodsTotalNumber)
				if (that.goodsTotalNumber == 0) {
					that.hideShoppingCar();
				}
				this.$refs["popup1"].close();
				that.setLabelNumber();
				//购物车商品数据缓存至本地
				//uni.setStorageSync(that.shoppingCartStorageName, that.shoppCart);
			},

			//新增商品计算价格
			addGoodsChange(number, rowData) {
				//console.log(rowData);
				number = Number(number);
				rowData.number = number;
				let that = this;
				let gindex = this.shoppCart.findIndex(o => o.id == rowData.id);
				console.log(number);
				if (gindex == -1) {
					// that.shoppCart.push({
					// 	...rowData
					// });
					that.shoppCart.push(rowData);
				} else if(number==0){
					that.shoppCart = this.shoppCart.filter(o=>o.id!=rowData.id);
				}
				// else {
				// 	let goods = [];
				// 	this.shoppCart.forEach(item => {
				// 		if (item.id != rowData.id)
				// 			goods.push({
				// 				...item
				// 			});
				// 	})
				// 	that.shoppCart = goods;
				// }
				console.log(that.shoppCart)
				if (that.shoppCart.length > 0) {
					let tns = that.shoppCart.map(n => n.number);
					let atn = 0;
					tns.forEach(item => {
						atn += item;

					})
					that.goodsTotalNumber = atn;
				} else
					that.goodsTotalNumber = 0;

				console.log(that.goodsTotalNumber)
				if (that.goodsTotalNumber == 0) {
					that.hideShoppingCar();
				}

				that.setLabelNumber();
				//购物车商品数据缓存至本地
				//uni.setStorageSync(that.shoppingCartStorageName, that.shoppCart);
			},
			delItem(rowData) {
				let that = this;
				let goods = [];
				this.shoppCart.forEach(item => {
					console.log(item)
					if (item.shopspec) {
						console.log(item.codes)
						console.log(rowData.codes)
						if (item.id != rowData.id && item.codes != rowData.codes)
							goods.push({
								...item
							});
					} else {
						if (item.id != rowData.id)
							goods.push({
								...item
							});
					}
				})
				that.shoppCart = goods;
				let cindex = this.goodsList.findIndex(o => o.id == rowData.id);
				if (cindex != -1) {
					console.log(66666);
					let item = this.goodsList.find(o => o.id == rowData.id);
					console.log(item);
					item.number = 0;
				}
				let total = 0;

				that.goodsTotalNumber = that.shoppCart.length;

				console.log(that.goodsTotalNumber)
				if (that.goodsTotalNumber == 0) {
					that.hideShoppingCar();
				}
				that.setLabelNumber();
				//购物车商品数据缓存至本地
				//uni.setStorageSync(that.shoppingCartStorageName, that.shoppCart);

			},
			addGoodsChange2(number, rowData) {
				console.log(rowData);
				number = Number(number);
				rowData.number = number;
				let that = this;
				let gindex = this.shoppCart.findIndex(o => o.id == rowData.id);
				console.log(gindex);
				if (gindex == -1) {
					that.shoppCart.push({
						...rowData
					});
				} else {

					let goods = [];
					this.shoppCart.forEach(item => {
						if (item.id != rowData.id)
							goods.push({
								...item
							});
					})
					that.shoppCart = goods;
				}
				console.log(that.shoppCart)
				let cindex = this.goodsList.findIndex(o => o.id == rowData.id);
				if (cindex != -1 && number == 0) {
					console.log(66666);
					let item = this.goodsList.find(o => o.id == rowData.id);
					console.log(item);
					item.number = 0;
				}
				let total = 0;
				that.shoppCart.forEach(item => {

					console.log(item);
					item.number = 1;
					total += item.number;
				})
				console.log(that.shoppCart)
				if (that.shoppCart.length > 0) {
					let tns = that.shoppCart.map(n => n.number);
					let atn = 0;
					tns.forEach(item => {
						atn += item;

					})
					that.goodsTotalNumber = atn;
				} else
					that.goodsTotalNumber = 0;

				console.log(that.goodsTotalNumber)
				if (that.goodsTotalNumber == 0) {
					that.hideShoppingCar();
				}
				that.setLabelNumber();
				//购物车商品数据缓存至本地
				//uni.setStorageSync(that.shoppingCartStorageName, that.shoppCart);
			},

			//计算每类商品购买的总数
			setLabelNumber() {
				let that = this;
				//计算每一类购买商品的总数量
				for (let j in that.categoryList) {
					let n = 0;
					for (var i in that.shoppCart) {
						if (that.shoppCart[i].type_id == that.categoryList[j].id) {
							n += that.shoppCart[i].number;
						}
					}
					that.categoryList[j].number = n;
				}
				for (let j in that.goodsList) {
					let item = that.goodsList[j];
					if (item.shopspec) {
						console.log(33343)
						item.specnum = that.shoppCart.filter(o => o.id == item.id).length;
					}
				}
			},

			//去结算
			jiesuan() {
				this.$refs["popup1"].close();
				console.log(this.shoppCart);
				this.$api.prePage().setItem(this.shoppCart);
				//this.clearShoppingCart();
				uni.navigateBack({

				});
			},
			//联系商家
			// contact() {
			// 	uni.navigateTo({
			// 		url: `/pages/select/select`
			// 	})
			// 	// uni.showModal({
			// 	// 	title: "",
			// 	// 	content: "联系商家"
			// 	// })
			// },
			//去结账
			contact() {
				uni.navigateBack({

				})
			},
			navtoSelect() {
				uni.navigateBack({
					delta: 1
				})
			},
			showStoreBoxFunc() {
				this.storeInfoBoxHeight = uni.getSystemInfoSync().screenHeight - 136;
				this.$set(this.$data, 'showFoot', false);
				this.showStoreBox = true;
				uni.pageScrollTo({
					duration: 0,
					scrollTop: 0
				})
			},
			hiddenStoreBoxFunc() {
				this.storeInfoBoxHeight = 100;
				this.showStoreBox = false;
				if (this.swiperCurrent == 0) {
					this.$set(this.$data, 'showFoot', true);
				}
			},

			mpClear(e) {
				// TODO nvue 取消冒泡
				e.stopPropagation()
			},

			//显示购物车
			showShoppingCar() {
				if (this.goodsTotalNumber == 0) {
					return;
				}
				this.footHeight = '100%';
				this.showCar = !this.showCar;
				this.carGoodsScrollTop = 0;
			},
			//隐藏购物车
			hideShoppingCar() {
				this.footHeight = '0';
				this.showCar = false;
			},
			//清空该门店的购物车
			clearShoppingCart() {
				let that = this;

				that.$refs["popup1"].close();

				that.shoppCart = [];
				// that.storeData.shoppingCart = [];
				// for (let i in that.shoppingCartAll) {
				// 	if (that.shoppingCartAll[i].hotelid == that.storeData.hotelid) {
				// 		that.shoppingCartAll[i] = that.storeData
				// 	}
				// }
				that.goodsList.forEach(item => {
					item.number = 0;
				})
				// for (let i in that.goodsList) {
				// 	console.log(1111)
				// 	that.goodsList[i].number = 0;
				// }
				for (let i in that.categoryList) {
					that.categoryList[i].number = 0;
				}
				//uni.setStorageSync(that.shoppingCartStorageName, that.shoppCart);

				//购物车商品价格合计
				that.goodsTotalPrice = 0;
				//购物车商品数量合计
				that.goodsTotalNumber = 0;
				that.hideShoppingCar();
				// uni.redirectTo({
				// 	url: '/pages/booking/select'
				// })
			},
			hrefGoodsInfo(id) {
				// uni.navigateTo({
				// 	url: '/pages/product/product?id=' + id
				// });
			},
			//拨打电话
			goCall(phone) {
				if (!phone) {
					return;
				}
				uni.makePhoneCall({
					phoneNumber: phone //仅为示例
				});
			},
			goAddress(item) {
				//console.log(item);
				uni.openLocation({
					longitude: item.longitude,
					latitude: item.latitude,
					name: item.storeName,
					address: item.address
				})
			},


			touchStart(e) {

				this.touchData.clientX = e.changedTouches[0].clientX;

				this.touchData.clientY = e.changedTouches[0].clientY;
			},
			touchEnd(e) {

				const subX = e.changedTouches[0].clientX - this.touchData.clientX;
				const subY = e.changedTouches[0].clientY - this.touchData.clientY;
				if (subY > 50 || subY < -50) {
					if (subY > 50) {
						//console.log('下滑')
						if (this.pageScrollTop == 0) {
							// this.showStoreBox=true;

						}
					} else if (subY < -50) {
						//console.log('上滑')
						this.showStoreBox = false;
					} else {
						//console.log('上下滑无效')
					}

				} else {
					if (subX > 100) {
						//console.log('右滑')
					} else if (subX < -100) {
						//console.log('左滑')
					} else {
						//console.log('左右滑无效')
					}
				}
			},
			preViews(src) {
				let srcs = [];
				srcs.push(src);
				uni.previewImage({
					urls: srcs
				})
			}
		}
	}
</script>

<style lang="scss">
	//主题颜色
	$hx-theme-color: #FFC107;
	$hx-theme-color-light: #FFEB3B;

	.add {
		position: fixed;
		right: 60upx;
		top: 300upx;
		z-index: 999;
	}

	.ctn {

		/* border: 1px solid #e3e3e3; */
		width: 100%;
		display: flex;
		justify-content: flex-end;
		overflow: hidden;
		align-items: center;

		.searchCtn {
			display: flex;
			border-radius: 80upx;
			padding: 8upx 12upx;
			line-height: 44upx;
			background: #e0e0e0;
			overflow: hidden;
			align-items: center;
			min-width: 22px;
		}

		.leftBox {
			display: flex;
			width: 53px;
			justify-content: space-between;
			flex: none;
			margin: 0 8px;
		}

		.jrNull {
			/* #ifdef MP */
			width: 95px;
			flex: none;
			/* #endif */
		}
	}

	page {
		background: #ffffff;
	}

	.hx-bb {
		border-bottom: 1px solid $uni-border-color;
	}

	.hx-txt-10 {
		font-size: 10px;
	}

	.hx-txt-12 {
		font-size: 12px;
	}

	.hx-txt-14 {
		font-size: 14px;
	}

	.hx-txt-16 {
		font-size: 16px;
	}

	.hx-txt-18 {
		font-size: 18px;
	}

	.hx-txt-22 {
		font-size: 22px;
	}

	.hx-color-gray {
		color: #bbbbbb;
	}

	.hx-color-white {
		color: #FFFFFF;
	}

	.hx-color-black {
		color: #333333;
	}

	.hx-txt-weigth {
		font-weight: bold;
	}

	.hx-mb-10 {
		margin-bottom: 10px;
	}

	.hx-mt-15 {
		margin-top: 15px;
	}

	.hx-shadow {
		box-shadow: 0px 6upx 16upx rgba(173, 173, 173, 0.2);
	}

	.hx-store {
		.header {
			position: relative;
			min-height: 230px;

			&-bg {
				position: absolute;
				left: 0;
				top: 0;
				z-index: 2;
				width: 100%;
				height: 142px;
			}

			&-bg-black {
				position: absolute;
				left: 0;
				top: 142px;
				bottom: 0;
				z-index: 1;
				background-color: #ffffff;
				width: 100%;
				transition: background-color 0.2s;
			}

			&-bg-gray {
				position: absolute;
				left: 0;
				top: 142px;
				bottom: -16px;
				z-index: 1;
				background-color: #afafaf;
				width: 100%;
				transition: background-color 0.2s;
			}

			&-top-Placeholder {
				height: 105px;
			}

			.storeInfo {
				position: relative;
				z-index: 2;
				background: #ffffff;
				height: 100px;
				border-radius: 6px;
				padding: 12px;
				margin-bottom: 4px;
				transition: all 0.2s;

				.shrink-box {
					position: absolute;
					bottom: 0;
					left: 0;
					right: 0;
					text-align: center;
					font-size: 20px;
					color: #a2a8ab;
				}

				.storeAvatar {
					position: absolute;
					width: 50px;
					height: 50px;
					right: 16px;
					top: -25px;
					background: #ffffff;
					border-radius: 4px;

				}
			}
		}

		.container {
			margin: 0 32upx;
		}

		.QS-tabs-box {
			width: 100%;
			position: sticky;
			top: calc(44px + var(--status-bar-height));
			z-index: 10;
			background-color: white;
			border-bottom: 1px solid #efefef;
			height: 40px;

			.hx-tabs {
				position: relative;
				display: flex;
				height: 100%;

				&-item {
					display: flex;
					flex-direction: row;
					justify-content: center;
					align-items: center;
					width: 70px;
					color: #666666;

					text {
						font-size: 16px;
					}

				}

				&-active {
					color: #333333;
					font-weight: bold;
				}

				&-slider-box {
					position: absolute;
					display: flex;
					justify-content: center;
					bottom: 0;
					width: 70px;
				}

				&-slider {
					display: flex;
					background: #f6d200;
					width: 30px;
					height: 3px;
				}
			}
		}

		.main {
			position: relative;
			background-color: #ffffff;

			#mainSwiper {
				background-color: #eeeeee;
				position: sticky;
				top: calc(40px + 44px + var(--status-bar-height));

				.scroll-items {

					// 商品列表样式
					.category-list {
						width: 100%;
						background-color: #fff;
						display: flex;
						padding-bottom: 50px;

						.left,
						.right {
							background: #fff;
							position: absolute;
							top: 0;
							bottom: 0upx;
						}

						.left {
							width: 24%;
							left: 0upx;
							background-color: #f6f3f3;

							.row {
								width: 100%;
								height: 45px;
								display: flex;
								align-items: center;
								overflow: hidden;
								position: relative;

								.text {
									width: 100%;
									font-size: 14px;
									color: #999999;
									overflow: hidden;
									text-overflow: ellipsis;
									display: -webkit-box;
									-webkit-box-orient: vertical;
									-webkit-line-clamp: 2;
									text-align: center;
									padding: 0 16px;
								}

								.text1 {
									width: 100%;
									font-size: 14px;
									color: red;
									overflow: hidden;
									text-overflow: ellipsis;
									display: -webkit-box;
									-webkit-box-orient: vertical;
									-webkit-line-clamp: 2;
									text-align: center;
									padding: 0 16px;
								}

								&-number {
									position: absolute;
									width: 18px;
									height: 18px;
									right: 4px;
									top: 4px;
									background: #ff5722;
									border-radius: 50%;
									line-height: 18px;
									text-align: center;
									font-size: 10px;
									color: #ffffff;
								}

								&.active {
									height: 45px;
									background-color: #fff;

									.text {
										font-size: 14px;

									}
								}
							}

							.row:last-child {
								margin-bottom: 200upx;
							}
						}

						.right {
							width: 76%;
							left: 24%;

							.goodsListBox {
								padding-bottom: 100px;

								.category {
									// 				width: 94%;
									padding: 0 15px 10px 15px;

									.s-item {
										height: 45px;
										line-height: 45px;
										font-size: 16px;
										background: #ffffff;
										color: #555555;
										position: sticky;
										top: 0;
										z-index: 18;
									}

									.list:last-child {
										margin-bottom: 0;
									}

									.list {
										margin-bottom: 20px;
										width: 100%;
										display: flex;
										flex-wrap: wrap;

										.box:first-child {
											.m-store-item {
												margin-top: 0;
											}
										}

										.box {
											width: 100%;

											.m-store-item {
												display: flex;
												flex-direction: row;
												width: 100%;
												justify-content: space-between;
												align-items: flex-end;
												margin-top: 15px;
												margin-bottom: 15px;

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
														bottom: -4px;
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
						}
					}
				}

				.evaluate-box {}

				.business-box {

					.info-list {
						background: #ffffff;
						padding: 0 15px;

						&-container {
							line-height: 46px;
							height: 46px;
							display: flex;
							flex-direction: row;

							.hxicon {
								color: #a2a2a2;
								margin-right: 8px;
							}

							text {
								font-size: 14px;
							}

							.right {

								float: right;
								color: #dddddd;
								display: flex;
								flex-direction: row;
								align-items: center;

								.hxicon {
									color: #dddddd;
									margin-right: 0;
									font-size: 16px;
								}
							}
						}

					}
				}
			}

		}

		.foot {
			position: fixed;
			display: flex;
			z-index: 999;

			justify-content: center;
			align-items: center;
			bottom: 0;
			height: 100%;
			width: 100%;

			/*width: calc(100% - 32px);*/
			.btn-box {
				position: absolute;
				display: flex;
				bottom: 6px;
				justify-content: center;
				align-items: center;
				margin: 0;
				height: 45px;
				width: calc(100% - 32px);
				z-index: 9;

				&-left {
					background: #222222;
					border-top-left-radius: 50px;
					border-top-right-radius: 9px;
					border-bottom-left-radius: 50px;
					border-bottom-right-radius: 9px;
					padding-left: 6upx;
					display: flex;
					flex-direction: column;
					justify-content: center;
					align-self: center;
					width: 70px;
					height: 100%;
					color: #f6d200;
					text-align: center;

					.imgBox {
						display: flex;
						text-align: center;
						justify-content: center;

						image {
							width: 20px;
							height: 20px;
						}
					}

					text {
						font-size: 20upx;
					}
				}

				&-line {
					background: #ffffff;
					width: 2px;
					height: 100%;
				}

				&-center {
					height: 100%;
					flex: auto;
					display: flex;
					justify-content: flex-start;
					align-self: center;
					align-items: center;
					background: #222222;
					border-top-left-radius: 8upx;
					border-bottom-left-radius: 8upx;
					padding-left: 10upx;

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

					.priceBox {
						flex: auto;
					}

				}

				&-right {
					width: 70px;
					height: 100%;
					position: relative;
					display: flex;
					justify-content: flex-start;
					align-self: center;
					align-items: center;


					.pscj {
						width: 100%;
						height: 100%;
						border-top-right-radius: 100upx;
						border-bottom-right-radius: 100upx;
						background: #222222;
						text-align: center;
						display: flex;
						justify-content: center;
						align-self: center;
						align-items: center;
					}

					.jiesuan {
						width: 100%;
						height: 100%;
						font-size: 28upx;
						border-top-right-radius: 100upx;
						border-bottom-right-radius: 100upx;
						text-align: center;
						display: flex;
						justify-content: center;
						align-self: center;
						align-items: center;
						background: linear-gradient(45deg, $hx-theme-color-light, $hx-theme-color);
						font-weight: bold;
						color: #222222;
					}


				}
			}

			.zz {
				position: absolute;
				top: 0;
				left: 0;
				right: 0;
				bottom: 0;
				background-color: rgba(0, 0, 0, .7);
				z-index: 1;
			}

			.cart-box {
				display: flex;
				justify-content: flex-start;
				flex-flow: column;
				background: #ffffff;
				position: absolute;
				bottom: 0;
				z-index: 2;
				max-height: 66%;

				padding-bottom: 62px;
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

					&_right {
						flex: 1;
					}

					&_left {
						display: flex;
						flex-direction: row;
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
											bottom: -4px;
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
			}
		}




		.myselect {
			position: relative;
			border-radius: 25rpx;
			width: 100rpx;
			height: 50rpx;
			background: linear-gradient(100deg, #FFEB3B, #FFC107);
			color: #333;
			display: flex;
			justify-content: center;
			align-items: center;
		}

		.tip {
			display: block;
			background: #f00;
			border-radius: 50%;
			width: 25rpx;
			height: 25rpx;
			top: -20rpx;
			left: 75rpx;
			position: absolute;
			color: #FFFFFF;
			display: flex;
			justify-content: center;
			align-items: center;
		}

		.btn1 {
			width: 30%;
			height: 50rpx;
			color: #ff9800;
			font-size: 28rpx;
			background: #fff;
			border-radius: 6rpx;
			margin: 1.3%;
			border: 1rpx solid #ff9800;
			padding: 10rpx 0rpx;
			display: flex;
			justify-content: center;
			align-items: center;
		}

		.color {
			background: rgba(255, 152, 00, 1);
			color: #fff;
		}

		.dishname {
			font-size: 36rpx;
			color: #333;
			font-size: 36rpx;
			font-weight: bold;
			height: 80rpx;
			width: 100%;
			text-align: center;
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
		}

		.typename {
			color: #666;
			font-size: 28rpx;
			height: 40rpx;
			padding-left: 10rpx;
			padding-top: 10rpx;
		}

		.selectType {
			margin-top: 20rpx;
			display: flex;
			flex-direction: row;

			.tit {
				padding-right: 20rpx;
				font-size: 28rpx;
				color: #888;
			}

			.val {
				flex: 1;
				font-size: 28rpx;
				color: #333;
			}
		}

		.rmb {
			color: #ff582b;
			font-size: 12px;
		}

		.newPrice {
			position: relative;
			top: 2px;
			font-size: 18px;
			color: #ff582b;
			font-weight: bold;
		}

		.oldPrice {
			margin-left: 3rpx;
			font-size: 10px;
			color: #999999;
			margin-top: 5rpx;
			text-decoration: line-through;
		}

		.btn2 {
			background: linear-gradient(100deg, #FFEB3B, #FFC107);
			height: 60rpx;
			font-size: 28rpx;
			font-weight: bold;
			color: #333;
			display: flex;
			justify-content: center;
			align-items: center;
		}
	}
</style>
