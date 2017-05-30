local skynet = require "skynet"
local queue = require "skynet.queue"
local snax = require "snax"

local i = 7
local hello = "hello"

local invoke_func_stop

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
	print("c22cc1111"..str..i)
	
	-- invoke_func_stop()
end

function init( ... )
	print("----------test_service_01 start--------------")

	-- invoke_func_stop = snax.invokeRepeat(function ( ... )
	-- 	print("MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM")
	-- end, 100)
end

function exit(...)
	print ("service exit", ...)
end

function accept.reloadCode()
	local fileName = debug.getinfo(1,'S').source:sub(2)
    snax.reloadScript(fileName)
end
