local sprotoparser = require "sprotoparser"

local proto = {}

proto.c2s = sprotoparser.parse [[
.package {
	type 0 : integer
	session 1 : integer
}

handshake 1 {
	response {
		msg 0  : string
	}
}

get 2 {
	request {
		what 0 : string
	}
	response {
		result 0 : string
	}
}

set 3 {
	request {
		what 0 : string
		value 1 : string
	}
}

quit 4 {}

addMoney 5{
	request {
		money 0 : integer
	}
	response {
		money 0 : integer
	}
}

.ItemInfo{
	id 0 : integer
	param1 1 : integer
	param2 2 : string
}

jinglian 6{
	request {
		items 0 : *ItemInfo
	}
	response {
		items 0 : *ItemInfo
	}
}

]]

proto.s2c = sprotoparser.parse [[
.package {
	type 0 : integer
	session 1 : integer
}

heartbeat 1 {}
]]

return proto
