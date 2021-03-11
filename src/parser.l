var name;

%s NAME
%s COMMENT
%s ESCAPE

%%

<INITIAL>"#"        { this.begin("COMMENT"); }
<INITIAL>"\\"       { this.begin("ESCAPE"); }
<INITIAL>"->"       { return "ARROW"; }
<INITIAL>"|"        { return "CHOICE"; }
<INITIAL>"."        { return "STOP"; }
<INITIAL><<EOF>>    { }
<INITIAL>[\s\n]     { }
<INITIAL>.          { this.begin("NAME"); name = yytext; }

<NAME>"\\"      { this.begin("ESCAPE"); yytext = name; return "NAME"; }
<NAME>"->"      { this.unput("->"); this.begin("INITIAL"); yytext = name; return "NAME"; }
<NAME>"|"       { this.unput("|"); this.begin("INITIAL"); yytext = name; return "NAME"; }
<NAME>"."       { this.unput("."); this.begin("INITIAL"); yytext = name; return "NAME"; }
<NAME><<EOF>>   { yytext = name; return "NAME"; }
<NAME>[\s\n]    { this.begin("INITIAL"); yytext = name; return "NAME"; }
<NAME>.         { name += yytext; }

<COMMENT>[\n]   { this.begin("INITIAL"); }
<COMMENT>[\s]   { }
<COMMENT>.      { }

<ESCAPE>[\n]    { this.begin("INITIAL"); }
<ESCAPE>.       { console.log("Escape char is " + yytext); this.begin("INITIAL"); name += yytext; return "NAME"; }

%%