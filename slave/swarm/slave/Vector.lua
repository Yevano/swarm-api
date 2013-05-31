Vector = { }
Vector.__index = Vector

function Vector.new(x, y, z)
	local self = { }
	setmetatable(self, Vector)
	self.x = x
	self.y = y
	self.z = z
	return self
end

function Vector:length()
	return mathx.sqrt(math.pow(self.x, 2) + math.pow(self.y, 2) + math.pow(self.z, 2))
end

function Vector:__add(v)
	if type(v) == "number" then
		self.x = self.x + v
		self.y = self.y + v
		self.z = self.z + v
	elseif type(v) == "table" and getmetatable(v) == Vector then
		self.x = self.x + v.x
		self.y = self.y + v.y
		self.z = self.z + v.z
	else
		error("Invalid argument.")
	end

	return self
end

function Vector:__sub(v)
	if type(v) == "number" then
		self.x = self.x - v
		self.y = self.y - v
		self.z = self.z - v
	elseif type(v) == "table" and getmetatable(v) == Vector then
		self.x = self.x - v.x
		self.y = self.y - v.y
		self.z = self.z - v.z
	else
		error("Invalid argument.")
	end

	return self
end

function Vector:__div(v)
	if type(v) == "number" then
		self.x = self.x / v
		self.y = self.y / v
		self.z = self.z / v
	elseif type(v) == "table" and getmetatable(v) == Vector then
		self.x = self.x / v.x
		self.y = self.y / v.y
		self.z = self.z / v.z
	else
		error("Invalid argument.")
	end

	return self
end

function Vector:__mul(v)
	if type(v) == "number" then
		self.x = self.x * v
		self.y = self.y * v
		self.z = self.z * v
	elseif type(v) == "table" and getmetatable(v) == Vector then
		self.x = self.x * v.x
		self.y = self.y * v.y
		self.z = self.z * v.z
	else
		error("Invalid argument.")
	end

	return self
end
