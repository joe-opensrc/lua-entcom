package.path = package.path .. ";ext/share/lua/5.1/?.lua"
local uuid    = require("uuid")
local inspect = require("inspect")

function printf(...)
   local function wrapper(...) io.write(string.format(...)) end
   local status, result = pcall(wrapper, ...)
   if not status then error(result, 2) end
end

function pi(...)
  printf("%s\n",  inspect( ... ) )
end

-- impl speedup
local next = next
function isEmpty(t)
  return next(t) == nil
end

System = {}
-- System.defaults = { entities = {} }

System.metatable = {}
System.metatable.__index = System -- System.defaults

function System.new(f)
  local self = setmetatable({}, System.metatable)  
  self.entities = Set.new({})
  self.options = {}
  self.overrideFilter = false
  self.dynamicRefresh = false
  self.filter = f or {}
  return self
end


-- Set equality for filter test?
Set = {}
Set.metatable = { allOrAny = "any" }
Set.metatable.__index = Set

-- Set.metatable.__eq = function(s1,s2)
--   local count = 0
--   for k,_ in pairs(s1) do
--     if s2[k] == true then
--         count = count + 1 
--     end
--   end

--   if count == #s1 == #s2 
--   then 
--     return true
--   else
--     return false
--   end
-- end


function Set:getFilterLogic()
  return self.metatable.allOrAny
end

function Set:setFilterLogic(x)
  assert( ( x == "all" or x == "any" ), "Invalid Value: must be 'all' or 'any'" )
  self.metatable.allOrAny = x
end

function Set.new(t)
  assert( type(t) ~= nil, "Check table?" )
  local self = setmetatable({}, Set.metatable)  
  for k,_ in pairs(t) do self[k] = true end
  return self 
end

function System:parseFilter(f)
  -- string parse to Set? 
end


function Set.size(s)
  s:size()
end

function Set:size()
  local count = 0
  for x in pairs(self)
  do
    -- print("X:" .. x )
    count = count + 1 
  end

  return count 
end

function Set:intersects(theirs)

  assert( theirs ~= nil, "Check '.' vs ':' ! :D" )
  local ourSize = self:size()
  local theirSize = theirs:size()
  local which = nil
  local count = 0

  if ourSize <= theirSize
  then
    small = self
    large = theirs
  else
    small = theirs
    large = self
  end  

  for k,_ in pairs(small)
  do
    if large[k]
    then
      count = count + 1
    end
  end

  -- print( "c:" .. count )
  -- print( "s:" .. Set.size(small) )
  -- print( "l:" .. Set.size(large) )

  -- any
  -- if count > 0 and count <= Set.size(small) 
  --
  -- all
  -- print(self:getFilterLogic())
  if self:getFilterLogic() == "any"
  then
    return ( count > 0 and count <= Set.size(small) )
  else
    return count == small:size()
  end
  return false  
  
end

function System:addEntity(ent)
  local ents = self.entities
  -- pi(Set(self.filter))
  -- pi(ent)
  if isEmpty(self.filter)
  then  
    ents[#ents+1] = ent
    return ent
  else
    local entSet = Set.new(ent)
    local filSet = Set.new(self.filter)

    if entSet:intersects(filSet)
    then
      ents[#ents+1] = ent
      return ent
    end
  end 

  return {}
end

-- internal function to 
function System:_update()
  if self.dynamicRefresh
  then
    -- refresh entities list
    -- self.refresh()
  end
  
end

function System:refresh(filter)

  if filter
  then
    self.filter = filter 
  end
  -- update list of entities with possibly modified filter
end

local airlock = System.new({ x = true; y = true; z = true })
airlock.entities:setFilterLogic("all")

-- airlock:refresh({ x = true })
-- airlock:setFilterLogic("all")
-- pi(airlock)
--
pi( airlock:addEntity( {x=1; y=2} ))
-- pi(airlock.entities)
