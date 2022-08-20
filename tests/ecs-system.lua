package.path = package.path .. ";ext/share/lua/5.3/?.lua"
lu = require('luaunit')

os.exit( lu.LuaUnit.run() )
