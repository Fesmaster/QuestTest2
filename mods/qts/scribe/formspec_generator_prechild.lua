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

        --return constructed formspec string
        return "formspec_version[6]"..
            "size["..size.x..","..size.y..",false]"..
            [[
            position[0.5,0.5]
            anchor[0.5,0.5]
            padding[0.05,0.05]
            real_coordinates[true]
            ]]
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
                    math.floor(middle.x_min)..","..math.floor(middle.y_min)..",-"..math.floor(middle.x_max)..",-"..math.floor(middle.y_max).."]"
            else
                imgstring = "background["..qts.scribe.vec2.tostring(pos_bg)..";" .. sizestr ..";"..formdata.details.texture..";false]"
            end
        end
        
        return imgstring.."container["..posstr.."]"
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
                    math.floor(middle.x_min)..","..math.floor(middle.y_min)..",-"..math.floor(middle.x_max)..",-"..math.floor(middle.y_max).."]"
            else
                imgstring = "background["..qts.scribe.vec2.tostring(pos_bg)..";" .. qts.scribe.vec2.tostring(formdata.details.size) ..";"..formdata.details.texture..";false]"
            end
        end
        
        
        if formdata.details.scrollable then
            local scrollbar_name = qts.scribe.next_element_name("scrollbar")
            
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
            "arrows=default]" .. --scrollbar options
            "scrollbar["..qts.scribe.vec2.tostring(scrollbar_pos)..";"..qts.scribe.vec2.tostring(scrollbar_size)..
            ";vertical;".. scrollbar_name .. ";0]" .. --scrollbar
            "scroll_container["..posstr..";"..sizestr..";"..scrollbar_name..";vertical;0.1]"
            
        else
            return imgstring.."container["..posstr.."]"
        end


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
        local style_normal = "style["..formdata.details.name..":default"
        local style_hovered = "style["..formdata.details.name..":hovered"
        local style_pressed = "style["..formdata.details.name..":pressed"
        local style_all = "style["..formdata.details.name

        local needs_style_all = false
        local needs_style_normal = false
        local needs_style_hovered = false
        local needs_style_pressed = false
        
        --bg alpha
        if (formdata.details.background_use_alpha) then
            style_all = style_all .. ";alpha="..tostring(formdata.details.background_use_alpha)
            --this does not mark them needed!
        end
        --bg image
        if (formdata.details.background) then
            if (formdata.details.background_pressed or formdata.details.background_hovered) then
                --use specific bg style
                style_normal=style_normal..";bgimg="..formdata.details.background
                needs_style_normal=true
            else
                --use style all
                style_all=style_all..";bgimg="..formdata.details.background
                needs_style_all=true
            end
        end
        if (formdata.details.background_hovered) then
            style_hovered=style_hovered..";bgimg="..formdata.details.background_hovered
            needs_style_hovered=true
        end
        if (formdata.details.background_pressed) then
            style_pressed=style_pressed..";bgimg="..formdata.details.background_pressed
            needs_style_pressed=true
        end
        --bg tint
        if (formdata.details.background_tint) then
            if (formdata.details.background_tint_hovered or formdata.details.background_tint_pressed) then
                --use specific bg style
                style_normal=style_normal..";bgcolor="..formdata.details.background_tint
                needs_style_normal=true
            else
                --use style all
                style_all=style_all..";bgcolor="..formdata.details.background_tint
                needs_style_all=true
            end
        end
        if (formdata.details.background_tint_hovered) then
            style_hovered=style_hovered..";bgcolor="..formdata.details.background_tint_hovered
            needs_style_hovered=true
        end
        if (formdata.details.background_tint_pressed) then
            style_pressed=style_pressed..";bgcolor="..formdata.details.background_tint_pressed
            needs_style_pressed=true
        end
        --font
        if (formdata.details.font) then
            ---@type ScribeFontStyle
            local font = formdata.details.font
            
            if font.style or font.bold or font.italic then
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
                style_all=style_all..";font="..fontstr
                needs_style_all=true
            end

            if font.size then
                style_all=style_all..";font_size="..font.size
                needs_style_all=true
            end

            if font.color then
                style_all=style_all..";textcolor="..font.color
                needs_style_all=true
            end
        end

        if formdata.details.border then
            style_all=style_all..";border="..tostring(formdata.details.border)
            needs_style_all=true
        end
        if formdata.details.internal_offset then
            style_all=style_all..";content_offset="..qts.scribe.vec2.tostring(formdata.details.internal_offset)
            needs_style_all=true
        end
        if formdata.details.padding then
            ---@type Rect
            local padding = formdata.details.padding
            ---padding in context of a button is a different struct
            style_all=style_all..";padding="..math.floor(padding.x_min)..","..math.floor(padding.y_min)..",-"..math.floor(padding.x_max)..",-"..math.floor(padding.y_max)
            needs_style_all=true
        end
        if formdata.details.sound then
            style_all=style_all..";sound="..tostring(formdata.details.sound)
            needs_style_all=true
        end
        
        --collect styles
        local style = ""
        if needs_style_all then
            style = style..style_all.."]"
        end
        if needs_style_normal then
            style = style..style_normal.."]"
        end
        if needs_style_hovered then
            style = style..style_hovered.."]"
        end
        if needs_style_pressed then
            style = style..style_pressed.."]"
        end

        --build the button
        local btn = ""
        if formdata.details.texture then
            --image button
            btn = "image_button["..posstr..";"..sizestr..";"..formdata.details.texture..";"..formdata.details.name..";"..label
            if formdata.details.texture_pressed then
                btn=btn..";true;false;"..formdata.details.texture_pressed.."]"
            else
                btn=btn..";true;false;"..formdata.details.texture.."]"
            end
        elseif formdata.details.item then
            --item button
            btn = "item_image_button["..posstr..";"..sizestr..";"..formdata.details.item..";"..formdata.details.name..";"..label.."]"
        else
            --regular button
            btn = "button["..posstr..";"..sizestr..";"..formdata.details.name..";"..formdata.details.label.."]"
        end

        --build the tooltip
        local tooltip = ""
        if formdata.details.tooltip then
            if type(formdata.details.tooltip) == "string" then
                tooltip = "tooltip["..posstr..";"..sizestr..";"..formdata.details.tooltip.."]"
            elseif type(formdata.details.tooltip) == "table" then
                tooltip = "tooltip["..posstr..";"..sizestr..";"..formdata.details.tooltip.text..";"..formdata.details.tooltip.bgcolor..";"..formdata.details.tooltip.fgcolor.."]"
            end
        end

        return style..btn..tooltip
    end,
}