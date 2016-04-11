--[[
		'grok' style pattern snippets using LPeg 're' module for the Heka grok plugin.
]]

return {
	MONTH = "('Jan'('uary')?/'Feb'('ruary')?/'Mar'('ch')?/'Apr'('il')?/'May'/'Jun'('e')?/'Jul'('y')?/'Aug'('ust')?/'Sep'('tember')?/'Oct'('ober')?/'Nov'('ember')?/'Dec'('ember')?)",
	MONTHNUM = "('0'?[1-9]/'1'[0-2])",
	MONTHNUMTWO = "('0'[1-9]/'1'[0-2])",
	MONTHDAY = "(('0'[1-9])/([12][0-9])/('3'[01])/[1-9])",
	DAY = "('Mon'('day')?/'Tue'('sday')?/'Wed'('nesday')?/'Thu'('rsday')?/'Fri'('day')?/'Sat'('urday')?/'Sun'('day')?)",
	YEAR = "(%d%d)(%d%d)?",
	HOUR = "('2'[0123]/[01]?[0-9])",
	MINUTE = "([0-5][0-9])^1",
	SECOND = "(([0-5]?[0-9]/'60')([:.,][0-9]+)?)",
	TIME = "(HOUR ':' MINUTE (':' SECOND)?)",
}
