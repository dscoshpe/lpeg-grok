--[[
	Test suite for the lpeg-grok module.
--]]

local grok = require("grok")

local testcases = {
	{
		description = "p0f output",
		name = "POF",
		patterns = {
		   POF = "'[' {:date: (YEAR '/' MONTHNUM2 '/' MONTHDAY) :} ' ' {:time: TIME :} '] ' {:fields: {| (POFFIELD '|'?)+ |} :}",
		   POFFIELD = "{| {:name: POFKEY :} '=' {:value: POFVALUE :} |}",
		   POFKEY = "[^=]+",
		   POFVALUE = "[^|%nl]*"
		},
		samples = {
			{
				input = "[2014/06/30 06:46:34] mod=syn+ack|cli=10.136.24.202/51023|srv=23.21.244.166/80|subj=srv|os=Linux 3.x|dist=0|params=none|raw_sig=4:64+0:0:1432:mss*10,0:mss,nop,nop,sok:df:0",
				verify = {
					date = "2014/06/30",
					time = "06:46:34",
					fields = {
						[1] = {name = "mod", value = "syn+ack"},
						[2] = {name = "cli", value = "10.136.24.202/51023"},
						[3] = {name = "srv", value = "23.21.244.166/80"},
						[4] = {name = "subj", value = "srv"},
						[5] = {name = "os", value = "Linux 3.x"},
						[6] = {name = "dist", value = "0"},
						[7] = {name = "params", value = "none"},
						[8] = {name = "raw_sig", value = "4:64+0:0:1432:mss*10,0:mss,nop,nop,sok:df:0"}
					}
				}
			}
		}
	},
	{
		description = "simple syslog line",
		name = "SYSLOGLINE",
		patterns = {},
		samples = {
			{ -- #1
				input = "Mar 16 00:01:25 evita postfix/smtpd[1713]: connect from camomile.cloud9.net[168.100.1.3]",
				verify = {
					tags = nil,
					logsource = "evita",
					timestamp = "Mar 16 00:01:25",
					message = "connect from camomile.cloud9.net[168.100.1.3]",
					program = "postfix/smtpd",
					pid = "1713"
				}
			}
		}
	},
	{
		description = "ietf 5424 syslog line",
		name = "SYSLOG5424LINE",
		patterns = {},
		samples = {
			{ -- #1
				input = '<191>1 2009-06-30T18:30:00+02:00 paxton.local grokdebug 4123 - [id1 foo="bar" blah="zay"][id2 baz="something"] Hello, syslog.',
				verify = {
					tags = nil,
					syslog5424_pri = "191",
					syslog5424_ver = "1",
					syslog5424_ts = "2009-06-30T18:30:00+02:00",
					syslog5424_host = "paxton.local",
					syslog5424_app = "grokdebug",
					syslog5424_proc = "4123",
					syslog5424_msgid = nil,
					syslog5424_sd = {
						[1] = {
							id = "id1",
							params = {
								[1] = { name = "foo", value = "bar" },
								[2] = { name = "blah", value = "zay" }
							}
						},
						[2] = {
							id = "id2",
							params = {
								[1] = { name = "baz", value = "something" }
							}
						}
					},
					syslog5424_msg = "Hello, syslog."
				}
			},
			{ -- #2
				input = '<191>1 2009-06-30T18:30:00+02:00 paxton.local grokdebug - - [id1 foo="bar"] No process ID.',
				verify = {
					tags = nil,
					syslog5424_pri = "191",
					syslog5424_ver = "1",
					syslog5424_ts = "2009-06-30T18:30:00+02:00",
					syslog5424_host = "paxton.local",
					syslog5424_app = "grokdebug",
					syslog5424_proc = nil,
					syslog5424_msgid = nil,
					syslog5424_sd = {
						[1] = {
							id = "id1",
							params = {
								[1] = { name = "foo", value = "bar" }
							}
						}
					},
					syslog5424_msg = "No process ID."
				}
			},
			{ -- #3
				input = '<191>1 2009-06-30T18:30:00+02:00 paxton.local grokdebug 4123 - - No structured data.',
				verify = {
					tags = nil,
					syslog5424_pri = "191",
					syslog5424_ver = "1",
					syslog5424_ts = "2009-06-30T18:30:00+02:00",
					syslog5424_host = "paxton.local",
					syslog5424_app = "grokdebug",
					syslog5424_proc = "4123",
					syslog5424_msgid = nil,
					syslog5424_sd = nil,
					syslog5424_msg = "No structured data."
				}
			},
			{ -- #4
				input = '<191>1 2009-06-30T18:30:00+02:00 paxton.local grokdebug - - - No PID or SD.',
				verify = {
					tags = nil,
					syslog5424_pri = "191",
					syslog5424_ver = "1",
					syslog5424_ts = "2009-06-30T18:30:00+02:00",
					syslog5424_host = "paxton.local",
					syslog5424_app = "grokdebug",
					syslog5424_proc = nil,
					syslog5424_msgid = nil,
					syslog5424_sd = nil,
					syslog5424_msg = "No PID or SD."
				}
			},
			{ -- #5
				input = '<191>1 2009-06-30T18:30:00+02:00 paxton.local grokdebug 4123 -  Missing structured data.',
				verify = {
					tags = nil,
					syslog5424_pri = "191",
					syslog5424_ver = "1",
					syslog5424_ts = "2009-06-30T18:30:00+02:00",
					syslog5424_host = "paxton.local",
					syslog5424_app = "grokdebug",
					syslog5424_proc = "4123",
					syslog5424_msgid = nil,
					syslog5424_sd = nil,
					syslog5424_msg = "Missing structured data."
				}
			},
			{ -- #6
				input = '<191>1 2009-06-30T18:30:00+02:00 paxton.local grokdebug  4123 - - Additional spaces.',
				verify = {
					tags = nil,
					syslog5424_pri = "191",
					syslog5424_ver = "1",
					syslog5424_ts = "2009-06-30T18:30:00+02:00",
					syslog5424_host = "paxton.local",
					syslog5424_app = "grokdebug",
					syslog5424_proc = "4123",
					syslog5424_msgid = nil,
					syslog5424_sd = nil,
					syslog5424_msg = "Additional spaces."
				}
			},
			{ -- #7
				input = '<191>1 2009-06-30T18:30:00+02:00 paxton.local grokdebug  4123 -  Additional spaces and missing SD.',
				verify = {
					tags = nil,
					syslog5424_pri = "191",
					syslog5424_ver = "1",
					syslog5424_ts = "2009-06-30T18:30:00+02:00",
					syslog5424_host = "paxton.local",
					syslog5424_app = "grokdebug",
					syslog5424_proc = "4123",
					syslog5424_msgid = nil,
					syslog5424_sd = nil,
					syslog5424_msg = "Additional spaces and missing SD."
				}
			},
			{ -- #8
				input = '<30>1 2014-04-04T16:44:07+02:00 osctrl01 dnsmasq-dhcp 8048 - -  Appname contains a dash',
				verify = {
					tags = nil,
					syslog5424_pri = "30",
					syslog5424_ver = "1",
					syslog5424_ts = "2014-04-04T16:44:07+02:00",
					syslog5424_host = "osctrl01",
					syslog5424_app = "dnsmasq-dhcp",
					syslog5424_proc = "8048",
					syslog5424_msgid = nil,
					syslog5424_sd = nil,
					syslog5424_msg = "Appname contains a dash"
				}
			},
			{ -- #9
				input = '<30>1 2014-04-04T16:44:07+02:00 osctrl01 - 8048 - -  Appname is nil',
				verify = {
					tags = nil,
					syslog5424_pri = "30",
					syslog5424_ver = "1",
					syslog5424_ts = "2014-04-04T16:44:07+02:00",
					syslog5424_host = "osctrl01",
					syslog5424_app = nil,
					syslog5424_proc = "8048",
					syslog5424_msgid = nil,
					syslog5424_sd = nil,
					syslog5424_msg = "Appname is nil"
				}
			}
		}
	}
}


local function checkRecord(known, unknown)
	for k,v in pairs(known) do
		--print(k)
		if type(known[k]) == "table" then
			if type(unknown[k]) ~= "table" then
				print("ERROR: did not get expected table for element '"..k.."' of parsed output!")
				return nil
			else
				if checkRecord(known[k], unknown[k]) == nil then return nil end
			end
		else
			if type(unknown) ~= 'table' then
				print("ERROR: the returned matches don't make sense!")
				print(unknown)
				return nil
			end
			if known[k] ~= unknown[k] then
				local tmpk = known[k] or "nil"
				local tmpu = unknown[k] or "nil"
				print("ERROR: key '"..k.."' failed, expected '"..tmpk.."' got '"..tmpu.."'")
				return nil
			end
		end
	end

	return true
end

for i,tc in pairs(testcases) do
	local failed = false
	print("\n---> Test #"..i..": "..tc.description)
	local p = grok:new(tc.patterns):compile(tc.name)

	if p then
		for j,s in pairs(tc.samples) do
			local matches = p:match(s.input)
			if checkRecord(s.verify, matches) then print("---> #"..i.."."..j..": ok") else failed = true end
		end
	else
		print("ERROR: failed to gather a pattern for '"..tc.name.."' from the available patterns!")
		failed = true
	end

	if failed then print("---> FAILED!!!") end
end

print()