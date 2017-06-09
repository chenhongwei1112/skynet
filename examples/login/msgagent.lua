local skynet = require "skynet"
local sprotoloader = require "sprotoloader"

local host
local gate
local userid, subid

local REQUEST = {}
local CMD = {}

local heartcount

function CMD.login(source, uid, sid, secret)
	-- you may use secret to make a encrypted data stream
	skynet.error(string.format("%s is login", uid))
	gate = source
	userid = uid
	subid = sid

	heartcount = 5
	-- you may load user data from database
end

local function logout()
	if gate then
		skynet.call(gate, "lua", "logout", userid, subid)
	end
	skynet.exit()
end

function CMD.logout(source)
	-- NOTICE: The logout MAY be reentry
	skynet.error(string.format("%s is logout", userid))
	logout()
end

function CMD.afk(source)
	-- the connection is broken, but the user may back
	skynet.error(string.format("AFK"))
end


local temp1
function REQUEST:foobar()
	return { ok = 1 }
end

function REQUEST:heartbeat()
	return { ok = true }
end

local co_tbl = {}
local data1 = 20
local data2 = "fff"

function REQUEST:mytest2()
	local co = co_tbl[#co_tbl]
	if not co then
		return
	end

	data1 = data1 + 1
	co_tbl[#co_tbl] = nil
	skynet.wakeup(co)
end


local function request(name, args, response)
	if name == "mytest1" then
		temp1= coroutine.running()
		table.insert(co_tbl, temp1)
		skynet.wait(temp1)
		return send_request("player_join", {id = data1, account = data2})
	else
		local f = assert(REQUEST[name])
		local r = f(args)
		if response then
			return response(r)
		end
	end
end

skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = function (msg, sz)
		return host:dispatch(msg, sz)
	end,
	dispatch = function (_, _, type, ...)
		if type == "REQUEST" then
			local ok, result  = pcall(request, ...)
			if ok then
				if result then
					skynet.ret(result)
				end
			else
				skynet.error(result)
			end
		else
			assert(type == "RESPONSE")
			error "This example doesn't support request client"
		end
	end
}

local hearbeat_invoke
skynet.start(function()
	host = sprotoloader.load(1):host "package"
	send_request = host:attach(sprotoloader.load(2))

	-- If you want to fork a work thread , you MUST do it in CMD.login
	skynet.dispatch("lua", function(session, source, command, ...)
		local f = assert(CMD[command])
		skynet.ret(skynet.pack(f(source, ...)))
	end)

	heartcount = 0
	hearbeat_invoke = skynet.invokeRepeat(function ()
		heartcount = heartcount - 1
		if heartcount < -3 then
			hearbeat_invoke()
		end
	end, 100)
end)
