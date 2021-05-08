
local M = 

{
	ReqTest = 
	{
		tmField = 
		{
			test_str = 
			{
				fieldNumber = 2,
				prefix = 'required',
				type = 'string',
				name = 'test_str'
			},
			test_number = 
			{
				fieldNumber = 1,
				prefix = 'required',
				type = 'uint32',
				name = 'test_number'
			}
		},
		fullName = 'com.bb.proto.ReqTest',
		type = 'message',
		name = 'ReqTest'
	},
	Request = 
	{
		tmField = 
		{
			data = 
			{
				fieldNumber = 3,
				prefix = 'optional',
				type = 'bytes',
				name = 'data'
			},
			apiId = 
			{
				fieldNumber = 1,
				prefix = 'required',
				type = 'int32',
				name = 'apiId'
			},
			clientIndex = 
			{
				fieldNumber = 2,
				prefix = 'required',
				type = 'int32',
				name = 'clientIndex'
			}
		},
		fullName = 'com.bb.proto.Request',
		type = 'message',
		name = 'Request'
	},
	__loadlist__ = {
		'GameMsg.proto','CmdTest.proto','EnumMsg.proto'
	},
	RespTest = 
	{
		tmField = 
		{
			test_str = 
			{
				fieldNumber = 2,
				prefix = 'required',
				type = 'string',
				name = 'test_str'
			},
			test_number = 
			{
				fieldNumber = 1,
				prefix = 'required',
				type = 'uint32',
				name = 'test_number'
			}
		},
		fullName = 'com.bb.proto.RespTest',
		type = 'message',
		name = 'RespTest'
	},
	MessageId = 
	{
		fullName = 'com.bb.proto.MessageId',
		enums = 
		{
			ReqTest = 10001,
			RespTest = 10002
		},
		type = 'enum',
		name = 'MessageId'
	},
	Response = 
	{
		tmField = 
		{
			apiId = 
			{
				fieldNumber = 1,
				prefix = 'required',
				type = 'int32',
				name = 'apiId'
			},
			code = 
			{
				fieldNumber = 3,
				prefix = 'optional',
				type = 'int32',
				name = 'code'
			},
			data = 
			{
				fieldNumber = 2,
				prefix = 'optional',
				type = 'bytes',
				name = 'data'
			}
		},
		fullName = 'com.bb.proto.Response',
		type = 'message',
		name = 'Response'
	}
}
return M
    