//
//  General purpose patterns used in all openEHR parser and lexer tools
//  author:      Pieter Bos <pieter.bos@nedap.com>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2018- openEHR Foundation <http://www.openEHR.org>
//

lexer grammar base_lexer;

// ---------- path patterns -----------

ADL_PATH : ADL_ABSOLUTE_PATH | ADL_RELATIVE_PATH;
fragment ADL_ABSOLUTE_PATH : ('/' ADL_PATH_SEGMENT)+;
fragment ADL_RELATIVE_PATH : ADL_PATH_SEGMENT ('/' ADL_PATH_SEGMENT)+;

fragment ADL_PATH_SEGMENT      : ALPHA_LC_ID ('[' ADL_PATH_ATTRIBUTE ']')?;
fragment ADL_PATH_ATTRIBUTE    : ID_CODE | STRING | INTEGER | ARCHETYPE_REF;


// ---------- whitespace & comments ----------

WS         : [ \t\r]+    -> channel(HIDDEN) ;
LINE       : '\r'? '\n'  -> channel(HIDDEN) ;  // increment line count
H_CMT_LINE : '--------' '-'*? '\n'  ;         // long comment line for splitting template overlays
CMT_LINE   : '--' .*? '\r'? '\n'  -> skip ;   // (increment line count)

// ---------- various ADL2 codes -------

ROOT_ID_CODE : 'id1' '.1'* ;
ID_CODE      : 'id' CODE_STR ;
AT_CODE      : 'at' CODE_STR ;
AC_CODE      : 'ac' CODE_STR ;
fragment CODE_STR : ('0' | [1-9][0-9]*) ( '.' ('0' | [1-9][0-9]* ))* ;

// ---------- Delimited Regex matcher ------------
// In ADL, a regexp can only exist between {}.
// allows for '/' or '^' delimiters
// logical form - REGEX: '/' ( '\\/' | ~'/' )+ '/' | '^' ( '\\^' | ~'^' )+ '^';
// The following is used to ensure REGEXes don't get mixed up with paths, which use '/' chars

CONTAINED_REGEX: '{' WS* (SLASH_REGEX | CARET_REGEX) WS* (';' WS* STRING)? WS* '}';
fragment SLASH_REGEX: '/' SLASH_REGEX_CHAR+ '/';
fragment SLASH_REGEX_CHAR: ~[/\n\r] | ESCAPE_SEQ | '\\/';

fragment CARET_REGEX: '^' CARET_REGEX_CHAR+ '^';
fragment CARET_REGEX_CHAR: ~[^\n\r] | ESCAPE_SEQ | '\\^';

// ---------- ISO8601 Date/Time values ----------

ISO8601_DATE      : YEAR '-' MONTH ( '-' DAY )? | YEAR '-' MONTH '-' UNKNOWN_DT | YEAR '-' UNKNOWN_DT '-' UNKNOWN_DT ;
ISO8601_TIME      : ( HOUR ':' MINUTE ( ':' SECOND ( SECOND_DEC_SEP DIGIT+ )?)? | HOUR ':' MINUTE ':' UNKNOWN_DT | HOUR ':' UNKNOWN_DT ':' UNKNOWN_DT ) TIMEZONE? ;
ISO8601_DATE_TIME : ( YEAR '-' MONTH '-' DAY 'T' HOUR (':' MINUTE (':' SECOND ( SECOND_DEC_SEP DIGIT+ )?)?)? | YEAR '-' MONTH '-' DAY 'T' HOUR ':' MINUTE ':' UNKNOWN_DT | YEAR '-' MONTH '-' DAY 'T' HOUR ':' UNKNOWN_DT ':' UNKNOWN_DT ) TIMEZONE? ;
fragment TIMEZONE : 'Z' | ('+'|'-') HOUR_MIN ;   // hour offset, e.g. `+0930`, or else literal `Z` indicating +0000.
fragment YEAR     : [0-9][0-9][0-9][0-9] ;		   // Year in ISO8601:2004 is 4 digits with 0-filling as needed
fragment MONTH    : ( [0][1-9] | [1][0-2] ) ;    // month in year
fragment DAY      : ( [0][1-9] | [12][0-9] | [3][0-1] ) ;  // day in month
fragment HOUR     : ( [01]?[0-9] | [2][0-3] ) ;  // hour in 24 hour clock
fragment MINUTE   : [0-5][0-9] ;                 // minutes
fragment HOUR_MIN : ( [01]?[0-9] | [2][0-3] ) [0-5][0-9] ;  // hour / minutes quad digit pattern
fragment SECOND   : [0-5][0-9] ;                 // seconds
fragment SECOND_DEC_SEP : '.' | ',' ;
fragment UNKNOWN_DT  : '??' ;                    // any unknown date/time value, except years.

// ISO8601 DURATION PnYnMnWnDTnnHnnMnn.nnnS 
// here we allow a deviation from the standard to allow weeks to be // mixed in with the rest since this commonly occurs in medicine
// TODO: the following will incorrectly match just 'P'
ISO8601_DURATION : '-'?'P' (DIGIT+ [yY])? (DIGIT+ [mM])? (DIGIT+ [wW])? (DIGIT+[dD])? ('T' (DIGIT+[hH])? (DIGIT+[mM])? (DIGIT+ (SECOND_DEC_SEP DIGIT+)?[sS])?)? ;

// ------------------- special word symbols --------------
SYM_TRUE  : [Tt][Rr][Uu][Ee] ;
SYM_FALSE : [Ff][Aa][Ll][Ss][Ee] ;

// ---------------------- Identifiers ---------------------

ARCHETYPE_HRID      : ARCHETYPE_HRID_ROOT '.v' ARCHETYPE_VERSION_ID ;
ARCHETYPE_REF       : ARCHETYPE_HRID_ROOT '.v' INTEGER ( '.' DIGIT+ )* ;
fragment ARCHETYPE_HRID_ROOT : (NAMESPACE '::')? IDENTIFIER '-' IDENTIFIER '-' IDENTIFIER '.' LABEL ;
fragment ARCHETYPE_VERSION_ID: DIGIT+ ('.' DIGIT+ ('.' DIGIT+ ( ( '-rc' | '-alpha' ) ( '.' DIGIT+ )? )?)?)? ;
VERSION_ID          : DIGIT+ '.' DIGIT+ '.' DIGIT+ ( ( '-rc' | '-alpha' ) ( '.' DIGIT+ )? )? ;
fragment IDENTIFIER : ALPHA_CHAR WORD_CHAR* ;

// --------------------- composed primitive types -------------------

TERM_CODE_REF : '[' TERM_CODE_CHAR+ ( '(' TERM_CODE_CHAR+ ')' )? '::' TERM_CODE_CHAR+ ']' ;  // e.g. [ICD10AM(1998)::F23]; [ISO_639-1::en]
fragment TERM_CODE_CHAR: NAME_CHAR | '.';

// --------------------- URIs --------------------

EMBEDDED_URI: '<' ([ \t\r\n]|CMT_LINE)* URI ([ \t\r\n]|CMT_LINE)* '>';

// URI recogniser based on https://tools.ietf.org/html/rfc3986 and
// http://www.w3.org/Addressing/URL/5_URI_BNF.html

fragment URI : URI_SCHEME ':' URI_HIER_PART ( '?' URI_QUERY )? ('#' URI_FRAGMENT)? ;

fragment URI_HIER_PART : ( '//' URI_AUTHORITY ) URI_PATH_ABEMPTY
    | URI_PATH_ABSOLUTE
    | URI_PATH_ROOTLESS
    | URI_PATH_EMPTY;

fragment URI_SCHEME : ALPHA_CHAR ( ALPHA_CHAR | DIGIT | '+' | '-' | '.')* ;

fragment URI_AUTHORITY : ( URI_USERINFO '@' )? URI_HOST ( ':' URI_PORT )? ;
fragment URI_USERINFO: (URI_UNRESERVED | URI_PCT_ENCODED | URI_SUB_DELIMS | ':' )* ;
fragment URI_HOST : URI_IP_LITERAL | URI_IPV4_ADDRESS | URI_REG_NAME ; //TODO: ipv6
fragment URI_PORT: DIGIT*;

fragment URI_IP_LITERAL   : '[' URI_IPV6_LITERAL ']'; //TODO, if needed: IPvFuture
fragment URI_IPV4_ADDRESS : URI_DEC_OCTET '.' URI_DEC_OCTET '.' URI_DEC_OCTET '.' URI_DEC_OCTET ;
fragment URI_IPV6_LITERAL : HEX_QUAD (':' HEX_QUAD )* '::' HEX_QUAD (':' HEX_QUAD )* ;

fragment URI_DEC_OCTET  : DIGIT | [1-9] DIGIT | '1' DIGIT DIGIT | '2' [0-4] DIGIT | '25' [0-5];
fragment URI_REG_NAME: (URI_UNRESERVED | URI_PCT_ENCODED | URI_SUB_DELIMS)*;
fragment HEX_QUAD : HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT ;

fragment URI_PATH_ABEMPTY: ('/' URI_SEGMENT ) *;
fragment URI_PATH_ABSOLUTE: '/' ( URI_SEGMENT_NZ ( '/' URI_SEGMENT )* )?;
fragment URI_PATH_NOSCHEME: URI_SEGMENT_NZ_NC ( '/' URI_SEGMENT )*;
fragment URI_PATH_ROOTLESS: URI_SEGMENT_NZ ( '/' URI_SEGMENT )*;
fragment URI_PATH_EMPTY: ;

fragment URI_SEGMENT: URI_PCHAR*;
fragment URI_SEGMENT_NZ: URI_PCHAR+;
fragment URI_SEGMENT_NZ_NC: ( URI_UNRESERVED | URI_PCT_ENCODED | URI_SUB_DELIMS | '@' )+; //non-zero-length segment without any colon ":"

fragment URI_PCHAR: URI_UNRESERVED | URI_PCT_ENCODED | URI_SUB_DELIMS | ':' | '@';

//fragment URI_PATH   : '/' | ( '/' URI_XPALPHA+ )+ ('/')?;
fragment URI_QUERY : (URI_PCHAR | '/' | '?')*;
fragment URI_FRAGMENT  : (URI_PCHAR | '/' | '?')*;

fragment URI_PCT_ENCODED : '%' HEX_DIGIT HEX_DIGIT ;

fragment URI_UNRESERVED: ALPHA_CHAR | DIGIT | '-' | '.' | '_' | '~';
fragment URI_RESERVED: URI_GEN_DELIMS | URI_SUB_DELIMS;
fragment URI_GEN_DELIMS: [:/?#[\]@];
fragment URI_SUB_DELIMS: [!$&'()*+,;=];

// ------------------ miscellaneous identifier fragments ----------------

// According to IETF http://tools.ietf.org/html/rfc1034[RFC 1034] and http://tools.ietf.org/html/rfc1035[RFC 1035],
// as clarified by http://tools.ietf.org/html/rfc2181[RFC 2181] (section 11)
fragment NAMESPACE : LABEL ('.' LABEL)* ;
fragment LABEL : ALPHA_CHAR (NAME_CHAR | URI_PCT_ENCODED)* ;

GUID : HEX_DIGIT+ '-' HEX_DIGIT+ '-' HEX_DIGIT+ '-' HEX_DIGIT+ '-' HEX_DIGIT+ ;

ALPHA_UC_ID :   ALPHA_UCHAR WORD_CHAR* ;   // used for type ids
ALPHA_LC_ID :   ALPHA_LCHAR WORD_CHAR* ;   // used for attribute / method ids
ALPHA_UNDERSCORE_ID : '_' WORD_CHAR* ;     // usually used for meta-model ids

// --------------------- atomic primitive types -------------------

INTEGER : DIGIT+ E_SUFFIX? ;
REAL :    DIGIT+ '.' DIGIT+ E_SUFFIX? ;
fragment E_SUFFIX : [eE][+-]? DIGIT+ ;

STRING : '"' STRING_CHAR*? '"' ;
fragment STRING_CHAR : ~["\\] | ESCAPE_SEQ | UTF8CHAR ; // strings can be multi-line

CHARACTER : '\'' CHAR '\'' ;
fragment CHAR : ~['\\\r\n] | ESCAPE_SEQ | UTF8CHAR  ;

fragment ESCAPE_SEQ: '\\' ['"?abfnrtv\\] ;

// ------------------- character fragments ------------------

fragment NAME_CHAR     : WORD_CHAR | '-' ;
fragment WORD_CHAR     : ALPHANUM_CHAR | '_' ;
fragment ALPHANUM_CHAR : ALPHA_CHAR | DIGIT ;

fragment ALPHA_CHAR  : [a-zA-Z] ;
fragment ALPHA_UCHAR : [A-Z] ;
fragment ALPHA_LCHAR : [a-z] ;
fragment UTF8CHAR    : '\\u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT ;

fragment DIGIT     : [0-9] ;
fragment HEX_DIGIT : [0-9a-fA-F] ;

// ---------- symbols ----------

SYM_ASSIGNMENT: ':=';

SYM_GT : '>' ;
SYM_LT : '<' ;
SYM_LE : '<=' | '≤' ;
SYM_GE : '>=' | '≥' ;
SYM_NE : '/=' | '!=' | '≠' ;
SYM_EQ : '=' ;
SYM_PLUS_OR_MINUS : '+/-' | '±' ;

SYM_THEN     : [Tt][Hh][Ee][Nn] ;
SYM_AND      : [Aa][Nn][Dd] | '∧' ;
SYM_OR       : [Oo][Rr] | '∨' ;
SYM_XOR      : [Xx][Oo][Rr] ;
SYM_NOT      : [Nn][Oo][Tt] | '!' | '~' | '¬' ;
SYM_IMPLIES  : [Ii][Mm][Pp][Ll][Ii][Ee][Ss] | '⇒' ;
SYM_FOR_ALL: 'for_all' | '∀' ;
SYM_THERE_EXISTS: 'there_exists' | '∃' ;

SYM_EXISTS: 'exists' ;
SYM_IN: ':' | 'in' ;
SYM_LIST_CONTINUE: '...' ;
SYM_INTERVAL_SEP: '..' ;

SYM_MATCHES : [Mm][Aa][Tt][Cc][Hh][Ee][Ss] | [Ii][Ss]'_'[Ii][Nn] | '∈' ;

INCLUDED_LANGUAGE_FRAGMENT: '(' ALPHANUM_CHAR+ ')' (WS|LINE)* '<#' .*? '#>';

