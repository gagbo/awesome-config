##
# Awesome config
#
# @file
# @version 0.1

lint:
	luacheck keys.lua helpers.lua rc.lua titlebars.lua themes bar_themes

@PHONY: lint

# end
