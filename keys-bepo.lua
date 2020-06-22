-- Source : https://bepo.fr/wiki/Awesome
-- TODO : Clean this up
--  - Should be a module
--  - Should be a drop-in replacement of keys.lua
--  - Should be cleaned up to be on par with current qwerty bindings
--  - Should be able to live on parity with qwerty keys
--  - Should be switched on key layout change ???





-- {{{ Key bindings
 
-- Bind keyboard digits
-- Compute the maximum number of digit we need, limited to 9 keynumber = 0
for s = 1, screen.count() do
 keynumber = math.min(9, math.max(#tags[s], keynumber));
end
 
'''local bepo_numkeys = {'''
   '''[0]="asterisk", "quotedbl", "guillemotleft", "guillemotright", "parenleft", "parenright", "at", "plus", "minus", "slash"'''
'''}'''    
 
for i = 1, keynumber do
   keybinding({ modkey }, '''bepo_numkeys[i]''',
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewonly(tags[screen][i])
                      end
                  end):add()
   keybinding({ modkey, "Control" }, '''bepo_numkeys[i]''',
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          tags[screen][i].selected = not tags[screen][i].selected
                      end
                  end):add()
   keybinding({ modkey, "Shift" }, '''bepo_numkeys[i]''',
                  function ()
                      if client.focus then
                          if tags[client.focus.screen][i] then
                              awful.client.movetotag(tags[client.focus.screen][i])
                          end
                      end
                  end):add()
   keybinding({ modkey, "Control", "Shift" }, '''bepo_numkeys[i]''',
                  function ()
                      if client.focus then
                          if tags[client.focus.screen][i] then
                              awful.client.toggletag(tags[client.focus.screen][i])
                          end
                      end
                  end):add()
end
 
keybinding({ modkey }, "Left", awful.tag.viewprev):add()
keybinding({ modkey }, "Right", awful.tag.viewnext):add()
keybinding({ modkey }, "Escape", awful.tag.history.restore):add()
 
-- Standard program
keybinding({ modkey }, "Return", function () awful.util.spawn(terminal) end):add()
 
keybinding({ modkey, "Control" }, "'''h'''", function ()
                                          mypromptbox[mouse.screen].text =
                                              awful.util.escape(awful.util.restart())
                                       end):add()
keybinding({ modkey, "Shift" }, "q", awesome.quit):add()
 
-- Client manipulation
keybinding({ modkey }, "m", awful.client.maximize):add()
keybinding({ modkey }, "f", function () if client.focus then client.focus.fullscreen = not client.focus.fullscreen end end):add()
keybinding({ modkey, "Shift" }, '''"x"''', function () if client.focus then client.focus:kill() end end):add()
keybinding({ modkey }, '''"t"''', function () awful.client.focus.byidx(1); if client.focus then client.focus:raise() end end):add()
keybinding({ modkey }, '''"s"''', function () awful.client.focus.byidx(-1);  if client.focus then client.focus:raise() end end):add()
keybinding({ modkey, "Shift" }, '''"t"''', function () awful.client.swap.byidx(1) end):add()
keybinding({ modkey, "Shift" }, '''"s"''', function () awful.client.swap.byidx(-1) end):add()
keybinding({ modkey, "Control" }, '''"t"''', function () awful.screen.focus(1) end):add()
keybinding({ modkey, "Control" }, '''"s"''', function () awful.screen.focus(-1) end):add()
keybinding({ modkey, "Control" }, "space", awful.client.togglefloating):add()
keybinding({ modkey, "Control" }, "Return", function () if client.focus then client.focus:swap(awful.client.getmaster()) end end):add()
keybinding({ modkey }, "o", awful.client.movetoscreen):add()
keybinding({ modkey }, "Tab", awful.client.focus.history.previous):add()
keybinding({ modkey }, "u", awful.client.urgent.jumpto):add()
keybinding({ modkey, "Shift" }, '''"h"''', function () if client.focus then client.focus:redraw() end end):add()
 
-- Layout manipulation
keybinding({ modkey }, '''"r"''', function () awful.tag.incmwfact(0.05) end):add()
keybinding({ modkey }, '''"c"''', function () awful.tag.incmwfact(-0.05) end):add()
keybinding({ modkey, "Shift" }, '''"c"''', function () awful.tag.incnmaster(1) end):add()
keybinding({ modkey, "Shift" }, '''"r"''', function () awful.tag.incnmaster(-1) end):add()
keybinding({ modkey, "Control" }, '''"c"''', function () awful.tag.incncol(1) end):add()
keybinding({ modkey, "Control" }, '''"r"''', function () awful.tag.incncol(-1) end):add()
keybinding({ modkey }, "space", function () awful.layout.inc(layouts, 1) end):add()
keybinding({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end):add()
 
-- Prompt
keybinding({ modkey }, "F1", function ()
                                awful.prompt.run({ prompt = "Run: " }, mypromptbox[mouse.screen], awful.util.spawn, awful.completion.bash,
                                                 awful.util.getdir("cache") .. "/history")
                            end):add()
keybinding({ modkey }, "F4", function ()
                                awful.prompt.run({ prompt = "Run Lua code: " }, mypromptbox[mouse.screen], awful.util.eval, awful.prompt.bash,
                                                 awful.util.getdir("cache") .. "/history_eval")
                            end):add()
 
keybinding({ modkey, "Ctrl" }, "i", function ()
                                       local s = mouse.screen
                                       if mypromptbox[s].text then
                                           mypromptbox[s].text = nil
                                       elseif client.focus then
                                           mypromptbox[s].text = nil
                                           if client.focus.class then
                                               mypromptbox[s].text = "Class: " .. client.focus.class .. " "
                                           end
                                           if client.focus.instance then
                                               mypromptbox[s].text = mypromptbox[s].text .. "Instance: ".. client.focus.instance .. " "
                                           end
                                           if client.focus.role then
                                               mypromptbox[s].text = mypromptbox[s].text .. "Role: ".. client.focus.role
                                           end
                                       end
                                   end):add()
 
-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
keybinding({ modkey }, '''"j"''', awful.client.togglemarked):add() 
 
for i = 1, keynumber do
   keybinding({ modkey, "Shift" }, "F" .. i,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          for k, c in pairs(awful.client.getmarked()) do
                              awful.client.movetotag(tags[screen][i], c)
                          end
                      end
                  end):add()
end
-- }}}
