--[[
	A 'grok' style Lua module
]]

local string = require("string")
local table = require("table")

-- uses the LPeg 're' module
local re = require("re")
-- loads snippets list from 'snippets.lua'
local snippets = require("snippets")

-- gather up all the neded pattern snippets
local function getSnippets(snippet, n, s)
	n = n or {} -- names
	s = s or {} -- snippets

	for name in string.gmatch(snippet, "%u+%d*%u*") do
		if string.len(name) >= 2 then
			if snippets[name] then
				if n[name] == nil then
					-- save the snippet locally if its in the list
					n[name] = true
					table.insert(s, name..' <- '..snippets[name])
					getSnippets(snippets[name], n, s)
				end
			else
				print("WARNING: snippet '"..name.."' not found in snippets list!")
			end
		end
	end

	return table.concat(s, "\n")
end

-- name: name of the snippet to build the pattern for
-- snips: any of the user's extra snippets to add to the list
-- args: any additional args to pass to re.compile
local function getPattern(name, snips, args)
	snips = snips or {}

	-- load any new snippets
	for n,s in pairs(snips) do
		if not snippets[n] then
			snippets[n] = s
		else
			print("WARNING: snippet '"..s.."' already exists in the snippets list!")
		end
	end

	-- get all the snippets for the pattern, and compile with the provided args, return pattern
	local s = getSnippets(name)
	if #s > 0 then
		return re.compile(s, args)
	else
		return nil
	end
end

return {getPattern = getPattern}
