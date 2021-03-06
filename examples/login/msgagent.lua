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
	-- skynet.exit()
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

function REQUEST:foobar()
	return { ok = 1 }
end

function REQUEST:heartbeat()
	return { ok = true }
end

local hangupSessions = {}
local hangupSessionData = {}

local function sendPush(data)
	if #hangupSessions == 0 then
		error "no sesssions can use"
		return
	end

	local co = hangupSessions[#hangupSessions]
	hangupSessionData[co] = data
	hangupSessions[#hangupSessions] = nil
	skynet.wakeup(co)
end

function REQUEST:mytest()
	sendPush(send_request("create_room_succ", {result = 1, room_id = 100}))
end

local function request(name, args, response)
	if name == "sendSession" then
		local co = coroutine.running()
		table.insert(hangupSessions, co)
		skynet.wait(co)
		local data = hangupSessionData[co]
		hangupSessionData[co] = nil
		return data
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
