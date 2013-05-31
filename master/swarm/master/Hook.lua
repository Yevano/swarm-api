Hook = { }

local hooks = { }
local removedHooks = { }

function Hook.add(event, listener)
  if not hooks[event] then
    hooks[event] = { }
  end

  table.insert(hooks[event], listener)
  return #hooks[event]
end

function Hook.remove(event, id)
  table.insert(removedHooks, {event, id})
end

function Hook.call(event, obj)
  for i = 1, #removedHooks do
    local event = removedHooks[i][1]
    local id = removedHooks[i][2]
    table.remove(hooks[event], id)
  end

  removedHooks = { }
  
  local listeners = hooks[event]

  if listeners then
    for i = 1, #listeners do
      listeners[i](obj, i)
    end
  end
end