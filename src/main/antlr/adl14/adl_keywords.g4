//
// description: Antlr4 lexer grammar for keywords of Archetype Definition Language (ADL2)
// author:      Thomas Beale <thomas.beale@openehr.org>
// support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
// copyright:   Copyright (c) 2015 openEHR Foundation
// license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

lexer grammar adl_keywords;

// ADL keywords
SYM_ARCHETYPE   : [Aa][Rr][Cc][Hh][Ee][Tt][Yy][Pp][Ee] ;

SYM_SPECIALIZE  : '\n'[Ss][Pp][Ee][Cc][Ii][Aa][Ll][Ii][SsZz][Ee] ;
SYM_LANGUAGE    : '\n'[Ll][Aa][Nn][Gg][Uu][Aa][Gg][Ee] ;
SYM_DESCRIPTION : '\n'[Dd][Ee][Ss][Cc][Rr][Ii][Pp][Tt][Ii][Oo][Nn] ;
SYM_DEFINITION  : '\n'[Dd][Ee][Ff][Ii][Nn][Ii][Tt][Ii][Oo][Nn] ;
SYM_INVARIANT   : '\n'[Ii][Nn][Vv][Aa][Rr][Ii][Aa][Nn][Tt] ;
SYM_ONTOLOGY    : '\n'[Oo][Nn][Tt][Oo][Ll][Oo][Gg][Yy] ;
SYM_ANNOTATIONS : '\n'[Aa][Nn][Nn][Oo][Tt][Aa][Tt][Ii][Oo][Nn][Ss] ;

// CADL keywords
SYM_EXISTENCE   : [Ee][Xx][Ii][Ss][Tt][Ee][Nn][Cc][Ee] ;
SYM_OCCURRENCES : [Oo][Cc][Cc][Uu][Rr][Rr][Ee][Nn][Cc][Ee][Ss] ;
SYM_CARDINALITY : [Cc][Aa][Rr][Dd][Ii][Nn][Aa][Ll][Ii][Tt][Yy] ;
SYM_ORDERED     : [Oo][Rr][Dd][Ee][Rr][Ee][Dd] ;
SYM_UNORDERED   : [Uu][Nn][Oo][Rr][Dd][Ee][Rr][Ee][Dd] ;
SYM_UNIQUE      : [Uu][Nn][Ii][Qq][Uu][Ee] ;
SYM_USE_NODE    : [Uu][Ss][Ee][_][Nn][Oo][Dd][Ee] ;
SYM_USE_ARCHETYPE : [Uu][Ss][Ee][_][Aa][Rr][Cc][Hh][Ee][Tt][Yy][Pp][Ee] ;
SYM_ALLOW_ARCHETYPE : [Aa][Ll][Ll][Oo][Ww][_][Aa][Rr][Cc][Hh][Ee][Tt][Yy][Pp][Ee] ;
SYM_INCLUDE     : [Ii][Nn][Cc][Ll][Uu][Dd][Ee] ;
SYM_EXCLUDE     : [Ee][Xx][Cc][Ll][Uu][Dd][Ee] ;

SYM_DEFAULT     : '_'[Dd][Ee][Ff][Aa][Uu][Ll][Tt] ;

