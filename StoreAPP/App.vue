<script>
	/**
	 * vuex管理登陆状态，具体可以参考官方登陆模板示例
	 */
	import {
		mapMutations
	} from 'vuex';
	export default {
		methods: {
			...mapMutations(['login'])
		},
		onLaunch: function() {
			//uni.hideTabBar();
			// let that = this;
			// let userInfo = uni.getStorageSync('userInfo');
			// console.log(userInfo);
			// if (userInfo) {
				
			// } 
			// else
			// {
			// 	uni.navigateTo({
			// 		url:'/pages/login/login'
			// 	})
			// }
		},
		onShow: function() {
			console.log('App Show')
		},
		onHide: function() {
			console.log('App Hide')
		},
	}
</script>

<style lang='scss'>
	@import '/static/style/font_1681579_yaiyfblc2xt.css';
	@import "/components/colorui/main.css";
	@import "/components/colorui/icon.css";
    @import "/components/uview-ui/index.scss";
	/* @import "/static/style/thorui.css"; */
	@import "/static/style/app.css";
</style>
