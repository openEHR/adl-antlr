//
//  description: Antlr4 grammar for openEHR Rules core syntax.
//  author:      Thomas Beale <thomas.beale@openehr.org>
//  contributors:Pieter Bos <pieter.bos@nedap.com>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2016- openEHR Foundation <http://www.openEHR.org>
//  license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

grammar base_expressions;
import cadl_primitives;

//
// Statements: currently, assignment or assertion
// TODO: the direct assignment of symbol to path ('mapped_data_ref')
// is ambiguous; to be reviewed in next version
//

statement: variable_declaration |assignment | assertion;

variable_declaration: VARIABLE_ID ':' type_id ( SYM_ASSIGNMENT expression )? ;

assignment: VARIABLE_ID SYM_ASSIGNMENT expression ;

assertion: ( identifier ':' )? boolean_expr ;

//
// General expressions
//

expression:
      boolean_expr
    | arithmetic_expr
    ;

//
// Expressions evaluating to boolean values
//

boolean_expr:
      SYM_NOT boolean_expr
    | boolean_expr SYM_AND boolean_expr
    | boolean_expr SYM_XOR boolean_expr
    | boolean_expr SYM_OR boolean_expr
    | boolean_expr SYM_IMPLIES boolean_expr
    | boolean_leaf equality_binop boolean_literal
    | boolean_leaf
    ;

// basic boolean expression elements

boolean_leaf:
      boolean_literal
    | instance_ref
    | for_all_expr
    | there_exists_expr
    | '(' boolean_expr ')'
    | relational_expr
    | equality_expr
    | constraint_expr
    | SYM_EXISTS mapped_data_ref
    ;

//
// Universal and existential quantifier
//
for_all_expr: SYM_FOR_ALL VARIABLE_ID SYM_IN value_ref '|'? boolean_expr ;

there_exists_expr: SYM_THERE_EXISTS VARIABLE_ID SYM_IN value_ref '|'? boolean_expr ;

// Constraint expressions
constraint_expr:
      mapped_data_ref SYM_MATCHES '{' c_primitive_object '}'
    ;

boolean_literal:
      SYM_TRUE
    | SYM_FALSE
    ;

//
// Expressions evaluating to arithmetic values
//
arithmetic_expr:
      <assoc=right> arithmetic_expr '^' arithmetic_leaf
    | arithmetic_expr ( '/' | '*' ) arithmetic_leaf
    | arithmetic_expr ( '+' | '-' ) arithmetic_leaf
    | arithmetic_leaf
    ;

arithmetic_leaf:
      integer_value
    | real_value
    | instance_ref
    | '(' arithmetic_expr ')'
    ;

//
// Equality expression between any operand
//
equality_expr: arithmetic_leaf equality_binop arithmetic_leaf ;

equality_binop:
      SYM_EQ
    | SYM_NE
    ;

//
// Relational expressions of arithmetic operands
//
relational_expr: arithmetic_expr relational_binop arithmetic_leaf ;

relational_binop:
      SYM_GT
    | SYM_LT
    | SYM_LE
    | SYM_GE
    ;

//
// instances references: data references, variables, and function calls.
// TODO: Currently treat ADL paths as 'mapped' data references;
// which is ambiguous, since an ADL path may match multiple runtime objects
//

instance_ref:
      value_ref
    | function_call
    ;

value_ref:
      mapped_data_ref
    | VARIABLE_ID
    ;

mapped_data_ref: ADL_PATH ;

function_call: ALPHA_LC_ID '(' ( expression ( ',' expression )*? )? ')' ;

type_id: ALPHA_UC_ID ( '<' type_id ( ',' type_id )* '>' )? ;

//
// ---------- Lexer patterns -----------------
//
SYM_ASSIGNMENT: ':=' | '::=' ;

SYM_NE : '/=' | '!=' | '≠' ;
SYM_EQ : '=' ;

SYM_THEN     : [Tt][Hh][Ee][Nn] ;
SYM_AND      : [Aa][Nn][Dd] | '∧' ;
SYM_OR       : [Oo][Rr] | '∨' ;
SYM_XOR      : [Xx][Oo][Rr] ;
SYM_NOT      : [Nn][Oo][Tt] | '!' | '~' | '¬' ;
SYM_IMPLIES  : [Ii][Mm][Pp][Ll][Ii][Ee][Ss] | '⇒' ;
SYM_FOR_ALL: 'for_all' | '∀' ;
SYM_THERE_EXISTS: 'there_exists' | '∃' ;
SYM_EXISTS: 'exists' ;
SYM_MATCHES : [Mm][Aa][Tt][Cc][Hh][Ee][Ss] | [Ii][Ss]'_'[Ii][Nn] | '∈' ;

VARIABLE_ID: '$'? ALPHA_LC_ID;
