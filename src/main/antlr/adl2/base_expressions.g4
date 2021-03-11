//
//  description: Antlr4 grammar for openEHR Rules core syntax.
//  author:      Thomas Beale <thomas.beale@openehr.org>
//  contributors:Pieter Bos <pieter.bos@nedap.com>
//  support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//  copyright:   Copyright (c) 2016- openEHR Foundation <http://www.openEHR.org>
//  license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

grammar base_expressions;


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
      boolean_expr boolean_binop boolean_leaf
    | boolean_leaf
    ;

boolean_leaf:
      boolean_literal
    | boolean_data_ref
    | '(' boolean_expr ')'
    | relational_expr
    | constraint_expr
    | SYM_EXISTS data_ref
    | SYM_NOT boolean_leaf
    ;

boolean_binop:
    | SYM_AND
    | SYM_XOR
    | SYM_OR
    | SYM_IMPLIES
    ;

constraint_expr: 
      data_ref SYM_MATCHES '{' c_primitive_object '}' 
    ;

boolean_literal:
      SYM_TRUE
    | SYM_FALSE
    ;
    
//
// Relational expressions of arithmetic operands
//

relational_expr: 
      arithmetic_expr relational_binop arithmetic_expr
    ;

relational_binop:
      SYM_EQ
    | SYM_NE
    | SYM_GT
    | SYM_LT
    | SYM_LE
    | SYM_GE
    ;

//
// Expressions evaluating to arithmetic values
//

arithmetic_leaf:
      integer_value
    | real_value
    | numeric_data_ref   
    | '(' arithmetic_expr ')'
    ;

arithmetic_expr: 
      arithmetic_expr arithmetic_binop arithmetic_leaf
    | arithmetic_expr '^'<assoc=right> arithmetic_leaf
    | arithmetic_leaf
    ;

arithmetic_binop:
      '/'
    | '*'
    | '+'
    | '-'
    ;

//
// Data references: currently treat ADL paths as data references;
// this mapping is ambiguous, since an ADL path may match multiple runtime objects
//

data_ref:
      boolean_data_ref
    | numeric_data_ref
    ;
    
boolean_data_ref: ADL_PATH
    ;

numeric_data_ref: ADL_PATH
    ;

