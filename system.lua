package.path = package.path .. ";ext/share/lua/5.1/?.lua"
local uuid    = require("uuid")
local inspect = require("inspect")

util = {}
function util.size(t)
  local count = 0
  for _ in pairs(t)
  do
    count = count + 1 
  end
  return count 
end

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
  self.entities                   = {} -- Set.new({})
  self.options                    = {}
  self.options.exactMatch         = false
  self.options.matchAll           = false
  self.options.overrideFilter     = false
  self.dynamicRefresh             = false
  self.filter                     = f or {}
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

-- function System:getFilterLogic()
--   return self.entities:getFilterLogic()
-- end

-- function System:setFilterLogic(x)
--   self.entities:setFilterLogic(x)
-- end

function System:filterEntities(ents,exact)
  -- printf("options: %s\n\n",  inspect(self.options) )
  local fent = {}
  local exact = exact or self.options.exactMatch 
  local ents = ents or self.entities
  -- pi(#ents)
  for i, ent in ipairs(ents)
  do
    -- printf("%s: %s\n\n",  i, inspect(ent) )
    fent = self:filterEntity(ent,exact)  
    -- printf("fent: %s\n",  inspect( fent ) )
    if isEmpty(fent)
    then
      -- printf("<^^SHOULD REMOVE\n")
      ents[i] = nil
    end
    -- fent = {}
  end

  return ents
end

util = {}
function util.size(t)
  local count = 0
  for _ in pairs(t)
  do
    count = count + 1 
  end
  return count 
end

function System:filterEntity(ent,exact) 
  -- printf("fE: %s\n", inspect(self.filter) )
  local exact = exact or self.options.exactMatch 
  local hit = false
  local hitCount = 0
  local fsize = util.size(self.filter)
  
  if self.options.overrideFilter
  then 
    return ent
  end

  for k,v in pairs( self.filter )
  do

    if exact
    then
      hit = ( ent[k] == v )
      -- printf("%s = %s\n", inspect(k), inspect(v))
    elseif self.options.matchType
    then
      hit = ( type(ent[k]) == type(v) )
      -- printf("to(%s) == to(%s)?\n", type(ent[k]), type(v) )
    else
      hit = ( ent[k] ~= nil )
      -- printf("%s exists?\n", inspect( k ) ) 
    end

    -- printf("hit: %s\n", inspect(hit) )
    if hit
    then
       -- printf("som: %s\n", inspect(self.options.matchAll) )
       if not self.options.matchAll 
       then 
         return ent
       else
         hitCount = hitCount + 1
       end
    else
      if self.options.matchAll
      then
        return {}
      end
    end

    hit = false
  end

  -- printf("hc: %d\n",  hitCount )
  -- print( fsize )
  if hitCount == fsize
  then
   return ent
  end
 
  return {}
     
 -- local hit = false
 -- for _,ent in pairs(self.entities)
 -- do
 --   printf("e: %s\n", inspect(ent))
 --   for k,v in pairs( ent )
 --   do
 --     if exact or self.exact
 --     then
 --       hit = ( self.filter[k] == v )
 --       printf("%s = %s\n", inspect(k), inspect(v))
 --     else
 --       hit = ( self.filter[k] ~= nil )
 --       printf("%s exists?\n", inspect( k ) ) 
 --     end
 --     printf("hit: %s\n", inspect(hit) )
 --   end
 -- end


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
        if large[k]
        then
          ret[k] = k
        end
      end
  end

  return Set.new(ret)
  
end

function System:addEntity(ent)
  local ents = self.entities
  -- if this system doesn't filter
  if isEmpty(self.filter) or self.options.overrideFilter 
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

local airlock = System.new({ y = 2; x = 2; a = true })

airlock.options.exactMatch = true
airlock.options.matchType = false
airlock.options.matchAll = false

airlock.entities = { {x=1; y=3}; { a=false } }
airlock.options.overrideFilter = true
pi(airlock:addEntity( { x=1 } ))
print(inspect(airlock:filterEntities()))
-- pi(airlock.filter)
-- airlock.entities.metatable.match = true
-- airlock:setFilterLogic("any")
-- pi(airlock.entities)
-- airlock:refresh({ x = true })
-- pi(airlock)
-- pi( airlock:addEntity( {x=1; y=2} ))
-- pi( airlock:addEntity( {a=1; b="foo" }))
-- airlock:filterEntities()
