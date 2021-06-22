-- measure the performance of table inserts in append vs prepend mode:

local S1, S1_ = Stopwatch("table_prepend", "cyan")
local S2, S2_ = Stopwatch("table_append", "yellow")

for trial = 0, 5 do
        local y = {}
        S1()
        for x = 0, 5000 do
                table.insert(y, 1, x)
        end
        S1_(1)
end

for trial = 0, 5 do
        local y = {}
        S2()
        for x = 0, 5000 do
                table.insert(y, x)
        end
        S2_(1)
end
