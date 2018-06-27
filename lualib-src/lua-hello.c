// simple lua socket library for client
// It's only for demo, limited feature. Don't use it in your project.
// Rewrite socket library by yourself .

#define LUA_LIB

#include <lua.h>
#include <lauxlib.h>
#include <string.h>
#include <stdint.h>
#include <pthread.h>
#include <stdlib.h>

static int
lspeak(lua_State *L) {
	size_t sz = 0;
	const char * key = luaL_checklstring(L, 1, &sz);
	lua_pushlstring(L, "ABCDEFG", 3);
	return 1;
}

LUAMOD_API int
luaopen_client_hello(lua_State *L) {
	luaL_checkversion(L);
	luaL_Reg l[] = {
		{ "speak", lspeak },
		{ NULL, NULL },
	};
	luaL_newlib(L, l);

	return 1;
}
