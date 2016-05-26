--[[
	'grok' style patterns for LPeg 're' module.

	NOTE: many of these patterns are the result of some quick/naive porting and are yet to be fully verified.
--]]

return {
	USERNAME = "[A-Za-z0-9._-]+",
	USER = "USERNAME",
	INT = "([+-]?([0-9]+))",
	BASE10NUM = "([+-]?(([0-9]+('.'[0-9]+)?) / ('.'[0-9]+)))",
	NUMBER = "(BASENUM10)",
	BASE16NUM = "([+-]?('0x')?([0-9A-Fa-f]+))",
	BASE16FLOAT = "([+-]?('0x')?(([0-9A-Fa-f]+('.'[0-9A-Fa-f]*)?) / ('.'[0-9A-Fa-f]+)))",

	POSINT = "([1-9][0-9]*)",
	NONNEGINT = "([0-9]+)",
	WORD = "%a+",
	NOTSPACE = "%S+",
	SPACE = "%s*",
	DATA = ".*?",
	GREEDYDATA = ".*",
	QUOTEDSTRING = [[('"'('\'. / [^\\"]+)+'"' / '""' / ("'"('\'. / [^\\']+)+"'") / "''" / ("`"('\'. / [^\\`]+)+"`") / "``")]],
	UUID = "[A-Fa-f0-9]^8'-'([A-Fa-f0-9]^4'-')^3[A-Fa-f0-9]^12",

	--	Networking
	MAC = "(CISCOMAC / WINDOWSMAC / COMMONMAC)",
	CISCOMAC = "(([A-Fa-f0-9]^4'.')^2[A-Fa-f0-9]^4)",
	WINDOWSMAC = "(([A-Fa-f0-9]^2'-')^5[A-Fa-f0-9]^2)",
	COMMONMAC = "(([A-Fa-f0-9]^2':')^5[A-Fa-f0-9]^2)",
--TODO	IPV6 ((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?
	IPV4 = "(('25'[0-5] / '2'[0-4][0-9] / [0-1]?[0-9]^2 / [0-9]^1)[.]('25'[0-5] / '2'[0-4][0-9] / [0-1]?[0-9]^2 / [0-9]^1)[.]('25'[0-5] / '2'[0-4][0-9] / [0-1]?[0-9]^2 / [0-9]^1)[.]('25'[0-5] / '2'[0-4][0-9] / [0-1]?[0-9]^2 / [0-9]^1))",
--	IP = "({IPVSIX} / {IPVFOUR})",
	IP = "IPV4",
	HOSTNAME = "([A-Za-z0-9][A-Za-z0-9-]^-62)('.'([A-Za-z0-9][A-Za-z0-9-]^-62))*('.'?)",
	HOST = "HOSTNAME",
	IPORHOST = "(HOSTNAME / IP)",
	HOSTPORT = "IPORHOST':'POSINT",

	-- paths
	PATH = "(UNIXPATH / WINPATH)",
	UNIXPATH = "('/'([%a:_.!$,~@%-]+ / '\'.)*)+",
	TTY = "('/dev/'('pts' / 'tty'([pq])?)(%a+)?'/'?([0-9]+))",
	WINPATH = "([A-Za-z]+':' / '\')('\'[^\\?*]*)+",
	URIPROTO = "[A-Za-z]+('+'[A-Za-z+]+)?",
	URIHOST = "IPORHOST (':' {:port:POSINT:})?",
	-- uripath comes loosely from RFC1738, but mostly from what Firefox
	-- doesn't turn into %XX
	--         (?:/[A-Za-z0-9$.+!*'(){},~:;=@#%_\-]*)+
	URIPATH = "('/'[A-Za-z0-9$.+!*'(){},~:;=@#_%\\-]*)+",
	-- URIPARAM \?(?:[A-Za-z0-9]+(?:=(?:[^&]*))?(?:&(?:[A-Za-z0-9]+(?:=(?:[^&]*))?)?)*)?
	URIPARAM = "'?'([A-Za-z0-9$.+!*'|(){},~@#&/=:;_?%-] / '[' / ']')*",
	URIPATHPARAM = "URIPATH (URIPARAM)?",
	URI = "URIPROTO '://' (USER (':' [^@]*)? '@')? (URIHOST)? (URIPATHPARAM)?",

	-- Months: January, Feb, 3, 03, 12, December
	MONTH = "('Jan'('uary')? / 'Feb'('ruary')? / 'Mar'('ch')? / 'Apr'('il')? / 'May' / 'Jun'('e')? / 'Jul'('y')? / 'Aug'('ust')? / 'Sep'('tember')? / 'Oct'('ober')? / 'Nov'('ember')? / 'Dec'('ember')?)",
	MONTHNUM = "('0'?[1-9]/'1'[0-2])",
	MONTHNUM2 = "('0'[1-9]/'1'[0-2])",
	MONTHDAY = "(('0'[1-9])/([12][0-9])/('3'[01])/[1-9])",

	-- Days: Monday, Tue, Thu, etc...
	DAY = "('Mon'('day')?/'Tue'('sday')?/'Wed'('nesday')?/'Thu'('rsday')?/'Fri'('day')?/'Sat'('urday')?/'Sun'('day')?)",

	-- Years?
	YEAR = "(%d%d)(%d%d)?",
	HOUR = "('2'[0123]/[01]?[0-9])",
	MINUTE = "([0-5][0-9])^1",
	-- '60' is a leap second in most time standards and thus is valid.
	SECOND = "(([0-5]?[0-9]/'60')([:.,][0-9]+)?)",
	TIME = "(HOUR ':' MINUTE (':' SECOND)?)",
	-- datestamp is YYYY/MM/DD-HH:MM:SS.UUUU (or something like it)
	DATEUS = "MONTHNUM [/-] MONTHDAY [/-] YEAR",
	DATEEU = "MONTHDAY [./-] MONTHNUM [./-] YEAR",
	ISO8601TIMEZONE = "('Z' / [+-] HOUR (':'? MINUTE))",
	ISO8601SECOND = "(SECOND / '60')",
	TIMESTAMPISO8601 = "YEAR '-' MONTHNUM '-' MONTHDAY [T ] HOUR ':'? MINUTE (':'? SECOND)? ISO8601TIMEZONE?",
	DATE = "DATEUS / DATEEU",
	DATESTAMP = "DATE [- ] TIME",
	TZ = "([PMCE][SD]'T' / 'UTC')",
	DATESTAMPRFC822 = "DAY ' ' MONTH ' ' MONTHDAY ' ' YEAR ' ' TIME ' ' TZ",
	DATESTAMPRFC2822 = "DAY ', ' MONTHDAY ' ' MONTH ' ' YEAR ' ' TIME ' ' ISO8601TIMEZONE",
	DATESTAMPOTHER = "DAY ' ' MONTH ' ' MONTHDAY ' ' TIME ' ' TZ ' ' YEAR",
	DATESTAMPEVENTLOG = "YEAR MONTHNUM2 MONTHDAY HOUR MINUTE SECOND",
--	HTTPDERROR_DATE %{DAY} %{MONTH} %{MONTHDAY} %{TIME} %{YEAR}

	-- Syslog Dates: Month Day HH:MM:SS
	SYSLOGTIMESTAMP = "MONTH ' ' MONTHDAY ' ' TIME",
	PROG = "(%g*)",
	SYSLOGPROG = "{:program:PROG:} ('[' {:pid:POSINT:} ']')?",
	SYSLOGHOST = "IPORHOST",
	SYSLOGFACILITY = "'<' {:facility:NONNEGINT:}.{:priority:NONNEGINT:} '>'",
	HTTPDATE = "MONTHDAY '/' MONTH '/' YEAR ':' TIME ' ' INT",

	-- Shortcuts
	QS = "QUOTEDSTRING",

	-- Log formats
	SYSLOGBASE = "{:timestamp:SYSLOGTIMESTAMP:} ' ' (SYSLOGFACILITY)? {:logsource:SYSLOGHOST:} ' ' SYSLOGPROG ':'",
	COMMONAPACHELOG = [[{:clientip:IPORHOST:} ' ' {:ident:USER:} ' ' {:auth:USER:} ' [' {:timestamp:HTTPDATE:} '] "' ({:verb:WORD:} ' ' {:request:NOTSPACE:} (' HTTP/' {:httpversion:NUMBER:})? / {:rawrequest:DATA:}) '" ' {:response:NUMBER:} ' ' ({:bytes:NUMBER:} / '-')]],
	COMBINEDAPACHELOG = "COMMONAPACHELOG ' ' {:referrer:QS:} ' ' {:agent:QS:}",
--	HTTPD20_ERRORLOG \[%{HTTPDERROR_DATE:timestamp}\] \[%{LOGLEVEL:loglevel}\] (?:\[client %{IPORHOST:clientip}\] ){0,1}%{GREEDYDATA:errormsg}
--	HTTPD24_ERRORLOG \[%{HTTPDERROR_DATE:timestamp}\] \[%{WORD:module}:%{LOGLEVEL:loglevel}\] \[pid %{POSINT:pid}:tid %{NUMBER:tid}\]( \(%{POSINT:proxy_errorcode}\)%{DATA:proxy_errormessage}:)?( \[client %{IPORHOST:client}:%{POSINT:clientport}\])? %{DATA:errorcode}: %{GREEDYDATA:message}
--	HTTPD_ERRORLOG %{HTTPD20_ERRORLOG}|%{HTTPD24_ERRORLOG}

	-- Log Levels
	LOGLEVEL = "('ALERT' / [Aa]'lert' / 'CRIT'('ICAL')? / [Cc]'rit'('ical')? / 'DEBUG' / ([Dd]'ebug') / 'EMERG'('ENCY')? / [Ee]'merg'('ency')? / 'ERR'('OR')? / [Ee]'rr'('or')? / 'FATAL' / [Ff]'atal' / 'INFO' / [Ii]'nfo' / 'NOTICE' / [Nn]'otice' / 'SEVERE' / [Ss]'evere' / 'TRACE' / [Tt]'race' / 'WARN'('ING')? / [Ww]'arn'('ing')?)",
}
