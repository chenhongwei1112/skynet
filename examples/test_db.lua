local skynet = require "skynet"
local snax = require "skynet.snax"
local mongo = require "skynet.db.mongo"

local DB_CONF = require "db_config"

local CMD = {}

-- 检查是否需要新创建表
function CMD:check_colletions()
	local db_collections = DB_CONF.db_collections
	for i,v in ipairs(db_collections) do
		print("dddddddddd",i,v)
	end
end

-- 创建连接池
function CMD:create_conns()
	self.cur_conn_index = 0
	self.conns = {}

	for i=1,DB_CONF.db_max_conn do
		local db_client = mongo.client({host = DB_CONF.db_host})
		table.insert(self.conns, db_client[DB_CONF.db_name])
	end
end

function CMD:init()
	self:check_colletions()
	self:create_conns()
end

function CMD:getConn()
	self.cur_conn_index = self.cur_conn_index + 1
	if self.cur_conn_index > DB_CONF.db_max_conn then
		self.cur_conn_index = 1
	end
	return self.conns[self.cur_conn_index]
end

function CMD:do_cmd(aaa)

end

function CMD:insert(coll, data)
	local cur_db = self:getConn()
	cur_db[coll]:insert(data)
end

function CMD:insertBatch(coll, data)
	local cur_db = self:getConn()
	cur_db[coll]:batch_insert(data)
end

function CMD:del(coll, selector)
	local cur_db = self:getConn()
	cur_db[coll]:delete(selector)
end

function CMD:update(coll, selector, data)
	local cur_db = self:getConn()
	local update_doc =  {["$set"] = data}
	cur_db[coll]:update(selector, update_doc, false, true)
end

function CMD:find(coll, selector)
	local cur_db = self:getConn()
	local cursor = cur_db[coll]:find(selector)
	local datas = {}
	while cursor:hasNext() do
		local cur_obj = cursor:next()
		table.insert(datas, cur_obj)
	end
	cursor:close()
	return datas
end

function init( ... )
	print("----------test_db start--------------")
	CMD:init()

	-- 增
	-- CMD:insert("test_ddd", {name = "aaa", age = 10})

	-- 删
	-- CMD:del("test_ddd", {})

	-- 批量增
	-- local datas = {}
	-- for i=1,10 do
	-- 	local data = {}
	-- 	data.name = "小王"..i
	-- 	data.age = 100
	-- 	table.insert(datas, data)
	-- end
	-- CMD:insertBatch("test_ddd", datas)

	-- 改
	-- CMD:update("test_ddd", {age = 666}, {age = 777})
	
	-- 查找
	local datas = CMD:find("test_ddd", {age = 444})
	for i, v in ipairs(	datas) do
		print(i,v)
	end

	-- db[db_name].testdb:dropIndex("*")
	-- db[db_name].testdb:drop()

	-- local ret = db[db_name].testdb:safe_insert({test_key = 1});
	-- assert(ret and ret.n == 1)

	-- local ret = db[db_name].testdb:safe_insert({test_key = 1});
	-- assert(ret and ret.n == 1)
end

function exit(...)
	print ("service exit", ...)
end
