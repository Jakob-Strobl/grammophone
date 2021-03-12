var name;

%s NAME
%s COMMENT
%s ESCAPE
%s DOUBLE_SPACE

%%

<INITIAL>"#"        { this.begin("COMMENT"); }
<INITIAL>"\\"       { this.begin("ESCAPE"); }
<INITIAL>"  "       { this.unput("  "); this.begin("DOUBLE_SPACE"); }
<INITIAL>"->"       { return "ARROW"; }
<INITIAL>"|"        { return "CHOICE"; }
<INITIAL>"."        { return "STOP"; }
<INITIAL><<EOF>>    { }
<INITIAL>[\s\n]     { }
<INITIAL>.          { this.begin("NAME"); name = yytext; }

<NAME>"\\"      { this.begin("ESCAPE"); yytext = name; return "NAME"; }
<NAME>"  "      { this.unput("  "); this.begin("DOUBLE_SPACE"); yytext = name; return "NAME"; }
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
<ESCAPE>.       { console.log("Escape char is " + yytext); this.begin("INITIAL"); return "NAME"; }

<DOUBLE_SPACE>"  " { console.log("DOUBLE SPACE '" + yytext + "'"); this.begin("INITIAL"); yytext = " "; return "SPACE" };

%%