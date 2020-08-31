
local M = 

{
	DtoUser = 
	{
		tmField = 
		{
			username = 
			{
				fieldNumber = 3,
				prefix = 'optional',
				type = 'string',
				name = 'username'
			},
			sociatyId = 
			{
				fieldNumber = 8,
				prefix = 'optional',
				type = 'string',
				name = 'sociatyId'
			},
			teamLevel = 
			{
				fieldNumber = 6,
				prefix = 'optional',
				type = 'int32',
				name = 'teamLevel'
			},
			userId = 
			{
				fieldNumber = 2,
				prefix = 'optional',
				type = 'string',
				name = 'userId'
			},
			teamExp = 
			{
				fieldNumber = 13,
				prefix = 'optional',
				type = 'int32',
				name = 'teamExp'
			},
			avatar = 
			{
				fieldNumber = 5,
				prefix = 'optional',
				type = 'int32',
				name = 'avatar'
			},
			vipLevel = 
			{
				fieldNumber = 7,
				prefix = 'optional',
				type = 'int32',
				name = 'vipLevel'
			},
			nickname = 
			{
				fieldNumber = 4,
				prefix = 'optional',
				type = 'string',
				name = 'nickname'
			}
		},
		fullName = 'com.kw.wow.proto.DtoUser',
		type = 'message',
		name = 'DtoUser'
	},
	UserAuthReq = 
	{
		tmField = 
		{
			session = 
			{
				fieldNumber = 1,
				prefix = 'required',
				type = 'string',
				name = 'session'
			}
		},
		fullName = 'com.kw.wow.proto.UserAuthReq',
		type = 'message',
		name = 'UserAuthReq'
	},
	UserQuickLoginRsp = 
	{
		tmField = 
		{
			session = 
			{
				fieldNumber = 1,
				prefix = 'optional',
				type = 'string',
				name = 'session'
			}
		},
		fullName = 'com.kw.wow.proto.UserQuickLoginRsp',
		type = 'message',
		name = 'UserQuickLoginRsp'
	},
	UserLoginReq = 
	{
		tmField = 
		{
			centerUserId = 
			{
				fieldNumber = 1,
				prefix = 'required',
				type = 'string',
				name = 'centerUserId'
			},
			zone = 
			{
				fieldNumber = 6,
				prefix = 'optional',
				type = 'string',
				name = 'zone'
			},
			deviceType = 
			{
				fieldNumber = 4,
				prefix = 'required',
				type = 'string',
				name = 'deviceType'
			},
			deviceId = 
			{
				fieldNumber = 3,
				prefix = 'required',
				type = 'string',
				name = 'deviceId'
			},
			centerSession = 
			{
				fieldNumber = 2,
				prefix = 'required',
				type = 'string',
				name = 'centerSession'
			},
			channel = 
			{
				fieldNumber = 5,
				prefix = 'optional',
				type = 'string',
				name = 'channel'
			}
		},
		fullName = 'com.kw.wow.proto.UserLoginReq',
		type = 'message',
		name = 'UserLoginReq'
	},
	AppendItem = 
	{
		tmField = 
		{
			data = 
			{
				fieldNumber = 2,
				prefix = 'required',
				type = 'bytes',
				name = 'data'
			},
			id = 
			{
				fieldNumber = 1,
				prefix = 'required',
				type = 'int32',
				name = 'id'
			}
		},
		fullName = 'com.kw.wow.proto.AppendItem',
		type = 'message',
		name = 'AppendItem'
	},
	ApiId = 
	{
		fullName = 'com.kw.wow.proto.ApiId',
		enums = 
		{
			UserAuthRsp = 10002,
			UserLoginRsp = 10001,
			UserQuickLoginRsp = 10003
		},
		type = 'enum',
		name = 'ApiId'
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
			},
			appendData = 
			{
				fieldNumber = 4,
				prefix = 'optional',
				type = 'bytes',
				name = 'appendData'
			}
		},
		fullName = 'com.kw.wow.proto.Request',
		type = 'message',
		name = 'Request'
	},
	UserQuickLoginReq = 
	{
		tmField = 
		{

		},
		fullName = 'com.kw.wow.proto.UserQuickLoginReq',
		type = 'message',
		name = 'UserQuickLoginReq'
	},
	ErrorCode = 
	{
		fullName = 'com.kw.wow.proto.ErrorCode',
		enums = 
		{
			INTER_ERROR_UNCATCHED = 100,
			USER_NAME_EXISTS = 1000,
			USERNAME_PROHIBIT = 1002,
			USER_STATUS_BAN = 1010,
			USER_NAME_NOT_VALID = 1004,
			NO_ERROR = 0,
			API_CHECK_SERVER_NOT_OPEN = 111,
			CENTER_USER_INVALID = 1006,
			INTER_ERROR_NO_HANDLER = 102,
			USER_PASSWORD_NOT_VALID = 1005,
			API_CHECK_SERVER_MAINTENANCE = 112,
			API_CHECK_SERVER_IP_BLACK = 113,
			API_CHECK_SERVER_REGISTER_CLOSE = 114,
			INVALID_PARAM = 5,
			USER_NOT_EXISTS = 1003,
			INVALID_TOKEN = 1008,
			USER_NAME_PASSWORD_NOT_MATCH = 1007,
			ERROR_AUTH = 1009,
			INTER_ERROR = 101,
			USER_NICKNAME_EXIST = 1001
		},
		type = 'enum',
		name = 'ErrorCode'
	},
	UserLoginRsp = 
	{
		tmField = 
		{
			firstLogin = 
			{
				fieldNumber = 1,
				prefix = 'optional',
				type = 'bool',
				name = 'firstLogin'
			},
			user = 
			{
				fieldNumber = 2,
				prefix = 'optional',
				type = 'DtoUser',
				name = 'user'
			}
		},
		fullName = 'com.kw.wow.proto.UserLoginRsp',
		type = 'message',
		name = 'UserLoginRsp'
	},
	__loadlist__ = {
		'GameMsg.proto','ApiUserDto.proto','GameError.proto','ApiUser.proto','ApiMsg.proto'
	},
	UserAuthRsp = 
	{
		tmField = 
		{
			staticVersion = 
			{
				fieldNumber = 2,
				prefix = 'optional',
				type = 'string',
				name = 'staticVersion'
			},
			session = 
			{
				fieldNumber = 1,
				prefix = 'optional',
				type = 'string',
				name = 'session'
			}
		},
		fullName = 'com.kw.wow.proto.UserAuthRsp',
		type = 'message',
		name = 'UserAuthRsp'
	},
	AppendData = 
	{
		tmField = 
		{
			appendItem = 
			{
				fieldNumber = 1,
				prefix = 'repeated',
				type = 'AppendItem',
				name = 'appendItem'
			}
		},
		fullName = 'com.kw.wow.proto.AppendData',
		type = 'message',
		name = 'AppendData'
	},
	Response = 
	{
		tmField = 
		{
			code = 
			{
				fieldNumber = 8,
				prefix = 'optional',
				type = 'int32',
				name = 'code'
			},
			clientIndex = 
			{
				fieldNumber = 2,
				prefix = 'required',
				type = 'int32',
				name = 'clientIndex'
			},
			apiId = 
			{
				fieldNumber = 1,
				prefix = 'required',
				type = 'int32',
				name = 'apiId'
			},
			compress = 
			{
				fieldNumber = 7,
				prefix = 'required',
				type = 'bool',
				name = 'compress'
			},
			serverIndex = 
			{
				fieldNumber = 3,
				prefix = 'required',
				type = 'int32',
				name = 'serverIndex'
			},
			result = 
			{
				fieldNumber = 5,
				prefix = 'required',
				type = 'bool',
				name = 'result'
			},
			appendData = 
			{
				fieldNumber = 6,
				prefix = 'optional',
				type = 'AppendData',
				name = 'appendData'
			},
			data = 
			{
				fieldNumber = 4,
				prefix = 'optional',
				type = 'bytes',
				name = 'data'
			}
		},
		fullName = 'com.kw.wow.proto.Response',
		type = 'message',
		name = 'Response'
	}
}
return M
    