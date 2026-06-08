//商家信息
const storeData = {
		//商家唯一标识
		storeId: '168',
		//商家名称
		storeName: '小太阳商店',
		//头像
		avatar: '/static/face/face_2.jpg',
		//横幅图片
		banner: '/static/goods/banner.jpg',
		//商家住址
		address: '新疆阿克苏是他北路2号',
		//配送时间
		deliveryTime: '11:00~20:30',
		//联系电话
		telephone: '18299989916',
		//商家购物车
		shoppingCart: [],
		//配送费
		shippingDees: 0,
		//配送起步价
		startingPrice:30
	};

//评论数据
const commentData = [{
		header_img: "/static/face/face_4.jpg",
		user_name: "测试1",
		rate:5,
		create_time: "2019.04.12",
		content: "好评",
		imgs:[
			'/static/goods/1.jpg',
			'/static/goods/3.jpg',
			'/static/goods/4.jpg',
			'/static/goods/5.jpg'
		]
	},
	{
		content: "中评",
		create_time: "2019.04.12",
		header_img: "/static/face/face_5.jpg",
		user_name: "测试2",
		rate:4,
		// imgs:[]
	},
	{
		content: "",
		create_time: "2019.04.12",
		header_img: "/static/face/face_6.jpg",
		user_name: "测试3",
		rate:2,
		// imgs:[]
	},{
		content: "好评",
		create_time: "2019.04.12",
		header_img: "/static/face/face_7.jpg",
		user_name: "小蚂蚁",
		rate:5,
		imgs:[
			'/static/goods/7.jpg',
			'/static/goods/8.jpg',
			'/static/goods/9.jpg',
			'/static/goods/10.jpg'
		]
	},
	{
		content: "中评",
		create_time: "2019.04.12",
		header_img: "/static/face/face_8.jpg",
		user_name: "沙漠骆驼",
		rate:3.5,
		// imgs:[]
	},
	{
		content: "",
		create_time: "2019.04.12",
		header_img: "/static/face/face_9.jpg",
		user_name: "莫思",
		rate:2.3,
		// imgs:[]
	}];

//商品数据
const goodsData= [{   
		id: 1,
		type_id:1,
		name:'白果王水果沙拉',
		descripe:"脆糯营养，口感好，健康绿色",
		img:'/static/goods/9.jpg',
		price:"9",
		oldprice:"100"
	},
	{   
		id: 2,
		type_id:2,
		name:'精品烤山药',
		descripe:"脆糯营养，口感好，健康绿色",
		img: '/static/goods/10.jpg',
		price:"8",
		oldprice:"100"
	},
	{   
		id: 3,
		type_id:2,
		name:'川味毛血旺',
		descripe:"脆糯营养，口感好，健康绿色",
		img: '/static/goods/11.jpg',
		price:"4",
		oldprice:""
	},
	{   
		id: 4,
		type_id:3,
		name:'吐鲁番烤全羊',
		descripe:"脆糯营养，口感好，健康绿色",
		img: '/static/goods/4.jpg',
		price:"4",
		oldprice:""
	},
	{   
		id: 5,
		type_id:3,
		name:'红烧肉',
		descripe:"脆糯营养，口感好，健康绿色",
		img: '/static/goods/5.jpg',
		price:"4",
		oldprice:""
	},
	{   
		id: 6,
		type_id:4,
		name:'新疆特色辣子鸡',
		descripe:"脆糯营养，口感好，健康绿色",
		img: '/static/goods/6.jpg',
		price:"4",
		oldprice:""
	},
	{   
		id: 7,
		type_id:5,
		name:'绝味海鲜拼盘',
		descripe:"脆糯营养，口感好，健康绿色",
		img: '/static/goods/7.jpg',
		price:"4",
		oldprice:""
	},
	{   
		id: 8,
		type_id:5,
		name:'金色香糯大粽子',
		descripe:"脆糯营养，口感好，健康绿色",
		img: '/static/goods/3.jpg',
		price:"4",
		oldprice:""
	},
	{   
		id: 9,
		type_id:5,
		name:'马梓林香香鸡',
		descripe:"脆糯营养，口感好，健康绿色",
		img: '/static/goods/2.jpg',
		price:"4",
		oldprice:""
	},
	{   
		id: 10,
		type_id:6,
		name:'草莓味莫普氏蛋糕',
		descripe:"脆糯营养，口感好，健康绿色",
		img: '/static/goods/1.jpg',
		price:"4",
		oldprice:""
	}];
	
//商品种类数据
const categoryData = [
		{id: 1,name: '烧烤'},
		{id: 2,name: '生鲜'},
		{id: 3,name: '绿蔬'},
		{id: 4,name: '肉类'},
		{id: 5,name: '川味'},
		{id: 6,name: '粤菜'},
		{id: 7,name: '湘菜'},
		{id: 8,name: '西餐'},
		{id: 9,name: '饮料'},
		{id: 10,name: '糕点'},
		{id: 11,name: '凉菜'},
		{id: 12,name: '火锅'},
		{id: 13,name: '干锅'}
	];

//商品详细
const goodsInfo = {
	//商品id
	id: 1,
	//商品类id
	type_id:1,
	//商品名称
	name:'新疆特色辣子鸡排饭',
	//商品描述-就是掌柜描述，
	descripe:"口味可以自己选，有香辣、蒜香、葱香、孜然、老麻口味",
	//主图
	img:'/static/face/face_5.jpg',
	//滚动图片
	banner_img:['/static/goods/4.jpg','/static/goods/5.jpg','/static/goods/6.jpg'],
	//现价
	price:"23",
	//原价
	oldprice:"44",
	//月销售
	monthly_sales: "566",
	//商品标签
	goods_tag:['约800克','香辣','特色菜','营养美食'],
	//详情
	detail:[
		{
			tit:'掌柜描述',
			txt:'口味可以自己选，有香辣、蒜香、葱香、孜然、老麻口味',
		},{
			tit:'主料',
			txt:'鸡胸排，大葱',
		},{
			tit:'菜系',
			txt:'新疆特色菜',
		},{
			tit:'口味',
			txt:'香辣',
		}
		//......更多
	],
	//图文
	desc: `
		<div style="width:100%">
			<img style="width:100%;display:block;" src="/static/goods/5.jpg" />
			<img style="width:100%;display:block;" src="/static/goods/6.jpg" />
			<img style="width:100%;display:block;" src="/static/goods/7.jpg" />
			<img style="width:100%;display:block;" src="/static/goods/8.jpg" />
			<img style="width:100%;display:block;" src="/static/goods/9.jpg" />
		</div>
	`,
};

//商品评价
const goodsEva = {
	//总评价数
	sum: '386',
	//好评
	praise: '306',
	//差评
	bad_review: '80',
	//评价标签
	eva_tag: {
		//有图
		'exist_pic': '62',
		//赞
		'appreciate': '96',
		//踩
		'oppose': '16',
		//其他标签
		'other': ['92%人口味满意','300人希望再次购买']
	},
	eva_list: [
		{
			//用户名
			name: '白色的太阳',
			//头像
			avatar: '/static/face/face_4.jpg',
			//评论时间
			time: '2020.03.12',
			//点赞或踩商品,没有投票【0】、赞【1】、踩【2】
			point: 1,
			//评价内容
			content: "味道好极了，家里人超爱吃，希望下次能多放点辣椒，我们家吃辣",
			//上传的图片
			pic: ['/static/goods/7.jpg','/static/goods/8.jpg','/static/goods/9.jpg']
		},
		{
			//用户名
			name: '匿名用户',
			//头像
			avatar: '/static/face/face_2.jpg',
			//评论时间
			time: '2020.03.16',
			//点赞或踩商品,没有投票【0】、赞【1】、踩【2】
			point: 2,
			//评价内容
			content: "",
			//上传的图片
			pic: []
		},
		{
			//用户名
			name: '匿名用户',
			//头像
			avatar: '/static/face/face_3.jpg',
			//评论时间
			time: '2020.03.16',
			//点赞或踩商品,没有投票【0】、赞【1】、踩【2】
			point: 0,
			//评价内容
			content: "一般般",
			//上传的图片
			pic: []
		},
	]
}
	
export default {
	storeData,
	commentData,
	goodsData,
	categoryData,
	goodsInfo,
	goodsEva
}
	