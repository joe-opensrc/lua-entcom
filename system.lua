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

function System:getFilterLogic()
  return self.entities:getFilterLogic()
end

function System:setFilterLogic(x)
  self.entities:setFilterLogic(x)
end

function System:filterEntities(exact) 
  local inter = self.entities:intersection(self.filter) 
  print(inter)
  --   if self.match == true
  --     if large[k] == k
  --   else
  --      if large[k]
  -- 
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
  local inter = self:intersection(theirs)
  return inter:size() > 0
end

function Set:intersection(theirs)

  assert( theirs ~= nil, "Check '.' vs ':' ! :D" )
  local ourSize = self:size()
  local theirSize = Set.size(theirs)
  local which = nil

  local small = {}
  local large = {}
  local ret = {}

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
      if self.metatable.match == true
      then
        if large[k] == k
        then
          ret[k] = k
        end
      else
        print("bar")
        if large[k]
        then
          ret[k] = k
        end
      end
  end

  return Set.new(ret)
  
end

function System:addEntity(ent,test)
  local ents = self.entities
  local test = test or false
  -- pi(Set(self.filter))
    
  -- if this system doesn't filter
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

local airlock = System.new({ a = true; x = 1; z = true })
airlock.entities.metatable.match = true
airlock:setFilterLogic("any")
airlock:matchEntities()
pi(airlock.entities)
-- airlock:refresh({ x = true })
-- pi(airlock)
pi( airlock:addEntity( {x=1; y=2} ))
-- pi(airlock.entities)
