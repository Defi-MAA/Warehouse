import Vue from 'vue'
import store from './store'
import App from './App'

import Json from './Json' //测试用数据

import cuCustom from 'components/colorui/components/cu-custom.vue'
Vue.component('cu-custom', cuCustom)

import uView from 'components/uview-ui';
Vue.use(uView);
/**
 *  因工具函数属于公司资产, 所以直接在Vue实例挂载几个常用的函数
 *  所有测试用数据均存放于根目录json.js
 *  
 *  css部分使用了App.vue下的全局样式和iconfont图标，有需要图标库的可以留言。
 *  示例使用了uni.scss下的变量, 除变量外已尽量移除特有语法,可直接替换为其他预处理器使用
 */
const msg = (title, duration = 1500, mask = false, icon = 'none', position = 'center') => {
	//统一提示方便全局修改
	if (Boolean(title) === false) {
		return;
	}
	uni.showToast({
		title,
		duration,
		mask,
		icon,
		position
	});
}
const json = type => {
	//模拟异步请求数据
	return new Promise(resolve => {
		setTimeout(() => {
			resolve(Json[type]);
		}, 500)
	})
}
const getUrlParam = (name) => {
	let reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
	let r = window.location.search.substr(1).match(reg);
	if (r != null) {
		return unescape(r[2]);
	}
	return null;
}

const formatRichText = (html) => { //控制小程序中图片大小
	let newContent = html.replace(/<img[^>]*>/gi, function(match, capture) {
		match = match.replace(/style="[^"]+"/gi, '').replace(/style='[^']+'/gi, '');
		match = match.replace(/width="[^"]+"/gi, '').replace(/width='[^']+'/gi, '');
		match = match.replace(/height="[^"]+"/gi, '').replace(/height='[^']+'/gi, '');
		return match;
	});
	newContent = newContent.replace(/style="[^"]+"/gi, function(match, capture) {
		match = match.replace(/width:[^;]+;/gi, 'max-width:100%;').replace(/width:[^;]+;/gi,
			'max-width:100%;');
		return match;
	});
	//newContent = newContent.replace(/<br[^>]*\/>/gi, '');
	newContent = newContent.replace(/\<img/gi,
		'<img style="max-width:100%;height:auto;display:inline-block;margin:10rpx auto;"');
	//newContent = newContent.replace('<p>', '<view style="white-space:normal;word-wrap: break-all;word-warp:break-word;width:100%">');
	//newContent = newContent.replace('</p>', '</view>');

	newContent = newContent.replace(/<span[^>]*>/gi, '');
	newContent = newContent.replace(/<\/span>/gi, '');
	//console.log(newContent)
	return newContent;
}
// 判断是否为公众号模拟器环境
const isWechat = () => {
	return String(navigator.userAgent.toLowerCase().match(/MicroMessenger/i)) === "micromessenger";
}

const prePage = () => {
	let pages = getCurrentPages();
	let prePage = pages[pages.length - 2];
	// #ifdef H5
	return prePage;
	// #endif
	return prePage.$vm;
}


const apiurl = 'http://127.0.0.1:3818/';

const myheader = () => {
	var token = uni.getStorageSync('token');
	if (isEmpty(token)) {
		return {
			softtype: 0,
			usertype: 0,
			token: '',
		}
	} else {
		return {
			softtype: 0,
			usertype: 0,
			token: token
		}
	}
}
const checkToken = () => {
	return new Promise(async (resolve) => {
		var token = uni.getStorageSync('token');
		if (isEmpty(token)) {
			uni.navigateTo({
				url: '/pages/my/login'
			})
			resolve(false);
			return;
		}
		let obj = await ajax('/api/store/checkToken', {});
		if (!obj.success) {
			uni.navigateTo({
				url: '/pages/my/login'
			})
			resolve(false);
		}
		resolve(obj.success);
	})
}
const navto = async (url) => {
	console.log(url);
	let obj = await ajax('/api/member/CheckOpenID', {});
	console.log(obj.data.isauthor)
	if (!obj.data.isauthor) {
		uni.navigateTo({
			url: '/pages/my/login'
		})
	} else {
		uni.navigateTo({
			url: url
		})
	}
}

const redto = async (url) => {
	let obj = await ajax('/api/member/CheckOpenID', {});
	if (!obj.data.isauthor) {
		uni.navigateTo({
			url: '/pages/my/login'
		})

	} else {
		uni.navigateTo({
			url: url
		})

	}
}


const loading = (statu, title = '加载中') => {
	// Loading
	if (Boolean(statu) === false) {
		uni.hideLoading();
	} else {
		uni.showLoading({
			title
		});
	}
}



const mypost = (options) => {
	let method = options.method || 'POST';
	let success = options.success || function() {};
	let fail = options.fail || function() {};
	let data = options.data || {};

	uni.request({
		url: uni.getStorageSync('apiurl') + options.url,
		method: method,
		data: data,
		header: myheader(),
		success: (result) => {
			console.log(result);
			success(result.data);
		},
		fail: (err) => {
			fail(err);
		}
	})

}
const isPoneAvailable = (str) => {
	var myreg = /^[1][3,4,5,7,8][0-9]{9}$/;
	if (!myreg.test(str)) {
		return false;
	} else {
		return true;
	}
}



const ajax = (myurl, data, method = 'POST') => {
	return new Promise((resolve, reject) => {
		myurl = uni.getStorageSync('apiurl') + myurl;
		// console.log(myurl)
		uni.request({
			url: myurl,
			method: method,
			data: data,
			header: myheader(),
			success: (result) => {
				//console.log(result);
				resolve(result.data);
			},
			fail: (err) => {
				console.log(err)
				msg('网络异常');
				resolve(err);
			}
		})
	})
}

const ajax2 = (myurl, data, method = 'POST') => {
	return new Promise((resolve, reject) => {
	
		uni.request({
			url: myurl,
			method: method,
			data: data,
			header: myheader(),
			success: (result) => {
				//console.log(result);
				resolve(result.data);
			},
			fail: (err) => {
				resolve(err);
			}
		})
	})
}

const myget = (myurl, data) => {
	return new Promise((resolve, reject) => {
		myurl = qklurl + myurl;
		uni.request({
			url: myurl,
			method: 'GET',
			success: (result) => {
				//console.log(result);
				resolve(result.data);
			},
			fail: (err) => {
				resolve(err);
			}
		})

	});
}

const isEmpty = (value) => {
	return (
		value === undefined ||
		value === null ||
		(typeof value === "object" && Object.keys(value).length === 0) ||
		(typeof value === "string" && value.trim().length === 0)
	);
}

Vue.config.productionTip = false
Vue.prototype.$fire = new Vue();
Vue.prototype.$store = store;
Vue.prototype.$api = {
	msg,
	json,
	prePage,
	mypost,
	ajax,
	ajax2,
	myget,
	apiurl,
	isPoneAvailable,
	formatRichText,
	checkToken,
	navto,
	redto,
	loading,
	isEmpty
};

App.mpType = 'app'

const app = new Vue({
	...App
})

app.$mount()
