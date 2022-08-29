--[[
	maths.lua
	This file is used for math functions and data structures that are not vectors
--]]

--[[
	checks to see if a and b are within degree of each other  
	
	Params:  
		a - number, the first to compare  
		b - number, the second to compare  
		degree - number, how close they have to be. defautls to 0.001  
	
	Return:  
		boolean true or false as you expect.  
]]
function qts.nearly_equal(a, b, degree)
	if not degree then degree = 0.001 end
	return (a >= b-degree and a <= b+degree)
end

--[[
	Creats a set from a list.   
	ie, {1="item1", 2="item2, ... N="itemN"}  
	becomes {["item1"]=true, ["item2"]=true, ... ["itemN"]=true}  
	
	Params:   
		t - table, list-style 1 indexed.  
	
	Returns:  
		table, set style  
]]
function Set(t)
	local s = {}
	for i, v in ipairs(t) do
		s[v] = true
	end
	return s
end

--[[Deque Internal Functions]]

--[[Add an item to the back of the Deque]]
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
--[[Add an item to the front of the Deque]]
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
--[[Remove an item from the back of the Deque, returning it]]
local function d_remove_from_back(self)
	if not self.lastindex then
		return nil
	end
	self.lastindex = self.lastindex-1
	return self[self.lastindex+1]
end
--[[Remove an item from the front of the Deque, returning it]]
local function d_remove_from_front(self)
	if not self.firstindex then
		return nil
	end
	self.firstindex = self.firstindex+1
	return self[self.firstindex-1]
end
--[[Get a reference (or copy if simple) to the item at the back of the Deque]]
local function d_peek_back(self)
	if not self.lastindex then
		return nil
	end
	return self[self.lastindex]
end
--[[Get a reference (or copy if simple) to the item at the front of the Deque]]
local function d_peek_front(self)
	if not self.firstindex then
		return nil
	end
	return self[self.firstindex]
end

--[[
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
]]
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

--[[
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
]]
function Counter()
	local i = 0
	return function()
		i = i + 1
		return i
	end
end

