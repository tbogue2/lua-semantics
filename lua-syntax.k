module LUA-SYNTAX

/*@ \section{Syntax}
This module defines the syntax of Lua 5.1.
Based on the manual at http://www.lua.org/manual/5.1/manual.html
*/

//TODO: write the proper regex for these,
//add long bracketed strings
syntax StringLiteral ::= String
syntax NumericalConstant ::= Float | Int

//TODO: add regex for comments?


//Names in Lua follow the same convention as Ids in K
syntax Name ::= Id
syntax NameList ::= Name
				  | NameList "," Name


syntax Var ::= Name
			 | PrefixExp "[" Exp "]"
			 | PrefixExp "." Name
syntax PrefixExp ::= Var
			       | FunctionCall
			       | "(" Exp ")"
syntax VarList ::= Var
				 | VarList "," Var


syntax Field ::= "[" Exp "]" "=" Exp
			   | Name "=" Exp
			   | Exp
syntax FieldList         ::= List { FieldListCommaSep, ";" }
syntax FieldListCommaSep ::= List { Field,             "," }

syntax TableConstructor ::= "{" FieldList "}"


syntax Args ::= "(" ")" 
			  | "(" ExpList ")"
			  | TableConstructor
			  | StringLiteral
syntax FunctionCall ::= PrefixExp Args
					  | PrefixExp ":" Name Args

syntax ParList ::= NameList
				 | NameList "," "..."
				 | "..."
syntax FuncBody ::= "(" ")" Block "end"
		   		  | "(" ParList ")" Block "end"
syntax Function ::= "function" FuncBody


syntax Exp ::= "nil"
			 | "false"
			 | "true"
			 | NumericalConstant
			 | StringLiteral
			 | "..."
			 | Function
			 | PrefixExp
			 | TableConstructor
syntax Exp ::= Exp "^" Exp   [right]
			 > "not" Exp
			 | "#" Exp
			 | "-" Exp
			 > left:
			   Exp "*" Exp   [left]
			 | Exp "/" Exp   [left]
			 | Exp "%" Exp   [left]
			 > left:
			   Exp "+" Exp   [left]
			 | Exp "-" Exp   [left]
			 > Exp ".." Exp  [right]
			 > left:
			   Exp "<" Exp   [left]
			 | Exp ">" Exp   [left]
			 | Exp "<=" Exp  [left]
			 | Exp ">=" Exp  [left]
			 | Exp "~=" Exp  [left]
			 | Exp "==" Exp  [left]
			 > Exp "and" Exp [left]
			 > Exp "or" Exp  [left]

//Is this backwards?
syntax ExpList ::= Exp
				 | Exp "," ExpList



syntax FuncName ::= Name
				  | FuncName "." Name
syntax MethodName ::= FuncName ":" Name


syntax Condition ::= Exp "then" Block
syntax ConditionList ::= List { Condition, "elseif" } 
syntax FinalCondition ::= "else" Block


syntax Stat::= VarList "=" ExpList 
		 	 | FunctionCall
		 	 | "do" Block "end"
		 	 | "while" Exp "do" Block "end"
			 | "repeat" Block "until" Exp
		 	 | "if" ConditionList "end"
		 	 | "if" ConditionList FinalCondition "end"
		 	 | "for" Name "=" Exp "," Exp "do" Block "end"
		 	 | "for" Name "=" Exp "," Exp "," Exp "do" Block "end"
		 	 | "for" NameList "in" ExpList "do" Block "end"
		 	 | "function" FuncName FuncBody
		 	 | "function" MethodName FuncBody
		 	 | "local" "function" Name FuncBody
		 	 | "local" NameList
		 	 | "local" NameList "=" ExpList


syntax LastStat ::= "return"
				  | "return" ExpList
				  | "break"

syntax StatWithPossibleSemicolon ::= Stat | Stat ";"
syntax LastStatWithPossibleSemicolon ::= LastStat | LastStat ";"
syntax StatList ::= List{ StatWithPossibleSemicolon, "" }

syntax Chunk ::= StatList
			   | StatList LastStatWithPossibleSemicolon

syntax Block ::= Chunk


endmodule