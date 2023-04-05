package chocopy.pa1;
import java_cup.runtime.*;
import java.util.ArrayList;
import java.util.Arrays;

%%

/*** Do not change the flags below unless you know what you are doing. ***/

%unicode
%line
%column

%class ChocoPyLexer
%public

%cupsym ChocoPyTokens
%cup
%cupdebug

%eofclose false

/*** Do not change the flags above unless you know what you are doing. ***/

/* The following code section is copied verbatim to the
 * generated lexer class. */
%{
    /* The code below includes some convenience methods to create tokens
     * of a given type and optionally a value that the CUP parser can
     * understand. Specifically, a lot of the logic below deals with
     * embedded information about where in the source code a given token
     * was recognized, so that the parser can report errors accurately.
     * (It need not be modified for this project.) */

    /** Producer of token-related values for the parser. */
    final ComplexSymbolFactory symbolFactory = new ComplexSymbolFactory();

    /** Return a terminal symbol of syntactic category TYPE and no
     *  semantic value at the current source location. */
    private Symbol symbol(int type) {
        return symbol(type, yytext());
    }

    /** Return a terminal symbol of syntactic category TYPE and semantic
     *  value VALUE at the current source location. */
    private Symbol symbol(int type, Object value) {
        return symbolFactory.newSymbol(ChocoPyTokens.terminalNames[type], type,
            new ComplexSymbolFactory.Location(yyline + 1, yycolumn + 1),
            new ComplexSymbolFactory.Location(yyline + 1,yycolumn + yylength()),
            value);
    }

    /* globals to track current indentation */
    int current_line_indent = 0;   /* indentation of the current line */
    ArrayList<Integer> indents = new ArrayList<Integer>(Arrays.asList(0));

    String process_string_literal(String s) {
        /* TODO: processar caracteres de escape \" \n \t \\ */
        return s.substring(1, s.length() - 1);
    }
%}

/* Macros (regexes used in rules below) */

WhiteSpace = [ \t]
LineBreak  = \r|\n|\r\n

IntegerLiteral = 0 | [1-9][0-9]*

StringLiteral = \"([^\"\\\n]|(\\.))*\"

Identifier = [a-zA-Z_$][a-zA-Z0-9_$]*

Comment = [/\*].*[\*/]

EmptyLine = (\s | \t)*

Indentation = [ \t]*.

%x indent
%s normal

%%

<YYINITIAL> {

  {EmptyLine}   { /* ignore */ }

  . { yypushback(1); yybegin(indent); }

}

<indent> {

  {EmptyLine}   { /* ignore */ }

  {Indentation} {  current_line_indent = yytext().length() - 1;
                   yypushback(current_line_indent + 1);
                   if (current_line_indent > indents.get(indents.size()-1)) {
                       indents.add(current_line_indent);
                       yybegin(normal);
                       return symbol(ChocoPyTokens.INDENT);
                   } else if (current_line_indent < indents.get(indents.size()-1)) {
                       indents.remove(indents.size()-1);
                       return symbol(ChocoPyTokens.DEDENT);
                   } else {
                       yybegin(normal);
                   }
                }

  <<EOF>>       { zzAtEOF = false;
                  if (indents.size() > 1) {
                      indents.remove(indents.size()-1);
                      return symbol(ChocoPyTokens.DEDENT);
                  } else
                      yybegin(normal);
                }
}




<normal> {

  /* Comment */
  {Comment}                   {  }

  /* Delimiters. */
  {LineBreak}                 { yybegin(indent); return symbol(ChocoPyTokens.NEWLINE); }

  /* Literals. */
  {IntegerLiteral}            { return symbol(ChocoPyTokens.INTEGER,
                                                 Integer.parseInt(yytext())); }
  {StringLiteral}             { return symbol(ChocoPyTokens.STRING, process_string_literal(yytext())); }

  /* Operators. */
  "+"                         { return symbol(ChocoPyTokens.PLUS, yytext()); }
  "-"                         { return symbol(ChocoPyTokens.MINUS, yytext()); }
  "*"                         { return symbol(ChocoPyTokens.TIMES, yytext()); }
  "/"                         { return symbol(ChocoPyTokens.DIV, yytext()); }
  "%"                         { return symbol(ChocoPyTokens.MOD, yytext()); }
  "<"                         { return symbol(ChocoPyTokens.LT, yytext()); }
  ">"                         { return symbol(ChocoPyTokens.GT, yytext()); }
  "<="                        { return symbol(ChocoPyTokens.LEQ, yytext()); }
  ">="                        { return symbol(ChocoPyTokens.GEQ, yytext()); }
  "=="                        { return symbol(ChocoPyTokens.EQEQ, yytext()); }
  "!="                        { return symbol(ChocoPyTokens.NE, yytext()); }
  "="                         { return symbol(ChocoPyTokens.EQ, yytext()); }
  ","                         { return symbol(ChocoPyTokens.COMMA, yytext()); }
  ":"                         { return symbol(ChocoPyTokens.COLON, yytext()); }
  "."                         { return symbol(ChocoPyTokens.DOT, yytext()); }
  "->"                        { return symbol(ChocoPyTokens.ARROW, yytext()); }
  /* TODO: adicionar todos os operadores */

  /* Delimiters. */
  "("                         { return symbol(ChocoPyTokens.LPAREN, yytext()); }
  ")"                         { return symbol(ChocoPyTokens.RPAREN, yytext()); }
  "["                         { return symbol(ChocoPyTokens.LINDEX, yytext()); }
  "]"                         { return symbol(ChocoPyTokens.RINDEX, yytext()); }
  /* TODO: adicionar todos os delimitadores */

  /* Whitespace. */
  {WhiteSpace}                { /* ignore */ }


  /* Keywords. */
    "False"                     { return symbol(ChocoPyTokens.FALSE, yytext()); }
    "None"                      { return symbol(ChocoPyTokens.NONE, yytext()); }
    "True"                      { return symbol(ChocoPyTokens.TRUE, yytext()); }
    "and"                       { return symbol(ChocoPyTokens.AND); }
    "as"                        { return symbol(ChocoPyTokens.AS); }
    "assert"                    { return symbol(ChocoPyTokens.ASSERT); }
    "async"                     { return symbol(ChocoPyTokens.ASYNC); }
    "await"                     { return symbol(ChocoPyTokens.AWAIT); }
    "break"                     { return symbol(ChocoPyTokens.BREAK); }
    "class"                     { return symbol(ChocoPyTokens.CLASS); }
    "continue"                  { return symbol(ChocoPyTokens.CONTINUE); }
    "def"                       { return symbol(ChocoPyTokens.DEF); }
    "del"                       { return symbol(ChocoPyTokens.DEL); }
    "elif"                      { return symbol(ChocoPyTokens.ELIF); }
    "else"                      { return symbol(ChocoPyTokens.ELSE); }
    "except"                    { return symbol(ChocoPyTokens.EXCEPT); }
    "finally"                   { return symbol(ChocoPyTokens.FINALLY); }
    "for"                       { return symbol(ChocoPyTokens.FOR); }
    "from"                      { return symbol(ChocoPyTokens.FROM); }
    "global"                    { return symbol(ChocoPyTokens.GLOBAL); }
    "if"                        { return symbol(ChocoPyTokens.IF); }
    "import"                    { return symbol(ChocoPyTokens.IMPORT); }
    "in"                        { return symbol(ChocoPyTokens.IN); }
    "is"                        { return symbol(ChocoPyTokens.IS); }
    "lambda"                    { return symbol(ChocoPyTokens.LAMBDA); }
    "nonlocal"                  { return symbol(ChocoPyTokens.NONLOCAL); }
    "not"                       { return symbol(ChocoPyTokens.NOT); }
    "or"                        { return symbol(ChocoPyTokens.OR); }
    "pass"                      { return symbol(ChocoPyTokens.PASS); }
    "raise"                     { return symbol(ChocoPyTokens.RAISE); }
    "return"                    { return symbol(ChocoPyTokens.RETURN); }
    "try"                       { return symbol(ChocoPyTokens.TRY); }
    "while"                     { return symbol(ChocoPyTokens.WHILE); }
    "with"                      { return symbol(ChocoPyTokens.WITH); }
    "yield"                     { return symbol(ChocoPyTokens.YIELD); }
  /* TODO: adicionar as keywords */


  /* Identifier. */
  {Identifier}                { return symbol(ChocoPyTokens.IDENTIFIER, yytext()); }
}

<<EOF>>                       { return symbol(ChocoPyTokens.EOF); }

/* Error fallback. */
[^]                           { return symbol(ChocoPyTokens.UNRECOGNIZED); }
