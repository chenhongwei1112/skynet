local skynet = require "skynet"

skynet.start(function()
	skynet.uniqueservice("protoloader")

	skynet.newservice("debug_console",8000)

	local loginserver = skynet.newservice("logind")
	local gate = skynet.newservice("gated", loginserver)

	skynet.call(gate, "lua", "open" , {
		port = 8888,
		maxclient = 64,
		servername = "sample",
	})
end)
