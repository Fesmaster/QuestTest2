--[[
    This file has the first half of the conversion functions from scribe gui to formspec gui.
]]

---build a formspec style string from a ScribeFontStyle table
---@param font ScribeFontStyle|nil
local function build_font_string(font, needs_style, needs_size, needs_color)
    if font == nil then return "" end

    local retstr = ""
    if needs_style and (font.style or font.bold or font.italic) then
        local fontstr = "normal"
        if font.style then
            fontstr = font.style
        end
        if font.bold then
            fontstr = fontstr..",bold"
        end
        if font.italic then
            fontstr = fontstr..",italic"
        end
        retstr=retstr..";font="..fontstr
    end
    if needs_size and font.size then
        retstr=retstr..";font_size="..font.size
    end
    if needs_color and font.color then
        retstr=retstr..";textcolor="..font.color
    end
    return retstr
end

---Create the string for a button style
---@param style ScribeButtonStateStyle
local function build_button_style_string(style)
    local stylestr = ""
    --bg alpha
    if style.background_use_alpha then
        stylestr = stylestr .. ";alpha="..qts.select(style.background_use_alpha, "true", "false")
    end
    --bg image
    if style.background then
        stylestr=stylestr..";bgimg="..style.background
        --middle
        if style.background_middle ~= nil then
            ---@type Rect
            local padding = style.background_middle
            ---padding in context of a button is a different struct
            stylestr=stylestr..";bgimg_middle="..math.floor(padding.x_min)..","..math.floor(padding.y_min)..",-"..math.floor(padding.x_max)..",-"..math.floor(padding.y_max)
        end
    end
    --bg tint
    if style.background_tint then
        stylestr=stylestr..";bgcolor="..style.background_tint
    end
    --font
    if style.font then
        stylestr=stylestr..build_font_string(style.font, true, true, true)
    end
    --border
    if style.border then
        stylestr=stylestr..";border="..tostring(style.border)
    end
    --internal offset
    if style.internal_offset then
        stylestr=stylestr..";content_offset="..qts.scribe.vec2.tostring(style.internal_offset)
    end
    --padding
    if style.padding then
        ---@type Rect
        local padding = style.padding
        ---padding in context of a button is a different struct
        stylestr=stylestr..";padding="..math.floor(padding.x_min)..","..math.floor(padding.y_min)..",-"..math.floor(padding.x_max)..",-"..math.floor(padding.y_max)
    end
    
    return stylestr
end

---Build a tooltip element
---@param name_or_pos string|{pos:vec2|string,size:vec2|string}|
---@param tooltip string|{text:string,bgcolor:ColorSpec,fgcolor:ColorSpec}
---@return string
local function build_tooltip(name_or_pos, tooltip)
    local tooltip_text = ""
    if tooltip then
        if type(name_or_pos) == "string" then
            tooltip_text = "tooltip["..name_or_pos..";"
        elseif type(name_or_pos) == "table" then
            local posstr = ""
            if type(name_or_pos.pos) == "string" then
                posstr = name_or_pos.pos
            else
                posstr = qts.scribe.vec2.tostring(name_or_pos.pos)
            end

            local sizestr = ""
            if type(name_or_pos.size) == "string" then
                sizestr = name_or_pos.size
            else
                sizestr = qts.scribe.vec2.tostring(name_or_pos.size)
            end

            tooltip_text = "tooltip["..posstr..";"..sizestr..";"
        end

        if type(tooltip) == "string" then
            tooltip_text=tooltip_text..tooltip.."]\n"
        elseif type(tooltip) == "table" then
            tooltip_text=tooltip_text..tooltip.text..";"..tooltip.bgcolor..";"..tooltip.fgcolor.."]\n"
        end
    end
    return tooltip_text
end

---@type table<ScribeFormType,fun(formdata:ScribeFormdata):string>
return {
    ---@param formdata ScribeFormdata
    base = function(formdata)
        --calculate the GPI size
        local size = {x=0,y=0}
        for i, childformdata in ipairs(formdata.children) do
            --max X
            if childformdata.details.size.x > size.x then
                size.x = childformdata.details.size.x
            end
            --max Y
            if childformdata.details.size.y > size.y then
                size.y = childformdata.details.size.y
            end
        end

        local base = "formspec_version[6]\n"..
        "size["..size.x..","..size.y..",false]\n"..
        [[
            position[0.5,0.5]
            anchor[0.5,0.5]
            padding[0.05,0.05]
            ]]..
            qts.select(formdata.details.use_minetest_prepend, "", "no_prepend[]\n")..
            "real_coordinates[true]\n"
        if formdata.details.inventory_colors ~= nil then
            local colors = formdata.details.inventory_colors
            ---@cast colors +ScribeInventoryFormColors
            base = base .. "listcolors["..
                colors.background_color..";"..
                colors.background_hover_color..";"..
                colors.border_color..";"..
                colors.tooltip_color..";"..
                colors.tooltip_text_color.."]\n"
        end
        --return constructed formspec string
        return base
    end,

    ---@param formdata ScribeFormdata
    container = function(formdata)
        local pos = {x=0,y=0}
        if formdata.details.position ~= nil then
            pos = qts.scribe.vec2.copy(formdata.details.position,pos)
        end
        if pos == nil then
            minetest.log("warning", "Scribe: Invalid container.")
            return ""
        end
        local pos_bg = qts.scribe.vec2.copy(pos)
        if formdata.details.padding then
            pos.x = pos.x + formdata.details.padding.x
            pos.y = pos.y + formdata.details.padding.y
        end
        local posstr = qts.scribe.vec2.tostring(pos)
        
        --no need to padd size, as its only used for background, which is full unpadded area.
        local sizestr = qts.scribe.vec2.tostring(formdata.details.size)

        --if an texture is used, generate that element 
        local imgstring = ""
        if formdata.details.texture then
            if formdata.details.middle then
                local middle = formdata.details.middle
                imgstring = "background9["..qts.scribe.vec2.tostring(pos_bg)..";" .. sizestr ..";"..formdata.details.texture..";false;"..
                    math.floor(middle.x_min)..","..math.floor(middle.y_min)..",-"..math.floor(middle.x_max)..",-"..math.floor(middle.y_max).."]\n"
            else
                imgstring = "background["..qts.scribe.vec2.tostring(pos_bg)..";" .. sizestr ..";"..formdata.details.texture..";false]\n"
            end
        end
        
        return imgstring.."container["..posstr.."]\n"
    end,

    ---@param formdata ScribeFormdata
    vertical_box = function(formdata)
        local scrollbar_size = formdata.details.scrollbar_size
        local pos = {x=0,y=0}
        if formdata.details.position ~= nil then
            pos = qts.scribe.vec2.copy(formdata.details.position)
        end
        if pos == nil then
            minetest.log("warning", "Scribe: Invalid container.")
            return ""
        end
        local pos_bg = qts.scribe.vec2.copy(pos)
        if formdata.details.scrollable and formdata.details.scrollbar_side < qts.scribe.allignment.MAX then
            pos.x = pos.x + scrollbar_size
        end
        if formdata.details.padding then
            pos.x = pos.x + formdata.details.padding.x
            pos.y = pos.y + formdata.details.padding.y
        end
        local posstr = qts.scribe.vec2.tostring(pos)
        local size = qts.scribe.vec2.copy(formdata.details.size)
        if formdata.details.scrollable  then
            size.x = size.x - scrollbar_size
        end
        if formdata.details.padding then
            size.x = size.x - (formdata.details.padding.x*2)
            size.y = size.y - (formdata.details.padding.y*2)
        end
        local sizestr = qts.scribe.vec2.tostring(size)

        --if an texture is used, generate that element 
        local imgstring = ""
        if formdata.details.texture then
            if formdata.details.middle then
                local middle = formdata.details.middle
                imgstring = "background9["..qts.scribe.vec2.tostring(pos_bg)..";" .. qts.scribe.vec2.tostring(formdata.details.size) ..";"..formdata.details.texture..";false;"..
                    math.floor(middle.x_min)..","..math.floor(middle.y_min)..",-"..math.floor(middle.x_max)..",-"..math.floor(middle.y_max).."]\n"
            else
                imgstring = "background["..qts.scribe.vec2.tostring(pos_bg)..";" .. qts.scribe.vec2.tostring(formdata.details.size) ..";"..formdata.details.texture..";false]\n"
            end
        end
        
        
        if formdata.details.scrollable then
            local scrollbar_ticks = math.ceil((formdata.details.listsize - size.y) * qts.scribe.scrollbar_ticks_per_unit)
            local vis_size = math.floor(size.y / formdata.details.listsize  * scrollbar_ticks)
            local scrollbar_pos = {x=pos.x-scrollbar_size, y=pos.y}
            if formdata.details.scrollbar_side == qts.scribe.allignment.MAX then
                scrollbar_pos.x = pos.x + size.x
            end
            local scrollbar_size = {x=scrollbar_size,y=size.y}

            return imgstring..
            "scrollbaroptions["..
            "min=0;max="..scrollbar_ticks..";smallstep=10;largestep="..
            vis_size ..";thumbsize="..vis_size..";"..
            "arrows=default]\n" .. --scrollbar options
            "scrollbar["..qts.scribe.vec2.tostring(scrollbar_pos)..";"..qts.scribe.vec2.tostring(scrollbar_size)..
            ";vertical;".. formdata.details.scrollbar_name .. ";0]\n" .. --scrollbar
            "scroll_container["..posstr..";"..sizestr..";"..formdata.details.scrollbar_name..";vertical;0.1]\n"
            
        else
            return imgstring.."container["..posstr.."]\n"
        end
    end,

    ---@param formdata ScribeFormdata
    horizontal_box = function(formdata)
        local scrollbar_size = formdata.details.scrollbar_size
        local pos = {x=0,y=0}
        if formdata.details.position ~= nil then
            pos = qts.scribe.vec2.copy(formdata.details.position)
        end
        if pos == nil then
            minetest.log("warning", "Scribe: Invalid container.")
            return ""
        end
        local pos_bg = qts.scribe.vec2.copy(pos)
        if formdata.details.scrollable and formdata.details.scrollbar_side < qts.scribe.allignment.MAX then
            pos.y = pos.y + scrollbar_size
        end
        if formdata.details.padding then
            pos.x = pos.x + formdata.details.padding.x
            pos.y = pos.y + formdata.details.padding.y
        end
        local posstr = qts.scribe.vec2.tostring(pos)
        local size = qts.scribe.vec2.copy(formdata.details.size)
        if formdata.details.scrollable  then
            size.y = size.y - scrollbar_size
        end
        if formdata.details.padding then
            size.x = size.x - (formdata.details.padding.x*2)
            size.y = size.y - (formdata.details.padding.y*2)
        end
        local sizestr = qts.scribe.vec2.tostring(size)

        --if an texture is used, generate that element 
        local imgstring = ""
        if formdata.details.texture then
            if formdata.details.middle then
                local middle = formdata.details.middle
                imgstring = "background9["..qts.scribe.vec2.tostring(pos_bg)..";" .. qts.scribe.vec2.tostring(formdata.details.size) ..";"..formdata.details.texture..";false;"..
                    math.floor(middle.x_min)..","..math.floor(middle.y_min)..",-"..math.floor(middle.x_max)..",-"..math.floor(middle.y_max).."]\n"
            else
                imgstring = "background["..qts.scribe.vec2.tostring(pos_bg)..";" .. qts.scribe.vec2.tostring(formdata.details.size) ..";"..formdata.details.texture..";false]\n"
            end
        end
        
        
        if formdata.details.scrollable then
            local scrollbar_ticks = math.ceil((formdata.details.listsize - size.x) * qts.scribe.scrollbar_ticks_per_unit)
            local vis_size = math.floor(size.x / formdata.details.listsize  * scrollbar_ticks)
            local scrollbar_pos = {x=pos.x, y=pos.y-scrollbar_size}
            if formdata.details.scrollbar_side == qts.scribe.allignment.MAX then
                scrollbar_pos.y = pos.y + size.y
            end
            local scrollbar_size = {x=size.x,y=scrollbar_size}

            return imgstring..
            "scrollbaroptions["..
            "min=0;max="..scrollbar_ticks..";smallstep=10;largestep="..
            vis_size ..";thumbsize="..vis_size..";"..
            "arrows=default]\n" .. --scrollbar options
            "scrollbar["..qts.scribe.vec2.tostring(scrollbar_pos)..";"..qts.scribe.vec2.tostring(scrollbar_size)..
            ";horizontal;".. formdata.details.scrollbar_name .. ";0]\n" .. --scrollbar
            "scroll_container["..posstr..";"..sizestr..";"..formdata.details.scrollbar_name..";horizontal;0.1]\n"
            
        else
            return imgstring.."container["..posstr.."]\n"
        end
    end,

    ---@param formdata ScribeFormdata
    rect = function(formdata)
        if formdata.details.color == nil or formdata.details.color == "none" then
            return ""
        end

        local pos = {x=0,y=0}
        if formdata.details.position ~= nil then
            pos = qts.scribe.vec2.copy(formdata.details.position)
        end

        local outstr = "box["..
            qts.scribe.vec2.tostring(pos)..";"..
            qts.scribe.vec2.tostring(formdata.details.size)..";"..
            formdata.details.color.."]\n"

        if formdata.details.tooltip then
            outstr=outstr..build_tooltip({pos=pos,size=formdata.details.size}, formdata.details.tooltip)
        end

        return outstr
    end,

    ---@param formdata ScribeFormdata
    text = function(formdata)
        local pos = {x=0,y=0}
        if formdata.details.position ~= nil then
            pos = qts.scribe.vec2.copy(formdata.details.position)
        end
        
        local stylestring = ""
        local startstring = ""
        local endstring = ""
        if formdata.details.font then
            if formdata.details.font.style then
                stylestring = stylestring .. " font="..formdata.details.font.style
            end

            if formdata.details.font.size then
                stylestring = stylestring .. " size="..formdata.details.font.size
            end

            if formdata.details.font.color then
                stylestring = stylestring .. " color="..formdata.details.font.color
            end

            if formdata.details.font.secondary_color then
                stylestring = stylestring .. " hovercolor="..formdata.details.font.secondary_color
            end
            
            if formdata.details.font.bold then
                startstring = startstring .. "<b>"
                endstring = "</b>" .. endstring
            end

            if formdata.details.font.italic then
                startstring = startstring .. "<i>"
                endstring = "</i>" .. endstring
            end

            if formdata.details.font.underline then
                startstring = startstring .. "<u>"
                endstring = "</u>" .. endstring
            end
        end
        local allignments_v = {
            [qts.scribe.allignment.TOP]="top", 
            [qts.scribe.allignment.CENTER]="middle", 
            [qts.scribe.allignment.BOTTOM]="bottom"
        }
        local allignments_h = {
            [qts.scribe.allignment.LEFT]="left", 
            [qts.scribe.allignment.CENTER]="center", 
            [qts.scribe.allignment.RIGHT]="right", 
            [qts.scribe.allignment.JUSTIFY]="justify"
        }
        stylestring = stylestring.. " valign="..allignments_v[formdata.details.vertical_allignment]
            .. " halign="..allignments_h[formdata.details.horizontal_allignment]
            .. " background="..formdata.details.background_color

        local outstr = "hypertext["..
            qts.scribe.vec2.tostring(pos)..";"..
            qts.scribe.vec2.tostring(formdata.details.size)..";"..
            formdata.details.name..";"..
            "<global" .. stylestring .. ">"..
            startstring .. formdata.details.text .. endstring ..
            "]\n"

        if formdata.details.tooltip then
            outstr=outstr..build_tooltip({pos=pos,size=formdata.details.size}, formdata.details.tooltip)
        end

        return outstr
    end,

    ---@param formdata ScribeFormdata
    text_entry = function(formdata)
        local pos = {x=0,y=0}
        if formdata.details.position ~= nil then
            pos = qts.scribe.vec2.copy(formdata.details.position)
        end

        local outstr=""
        --styling
        if formdata.details.border ~= nil or formdata.details.font then
            outstr = outstr .. "\nstyle["..formdata.details.name..
                build_font_string(formdata.details.font, true, true, true)..
                ";border="..qts.select(formdata.details.border, "true", "false").. "]\n"
        
        end

        if formdata.details.obscure_content then
            outstr = outstr .. "\npwdfield["..qts.scribe.vec2.tostring(pos)..";"..
                qts.scribe.vec2.tostring(formdata.details.size)..";"..
                formdata.details.name..";"..
                formdata.details.label.."]\n"
        elseif formdata.details.multiline then
            outstr = outstr .. "\ntextarea["..qts.scribe.vec2.tostring(pos)..";"..
                qts.scribe.vec2.tostring(formdata.details.size)..";"..
                formdata.details.name..";"..
                formdata.details.label..";"..
                formdata.details.default_value.."]\n"
        else
            outstr = outstr .. "\nfield["..qts.scribe.vec2.tostring(pos)..";"..
                qts.scribe.vec2.tostring(formdata.details.size)..";"..
                formdata.details.name..";"..
                formdata.details.label..";"..
                formdata.details.default_value.."]\n"
        end

        --field to stop text entry from closing the UI by default
        if not formdata.details.multiline then
            outstr = outstr.."\nfield_close_on_enter["..formdata.details.name..";"..
                qts.select(formdata.details.close_on_enter, "true", "false") .. "]\n"
        end

        

        --tooltip
        if formdata.details.tooltip then
            outstr=outstr..build_tooltip(formdata.details.name, formdata.details.tooltip)
        end

        return outstr
    end,

    ---@param formdata ScribeFormdata
    image = function (formdata)
        local pos = {x=0,y=0}
        if formdata.details.position ~= nil then
            pos = qts.scribe.vec2.copy(formdata.details.position)
        end

        local outstr = ""
        if formdata.details.item then
            outstr = "item_image["..
                qts.scribe.vec2.tostring(pos)..";"..
                qts.scribe.vec2.tostring(formdata.details.size)..";"..
                formdata.details.item.."]\n"
        else
                
            if formdata.details.animation then
                --animated image
                outstr = "animated_image["..
                    qts.scribe.vec2.tostring(pos)..";"..
                    qts.scribe.vec2.tostring(formdata.details.size)..";"..
                    formdata.details.name..";"..
                    formdata.details.texture..";"..
                    formdata.details.animation.count..";"..
                    formdata.details.animation.duration..";"..
                    formdata.details.animation.start
            else
                --regular image
                outstr = "image["..
                    qts.scribe.vec2.tostring(pos)..";"..
                    qts.scribe.vec2.tostring(formdata.details.size)..";"..
                    formdata.details.texture
            end

            if formdata.details.middle then
                outstr=outstr .. ";" .. formdata.details.middle.x_min..","..
                    formdata.details.middle.y_min..","..formdata.details.middle.x_max..
                    ","..formdata.details.middle.y_max
            end
            outstr = outstr .. "]\n"

            
        end
        
        if formdata.details.tooltip then
            outstr=outstr..build_tooltip({pos=pos,size=formdata.details.size}, formdata.details.tooltip)
            --[["\ntooltip["..
            qts.scribe.vec2.tostring(pos)..";"..
            qts.scribe.vec2.tostring(formdata.details.size)..";"..
            formdata.details.tooltip.."]"]]
        end

        return outstr
    end,

    ---@param formdata ScribeFormdata
    button = function(formdata)
        local pos = {x=0,y=0}
        if formdata.details.position ~= nil then
            pos = formdata.details.position
        end
        if pos == nil then
            minetest.log("warning", "Scribe: Invalid container.")
            return ""
        end
        local posstr = qts.scribe.vec2.tostring(pos)
        local sizestr = qts.scribe.vec2.tostring(formdata.details.size)
        local label = formdata.details.label or ""

        --build the button style controls
        local style_any = "style["..formdata.details.name
        local style_normal = "style["..formdata.details.name..":default"
        local style_hovered = "style["..formdata.details.name..":hovered"
        local style_pressed = "style["..formdata.details.name..":pressed"

        local needs_style_any = false
        local needs_style_normal = false
        local needs_style_hovered = false
        local needs_style_pressed = false
        
        
        local any_content = build_button_style_string(formdata.details.style_any)
        if any_content ~= "" then
            needs_style_any = true
            style_any = style_any..any_content    
        end

        local normal_content = build_button_style_string(formdata.details.style_normal)
        if normal_content ~= "" then
            needs_style_normal = true
            style_normal = style_normal..normal_content    
        end

        local hovered_content = build_button_style_string(formdata.details.style_hovered)
        if hovered_content ~= "" then
            needs_style_hovered = true
            style_hovered = style_hovered..hovered_content    
        end

        local pressed_content = build_button_style_string(formdata.details.style_pressed)
        if pressed_content ~= "" then
            needs_style_pressed = true
            style_pressed = style_pressed..pressed_content    
        end

        if formdata.details.sound then
            style_any=style_any..";sound="..tostring(formdata.details.sound)
            needs_style_any=true
        end

        
        
        --collect styles
        local style = ""
        if needs_style_any then
            style = style..style_any.."]\n"
        end
        if needs_style_normal then
            style = style..style_normal.."]\n"
        end
        if needs_style_hovered then
            style = style..style_hovered.."]\n"
        end
        if needs_style_pressed then
            style = style..style_pressed.."]\n"
        end

        --build the button
        local btn = ""
        if formdata.details.texture then
            --image button
            btn = "image_button["..posstr..";"..sizestr..";"..formdata.details.texture..";"..formdata.details.name..";"..label
            if formdata.details.texture_pressed then
                btn=btn..";true;false;"..formdata.details.texture_pressed.."]\n"
            else
                btn=btn..";true;false;"..formdata.details.texture.."]\n"
            end
        elseif formdata.details.item then
            --item button
            btn = "item_image_button["..posstr..";"..sizestr..";"..formdata.details.item..";"..formdata.details.name..";"..label.."]\n"
        else
            --regular button
            btn = "button["..posstr..";"..sizestr..";"..formdata.details.name..";"..formdata.details.label.."]\n"
        end

        --build the tooltip
        local tooltip = build_tooltip(formdata.details.name, formdata.details.tooltip)

        return style..btn..tooltip
    end,

    ---@param formdata ScribeFormdata
    inventory = function(formdata)
        local pos = {x=0,y=0}
        if formdata.details.position ~= nil then
            pos = qts.scribe.vec2.copy(formdata.details.position)
        end

        --build style element first. It must always exist
        local outstr = "style_type[list;size="..
            qts.scribe.vec2.tostring(formdata.details.slot_size)..";spacing="..
            qts.scribe.vec2.tostring(formdata.details.slot_spacing).."]\n"

        -- list colors are a universal setting, and cannot be set per-element
        --[[ this uses QT2 Defaults, not minetest defaults.
        outstr = outstr .. "\nlistcolors["..
        qts.select(formdata.details.background_color,       formdata.details.background_color,          "#00000069").. ";" ..
        qts.select(formdata.details.background_color_hover, formdata.details.background_color_hover,    "#5A5A5A")  .. ";" ..
        qts.select(formdata.details.border_color,           formdata.details.border_color,              "#141318")  .. ";" ..
        qts.select(formdata.details.tooltip_color,          formdata.details.tooltip_color,             "#30434C")  .. ";" ..
        qts.select(formdata.details.tooltip_text_color,     formdata.details.tooltip_text_color,        "#FFFFFF")  .. "]"
        --]]
        
        --list element
        local list_src = ""
        if formdata.details.source == qts.scribe.inventory_source.CURRENT_PLAYER then
            list_src = "current_player"
        elseif formdata.details.source == qts.scribe.inventory_source.SPECIFIC_NODE then
            minetest.log("Source Name in translator: " .. dump(formdata.details.sourcename))
            list_src = "nodemeta:"..
                qts.select(
                    type(formdata.details.sourcename)=="string", 
                    formdata.details.sourcename, 
                    ""..formdata.details.sourcename.x..","..formdata.details.sourcename.y..","..formdata.details.sourcename.z
                )
            minetest.log("Current list_src = " .. list_src)
        elseif formdata.details.source == qts.scribe.inventory_source.SPECIFIC_PLAYER then
            list_src = "player:"..formdata.details.sourcename
            
        elseif formdata.details.source == qts.scribe.inventory_source.DETACHED then
            list_src = "detached:"..formdata.details.sourcename
        end

        if formdata.details.orientation == qts.scribe.orientation.HORIZONTAL then
            --normal list orientation - easy!
            outstr = outstr .. "\nlist[" .. list_src .. ";" .. formdata.details.listname .. ";"..
                qts.scribe.vec2.tostring(pos)..";"..
                qts.scribe.vec2.tostring(formdata.details.slots)..";"..
                formdata.details.starting_item_index .. "]\n"
        else
            --vertical list orientation - hard!
            --not supported by formspec, so we have to make a bunch of individual lists that are 1 element wide and space them correctly.
            local running_start = formdata.details.starting_item_index
            local running_pos = qts.scribe.vec2.copy(pos)
            --for each column
            for x = 0, formdata.details.slots.x-1 do
                --add vertical list strip
                outstr = outstr .. "\nlist[" .. list_src .. ";" .. formdata.details.listname .. ";"..
                    qts.scribe.vec2.tostring(running_pos)..";"..
                    "1,"..formdata.details.slots.y..";"..
                    running_start .. "]\n"

                --update the start and running pos
                running_pos.x = running_pos.x + formdata.details.slot_size.y + formdata.details.slot_spacing.y
                running_start = running_start + formdata.details.slots.y
            end
        end

        if formdata.details.use_list_ring then
            outstr = outstr .. "\nlistring["..list_src..";"..formdata.details.listname.."]\n"
        end

        return outstr
    end,


    ---@param formdata ScribeFormdata
    model = function(formdata)
        local pos = {x=0,y=0}
        if formdata.details.position ~= nil then
            pos = qts.scribe.vec2.copy(formdata.details.position)
        end

        local style_str = ""
        if (formdata.details.background_color) then
            style_str = "style["..formdata.details.name..";bgcolor="..formdata.details.background_color.."]\n"
        end

        local posstr = qts.scribe.vec2.tostring(pos)
        local sizestr = qts.scribe.vec2.tostring(formdata.details.size)

        local outstr = style_str .. "model["..
            posstr..";"..
            sizestr..";"..
            formdata.details.name..";"..
            formdata.details.mesh..";"..
            formdata.details.textures..";"..
            qts.scribe.vec2.tostring(formdata.details.rotation)..";"..
            qts.select(formdata.details.continuous_rotation, "true", "false")..";"..
            qts.select(formdata.details.mouse_control, "true", "false")

        if (formdata.details.frames_per_second > 0) then
            --frame_loop_range vec2? the range of any animation to play, <begin>,<end>. Default: {x=0,y=0}
            --frames_per_second number? frames per second on the animation. Default: 0
            outstr = outstr ..";"..
                qts.scribe.vec2.tostring(formdata.details.frame_loop_range)..";"..
                formdata.details.frames_per_second
        end

        outstr = outstr.."]\n"
        
        
        return outstr
    end,
}

