package.path = package.path .. ";ext/share/lua/5.3/?.lua"

local lu = require('luaunit')
local ecs = require("entcom")
local TestSystem = ecs:newSys()

TestCreate = {}
function TestCreate:testSystemCreateVanilla()

  local sys = TestSystem

  lu.assertEquals( type(sys),                 "table" )
  lu.assertEquals( type(sys.options),         "table" )
  
  lu.assertEquals(sys.options.exactMatch,     false   )
  lu.assertEquals(sys.options.matchAll,       false   )
  lu.assertEquals(sys.options.overrideFilter, false   )

  lu.assertEquals(sys.entities,               {}      )
  lu.assertEquals(sys.inactiveEntities,       {}      )
  lu.assertEquals(sys.filter,                 {}      )
  lu.assertEquals(sys.dynamicRefresh,         false   )

end

function TestCreate:testSystemCreateWithFilter()

  local f = { x = 1, y = 2 } 
  local sys = ecs:newSys(f)

  lu.assertIsTable(sys.filter)
  lu.assertEquals(sys.filter, f)

end

TestFilter = {}
function TestFilter:setUp()

  local f = { x = 1, y = 2 }

  self.sys = ecs:newSys(f)
  self.matchingEntity = { x = 1 }
  
end

function TestFilter:testEmptyEntity()
 
  local sys = self.sys 
  local e = {}
  local r = sys:filterEntity(e)

  lu.assertIsTable( r )
  lu.assertEquals( r, {} ) 

end


function TestFilter:testMatchingEntity()
 
  local sys = self.sys 
  local r = sys:filterEntity(self.matchingEntity)

  lu.assertIsTable( r )
  lu.assertEquals( r, self.matchingEntity ) 

end

function TestFilter:testNonMatchingEntity()
  local sys = self.sys 
  local e = { a = true, b = "ZZZ" }
  
  local r = sys:filterEntity(e)
  lu.assertIsTable( r )
  lu.assertEquals( r, {} )

end

-- sys.options.matchSub = true
-- sys.options.matchType = true
-- sys.options.overrideFilter = true
-- sys.options.matchAll = true
-- sys.options.exactMatch = true
-- sys.entities = b
-- sys:_update()
-- pi(sys:filterEntities())
-- sys:resetEntityLists()


-- pi(sys:filterEntity(a)) -- x & y are proper subset + values match exactly
-- -- { x = 1; y = 2 }

-- sys:filterEntity(b) -- x & y are proper subset + values do not match exactly
-- -- {}

-- sys.options.matchSub = false
-- sys:filterEntity(b) -- y matches on value; x is not considered, i.e., 'matchAny'
-- -- { x = 99; y = 2 }


-- local airlock = TestSystem.new({ y = 2; x = 2; a = true })
-- local z = { a = true; x = 2 }

-- airlock.options.exactMatch = true
-- airlock.options.matchType = true
-- airlock.options.matchAll = true -- matchSub might be cool? 
-- airlock.options.matchSub = true 

-- pi(airlock:addEntity(z))
-- airlock.entities = { {x=1; y=3}; { a=false } }
-- airlock.options.overrideFilter = true
-- pi(airlock:addEntity( { x=1 } ))
-- print(inspect(airlock:filterEntities()))
os.exit( lu.LuaUnit.run() )
