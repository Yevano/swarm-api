Util = { }

function Util.encodeNetData(str)
  local ret = ""
  
  for i = 1, #str do
    local b = string.byte(str:sub(i, i))
    
    if b > 127 then
      ret = ret .. string.char(1) .. string.char(b - 128)
    else
      ret = ret .. string.char(0) .. string.char(b)
    end
  end
  
  return ret
end

function Util.decodeNetData(str)
  local ret = ""
  
  for i = 1, #str, 2 do
    local flag = str:sub(i, i):byte()
    local data = str:sub(i + 1, i + 1):byte()
    
    if flag == 0 then
      ret = ret .. string.sub(str, i + 1, i + 1)
    else
      ret = ret .. string.char(data + 128)
    end
  end
  
  return ret
end

function Util.copy(t)
  local ret = { }
  
  for k, v in pairs(t) do
    ret[k] = v
  end
  
  return ret
end