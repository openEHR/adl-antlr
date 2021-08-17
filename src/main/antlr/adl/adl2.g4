//
//  description: Antlr4 grammar for Archetype Definition Language (ADL2)
//  author:      Thomas Beale <thomas.beale@openehr.org>
//  contributors:Pieter Bos <pieter.bos@nedap.com>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2015- openEHR Foundation <http://www.openEHR.org>
//  license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

grammar adl2;
import cadl2, odin;

//
//  ============== Parser rules ==============
//

adl2_archetype: ( authored_archetype | template | template_overlay | operational_template ) EOF ;

authored_archetype:
    SYM_ARCHETYPE meta_data?
    ARCHETYPE_HRID
    specialize_section?
    language_section
    description_section
    definition_section
    rules_section?
    terminology_section
    annotations_section?
    ;

template: 
    SYM_TEMPLATE meta_data? 
    ARCHETYPE_HRID
    specialize_section
    language_section
    description_section
    definition_section
    rules_section?
    terminology_section
    annotations_section?
    (H_CMT_LINE template_overlay)*
    ;

template_overlay: 
    SYM_TEMPLATE_OVERLAY 
    ARCHETYPE_HRID
    specialize_section
    definition_section
    terminology_section
    ;

operational_template: 
    SYM_OPERATIONAL_TEMPLATE meta_data? 
    ARCHETYPE_HRID
    language_section
    description_section
    definition_section
    rules_section?
    terminology_section
    annotations_section?
    component_terminologies_section?
    ;

specialize_section  : SYM_SPECIALIZE ARCHETYPE_REF ;
language_section    : SYM_LANGUAGE odin_text ;
description_section : SYM_DESCRIPTION odin_text ;
definition_section  : SYM_DEFINITION c_complex_object ;
rules_section       : SYM_RULES statement_block ;
terminology_section : SYM_TERMINOLOGY odin_text ;
annotations_section : SYM_ANNOTATIONS odin_text ;
component_terminologies_section: SYM_COMPONENT_TERMINOLOGIES odin_text ;

meta_data: '(' meta_data_item  (';' meta_data_item )* ')' ;

meta_data_item:
      meta_data_tag_adl_version '=' VERSION_ID
    | meta_data_tag_uid '=' GUID
    | meta_data_tag_build_uid '=' GUID
    | meta_data_tag_rm_release '=' VERSION_ID
    | meta_data_tag_is_controlled
    | meta_data_tag_is_generated
    | ALPHANUM_ID ( '=' meta_data_value )?
    ;

meta_data_value:
      primitive_value
    | GUID
    | VERSION_ID
    ;

meta_data_tag_adl_version   : 'adl_version' ;
meta_data_tag_uid           : 'uid' ;
meta_data_tag_build_uid     : 'build_uid' ;
meta_data_tag_rm_release    : 'rm_release' ;
meta_data_tag_is_controlled : 'controlled' ;
meta_data_tag_is_generated  : 'generated' ;

//
// ------------------ lexical patterns -----------------
//

// ADL keywords
SYM_ARCHETYPE            : [Aa][Rr][Cc][Hh][Ee][Tt][Yy][Pp][Ee] ;
SYM_TEMPLATE_OVERLAY     : [Tt][Ee][Mm][Pp][Ll][Aa][Tt][Ee]'_'[Oo][Vv][Ee][Rr][Ll][Aa][Yy] ;
SYM_TEMPLATE             : [Tt][Ee][Mm][Pp][Ll][Aa][Tt][Ee] ;
SYM_OPERATIONAL_TEMPLATE : [Oo][Pp][Ee][Rr][Aa][Tt][Ii][Oo][Nn][Aa][Ll]'_'[Tt][Ee][Mm][Pp][Ll][Aa][Tt][Ee] ;

SYM_SPECIALIZE  : '\n'[Ss][Pp][Ee][Cc][Ii][Aa][Ll][Ii][SsZz][Ee] ;
SYM_LANGUAGE    : '\n'[Ll][Aa][Nn][Gg][Uu][Aa][Gg][Ee] ;
SYM_DESCRIPTION : '\n'[Dd][Ee][Ss][Cc][Rr][Ii][Pp][Tt][Ii][Oo][Nn] ;
SYM_DEFINITION  : '\n'[Dd][Ee][Ff][Ii][Nn][Ii][Tt][Ii][Oo][Nn] ;
SYM_RULES       : '\n'[Rr][Uu][Ll][Ee][Ss] ;
SYM_TERMINOLOGY : '\n'[Tt][Ee][Rr][Mm][Ii][Nn][Oo][Ll][Oo][Gg][Yy] ;
SYM_ANNOTATIONS : '\n'[Aa][Nn][Nn][Oo][Tt][Aa][Tt][Ii][Oo][Nn][Ss] ;
SYM_COMPONENT_TERMINOLOGIES : '\n'[Cc][Oo][Mm][Pp][Oo][Nn][Ee][Nn][Tt]'_'[Tt][Ee][Rr][Mm][Ii][Nn][Oo][Ll][Oo][Gg][Ii][Ee][Ss] ;

// ---------------- meta-data keywords and symbols ---------------
SYM_EQ         : '=' ;
ALPHANUM_ID : [a-zA-Z0-9][a-zA-Z0-9_]* ;

// ---------- whitespace & comments ----------

WS         : [ \t\r]+    -> channel(HIDDEN) ;
LINE       : '\r'? EOL  -> channel(HIDDEN) ;  // increment line count
H_CMT_LINE : '--------' '-'*? EOL  ;         // long comment line for splitting template overlays
CMT_LINE   : '--' .*? '\r'? EOL  -> skip ;   // (increment line count)
fragment EOL : '\n' ;
