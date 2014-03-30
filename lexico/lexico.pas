{
   lexico.pas
   
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


program lexico;

uses crt;

type
	Tstring = packed array[1..255] of char;
	StringToken = record
		id : integer;
		keyWord : packed array[0..10] of char;
		token : packed array[0..5] of char;
	end;

const
	TOKEN_FILE_NAME = 'token-string.token-list.tkl';

var
	i : byte;
	fonte : file of StringToken;
	fonte_text : text;
	fonte_alt : text;
	mychar : string;
	mytoken : StringToken;

function stringToken_toString( token : StringToken ) : Tstring;
var
	store : Tstring;
begin
	store := '';
	str( token.id, store );
	
	store := store + '_va';
	
	writeln( store );
	stringToken_toString := store;
end;

BEGIN
	
	assign (fonte_text, TOKEN_FILE_NAME + '.txt');
	reset (fonte_text);
	
	i := 1;
	while not eof (fonte_text) do
	begin
		readln (fonte_text, mychar);
		writeln (i, ': ', mychar);
		i := i + 1;
	end;
	
	close(fonte_text);
	
	{ seting keys, just to see how the file looks like }
	writeln( '' );
	assign (fonte_alt, '~' + TOKEN_FILE_NAME);
	writeln( 'fopen' );
	Rewrite(fonte_alt);
	writeln( 'Rewrite' );
	
	mytoken.keyWord := 'begin';
	mytoken.token := 'BEGIN';
	
	writeln( 'att' );
	
	
	writeln( fonte_alt, 'bof' );
	for i := 0 to 2 do begin
		mytoken.id := i;
		writeln( 'mytoken.id: ', mytoken.id );
		
		writeln( fonte_alt, stringToken_toString( mytoken ) );
		writeln( 'write' );
	end;
	writeln( 'for' );
	
	close(fonte_alt);
	writeln( 'close' );
	
END.
	{ getting keys }
	assign (fonte, TOKEN_FILE_NAME);
	reset (fonte);
	
	i := 1;
	while not eof (fonte) do begin
		readln (fonte, StringToken);
		writeln (i, ': ', StringToken.);
		i := i + 1;
	end;
	
	close(fonte);
	
	
END.

