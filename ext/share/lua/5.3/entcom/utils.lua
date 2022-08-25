utils = {}

function utils.size(t)
  local count = 0
  for _ in pairs(t)
  do
    count = count + 1 
  end
  return count 
end

function utils.printf(...)
   local function wrapper(...) io.write(string.format(...)) end
   local status, result = pcall(wrapper, ...)
   if not status then error(result, 2) end
end

function utils.pi(...)
  printf("%s\n",  inspect( ... ) )
end

-- impl speedup
local next = next
function utils.isEmpty(t)
  return next(t) == nil
end

return utils
