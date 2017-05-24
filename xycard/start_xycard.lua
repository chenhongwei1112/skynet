package.path = "./xycard/base/?.lua;".. "./xycard/class/?.lua;" .. package.path

require "functions"

local skynet = require "skynet"
local sprotoloader = require "sprotoloader"
local snax = require "snax"

local max_client = 64

skynet.start(function()
	skynet.error("Server start")
	skynet.uniqueservice("xycard_protoloader")
	if not skynet.getenv "daemon" then
		local console = skynet.newservice("console")
	end
	skynet.newservice("debug_console",8000)
	skynet.newservice("xycard_service_db")
	local watchdog = skynet.newservice("xycard_watchdog")
	skynet.call(watchdog, "lua", "start", {
		port = 8888,
		maxclient = max_client,

		nodelay = true,
	})
	skynet.error("Watchdog listen on", 8888)

	local testservice = snax.newservice("xycard_service_01")
	-- local myservice1 = skynet.newservice("myservice1")

	-- local myservice1 = skynet.newservice("myservice1")
	-- print(skynet.call(myservice1, "lua", 1, 2, 3))

	-- local myservice2 = skynet.newservice("myservice2")
	-- print(skynet.call(myservice2, "lua", 1, 2, 3))


	-- local echo_reload = skynet.newservice("echo_reload")


local Circle = require "Circle"
local Rectangle = require "Rectangle"

local circle = Circle.new()             -- 输出: Shape:ctor(circle)
circle:setRadius(200)
circle:draw()                           -- 输出: draw circle, radius = 200.00

local rectangle = Rectangle.new()       -- 输出: Shape:ctor(rectangle)
rectangle:draw()                        -- 输出: draw rectangle


	skynet.exit()
end)
