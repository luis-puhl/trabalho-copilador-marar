{
   regex.pas
   
   Copyright 2014 Luís Puhl <luispuhl@gmail.com>

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
   
}

{
	
	Automato finito deterministico para reconhecer classes de palavras 
	usadas em pascal.
	
	reserved words
		These are words which have a fixed meaning in the language. They 
		cannot be changed or redefined. 
	
	identifiers
		These are names of symbols that the programmer defines. They can be 
		changed and re-used. They are subject to the scope rules of the 
		language. 
	
	operators
		These are usually symbols for mathematical or other operations: +, 
		-, * and so on. 
	
	separators
		This is usually white-space. 
	
	constants
		Numerical or character constants are used to denote actual values in 
		the source code, such as 1 (integer constant) or 2.3 (float 
		constant) or ’String constant’ (a string: a piece of text).
}

program regex;

uses read_fonte;

begin
	
	writeln( fontName );
	
end.

