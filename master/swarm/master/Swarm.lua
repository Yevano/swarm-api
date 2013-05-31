include.file("NetManager.lua")
include.file("Turtle.lua")
include.file("Hook.lua")

Swarm = { }

local MessageHandler = { }

local turtles = { }
local freeTurtles = { }
local busyTurtles = { }
local tasks = { }
local idTurtleMap = { }
local turtleIndexMap = { }

local function handleNet()
  local message = NetManager.receive()
  
  if     message.type == "JOIN" then
    MessageHandler.onJoin({turtleID = message.__SENDER})
  elseif message.type == "LEAVE" then
    MessageHandler.onLeave({turtleID = message.__SENDER})
  else
    Hook.call("NetMessage", {message = message})
  end
end

function Swarm.run()
  while true do
    handleNet()
  end
end

function Swarm.init(channel, modemSide)
  NetManager.open(channel, modemSide)
end

function Swarm.allocTurtles(amount)
  if #freeTurtles < amount then return end
  
  local turtles = { }
  for i = 1, amount do
    local turtle = table.remove(freeTurtles)
    table.insert(turtles, turtle)
    table.insert(busyTurtles)
  end
  
  return turtles
end

function Swarm.submitTask(task, turtles)
  for i = 1, #turtles do
    local turtle = turtles[i]
    turtle:run(i, task)
  end
end

function MessageHandler.onJoin(event)
  local turtle = Turtle.new(event.turtleID)
  idTurtleMap[event.turtleID] = turtle
  turtles[turtle] = turtle
  table.insert(freeTurtles, turtle)
  Hook.call("TurtleJoin", {turtle = turtle})
end

function MessageHandler.onLeave(event)
  Hook.call("TurtleLeave", {turtle = idTurtleMap[event.turtleID]})
  turtles[idTurtleMap[event.turtleID]] = nil
  idTurtleMap[event.turtleID] = nil
end