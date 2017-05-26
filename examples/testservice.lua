local skynet = require "skynet"
local queue = require "skynet.queue"
local snax = require "snax"

local i = 7
local hello = "hello"

function hotfix(...)
	local temp = i
	i = 7
	return temp
end

function response.ping(hello)
	skynet.sleep(100)
	return hello
end

function accept.hello(str)
	print("ccc"..str..i)
end

function init( ... )
	print("----------test_service_01 start--------------")
end

function exit(...)
	print ("service exit", ...)
end

function accept.reloadCode()
	local fileName = debug.getinfo(1,'S').source:sub(2)
    snax.reloadScript(fileName)
end
