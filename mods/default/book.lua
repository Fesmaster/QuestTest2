
local S = qts.gui.gui_makesize
local P = qts.gui.gui_makepos

qts.gui.register_gui("default_book_writeable", {
	get = function(data, pos, playername)
		local s = "size[16.03125,12]no_prepend[]bgcolor[#00000000;true]background[0,0;16.03125,12;default_book_UI_background.png]"
        --styling of text here
        s = s .. "style[textAreaLeft,textAreaRight;font=normal,bold;font_size=*1.4;border=false;textcolor=#000F]"
        --get the book text
        local bookText1 = "type here..."
        local bookText2 = "type here..."
        local player = minetest.get_player_by_name(playername)
        local item = player:get_wielded_item()
        local meta =item:get_meta()
        if meta:contains("bookText1") then
            bookText1 = meta:get("bookText1")
        end
        if meta:contains("bookText2") then
            bookText2 = meta:get("bookText2")
        end
        --add the text areas
        s = s .. "textarea[0.4,0.1;7.6,13.2;textAreaLeft;;"..minetest.formspec_escape(bookText1).."]"
        s = s .. "textarea[8.4,0.1;7.8,13.2;textAreaRight;;"..minetest.formspec_escape(bookText2).."]"
        s = s .. [[style[save_button;
            bgimg=gui_button.png;
            bgimg_hovered=gui_button_hovered.png;
            bgimg_pressed=gui_button_clicked.png;
            bgimg_middle=8;
            border=false;
            noclip=true]
            button[6.9, 11.8;2,0.2;save_button;Save Book]
            ]]
        return s
	end,
	handle = function(data, pos, playername, fields)
		if not fields.quit then
            --write data to metadata
            local bookText1 = fields.textAreaLeft or ""
            local bookText2 = fields.textAreaRight or ""
            local player = minetest.get_player_by_name(playername)
            local item = player:get_wielded_item()
            local isNewItem = false
            if item:get_count() > 1 then
                local remains = item
                item = remains:take_item()
                player:set_wielded_item(remains)
                isNewItem = true
            end
            local meta =item:get_meta()
            meta:set_string("bookText1", bookText1)
            meta:set_string("bookText2", bookText2)
            --update the book description
            local desc = minetest.registered_items[item:get_name()].description
            local endline = string.find(bookText1, "\n")
            if endline then
                desc = desc .. "\n" .. string.sub(bookText1, 1, endline-1)
            else
                desc = desc .. "\n" .. bookText1
            end
            meta:set_string("description", desc)

            if isNewItem then
                local item = player:get_inventory():add_item("main", item)
                if not item:is_empty() then
                    minetest.item_drop(item, player, pos)
                end 
            else
                player:set_wielded_item(item)
            end
        end
		return true
	end,
})


minetest.register_craftitem("default:book", {
    description="Book",
    inventory_image = "default_book.png",
    on_place = function(itemstack, placer, pointed_thing)
        qts.gui.show_gui(placer:get_pos(), placer, "default_book_writeable")
    end,
    on_secondary_use = function(itemstack, user, pointed_thing)
        qts.gui.show_gui(user:get_pos(), user, "default_book_writeable")
    end,
})