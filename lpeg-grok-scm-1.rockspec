package = "lpeg-grok"
version = "scm-1"
source = {
    url = "git://github.com/dscoshpe/lpeg-grok",
    tag = "HEAD",
}
description = {
    summary = "Fast, efficient, and reusable pattern matching with Lua and LPeg.",
    detailed = [[
        This is an example for the LuaRocks tutorial.
        Here we would put a detailed, typically
        paragraph-long description.
    ]],
    homepage = "https://github.com/dscoshpe/lpeg-grok",
    license = "MIT/X11"
}
dependencies = {
    "lua ~> 5.1",
    "lpeg >= 1"
}
build = {
    type = "builtin",
    modules = {
        ["lpeg-grok"] = "grok.lua",
        ["lpeg-grok.patterns"] = "patterns.lua"
    }
}
