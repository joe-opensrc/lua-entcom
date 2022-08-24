package = "entcom"
version = "0.1.1-1"

source = {
   url = "git+ssh://git@github.com/joe-opensrc/lua-entcom.git",
   tag = 'v' .. version 
    
}

description = {
  summary = "A Hideously Functional⁽™⁾ ECS module",
  detailed = [[
    An Entity Component System; written in Lua. 
    A framework for wrangling lua tables based on filters.
    Primarily intended for use with Löve as part of a game-engine :)
  ]],
  homepage = "https://github.com/joe-opensrc/lua-entcom",
  license = "CC BY-SA"
}

dependencies = {
  "lua ~> 5.3",
  "inspect ~> 3.1.3-0",
  "luaunit ~> 3.4-1",
  "uuid ~> 0.3-1",
}

build = {
   type = "builtin",
   modules = {
      entcom = "entcom.lua",
      ["ext.lib.luarocks.rocks-5.3.luaunit.3.4-1.doc.my_test_suite"] = "ext/lib/luarocks/rocks-5.3/luaunit/3.4-1/doc/my_test_suite.lua",
      ["ext.lib.luarocks.rocks-5.3.luaunit.3.4-1.test.run_unit_tests"] = "ext/lib/luarocks/rocks-5.3/luaunit/3.4-1/test/run_unit_tests.lua",
      ["ext.lib.luarocks.rocks-5.3.luaunit.3.4-1.test.test_luaunit"] = "ext/lib/luarocks/rocks-5.3/luaunit/3.4-1/test/test_luaunit.lua",
      ["ext.share.lua.5.3.inspect"] = "ext/share/lua/5.3/inspect.lua",
      ["ext.share.lua.5.3.luaunit"] = "ext/share/lua/5.3/luaunit.lua",
      ["ext.share.lua.5.3.uuid"] = "ext/share/lua/5.3/uuid.lua",
      ["tests.entcom"] = "tests/entcom.lua",
      utils = "utils.lua"
   },
   copy_directories = {
      "ext",
      "tests"
   }
}
