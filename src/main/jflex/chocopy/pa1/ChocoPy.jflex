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

StringLiteral = TODO /* expressão regular para representar uma string literal, como "Hello world" */

Identifier = TODO /* expressão regular para representar um identificador, como x */

Comment = TODO /* expressão regular para representar um comentário, como # comment */

EmptyLine = TODO /* expressão regular para representar uma linha que só tem caracteres em branco */

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
  /* TODO: adicionar todos os operadores */

  /* Delimiters. */
  "("                         { return symbol(ChocoPyTokens.LPAREN, yytext()); }
  /* TODO: adicionar todos os delimitadores */

  /* Whitespace. */
  {WhiteSpace}                { /* ignore */ }


  /* Keywords. */
  "False"			{ return symbol(ChocoPyTokens.FALSE, yytext()); }
  /* TODO: adicionar as keywords */


  /* Identifier. */
  {Identifier}                { return symbol(ChocoPyTokens.IDENTIFIER, yytext()); }
}

<<EOF>>                       { return symbol(ChocoPyTokens.EOF); }

/* Error fallback. */
[^]                           { return symbol(ChocoPyTokens.UNRECOGNIZED); }
