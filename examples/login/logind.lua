local login = require "snax.loginserver"
local crypt = require "skynet.crypt"
local skynet = require "skynet"

local httpc = require "http.httpc"

local server = {
	host = "0.0.0.0",
	port = 8001,
	multilogin = false,	-- disallow multilogin
	name = "login_master",
}

local server_list = {}
local user_online = {}
local user_login = {}

-- 错误码说明:
-- 410 服务器无法获取当前版本号,一般是nginx异常
-- 411 客户端版本不对

function server.auth_handler(token)
	-- the token is base64(user)@base64(server):base64(password)
	local user, server, password, version = token:match("([^@]+)@([^:]+):(.+)-(.+)")
	user = crypt.base64decode(user)
	server = crypt.base64decode(server)
	password = crypt.base64decode(password)
	assert(password == "123", "401")
	
	version = crypt.base64decode(version)
	local status, cur_version = httpc.get("127.0.0.1:8080", '/VersionFile')
	assert(status == 200, "410")
	cur_version = cur_version:match(".-([0-9.]+).-")
	assert(version == cur_version, "411")

	return server, user
end

function server.login_handler(server, uid, secret)
	print(string.format("%s@%s is login, secret is %s", uid, server, crypt.hexencode(secret)))
	local gameserver = assert(server_list[server], "Unknown server")
	-- only one can login, because disallow multilogin
	local last = user_online[uid]
	if last then
		skynet.call(last.address, "lua", "kick", uid, last.subid)
	end
	if user_online[uid] then
		error(string.format("user %s is already online", uid))
	end

	local subid = tostring(skynet.call(gameserver, "lua", "login", uid, secret))
	user_online[uid] = { address = gameserver, subid = subid , server = server}
	return subid
end

local CMD = {}

function CMD.register_gate(server, address)
	server_list[server] = address
end

function CMD.logout(uid, subid)
	local u = user_online[uid]
	if u then
		print(string.format("%s@%s is logout", uid, u.server))
		user_online[uid] = nil
	end
end

function server.command_handler(command, ...)
	local f = assert(CMD[command])
	return f(...)
end

login(server)
