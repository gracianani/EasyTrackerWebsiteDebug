{
    "employees" : [
		{
			"id":"1",
			"name":"随先生", 
			"status":1, 
			"store":["1","3"], 
			"check":1, 
			"photo":1, 
			"msg":0, 
			"complete":0,
			"show":1
		},
		{"id":"2", "name":"赵雅琪", "status":0, "store":["2","4"], "check":1, "photo":1, "msg":0, "complete":0,"show":1},
		{"id":"3", "name":"余虹", "status":0, "store":[], "check":0, "photo":1, "msg":0, "complete":0,"show":1}
	],
	"stores" : [
		{
			"id":"1", 
			"name":"官员花鸟鱼虫", 
			"status":1, 
			"manager":[{"id":"1","name":"随先生"},{"id":"2","name":"赵雅琪"}], 
			"check":1, 
			"photo":1, 
			"msg":0, 
			"lvl":"A类",
			"lvlId":"1",
			"chn":"7－11",
			"chnId":"1",
			"show":1
		},
		{"id":"2", "name":"西直门华联", "status":0, "manager":[{"id":"1","name":"随先生"},{"id":"2","name":"赵雅琪"}], "check":1, "photo":1, "msg":1,"lvl":"B类", "lvlId":"2","chn":"快客","chnId":"2","show":1},
		{"id":"3", "name":"物美大卖场", "status":0, "manager":[{"id":"1","name":"随先生"},{"id":"2","name":"赵雅琪"}], "check":0, "photo":1, "msg":0,"lvl":"C类", "lvlId":"3","chn":"物美","chnId":"3","show":1}
	]
}