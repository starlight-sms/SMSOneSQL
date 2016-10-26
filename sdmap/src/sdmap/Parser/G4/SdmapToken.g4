﻿lexer grammar SdmapToken;

STRING:
	'"' (('\\' (["\\/bfnrt] | UNICODE)) | ~ ["\\])* '"' | 
	'\'' (('\\' (['\\/bfnrt] | UNICODE)) | ~ ['\\])* '\'';

fragment UNICODE: 
	'u' HEX HEX HEX HEX;

fragment HEX: 
	[0-9a-fA-F];

NUMBER: 
	'-'? INT '.' [0-9] + EXP? | '-'? INT EXP | '-'? INT;

fragment INT: 
	'0' | [1-9] [0-9]*;

fragment EXP: 
	[Ee] [+\-]? INT;

DATE:
	INT '-' INT '-' INT;

SYNTAX: 
	[a-zA-Z_] [0-9a-zA-Z_]*;

WS: 
	[ \t\n\r] +     -> skip;

BlockComment: 
	'/*' .*? '*/' -> skip;

LineComment: 
	'//' ~[\r\n]* -> skip;

BeginNamedSql:
	'sql' SYNTAX '{' -> pushMode(SQL);

BeginUnnamedSql:
	'sql' '{' -> pushMode(SQL);

ExitDirectiveMode:
	'>' -> popMode;

mode SQL;
SqlText: 
	~('#' | '}')+;

EndSql:
	.*? '}' -> popMode;

EnterDirectiveMode:
	'#' SYNTAX '<' -> pushMode(DEFAULT_MODE);