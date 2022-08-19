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
  self.inactiveEntities           = {}
  self.options                    = {}
  self.options.exactMatch         = false
  self.options.matchAll           = false
  self.options.overrideFilter     = false
  self.dynamicRefresh             = false
  self.filter                     = f or {}
  return self

end


function System:parseFilter(f)
  -- string parse to Set? 
end

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
      table.move(ents,i,1,1,self.inactiveEntities)
      ents[i] = nil
    end
    -- fent = {}
  end

  return ents
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
       if not ( self.options.matchAll or self.options.matchSub )
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
  local hsize = util.size(ent)  
  if hitCount == fsize
  then
   return ent
  elseif self.options.matchSub and ( hitCount > 0 and hitCount < fsize ) and ( hitCount == hsize )
  then
    return ent 
  end
 
  return {}
     
end

function System:addEntity(ent)
  local ents = self.entities
  -- printf("ent: %s\n", inspect(ent))
  -- if this system doesn't filter
  -- pi(isEmpty(self.filter))
  -- pi(self.options.overrideFilter)
  if isEmpty(self.filter) or self.options.overrideFilter 
  then  
    ents[#ents+1] = ent
    return ent
  else
    -- printf("ent_post: %s\n", inspect(ent))
    if not isEmpty(self:filterEntity(ent))
    then
      ents[#ents+1] = ent
      return ent
    end

  end 

  return {}
end

-- internal function to 
function System:_update()

  self:resetEntityLists() 
  self:filterEntities()
  for k,v in pairs(self.entities)
  do
    printf("UP: %s\n", inspect( v.x + v.y ))
  end
  
  -- if self.dynamicRefresh
  -- then
  --   -- refresh entities list
  --   -- self.refresh()
  -- end
  
end


function System:resetEntityLists()
  local ies = self.inactiveEntities 
  self.entities = table.move( self.inactiveEntities, 1, #ies, 1, self.entities )
  self.inactiveEntities = {}
end

function System:refresh(filter)

  if filter
  then
    self.filter = filter 
  end
  -- update list of entities with possibly modified filter
end

local airlock = System.new({ y = 2; x = 2; a = true })
local z = { a = true; x = 1 }

airlock.options.exactMatch = true
-- airlock.options.matchType = true
airlock.options.matchAll = true -- matchSub might be cool? 

pi(airlock:addEntity(z))
-- airlock.entities = { {x=1; y=3}; { a=false } }
-- airlock.options.overrideFilter = true
-- pi(airlock:addEntity( { x=1 } ))
-- print(inspect(airlock:filterEntities()))
