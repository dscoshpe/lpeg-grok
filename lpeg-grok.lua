--[[
	Fast, efficient, and reusable pattern matching with Lua and LPeg.
--]]

local string = require("string")
local table = require("table")

-- uses the LPeg 're' module
local re = require("re")
-- load the default patterns library
local patterns = dofile("grok/patterns.lua")

Grok = {}

-- recursively fetch all patterns included in the named pattern from the default library or the user supplied patterns
function Grok:fetch(pattern, n, p)
	n = n or {} -- names
	p = p or {} -- patterns
	self.pats = self.pats or {}

	for name in string.gmatch(pattern, "%u+%d*%u*") do
		if string.len(name) >= 2 then
			local pat = self.pats[name] or patterns[name] or nil
			if pat ~= nil then
				if n[name] == nil then
					-- save the pattern locally if its in the list
					n[name] = true
					table.insert(p, name..' <- '..pat)
					self:fetch(pat, n, p)
				end
			else
				print("WARNING: pattern '"..name.."' not found!")
			end
		end
	end

	return table.concat(p, "\n")
end

-- return a new compiled LPeg pattern by name
-- name: name of the snippet to build the pattern for
-- args: any additional args to pass to re.compile
function Grok:compile(name, args)
	-- see if we can make this pattern
	local p = self:fetch(name)

	if #p <= 0 then
		print("ERROR: unable to create the pattern '"..name.."'!")
		return nil	
	end

	-- return the result of the compile (could be an error!)
	return re.compile(p, args)
end

-- initialize a new grok instance
-- patterns = additional patterns to add to or override with the patterns in the default library
function Grok:new(pats)
	return setmetatable({pats = pats or {}}, {__index = Grok})
end

return Grok
