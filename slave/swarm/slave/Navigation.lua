include.file("Vector.lua")

Navigation = { }
Direction = { }

Direction.NORTH = 0
Direction.EAST  = 1
Direction.SOUTH = 2
Direction.WEST  = 3

local detoured = true

local dir = 0
local pos = Vector.new(0, 0, 0)

local function toVector(dir)
  if dir == Direction.NORTH then
    return {x = 0, y = 1}
  elseif dir == Direction.EAST then
    return {x = 1, y = 0}
  elseif dir == Direction.SOUTH then
    return {x = 0, y = -1}
  elseif dir == Direction.WEST then
    return {x = -1, y = 0}
  end
end

-- TODO: add fuel checking
function Navigation.goTo(npos)
  local x = pos.x
  local y = pos.y
  local z = pos.z
  local nx = npos.x
  local ny = npos.y
  local nz = npos.z

  local dirZ = nz > z and 1 or -1
  for i = 1, math.abs(z - nz) do
    -- Go up or down and do path checking
    if not (dirZ == 1 and turtle.up() or turtle.down()) then
      -- TODO
    end
  end

  if nx < x then
    Navigation.turnTo(Direction.WEST)
  elseif nx > x then
    Navigation.turnTo(Direction.EAST)
  end

  for i = 1, math.abs(nx - x) do
    turtle.forward()
  end

  if ny < y then
    Navigation.turnTo(Direction.SOUTH)
  elseif ny > y then
    Navigation.turnTo(Direction.NORTH)
  end

  for i = 1, math.abs(ny - y) do
    turtle.forward()
  end
end

-- format is turnTable[dir][ndir] = turns
local turnTable = { }
turnTable[1] = {0, 1, 2, -1}
turnTable[2] = {-1, 0, 1, 2}
turnTable[3] = {2, -1, 0, 1}
turnTable[4] = {1, 2, -1, 0}

-- TODO: add fuel checking
function Navigation.turnTo(ndir)
  local turns = turnTable[dir + 1][ndir + 1]

  -- Choose which way to turn and then turn
  local f = turns > 0 and turtle.turnRight or turtle.turnLeft
  for i = 1, math.abs(turns) do
    f()
  end
end

function Navigation.setOrientation(_dir, _pos)
  dir = _dir
  pos = _pos
end

function Navigation.dir()
  return dir
end

function Navigation.pos()
  return pos
end

function Navigation.detourFunctions()
  if turtle.__navdetour then
    turtle.up        = turtle.__up
    turtle.down      = turtle.__down
    turtle.forward   = turtle.__forward
    turtle.back      = turtle.__back
    turtle.turnLeft  = turtle.__turnLeft
    turtle.turnRight = turtle.__turnRight
  else
    turtle.__navdetour = true
    turtle.__up        = turtle.up
    turtle.__down      = turtle.down
    turtle.__forward   = turtle.forward
    turtle.__back      = turtle.back
    turtle.__turnLeft  = turtle.turnLeft
    turtle.__turnRight = turtle.turnRight
  end

  function turtle.up()
    if turtle.__up() then
      pos.z = pos.z + 1
      return true
    end

    return false
  end

  function turtle.down()
    if turtle.__down() then
      pos.z = pos.z - 1
      return true
    end

    return false
  end

  function turtle.forward()
    if turtle.__forward() then
      local vec = toVector(dir)
      pos.x = pos.x + vec.x
      pos.y = pos.y + vec.y
      return true
    end

    return false
  end

  function turtle.back()
    if turtle.__back() then
      local vec = toVector(dir)
      pos.x = pos.x - vec.x
      pos.y = pos.y - vec.y
      return true
    end

    return false
  end

  function turtle.turnLeft()
    dir = dir == 0 and 3 or dir - 1
    return turtle.__turnLeft()
  end

  function turtle.turnRight()
    dir = dir == 3 and 0 or dir + 1
    return turtle.__turnRight()
  end
end

function Navigation.restoreFunctions()
  turtle.up        = turtle.__up
  turtle.down      = turtle.__down
  turtle.forward   = turtle.__forward
  turtle.back      = turtle.__back
  turtle.turnLeft  = turtle.__turnLeft
  turtle.turnRight = turtle.__turnRight

  turtle.__navdetour = nil
  turtle.__up        = nil
  turtle.__down      = nil
  turtle.__forward   = nil
  turtle.__back      = nil
  turtle.__turnLeft  = nil
  turtle.__turnRight = nil
end