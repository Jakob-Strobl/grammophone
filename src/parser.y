%start spec

%%

spec
  : rules { return $$ = $1; }
  | { return []; }
  ;

rules
  : rule STOP rules { $$ = $3; $3.unshift($1); }
  | rule STOP { $$ = [$1]; }
  ;

rule
  : NAME ARROW productions { $$ = { nt: $1, p: $3 }; }
  ;

productions
  : tokens { $$ = [$1]; }
  | tokens CHOICE productions { $$ = $3; $3.unshift($1); }
  ;

tokens
  : NAME tokens { $$ = $2; $2.unshift($1); }
  | SPACE tokens { $$ = $2; $2.unshift($1); }
  | { $$ = []; }
  ;
