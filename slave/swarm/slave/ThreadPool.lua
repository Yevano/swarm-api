ThreadPool = { }
ThreadPool.__index = ThreadPool

function ThreadPool.new()
  local self = { }
  setmetatable(self, ThreadPool)
  self.threads = { }
  self.eventFilters = { }
  self.eventData = { }
  return self
end

-- Runs a thread in this ThreadPool
function ThreadPool:runThread(i)
  local thread = self.threads[i]

  if not self.eventFilters[thread] or self.eventFilters[thread] == self.eventData[1] or self.eventData[1] == "terminate" then
    local ok, param = coroutine.resume(thread, unpack(self.eventData))
  
    if ok then
      self.eventFilters[thread] = param
    else
      error(param)
    end
  
    if coroutine.status(thread) == "dead" then
      table.remove(self.threads, i)
    end
  end
end

-- Runs the threads, passing event data to each one
function ThreadPool:waitForAll()
  while #self.threads > 0 do
    self:runOnce()
  end
end

-- Runs the threads once and returns
function ThreadPool:runOnce()
  for i = 1, #self.threads do
    self:runThread(i)
  end
  
  self.eventData = {os.pullEventRaw()}
end

-- Adds a thread to this ThreadPool
function ThreadPool:add(func)
  local thread = coroutine.create(func)
  table.insert(self.threads, thread)
  self:runThread(#self.threads)
end