love.filesystem.setRequirePath("ext/share/lua/5.3/?.lua")

local uuid    = require("uuid")
local inspect = require("inspect")
local tiny    = require("tiny")

require("utils")

function triggerEvent(name, ...)
  love.handler.push( name, ... )
end

function observeEvent(name, entity, ...)
  entity.events.name = entity
end

function forgetEvent(name)
  love.handlers[name] = nil
end

function objectUpdateFilter(obj, filter)

  for k,v in pairs(filter)
  do
  
    if v
    then
      obj[k] = v
    else
      obj[k] = nil
    end
     
  end 

  pi(obj)
  return world:addEntity(obj)

end

love.handlers.updateObjectFilters = function (objs,filter,...)
  
  pi( objs ) 
  -- for _,o in pairs(objs)
  -- do
  --   objectUpdateFilter(o,filter)
  -- end

end

function love.load() 

  love.mouse.setVisible(true)
  love.mouse.setRelativeMode(false)
  love.mouse.setCursor( love.mouse.getSystemCursor("crosshair") )

  -- window width, height
  W, H = love.graphics.getDimensions()
  world = tiny.world() -- it's so tiny  

  here = tiny.processingSystem()
  here.filter = tiny.requireAll("here")

  there = tiny.processingSystem()
  there.filter = tiny.requireAll("there")

  world:addSystem(here)
  world:addSystem(there)

  theObj = { name = "airlock", here = true }
  pi( theObj )

  world:addEntity(theObj)
  -- print( inspect( world ) )

  tobj={ x = 1 }
end

wantInputText=true
inputText=""
-- function love.textinput(t)
  
-- end
function test(obj)
  print( inspect (obj) )
  obj.x  = obj.x + 1
  -- print( "callback: " .. inspect (obj) )
end

love.handlers.test = test
function love.keypressed(key, scancode, isrepeat)

  if wantInputText then
    -- if not inputText.length 
  end
  -- queueAction("uixKeyboard", key)
  --
  if key == "a" then 
    -- print( love.keyboard.hasTextInput() )
    print( "tobj" .. inspect (tobj) ) 
    love.event.push("test", tobj)
    print( "tobj" .. inspect (tobj) )
    

  end

  if key == "i" then
    print( "here:" .. inspect( here.entities  ) )
    print( "there:" .. inspect( there.entities ) )
    -- print( "world:" .. inspect( world) )
  end

  if key == "t" then

    filterHereToThere = {
      here  = false;
      there = true
    }


    objectUpdateFilter( theObj, filterHereToThere )

    -- local objs = {}
    -- objs[1] = theObj
    love.event.push("updateObjectFilters",theObj, filterHereToThere ) 

  end
    
  if key == "escape" or key == "q" then
    love.event.quit()
  end

end

function love.update(dt) 
  mx,my = love.mouse.getPosition()
  world:update(dt)
end

function love.resize()
  W, H  = love.graphics.getDimensions()
end

function love.draw() 
  -- love.graphics.print( inspect( world ), 0, 0 )
  -- love.graphics.polygon("fill", mx,my, mx+100,my, mx+50,my+100)
end


function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			love.graphics.clear(love.graphics.getBackgroundColor())

			if love.draw then love.draw() end

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end

