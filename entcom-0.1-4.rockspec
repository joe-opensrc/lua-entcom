package = "entcom"
version = "0.1-4"

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
      ["entcom.utils"] = "entcom/utils.lua",
   },
   copy_directories = {
    "doc",
    "test"
   }
}
