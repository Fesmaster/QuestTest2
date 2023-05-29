--[[
    Scribe enums.
    These are used to define many things in scribe instead of strings, as these are more efficent to compare.
]]

---@enum ScribeFormVisibility
qts.scribe.visibility = {
    VISIBLE=0,
    HIDDEN=1,
    COLLAPSED=2
}

---@enum ScribeFormAllignment
qts.scribe.allignment = {
    MIN=0,
    LEFT=0,
    TOP=0,
    CENTER=1,
    MAX=2,
    RIGHT=2,
    BOTTOM=2,
    JUSTIFY=3
}

---@enum ScribeFormOrientation
qts.scribe.orientation = {
    HORIZONTAL=0,
    VERTICAL=1
}

qts.scribe.scrollbar_ticks_per_unit = 10 --gained from imperical testing
--formula for scrollbar ticks: (internal_size - external_size) * ticks_per_unit
--formula for scrollbar size: external_size / internal_size * ticks_per_unit