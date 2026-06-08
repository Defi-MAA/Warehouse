<template>
	<view class="login">
		<!--顶部返回按钮-->
		<text class="back-btn iconfont iconzuo" @tap="navBack"></text>
		<view class="login-top bg-active">
			<view class="desc">
				<view class="title">Hi~</view>
				<text>{{ appName }}欢迎您</text>
			</view>
			<image class="login-pic" src="/static/login-pic.png"></image>
		</view>
		<view class="login-type-content">
			<image class="login-bg" src="/static/login-bg.png"
				:style="{height: tabCurrentIndex === 1 ? '40vw' : '72vw'}"></image>
			<view class="main">
				<!-- <view style="margin: 10px;padding-top: 40px;" class="cu-form-group margin-top flex   justify-start">

					<checkbox :class="checked?'checked':''" :checked="checked?true:false" @click="setCheck"></checkbox>
					<text style="margin-left: 5px;font-size: 25rpx;">我已阅读并同意</text>
					<text class="text-blue" @click.stop="navto()" style="font-size: 25rpx;">《用户服务协议》《隐私政策》</text>

				</view> -->
				<view class="login-type-form">
					<view class="input-item">
						<text class="iconfont ">用名:</text>
						<input class="login-type-input" type="text" v-model="form.username" placeholder="请输入用户ID或者手机号"
							maxlength="11" />
					</view>
					<view class="input-item">
						<text class="iconfont ">密码:</text>
						<input class="login-type-input" type="password" v-model="form.password" placeholder="请输入密码"
							maxlength="11" />
					</view>
				</view>

				<button class="confirm-btn bg-active" :disabled="btnLoading" :loading="btnLoading" @click="getUserinfo">
					<!-- 	<u-icon size="40" name="weixin-fill" color="#fff"></u-icon> -->登录
				</button>
				<view class="login-type-bottom text-active margin-top" @click="navto1()">
					配置服务地址
				</view>
			</view>
		</view>

		<u-verification-code seconds="60" ref="uCode" @change="codeChange"></u-verification-code>

	</view>
</template>

<script>
	export default {
		data() {
			return {

				btnLoading: false,
				reqBody: {},
				codeSeconds: 0, // 验证码发送时间间隔
				loginByPass: true,
				smsCodeBtnDisabled: true,
				userInfo: null,
				appName: '',
				tabCurrentIndex: 0,
				tmpllist: [],
				mobile: '',
				code: '',
				codeTips: '',
				password: '',

				checked: true,
				form: {
					username: '',
					password: ''
				}

			};
		},
		onLoad(options) {
			this.tabCurrentIndex = parseInt(options.type || 0, 10);

		},
		methods: {
			setCheck() {
				this.checked = !this.checked;
			},
			codeChange(text) {
				this.codeTips = text;
			},
			// 返回上一页
			navBack() {
				//uni.navigateBack();
				uni.switchTab({
					url: '/pages/index/home'
				})
			},
			navto1() {

				uni.navigateTo({
					url: '/pages/my/set'
				})

			},
			navto() {

				uni.navigateTo({
					url: '/pages/my/contract'
				})

			},

			// 提交表单
			getUserinfo() {
				let that = this;
				if (this.form.username.length == 0) {
					this.$api.msg("请输入用户ID!");
					return;
				}

				if (this.form.password.length == 0) {
					this.$api.msg("请输入密码!");
					return;
				}
				this.login();
			},
			async login() {

				// let obj = await this.$api.ajax2('http://api.yhpms.net/api/admin/StoreAuthor', this.form);
				// if (!obj.success) {
				// 	this.$api.msg("未授权无法使用，请联系软件提供商！", 3000);
				// 	return;
				// }
				let obj = await this.$api.ajax('/api/store/login', this.form);
				if (obj.success) {
					uni.setStorageSync('token', obj.data.token);
					uni.setStorageSync('userInfo', obj.data);
					//uni.navigateBack({});
					uni.reLaunch({
						url: '/pages/index/home'
					})
				} else
					this.$api.msg(obj.msg, 3000);
			},


		}
	};
</script>
<style lang="scss">
	page {
		background: #fff;
	}

	.login {
		width: 100%;
		position: relative;

		.bg-active {
			background-color: $base-color;
			color: #fff;
		}

		.text-active,
		.iconfont {
			color: $base-color;

		}

		.back-btn {
			position: absolute;
			left: 40rpx;
			z-index: 9999;
			padding-top: var(--status-bar-height);
			top: 40rpx;
			font-size: 48rpx;
			color: #fff;
		}

		.login-top {
			height: 460rpx;
			position: relative;

			.desc {
				color: #fff;
				position: absolute;
				top: 200rpx;
				left: 40rpx;
				font-size: 48rpx;

				.title {
					font-size: 48rpx;
				}
			}

			.login-pic {
				position: absolute;
				width: 220rpx;
				height: 270rpx;
				right: 30rpx;
				top: 100rpx;
			}
		}

		.login-type-content {
			position: relative;
			top: -72rpx;

			.login-bg {
				width: 94vw;
				height: 74vw;
				margin: 0 3vw;
			}

			.main {
				width: 94vw;
				position: absolute;
				top: 0;
				left: 3vw;

				.nav-bar {
					display: flex;
					height: 100rpx;
					justify-content: center;
					align-items: center;
					position: relative;
					z-index: 10;

					.nav-bar-item {
						flex: 1;
						display: flex;
						height: 100%;
						line-height: 96rpx;
						font-size: 32rpx;
						display: flex;
						margin: 0 120rpx;
						justify-content: center;
					}

					.nav-bar-item-active {
						border-bottom: 5rpx solid;
					}
				}

				.login-type-form {
					width: 80%;
					margin: 50rpx auto;

					.input-item {
						position: relative;
						height: 90rpx;
						line-height: 90rpx;
						margin-bottom: 30rpx;

						.iconfont {
							font-size: 35rpx;
							position: absolute;
							left: 0;
						}

						.login-type-input {
							height: 90rpx;
							padding-left: 120rpx;
							border-bottom: 1rpx solid rgba(0, 0, 0, .1);
						}

						.sms-code-btn,
						sms-code-resend {
							width: 240rpx;
							font-size: 26rpx;
						}
					}
				}

				.login-type-tips {
					padding: 0 50rpx;
					display: flex;
					justify-content: space-between;
					font-size: 28upx;
					color: #666;
				}

				.confirm-btn {
					margin-top: 60upx;
					width: 80%;
					height: 80rpx;
					line-height: 80rpx;
				}
			}
		}

		.login-type-bottom {
			width: 100%;
			padding-bottom: 30rpx;
			text-align: center;
			font-size: 32rpx;
		}

		// 发送验证码样式
		.input-item-sms-code {
			.input-wrapper {
				display: flex;
				justify-content: space-between;
				align-items: center;
			}

			.sms-code-btn {
				width: 200upx;
				background-color: #fff;
				display: flex;
				padding: 15upx 0;
				justify-content: center;
				align-items: center;
				border-radius: 12upx;
			}

			.sms-code-resend {
				color: #666;
			}
		}
	}

	.cu-form-group .title {

		min-width: calc(4em + 15px);
	}
</style>
