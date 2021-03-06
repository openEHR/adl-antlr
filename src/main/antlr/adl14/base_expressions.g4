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

statement: assignment | assertion;

assignment:
      VARIABLE_ID ':' ALPHA_UC_ID SYM_ASSIGNMENT mapped_data_ref
    | VARIABLE_ID ( ':' ALPHA_UC_ID )? SYM_ASSIGNMENT expression
    ;

assertion: ( identifier ':' )? boolean_expr
    ;


//
// General expressions
//

expression: simple_expression
    ;

simple_expression:
      boolean_expr
    | arithmetic_expr
    ;

//
// Expressions evaluating to boolean values
//

boolean_expr:
      boolean_expr SYM_AND boolean_leaf
    | boolean_expr SYM_XOR boolean_leaf
    | boolean_expr SYM_OR boolean_leaf
    | boolean_expr SYM_IMPLIES boolean_leaf
    | boolean_leaf
    ;

// basic boolean expression elements

boolean_leaf:
      boolean_literal
    | instance_ref
    | '(' boolean_expr ')'
    | relational_expr
    | constraint_expr
    | SYM_EXISTS mapped_data_ref
    | SYM_NOT boolean_leaf
    ;

constraint_expr: 
      mapped_data_ref SYM_MATCHES '{' c_primitive_object '}' 
    ;

boolean_literal:
      SYM_TRUE
    | SYM_FALSE
    ;

//
// Relational expressions of arithmetic operands
//

relational_expr: 
      arithmetic_expr relational_binop arithmetic_leaf
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

arithmetic_expr: 
      <assoc=right> arithmetic_expr '^' arithmetic_leaf
    | arithmetic_expr mult_op arithmetic_leaf
    | arithmetic_expr add_op arithmetic_leaf
    | arithmetic_leaf
    ;

arithmetic_leaf:
      integer_value
    | real_value
    | instance_ref   
    | '(' arithmetic_expr ')'
    ;

mult_op:
      '/'
    | '*'
    ;

add_op:
      '+'
    | '-'
    ;

//
// instances references: data references, variables, and function calls.
// TODO: Currently treat ADL paths as 'mapped' data references;
// which is ambiguous, since an ADL path may match multiple runtime objects
//

instance_ref:
      mapped_data_ref
    | variable_id
    ;

mapped_data_ref: ADL_PATH ;

variable_id: ALPHA_LC_ID ;

//
// ---------- Lexer patterns -----------------
//

VARIABLE_ID: '$' ALPHA_LC_ID;

    
