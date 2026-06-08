<template>
	<view>
		<u-navbar title-color="#fff" back-icon-color="#ffffff" :is-fixed="isFixed" :is-back="isBack"
			:background="background" :back-text-style="{color: '#fff'}" :title="htitle" :back-icon-name="backIconName"
			:back-text="backText">

		</u-navbar>

		<form>
			<view class="cu-form-group ">
				<view class="title">建单日期：</view>
				<text style="width: 100%;">{{info.crdate}}</text>

			</view>
			<view class="cu-form-group ">
				<view class="title">收货部门：</view>

				<text style="width: 100%;">{{info.deptname}}</text>
			</view>
			<view class="cu-form-group ">
				<view class="title">仓库：</view>

				<text style="width: 100%;">{{info.storename}}</text>
			</view>
			<view class="cu-form-group ">
				<view class="title">货品类别：</view>
			
				<text style="width: 100%;">{{info.classname}}</text>
			</view>

			<!-- <view class="cu-form-group ">
				<view class="title">供应商：</view>

				<text style="width: 100%;">{{info.proname}}</text>
			</view> -->
			<view class="cu-bar bg-white solid-bottom margin-top">
				<view class="action">
					<text class="cuIcon-title text-orange "></text> 货品列表
				</view>

			</view>

			<view class="flex solid-bottom  justify-start text-bold bg-gray">
				<view class=" padding-sm  solid-right text-center" style="width: 30%;">货品名称</view>
				<view class=" padding-sm  solid-right text-center" style="width: 15%;">数量</view>
				<view class=" padding-sm  solid-right text-center" style="width: 15%;">单位</view>
				<view class=" padding-sm  solid-right text-center" style="width: 15%;">规格</view> 
				<view class=" padding-sm  solid-right text-center" style="width: 25%;">备注</view> 
			</view>
			<view class=" flex solid-bottom justify-start " v-for="(item,index) in items">

				<view class=" padding-sm  solid-right text-center" style="width: 30%;">
					{{item.name}}
				</view>
				<view class=" padding-sm  solid-right text-center bg-white" style="width: 15%;">
					<text>{{item.rfquantity}}</text>
				</view>
				<view class=" padding-sm  solid-right text-center bg-white" style="width: 15%;">
					<text>{{item.unit}}</text>
				</view>
				<view class=" padding-sm  solid-right text-center bg-white" style="width: 15%;">
					<text>{{item.size}}</text>
				</view>
				<view class=" padding-sm  solid-right text-center bg-white" style="width: 25%;">
					<text>{{item.remark}}</text>
				</view>
				<!-- <view class=" padding-sm  solid-right text-center bg-white" style="width: 20%;">
					<text>{{item.unitprice}}</text>
				</view>
				<view class=" padding-sm  solid-right text-center bg-white" style="width: 20%;">
					<text>{{(item.rfquantity*item.unitprice).toFixed(2)}}</text>
				</view> -->

			</view>

			<view class="cu-form-group margin-top">
				<view class="title">备注：</view>
				<text style="width: 100%;">{{info.remark}}</text>
			</view>
			<!-- <view class="padding flex flex-direction margin-top">
				<button v-if="info.status=='下单'" class="cu-btn bg-blue margin-tb-sm lg" @click="submit">签名确认</button>
			</view> -->
		</form>
		<u-popup border-radius="10" v-model="show" :mode="mode" length="50%" :mask="mask" :closeable="closeable"
			:close-icon-pos="closeIconPos">
			<view style="height:20px;"></view>
			<view class="handCenter">
				<canvas class="handWriting" disable-scroll="true" @touchstart="uploadScaleStart"
					@touchmove="uploadScaleMove" @touchend="uploadScaleEnd" @tap="mouseDown" canvas-id="handWriting">
				</canvas>
			</view>
			<view class="buttons" style=" display: flex; flex-direction: row; justify-content: center;">
				<button @click="retDraw" class="delBtn">重写</button>
				<button @click="subCanvas" class="subBtn">提交</button>
			</view>
		</u-popup>
	</view>
</template>

<script>
	import TUtil from '@/common/timeUtil.js'
	import Handwriting from "@/common/signature.js"
	export default {
		data() {
			return {
				//navbar*********************
				htitle: '清单明细',
				backText: '返回',
				backIconName: 'nav-back',
				background: {
					'background-color': '#ffcc00'
				},
				isBack: true,
				isFixed: true,
				//navbar*********************
				show: false,
				mode: 'bottom',
				mask: true, // 是否显示遮罩
				closeable: false,
				closeIconPos: 'top-right',

				info: {

				},
				datas: {},
				items: [],
				lineColor: 'black',
				slideValue: 50,
				begin: false,
				iost_no: '',
				handwriting: ''
			}
		},
		onLoad(op) {
			//this.info.crdate = TUtil.getDate();
			this.iost_no = op.iost_no;
			this.initData();
			this.handwriting = new Handwriting({
				lineColor: this.lineColor,
				slideValue: this.slideValue, // 0, 25, 50, 75, 100
				canvasName: 'handWriting',
			})

		},

		methods: {
			
			async initData() {
				this.$api.loading(true);
				let obj = await this.$api.ajax('/api/store/GetIODetail', {
					iost_no: this.iost_no
				});
				this.info = obj.data.iostore[0];
				this.items = obj.data.iodetail;
				this.$api.loading(false);
			},
			async submit() {
				this.show = true;
			},
			mouseDown(e) {

			},
			uploadScaleStart(event) {

				this.handwriting.uploadScaleStart(event)
			},
			uploadScaleMove(event) {

				this.handwriting.uploadScaleMove(event)
			},
			uploadScaleEnd(event) {
				this.begin = true;
				this.handwriting.uploadScaleEnd(event)
			},
			retDraw() {
				this.begin = false;
				this.handwriting.retDraw()
			},
			async ConfigSign(sign) {
				this.$api.loading(true);
				let obj = await this.$api.ajax('/api/store/ConfigSign', {
					sign: sign,
					id: this.info.id
				});
				this.$api.loading(false);
				if (obj.success) {
					this.$api.msg('提交成功');
					this.$api.prePage().refData();
					setTimeout(() => {
						uni.navigateBack({})

					}, 1000);
				} else
					this.$api.msg(obj.msg);
			},
			subCanvas() {
				if (!this.begin) {
					this.$api.msg('请签名！');
					return false;
				}
				this.handwriting.saveCanvas().then(res => {
					//this.showimg = res;
					this.ConfigSign(res)
				}).catch(err => {
					console.log(err);
				});

			},

		}
	}
</script>

<style scoped="true">
	.cu-form-group .title {
		min-width: calc(4em + 35px);
		text-align: right;
	}

	.handCenter {

		border: 4upx dashed #e9e9e9;
		flex: 5;
		overflow: hidden;
		box-sizing: border-box;
		width: 90%;
		margin: 0 auto;
	}

	.handWriting {

		background: #fff;
		width: 100%;
		height: 450upx;
	}

	.buttons {
		width: 100%;
		margin-top: 20upx;
		justify-content: space-between;
	}

	.buttons>button {
		font-size: 30upx;
		height: 80upx;
		width: 120upx;
	}

	.delBtn {
		color: #666;
	}

	.color {
		align-items: center;
	}

	.color>text {
		margin-right: 20upx;
	}

	.subBtn {
		background: #008ef6;
		color: #fff;
		text-align: center;
		justify-content: center;
	}
</style>
