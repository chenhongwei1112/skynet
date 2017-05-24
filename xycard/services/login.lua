local skynet = require "skynet"
local queue = require "skynet.queue"
local snax = require "snax"

function response.login(username, pwd)
	if username == "chenhw" and pwd == "333" then
		return true, nil
	else
		return false, "error AAAA"
	end
end

function init( ... )
	print("----------testservice start--------------")
end

function exit(...)
	print ("service exit", ...)
end
