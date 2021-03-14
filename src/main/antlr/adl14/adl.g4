//
//  description: Antlr4 grammar for Archetype Definition Language (ADL2)
//  author:      Thomas Beale <thomas.beale@openehr.org>
//  contributors:Pieter Bos <pieter.bos@nedap.com>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2015- openEHR Foundation <http://www.openEHR.org>
//  license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

grammar adl;
import cadl, odin;

//
//  ============== Parser rules ==============
//

adl: ( archetype) EOF ;

archetype: 
    SYM_ARCHETYPE meta_data?
    ARCHETYPE_HRID
    specialization_section?
    concept_section
    language_section
    description_section
    definition_section
    rules_section?
    ontology_section
    ;


specialization_section : SYM_SPECIALIZE archetype_ref ;
language_section       : SYM_LANGUAGE odin_text ;
description_section    : SYM_DESCRIPTION odin_text ;
definition_section     : SYM_DEFINITION c_complex_object ;
invariant_section      : SYM_INVARIANT assertion_list;
ontology_section       : SYM_ONTOLOGY odin_text ;

concept_section:
 'concept' '[' AT_CODE ']';

meta_data: '(' meta_data_item  (';' meta_data_item )* ')' ;

meta_data_item:
      meta_data_tag_adl_version '=' (REAL|VERSION_ID)
    | meta_data_tag_uid '=' guid_or_oid
    | meta_data_tag_build_uid '=' guid_or_oid
    | meta_data_tag_rm_release '=' (REAL|VERSION_ID)
    | meta_data_tag_is_controlled
    | meta_data_tag_is_generated
    | identifier ( '=' meta_data_value )?
    ;

meta_data_value:
      primitive_value
    | guid_or_oid
    | (REAL|VERSION_ID)
    ;

guid_or_oid: (GUID | OID | VERSION_ID); //VERSION_ID is the same as a OID with one or two dots

meta_data_tag_adl_version   : 'adl_version' ;
meta_data_tag_uid           : 'uid' ;
meta_data_tag_build_uid     : 'build_uid' ;
meta_data_tag_rm_release    : 'rm_release' ;
meta_data_tag_is_controlled : 'controlled' ;
meta_data_tag_is_generated  : 'generated' ;
