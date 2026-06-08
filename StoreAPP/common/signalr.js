const protocal = {
	protocol: "json",
	version: 1
};

const MessageType = {
	/** Indicates the message is an Invocation message and implements the {@link InvocationMessage} interface. */
	Invocation: 1,
	/** Indicates the message is a StreamItem message and implements the {@link StreamItemMessage} interface. */
	StreamItem: 2,
	/** Indicates the message is a Completion message and implements the {@link CompletionMessage} interface. */
	Completion: 3,
	/** Indicates the message is a Stream Invocation message and implements the {@link StreamInvocationMessage} interface. */
	StreamInvocation: 4,
	/** Indicates the message is a Cancel Invocation message and implements the {@link CancelInvocationMessage} interface. */
	CancelInvocation: 5,
	/** Indicates the message is a Ping message and implements the {@link PingMessage} interface. */
	Ping: 6,
	/** Indicates the message is a Close message and implements the {@link CloseMessage} interface. */
	Close: 7,
}


export class HubConnection {

	constructor() {
		this.openStatus = false;
		this.methods = {};
		this.negotiateResponse = {};
		this.connection = {};
		this.url = "";
		this.invocationId = 0;
		this.callbacks = {};
		this.hub = 'serverhub';
	}

	negotiate(url) {
		let timestamp = (new Date()).valueOf();
		let negotiateUrl = url + "/negotiate?clientProtocol=2.1&connectionData=%5B%7B%22name%22%3A%22" + this.hub +
			"%22%7D%5D&_=" + timestamp;
		console.log(negotiateUrl)
		uni.request({
			url: negotiateUrl,
			method: "get",
			async: false,
			success: res => {
				console.log(res.data);
				this.negotiateResponse = res.data;
				// this.startSocket(negotiateUrl.replace("/negotiate", ""));
				this.start(url, negotiateUrl.replace("/negotiate", ""));
			},
			fail: res => {
				console.error(`requrst ${url} error : ${res}`);
				return;
			}
		});

	}

	start(url, url2) {//&nickName=asdsa&avatar=232323
		let timestamp = (new Date()).valueOf();
		let token = this.negotiateResponse.ConnectionToken;
		token = token.replace(' ', '+');
		console.log(token);
		let negotiateUrl = url + "/start?transport=webSockets&clientProtocol=2.1&connectionToken=" + encodeURIComponent(
			token) + "&connectionData=%5B%7B%22name%22%3A%22"+ this.hub +"%22%7D%5D&_=" + timestamp;

		console.log(negotiateUrl)
		uni.request({
			url: negotiateUrl,
			method: "get",
			async: false,
			success: res => {
				console.log(res.data);
				this.startSocket(url2);
			},
			fail: res => {
				console.error(`requrst ${url} error : ${res}`);
				return;
			}
		});

	}

	startSocket(url) {
		let token = this.negotiateResponse.ConnectionToken;
		token = token.replace(' ', '+');
		console.log(token);
		let tid = Math.floor(Math.random() * 11);
		url += (url.indexOf("?") < 0 ? "?" : "&") + ('connectionToken=' + encodeURIComponent(token) +
			'&transport=webSockets&clientProtocol=2.1&tid=' + tid);
		url = url.replace(/^http/, "ws");
		this.url = url;
		if (this.connection != null && this.openStatus) {
			return;
		}


		this.connection = uni.connectSocket({
			url: url,
			method: "get",
			success: res => {

			}
		})

		this.connection.onOpen(res => {
			console.log(`websocket connectioned to ${this.url}`);
			this.sendData(protocal);
			this.openStatus = true;
			this.onOpen(res);
		});

		this.connection.onClose(res => {
			console.log(`websocket disconnection`);
			this.connection = null;
			this.openStatus = false;
			this.onClose(res);
		});

		this.connection.onError(res => {
			console.error(`websocket error msg: ${msg}`);
			this.close({
				reason: msg
			});
			this.onError(res);
		});

		this.connection.onMessage(res => this.receive(res));
	}


	on(method, fun) {
		if (this.methods[method]) {
			this.methods[method].push(fun);
			console.log("方法" + method + "进入");
		} else {
			console.log("方法" + method + "进入");
			this.methods[method] = [fun];
		}
	}

	onOpen(data) {}

	onClose(msg) {

	}

	onError(msg) {

	}


	close(data) {
		if (data) {
			this.connection.close(data);
		} else {
			this.connection.close();
		}

		this.openStatus = false;
	}

	sendData(data, success, fail, complete) {
		console.log(data, "数据调用");
		this.connection.send({
			data: JSON.stringify(data), //
			success: success,
			fail: fail,
			complete: complete
		});
		console.log(this.connection, 'test');
	}


	receive(data) {
		// if(data.data.length>3){
		//   data.data = data.data.replace('{}', "")
		// }
		// console.log(data,"数据接收");
		let message = JSON.parse(data.data);
		let messageDetail = message.M;
		//console.log(messageDetail,"收到的数据");
		message = JSON.parse(data.data.replace(new RegExp("", "gm"), ""));
		//console.warn(typeof (messageDetail),"typeof (messageDetail)");
		if (typeof(messageDetail) != 'undefined' && typeof(messageDetail[0]) != 'undefined') {
			let invokemessage = messageDetail[0];
			this.invokeClientMethod(message);
		}
		//留用数据类型
		// switch (message.type) {
		//   case MessageType.Invocation:
		//     this.invokeClientMethod(message);
		//     break;
		//   case MessageType.StreamItem:
		//     break;
		//   case MessageType.Completion:
		//     let callback = this.callbacks[message.invocationId];
		//     if (callback != null) {
		//       delete this.callbacks[message.invocationId];
		//       callback(message);
		//     }
		//     break;
		//   case MessageType.Ping:
		//     // Don't care about pings
		//     break;
		//   case MessageType.Close:
		//     console.log("Close message received from server.");
		//     this.close({
		//       reason: "Server returned an error on close"
		//     });
		//     break;
		//   default:
		//     this.invokeClientMethod(message);
		//     //console.warn("Invalid message type: " + message.type);
		// }


	}


	send(functionName) {

		let args = [];
		for (let _i = 1; _i < arguments.length; _i++) {
			args[_i - 1] = arguments[_i];
		}

		this.sendData({
			M: functionName,
			A: args,
			H: this.hub,
			type: MessageType.Invocation,
			I: this.invocationId
		});
		this.invocationId++;
	}


	invoke(functionName) {
		let args = [];
		for (let _i = 1; _i < arguments.length; _i++) {
			args[_i - 1] = arguments[_i];
		}

		let _this = this;
		let id = this.invocationId;
		let p = new Promise(function(resolve, reject) {

			_this.callbacks[id] = function(message) {
				if (message.error) {
					reject(new Error(message.error));
				} else {
					resolve(message.result);
				}
			}

			_this.sendData({
				M: functionName,
				A: args,
				H: this.hub,
				type: MessageType.Invocation,
				I: _this.invocationId
			}, null, function(e) {
				reject(e);
			});

		});
		this.invocationId++;
		return p;

	}

	invokeClientMethod(message) {
		// console.log(message);
		//得到启用的方法
		let methods = this.methods[message.M[0].M.toString()];
		console.log(methods);
		//console.log(this.methods,"methods方法");
		//console.log(message.M[0].M.toLowerCase(),"methods数据");
		if (methods) {
			methods.forEach(m => m.apply(this, message.M[0].A));
			if (message.invocationId) {
				// This is not supported in v1. So we return an error to avoid blocking the server waiting for the response.
				let errormsg = "Server requested a response, which is not supported in this version of the client.";
				console.error(errormsg);
				this.close({
					reason: errormsg
				});
			}
		} else {
			console.warn(`No client method with the name '${message.target}' found.`);
		}
	}
}
