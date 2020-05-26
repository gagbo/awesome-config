##
# Awesome config
#
# @file
# @version 0.1

lint:
	@luacheck keys.lua helpers.lua rc.lua titlebars.lua themes bar_themes

test:
	@Xephyr :5 & sleep 1 ; DISPLAY=:5 awesome

@PHONY: lint test

# end
