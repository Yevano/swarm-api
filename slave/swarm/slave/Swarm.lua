include.file("NetManager.lua")
include.file("ThreadPool.lua")
include.file("Navigation.lua")

Swarm = { }
local MessageHandler = { }

local threadPool = ThreadPool.new()

function handleNet()
  local message = NetManager.receive()
  
  if message.type == "RUN" then
    threadPool:add(function()
      loadstring(message.byteCode)(message.workerID)
    end)
  end
end

function Swarm.run()
  while true do
    threadPool:runOnce()
  end
end

function Swarm.init(masterID, channel, modemSide)
  NetManager.open(channel, modemSide)
  Swarm.masterID = masterID
end

function Swarm.join()
  NetManager.send(Swarm.masterID, {
    type = "JOIN"
  })
end

function Swarm.leave()
  NetManager.send(Swarm.masterID, {
    type = "LEAVE"
  })
end

threadPool:add(handleNet)