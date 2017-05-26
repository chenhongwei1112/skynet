local skynet = require "skynet"
local queue = require "skynet.queue"
local snax = require "snax"

local i = 56
local hello = "hello"

function hotfix(...)
	local temp = i
	i = 56
	return temp
end

function response.ping(hello)
	skynet.sleep(100)
	return hello
end

function accept.hello(str)
	print("222223333"..str..i)
end

function accept.reloadCode()
    local fileName = debug.getinfo(1,'S').source:sub(2)
    local file = io.open(fileName, "rb")
    if not file then 
    	return nil 
    end
    local content = file:read "*a"
    file:close()
    snax.hotfix(snax.self(), content)
end

function init( ... )
	print("----------test_service_01 start--------------")
end

function exit(...)
	print ("service exit", ...)
end
