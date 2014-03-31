{
   read-fonte.pas
   
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


program read_fonte;

uses
	crt;

const
	FONT_FOLDER = 'test-case/';
	FONT_PATT = 'test_';
	FONT_EXT = '.pas';
	FONT_MAX_SIZE = 1500;

var
	i : integer;
	
	fileIndex : integer = 1;
	font : array [0..FONT_MAX_SIZE] of char;
	fontFile : text;
	fontName : string;
	fontSize : integer;
	
	codeLine : string;

function intToString( i : integer ) : string;
var
	NUMBERS : array [0..9] of char = ( '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' );
	keyIndex : integer;
	counter : integer;
begin
	intToString := '';
	counter := 10;
	
	while i>0 do begin
		keyIndex := i mod counter;
		
		intToString := NUMBERS[keyIndex] + intToString;
		
		i := i - keyIndex;
		counter := 10 * counter;
	end;
	
	writeLn(  );
	
end;


function toLower ( i : char ) : char;
begin
{
	#65 => A
}
end;

BEGIN
	writeLn( 'fontName' );
	fontName := FONT_FOLDER + FONT_PATT + intToString( fileIndex ) + FONT_EXT;
	writeLn( fontName );
	
	writeLn( 'Assign' );
	Assign( fontFile, fontName );
	writeLn( 'Reset' );
	Reset( fontFile );
	
	i := 0;
	writeLn( 'Read' );
	while not Eof( fontFile ) do begin
		
		Read( fontFile, font[i] );
		write( font[i] );
		
		font[i] := lowerCase( font[i] );
		
		i := i + 1;
	end;
	fontSize := i;
	Close( fontFile );
	
	writeLn( 'mostrando o arquivo depois de processado' );
	writeLn(  );
	for i := 0 to fontSize do begin
		write( font[i] );
	end;
	
	
	
END.

