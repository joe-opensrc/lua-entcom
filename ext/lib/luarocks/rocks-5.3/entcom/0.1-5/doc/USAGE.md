### EntityCom Usage

Typically it starts like this:

```
local ecs = require("entcom")
local utils = require("entcom.utils")

local filter = { x = 250, y = 250, hasMaguffin = true }

local ent = { x = 99, y = 123, hasMaguffin = false }

local sys = ecs:newSys(filter)

-- if any of the keys exist
assert( sys:filterEntity(ent) == ent )

-- at least one key must match a filter value exactly
sys.options.exactMatch = true
assert( utils.isEmpty( sys:filterEntity(ent) ) )

-- set the Maguffin; one key now matches 
ent.hasMaguffin = true
assert( sys:filterEntity(ent) == ent )

-- all keys must match exactly
sys.options.matchAll   = true
sys.options.exactMatch = true

-- all keys /do/ match exactly
ent = filter -- or { x = 250, y = 250, hasMaguffin = true }
assert( sys:filterEntity(ent) == ent )
```
