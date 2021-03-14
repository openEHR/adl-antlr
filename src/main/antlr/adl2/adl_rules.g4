//
//  description: Antlr4 grammar for Rules sub-syntax of Archetype Definition Language (ADL2)
//  author:      Thomas Beale <thomas.beale@openehr.org>
//  contributors:Pieter Bos <pieter.bos@nedap.com>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2015- openEHR Foundation <http://www.openEHR.org>
//  license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

grammar adl_rules;
import base_expressions;

//
// Statements: currently, assignment or assertion
// TODO: the direct assignment of symbol to path ('mapped_data_ref')
// is ambiguous; to be reviewed in next version
//

statement: assignment | assertion;

assignment: 
      VARIABLE_ID ':' ALPHA_UC_ID SYM_ASSIGNMENT mapped_data_ref 
    | VARIABLE_ID ( ':' ALPHA_UC_ID )? SYM_ASSIGNMENT expression 
    ;

assertion: ( identifier ':' )? boolean_expr 
    ;



