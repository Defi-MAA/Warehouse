//格式化时间戳
const fmtDate = (fmt, date) => {
	let o = {
		"M+": date.getMonth() + 1, //月份   
		"d+": date.getDate(), //日   
		"h+": date.getHours(), //小时   
		"m+": date.getMinutes(), //分   
		"s+": date.getSeconds(), //秒   
		"q+": Math.floor((date.getMonth() + 3) / 3), //季度   
		"S": date.getMilliseconds() //毫秒   
	};
	if (/(y+)/.test(fmt))
		fmt = fmt.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
	for (let k in o)
		if (new RegExp("(" + k + ")").test(fmt))
			fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
	return fmt;
}

//当前日期加减天数
const mathChangeDate = (date, method, days) => {
	//method:'+' || '-'
	//ios不解析带'-'的日期格式，要转成'/'，不然Nan，切记
	let dateVal = date.replace(/-/g, '/');
	let timestamp = Date.parse(dateVal);
	if (method == '+') {
		timestamp = timestamp / 1000 + 24 * 60 * 60 * days;
	} else if (method == '-') {
		timestamp = timestamp / 1000 - 24 * 60 * 60 * days;
	}
	return fmtDate("yyyy-MM-dd hh:mm:ss", new Date(parseInt(timestamp) * 1000));
}

//时间戳转换具体时间
const getDateDiff = (dateTimeStamp) => {
	let result = '';
	let minute = 1000 * 60;
	let hour = minute * 60;
	let day = hour * 24;
	let halfamonth = day * 15;
	let month = day * 30;
	let now = new Date(); //有些特殊 不能使用 new Date()
	let diffValue = now - dateTimeStamp;
	if (diffValue < 0) {
		return;
	}
	let monthC = diffValue / month;
	let weekC = diffValue / (7 * day);
	let dayC = diffValue / day;
	let hourC = diffValue / hour;
	let minC = diffValue / minute;
	if (monthC >= 1) {
		result = "" + parseInt(monthC) + "月前";
	} else if (weekC >= 1) {
		result = "" + parseInt(weekC) + "周前";
	} else if (dayC >= 1) {
		result = "" + parseInt(dayC) + "天前";
	} else if (hourC >= 1) {
		result = "" + parseInt(hourC) + "小时前";
	} else if (minC >= 1) {
		result = "" + parseInt(minC) + "分钟前";
	} else
		result = "刚刚";
	return result;
};

//比较两个时间大小(格式参考yyyy-mm-dd hh:mm:ss)
const compareTime = (startTime, endTime) => {
	//结束时间大于开始时间就是true  ， 反之则为 false
	if (startTime.localeCompare(endTime) == -1) {
		return true;
	}

	return false;
}

const getDate = (type) => {
	const date = new Date();

	let year = date.getFullYear();
	let month = date.getMonth() + 1;
	let day = date.getDate();

	if (type === 'start') {
		year = year - 60;
	} else if (type === 'end') {
		year = year + 10;
	}
	month = month > 9 ? month : '0' + month;;
	day = day > 9 ? day : '0' + day;

	return `${year}-${month}-${day}`;
}

const dateTimeNow = (formatStr, t) => {
	let year = String(new Date().getFullYear());
	let month = String((new Date().getMonth() + 1) <= 9 ? "0" + (new Date().getMonth() + 1) : (new Date().getMonth() + 1));
	let day = String(new Date().getDate() <= 9 ? "0" + new Date().getDate() : new Date().getDate());
	let hour = String(new Date().getHours());
	let minute = String(new Date().getMinutes() <= 9 ? "0" + new Date().getMinutes() : new Date().getMinutes());
	let second = String(new Date().getSeconds() <= 9 ? "0" + new Date().getSeconds() : new Date().getSeconds());
	
	if (formatStr === "yyyy-MM-dd HH:mm") {
		if (t == 2) {return [year,month,day,hour,minute];}
		return `${year}-${month}-${day} ${hour}:${minute}`;
	}
	if (formatStr === "yyyy-MM-dd HH") {
		if (t == 2) {return [year,month,day,hour];}
		return `${year}-${month}-${day} ${hour}`;
	}
	if (formatStr === "yyyy-MM-dd") {
		if (t == 2) {return [year,month,day];}
		return `${year}-${month}-${day}`;
	}
	if (formatStr === "yyyy-MM") {
		if (t == 2) {return [year,month];}
		return `${year}-${month}`;
	}
	if (formatStr === "HH:mm:ss") {
		if (t == 2) {return [hour,minute,second];}
		return `${hour}:${minute}:${second}`;
	}
	if (formatStr === "HH:mm") {
		if (t == 2) {return [hour,minute];}
		return `${hour}:${minute}`;
	}
	if (t == 2) {return [year,month,day,hour,minute,second];}
	return `${year}-${month}-${day} ${hour}:${minute}:${second}`;
}

module.exports = {
	fmtDate: fmtDate,
	getDateDiff: getDateDiff,
	mathChangeDate: mathChangeDate,
	compareTime: compareTime,
	getDate: getDate,
	dateTimeNow: dateTimeNow
}
