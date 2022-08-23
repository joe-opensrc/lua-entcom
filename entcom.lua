package.path = package.path .. ";ext/share/lua/5.3/?.lua"
local uuid    = require("uuid")
local inspect = require("inspect")

require("utils")

EntCom = {}
-- EntCom.defaults = { entities = {} }

EntCom.metatable = {}
EntCom.metatable.__index = EntCom -- EntCom.defaults

function EntCom.new()
  local self = setmetatable({}, EntCom.metatable)   
  self.systems = {}
  return self
end


System = {}
System.metatable = {}
System.metatable.__index = System

function EntCom.newSys(f)
  local self = setmetatable({}, System.metatable)  
  self.entities                   = {}
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

  assert( type(ent) == "table", "an entity must be a lua table" )

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

return EntCom
