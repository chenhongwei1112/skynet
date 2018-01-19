local DB_CONF = {}

DB_CONF.db_host = "127.0.0.1"
DB_CONF.db_name = "test_db"
DB_CONF.db_max_conn = 10
DB_CONF.db_collections = {
	"aaa",
	"bb",
	"ccc",
	"ddd",
}

function DB_CONF:AAA()
end

return DB_CONF
