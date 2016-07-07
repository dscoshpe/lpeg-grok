# lpeg-grok

Fast, efficient, and reusable pattern matching with Lua and [LPeg](http://www.inf.puc-rio.br/~roberto/lpeg/).

# Installation

```sh
git clone https://github.com/dscoshpe/lpeg-grok.git
cd lpeg-grok
luarocks make
```

# Usage

```lua
local grok = require("lpeg-grok")

-- optionally, create an instance which adds its own patterns to the library
local my_grok = grok:new({MYPAT="custom patterns"})

-- compile the pattern
local my_pattern = my_grok:compile("MYPAT")
-- OR, do it all at once
local my_pattern = require("lpeg-grok"):new({MYPAT="custom pattern"}):compile("MYPAT")

-- do some matching
my_pattern:match("some string")
```

# Patterns

Patterns generally follow the [LPeg `re` module syntax](http://www.inf.puc-rio.br/~roberto/lpeg/re.html) with the additional assumption that words in ALLCAPS *may* be used to reference other patterns.

Patterns are stored in a Lua table by their name, like so:

```lua
patterns = {
	TIMESTAMP = "{:date: (YEAR '/' MONTHNUM2 '/' MONTHDAY) :} ' ' {:time: TIME :}",
	YEAR = "(%d%d)(%d%d)?",
	MONTHNUM2 = "('0'[1-9]/'1'[0-2])",
	MONTHDAY = "(('0'[1-9])/([12][0-9])/('3'[01])/[1-9])",
	TIME = "(HOUR ':' MINUTE (':' SECOND)?)",
	HOUR = "('2'[0123]/[01]?[0-9])",
	MINUTE = "([0-5][0-9])^1",
	SECOND = "(([0-5]?[0-9]/'60')([:.,][0-9]+)?)",
}
```

The `grok:compile(name)` method will search the table for the name of the pattern to compile. If found, it will then recursively search that pattern's string for words with all capital letters and search the table for patterns with those names as well until no more patterns are needed. Each pattern is then incorporated in to the larger grok pattern to be compiled. For example, every pattern listed in the table above would be incorporated upon `grok:compile("TIMESTAMP")`.

Patterns may be included for specific or immediate needs by passing a table of the same form as the table above as an argument to `grok:new()`. Patterns included using that method can represent patterns that are not in the default collection *or* override patterns that are.

# Matching

Matching is done entirely by LPeg.

Patterns that include LPeg capture syntax (e.g.: `{| p |}`, `{:name: p :}`) will return structured Lua tables when they match. For example:

```lua
grok:compile("TIMESTAMP"):match("2014/06/30 06:46:34")
```
would return:
```lua
{
	date = "2014/06/30",
	time = "06:46:34"
}
```

# TODO

- [ ] verify all of the patterns in the default collection
- [x] finish the testing script (busted?)
- [x] implement installation procedure (luarocks)
- [ ] add an optional 'optimize' step in case optimizing lpeg is used
- [ ] add automated documentation
