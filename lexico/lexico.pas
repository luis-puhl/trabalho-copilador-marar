{
   lexico.pas
   
   Copyright 2014 Luís Puhl <luispuhl@gmail.com>
   
   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are
   met:
   
   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
   * Redistributions in binary form must reproduce the above
     copyright notice, this list of conditions and the following disclaimer
     in the documentation and/or other materials provided with the
     distribution.
   * Neither the name of the  nor the names of its
     contributors may be used to endorse or promote products derived from
     this software without specific prior written permission.
   
   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
   OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
   
   
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

