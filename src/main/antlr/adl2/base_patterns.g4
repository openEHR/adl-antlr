//
//  General purpose patterns used in all openEHR parser and lexer tools
//

grammar base_patterns;
import base_lexer;

//
// -------------------------- Parse Rules --------------------------
//

rm_type_id      : ALPHA_UC_ID ( '<' rm_type_id ( ',' rm_type_id )* '>' )? ;
rm_attribute_id : ALPHA_LC_ID ;
identifier   : ALPHA_UC_ID | ALPHA_LC_ID ;

archetype_ref : ARCHETYPE_HRID | ARCHETYPE_REF ;

