--[[
    A tool to view gui's with styles. Used for debugging GUIs and styles
]]


qts.gui.register_scribe_gui("dtools:style_debug_gui", function (context)
    context:set_style("qtcore:stormcloud") --current style!
    --:enable_debug_printing(true)
    :container({
        position={x=0,y=0},
    }, function (c2)
        c2:tab_header({
            width=18.4,
            height=13,
            name="primary_tabs",
            inner_size={x=18,y=12},
            position={x=0,y=0},
        },{
            {
                tab={
                    name="itemlist_display",
                    label = "Item Lists",
                    width=2,
                    height=1,
                    padding={x=0,y=0}
                },
                page=function (context_tab)
                    context_tab
                    :container({
                        texture=qtcore.styles.stormcloud.BG_FANCY,
                        middle=16,
                        padding={x=0.2,y=0.2},
                        position={x=-0.2, y=0},
                        width=18 --inner_size
                    }, function(context_tab1_2)
                        context_tab1_2:inventory({
                            source = qts.scribe.inventory_source.CURRENT_PLAYER,
                            sourcename = "",
                            listname = "main",
                            width=10,
                            height=4,
                            position={x=0,y=0},
                            slot_size = {x=1,y=1},
                            slot_spacing = {x=0.125,y=0.125},
                            use_list_ring=true,
                        })
                        :inventory({
                            source = qts.scribe.inventory_source.DETACHED,
                            sourcename = "trash",
                            listname = "main",
                            width=1,
                            height=1,
                            position={x=0,y=7},
                            use_list_ring=true,
                        })
                    
                    end)
                end
            },--tab 1
            {
                tab={
                    name="button_display",
                    label = "Buttons",
                    width=2,
                    height=1,
                    padding={x=0,y=0}
                },
                page=function (context_tab)
                    context_tab
                    :container({
                        texture=qtcore.styles.stormcloud.BG_FANCY,
                        middle=16,
                        padding={x=0.2,y=0.2},
                        position={x=-0.2, y=0},
                        width=18 --inner_size
                    }, function(context_tab2_1)
                        context_tab2_1
                        :horizontal_box({
                            position={x=0,y=0},
                            texture="",
                            spacing={x=0.5,y=0},
                            middle=nil,
                            allignment=qts.scribe.allignment.TOP,
                        }, function (context_tab2_1a)
                            context_tab2_1a
                            :vertical_box({
                                --position={x=0.1, y=0.1},
                                allignment=qts.scribe.allignment.LEFT,
                                spacing={x=0,y=0.2},
                            }, function (context_tabs2_2)
                                context_tabs2_2
                                :text({
                                    name="buttondescriptortextelementcolumn1",
                                    text="Button Types - Vertical Box",
                                    font={
                                        bold=true,
                                        size=22,
                                        color=qtcore.styles.stormcloud.TEXT_COLOR
                                    },
                                    width=4,
                                height=1.2
                                })
                                --[[
                                    text button
                                ]]
                                :button({
                                    name="text_button",
                                    width=2,
                                    height=1,
                                    label="Text Button",
                                    is_exit=false,
                                    tooltip={
                                        text="Defaut Text Button. Prints a message to the log and to your chat."
                                    }
                                }, function (event)
                                minetest.log("Text button pressed.")
                                minetest.chat_send_player(event.player:get_player_name(), "Text button pressed.")
                                end)
                                --[[
                                Image Button
                                ]]
                                :button({
                                    name="image_button",
                                    width=1,
                                    height=1,
                                    texture="gui_one.png",
                                    texture_pressed="gui_ten.png",
                                    is_exit=false,
                                    tooltip={
                                        text="Default Image Button. Prints a message to the log and yoru chat."
                                    }
                                }, function (event)
                                minetest.log("Image button pressed.")
                                minetest.chat_send_player(event.player:get_player_name(), "Image button pressed.")
                                end)

                                --[[
                                Item Button
                                ]]
                                local item = ""
                                local desc = ""
                                while(item == "") do
                                    for name, def in pairs(minetest.registered_items) do
                                        if (math.random(1,100) == 1) then
                                            item = name
                                            desc = def.description
                                        end
                                    end
                                end
                                context_tabs2_2:button({
                                    name="item_button",
                                    width=2,
                                    height=2,
                                    item=item,
                                    is_exit=false,
                                    tooltip={
                                        text="Default Item Button. Item: "..desc..". Refreshes UI, selecting another random item."
                                    }
                                }, function (event)
                                    event:mark_for_refresh()
                                end)

                                --[[
                                Toggleables
                                ]]
                                context_tabs2_2:horizontal_box({
                                    texture="",
                                    spacing={x=0.3,y=0},
                                    middle=0,
                                    allignment=qts.scribe.allignment.CENTER,
                                },  function (context_tabs2_3)
                                    context_tabs2_3:button({
                                        name="ColorToggle1",
                                        toggleable=true,
                                        tooltip={
                                            bgcolor=qtcore.styles.stormcloud.BACKGROUND_COLOR_DARKER, -- Stormcloud_darker
                                            fgcolor=qtcore.styles.stormcloud.TEXT_COLOR, -- Stormcloud_text
                                            text="Toggle red-green"
                                        }
                                    }, function (event)
                                        event.userdata.color1 = not event.userdata.color1
                                    end)
                                    :container({}, function (context_tabs2_4)
                                        context_tabs2_4:rect({
                                            position={x=0,y=0},
                                            width=2,
                                            height=0.8,
                                            color=qts.select(context_tabs2_3.userdata.color1, "#FF0000", "#00FF00")
                                        })
                                    end)
                                end)
                                :horizontal_box({
                                    texture="",
                                    spacing={x=0.3,y=0},
                                    middle=0,
                                    allignment=qts.scribe.allignment.CENTER,
                                },  function (context_tabs2_3)
                                    context_tabs2_3:button({
                                        name="ColorToggle2",
                                        toggleable=true,
                                        tooltip={
                                            text="Toggle blue-yellow"
                                        }
                                    }, function (event)
                                        event.userdata.color2 = not event.userdata.color2
                                    end)
                                    :container({}, function (context_tabs2_4)
                                        context_tabs2_4:rect({
                                            position={x=0,y=0},
                                        width=2,
                                        height=0.8,
                                        color=qts.select(context_tabs2_3.userdata.color2, "#0000FF", "#FFFF00")
                                    })
                                end)
                                end)
                                :horizontal_box({
                                texture="",
                                spacing={x=0.3,y=0},
                                middle=0,
                                allignment=qts.scribe.allignment.CENTER,
                                },  function (context_tabs2_3)
                                context_tabs2_3:button({
                                    name="ColorToggle3",
                                    toggleable=true,
                                    tooltip={
                                        text="Toggle white-black"
                                    }
                                }, function (event)
                                    event.userdata.color3 = not event.userdata.color3
                                end)
                                :container({}, function (context_tabs2_4)
                                    context_tabs2_4:rect({
                                        position={x=0,y=0},
                                        width=2,
                                        height=0.8,
                                        color=qts.select(context_tabs2_3.userdata.color3, "#FFFFFF", "#000000")
                                    })  
                                end)
                                end)
                            end) --vertial_box column 1
                            :vertical_box({
                                allignment=qts.scribe.allignment.CENTER,
                                spacing={x=0,y=0.2},
                            },function (context_tabs2_2)
                                context_tabs2_2:text({
                                    name="buttondescriptortextelementcolumn2",
                                    text="Item Visbility - Vertical Box",
                                    font={
                                        bold=true,
                                        size=22,
                                        color=qtcore.styles.stormcloud.TEXT_COLOR, -- Stormcloud_text
                                    },
                                    width=4,
                                    height=1.2
                                })
                                :horizontal_box({
                                    texture="",
                                    spacing={x=0.2,y=0.2},
                                }, function (context_tabs2_3)
                                    context_tabs2_3:button({
                                        name="btn_hideTextElement",
                                        label="Hide",
                                        width=2,
                                        height=0.9,
                                    }, function (event)
                                        event.userdata.hide_text1 = true
                                        event:mark_for_refresh()
                                    end)
                                    :button({
                                        name="btn_showTextElement",
                                        label="Show",
                                        width=2,
                                        height=0.9,
                                    }, function (event)
                                        event.userdata.hide_text1 = false
                                        event:mark_for_refresh()
                                    end)
                                end) --horizontal_box show/hide
                                :text({
                                    text="This text will be hidden.",
                                    font={
                                        size=18,
                                        color=qtcore.styles.stormcloud.TEXT_COLOR, -- Stormcloud_text
                                    },
                                    width=4,
                                    height=1.2,
                                    visibility = qts.select(
                                        context_tabs2_2.userdata.hide_text1, 
                                        qts.scribe.visibility.HIDDEN, 
                                        qts.scribe.visibility.VISIBLE
                                    ),
                                })
                                :separator({
                                    orientation=qts.scribe.orientation.HORIZONTAL,
                                    length=4,
                                    color=qtcore.styles.stormcloud.TEXT_COLOR, -- Stormcloud_text
                                })
                                :horizontal_box({
                                    texture="",
                                    spacing={x=0.2,y=0.2},
                                }, function (context_tabs2_3)
                                    context_tabs2_3:button({
                                        name="btn_collapseTextElement",
                                        label="Collpse",
                                        width=2,
                                        height=0.9,
                                    }, function (event)
                                        event.userdata.hide_text2 = true
                                        event:mark_for_refresh()
                                    end)
                                    :button({
                                        name="btn_revealTextElement",
                                        label="Reveal",
                                        width=2,
                                        height=0.9,
                                    }, function (event)
                                        event.userdata.hide_text2 = false
                                        event:mark_for_refresh()
                                    end)
                                end) --horizontal_box show/hide
                                :text({
                                    text="This text will be collapsed.",
                                    font={
                                        size=18,
                                        color=qtcore.styles.stormcloud.TEXT_COLOR, -- Stormcloud_text
                                    },
                                    width=4,
                                    height=1.2,
                                    visibility = qts.select(
                                        context_tabs2_2.userdata.hide_text2, 
                                        qts.scribe.visibility.COLLAPSED, 
                                        qts.scribe.visibility.VISIBLE
                                    ),
                                })
                                :separator({
                                    orientation=qts.scribe.orientation.HORIZONTAL,
                                    length=4,
                                    color=qtcore.styles.stormcloud.TEXT_COLOR, -- Stormcloud_text
                                })
                                :text({
                                    text="This text will move if the previous text is collapsed.",
                                    font={
                                        size=18,
                                        color=qtcore.styles.stormcloud.TEXT_COLOR, -- Stormcloud_text
                                    },
                                    width=4,
                                    height=1.2,
                                })
                            end) --vertical_box column 2
                            :vertical_box({
                                allignment=qts.scribe.allignment.CENTER,
                                spacing={x=0,y=0.2},
                            }, function (context_tabs2_2)
                                context_tabs2_2:text({
                                    name="buttondescriptortextelementcolumn3",
                                    text="Item Visbility - Vertical Box",
                                    font={
                                        bold=true,
                                        size=22,
                                        color=qtcore.styles.stormcloud.TEXT_COLOR, -- Stormcloud_text
                                    },
                                    width=4,
                                    height=1.2
                                })
                                :model({
                                    name="PlayerModel",
                                    visibility = qts.select(context_tabs2_2.userdata.hide_mesh1, qts.scribe.visibility.HIDDEN, qts.scribe.visibility.VISIBLE),
                                    width=3,
                                    height=6,
                                    mesh="character.x",
                                    textures=minetest.formspec_escape(qts.make_humanoid_texture("player_base.png", nil, nil, nil, nil)),
                                    mouse_control=true,
                                    rotation={x=0,y=180},
                                })
                                :horizontal_box({
                                    texture="",
                                    spacing={x=0.2,y=0.2},
                                }, function (context_tabs2_3)
                                    context_tabs2_3:button({
                                        name="btn_hideMeshElement",
                                        label="Hide",
                                        width=2,
                                        height=0.9,
                                    }, function (event)
                                        event.userdata.hide_mesh1 = true
                                        event:mark_for_refresh()
                                    end)
                                    :button({
                                        name="btn_showMeshElement",
                                        label="Show",
                                        width=2,
                                        height=0.9,
                                    }, function (event)
                                        event.userdata.hide_mesh1 = false
                                        event:mark_for_refresh()
                                    end)
                                end)
                            end)
                        end) --horizontal_box
                    end) --container
                end --page
            }, --tab 2
            {
                tab={
                    name="text_display",
                    label="Text",
                    width=2,
                    height=1,
                    padding={x=0,y=0},
                },
                page=function (context_tab)
                    context_tab:container({
                        texture=qtcore.styles.stormcloud.BG_FANCY,
                        middle=16,
                        padding={x=0.2,y=0.2},
                        position={x=-0.2, y=0},
                        width=18 --inner_size
                    }, function (context_tab3_1)
                        context_tab3_1:vertical_box({
                            texture="",
                            spacing={x=0.2,y=0.2}
                        }, function (context_tab3_2)
                            context_tab3_2:text({
                                name="textblocktitle",
                                text="Text Display Demo",
                                width=18,
                                font={
                                    bold=true,
                                    size=22,
                                    color=qtcore.styles.stormcloud.TEXT_COLOR
                                },
                            })
                            :text({
                                width=18,
                                height=2,
                                horizontal_allignment=qts.scribe.allignment.LEFT,
                                vertical_allignment=qts.scribe.allignment.TOP,
                                text=[[This is a basic textblock.
                                        It can have multiple lines of text in one block.
                                        It can be set indented in LUA, to make the code nice, as Minetest handles removing the leading spaces.
                                        ����This can make it difficult to create intentional leading spaces (try Unicode U+FFFD).]]
                            })
                            :text({
                                name="textblock_markup",
                                width=18,
                                height=4.75,
                                horizontal_allignment=qts.scribe.allignment.LEFT,
                                vertical_allignment=qts.scribe.allignment.TOP,
                                text=[[This text block uses Minetest's markup language to modify the text.
                                    <b>Bold text surrounded by \\<b\\> and \\</b\\>.</b>
                                    <i>Italic text surrounded by \\<i\\> and \\</i\\>.</i>
                                    <u>Underlined text surrounded by \\<u\\> and \\</u\\>.</u>
                                    <bigger>Bigger</bigger>   <big>Big</big>   <normal>Normal</normal>
                                    <mono>minetest.log("monospaced font for code display")
                                    <style color=#8cdcfc>minetest</style><style color=#dadada>.</style><style color=#dcdcad>log</style><style color=#1e9fd7>(</style><style color=#dcdcad>dump</style><style color=#f19f21>(</style><style color=#9a9a9a>event</style><style color=#f19f21>)</style><style color=#1e9fd7>)</style><style color=#59a652> --this line has colors</style></mono>
                                    <action name=clicktext1>Click me to run that function!</action>
                                    ]]
                            }, function (event)
                                if (event.fields.textblock_markup == "action:clicktext1") then
                                    minetest.log("monospaced font for code display")
                                    minetest.log(dump(event)) --this line has colors
                                end
                            end)
                            :text({
                                width=18,
                                height=2.5,
                                horizontal_allignment=qts.scribe.allignment.CENTER,
                                vertical_allignment=qts.scribe.allignment.TOP,
                                text=[[† Unicode Characters! †<mono>
                                ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
                                ┃ We can use box drawing characters too ┃
                                ┃ Watch out for vertical spacing though ┃
                                ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛</mono>]]
                            })
                        end)
                    end) --container
                end
            }, --tab 3
        })
        
    end)

end)

minetest.register_chatcommand("scribetest", {
    params = "",
	description = "Tests Scribe GUI system",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
        if player then
            qts.gui.show_gui(player:get_pos(), player, "dtools:style_debug_gui")
        end
	end
})