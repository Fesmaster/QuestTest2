--[[
	maths.lua
	This file is used for math functions and data structures that are not vectors
	
qts.nearly_equal(a, b, degree)
	checks to see if a and b are within degree of each other
	Params:
	a - number, the first to compare
	b - number, the second to compare
	degree - number, how close they have to be. defautls to 0.001
	
	Return: true or false

Set(t)
	Creats a set from a list. 
	ie, {1="item1", 2="item2, ... N="itemN"}
	becomes {["item1"]=true, ["item2"]=true, ... ["itemN"]=true}
	
	Params: t - table, list-style 1 indexed.
	
	Return; table, set style

Deque()
	A Deque, Queue, and Stack data structure.
	use function calls with ":", ie
	item:pop()
	All functions are declared locally and referenced by all Deques, 
	maintaining minimun memory footprint
	
	constructor:
		Deque()
	
	methods:
		Deque:
			add_to_back(item)
			add_to_front(item)
			remove_from_back()
			remove_from_front()
			peek_back()
			peek_front()
		Queue:
			enqueue(item)
			dequeue()
			peek()
		Stack:
			push(item)
			pop()
			peek()
	
	these methods are pretty self explanatory.

Counter()
	returns a counter function. Each time it is called, it returns an incrementing number.
	the same number is never returned twice.
	
	mutpile counters can exists, and they are all independent.
	however, 
		c1 = Counter()
		c2 = c1
	will have c1 and c2 referenceing the same counter, and a call to c1() will cause c2() to be effected.
	
	Usage:
	counter = Counter()
	unique_val = counter()
	anoter_val = counter()
	...etc.

--]]

function qts.nearly_equal(a, b, degree)
	if not degree then degree = 0.001 end
	return (a >= b-degree and a <= b+degree)
end

function Set(t)
	local s = {}
	for i, v in ipairs(t) do
		s[v] = true
	end
	return s
end

--[[Deque Internal Functions]]
local function d_add_to_back(self, data)
	if not self.lastindex then
		self.lastindex = 0
		self.firstindex = 0
		self[0] = data
	else
		self.lastindex = self.lastindex+1
		self[self.lastindex] = data
	end
end
local function d_add_to_front(self, data)
	if not self.firstindex then
		self.lastindex = 0
		self.firstindex = 0
		self[0] = data
	else
		self.firstindex = self.firstindex-1
		self[self.firstindex] = data
	end
end
local function d_remove_from_back(self)
	if not self.lastindex then
		return nil
	end
	self.lastindex = self.lastindex-1
	return self[self.lastindex+1]
end
local function d_remove_from_front(self)
	if not self.firstindex then
		return nil
	end
	self.firstindex = self.firstindex+1
	return self[self.firstindex-1]
end
local function d_peek_back(self)
	if not self.lastindex then
		return nil
	end
	return self[self.lastindex]
end
local function d_peek_front(self)
	if not self.firstindex then
		return nil
	end
	return self[self.firstindex]
end
function Deque()
	return {
		lastindex = nil,
		firstindex = nil,
		add_to_back = d_add_to_back,
		add_to_front = d_add_to_front,
		remove_from_back = d_remove_from_back,
		remove_from_front = d_remove_from_front,
		peek_back = d_peek_back,
		peek_front = d_peek_front,
		enqueue = d_add_to_back,
		dequeue = d_remove_from_front,
		push = d_add_to_front,
		pop = d_remove_from_front,
		peek = d_peek_front,
	}
end

function Counter()
	local i = 0
	return function()
		i = i + 1
		return i
	end
end



--[[
DEPRICIATED FUNCTIONS
function qts.nearly_equal_vec(a, b, degree)
	error("DEPRICIATED: qts.nearly_equal_vec is replaced by vector.nearly_equal")
end
function qts.nearly_equal_vec_xz(a, b, degree)
	error("DEPRICIATED: qts.nearly_equal_vec_xz is replaced by vector.nearly_equal_xz")
end
function qts.rotateVectorYaw(vec, angle)
	error("DEPRICIATED: qts.rotateVectorYaw is replaced by vector.rotate_yaw")
end
function qts.Set(t)
	error("DEPRICIATED: qts.Set() is depreciated. Use Set() instead")
end
function qts.Deque()
	error("DEPRICIATED: qts.Deque() is depreciated. Use Deque() instead")
end
function qts.new_counter()
	error("DEPRICIATED: qts.new_counter() is depreciated. Use Counter() instead")
end
--]]
