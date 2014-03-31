{
   tabela.pas
   
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


program tabela;

type
	CampoTabela = record
		simbolo: string;
		colisao: integer;
	end;

const
	
	{Quantidade de símbolos reservados.}
	QuntSimRes = 22;
	SimbolosReservados: array[1..QuntSimRes] of string = ( '+','-','*','/',
	'=', '.', ';',':','"','<','>','<=','>=','<>','(',')','[', ']','{','}',
	'..',':=');
	
	{//Quantidade de palavras reservadas.}
	QuntPalRes = 34;
	PalavrasReservadas : array[1..QuntPalRes] of string = ('and', 'array', 
	'begin,', 'case','const','div','do','downto','else','end','file','for', 
	'func','goto', 'if','in','label','mod','nil','not','of','packed','proc', 
	'progr','record','repeat', 'set','then','to','type','until','var','while',
	'with' );

var
	Tabela: array[1..QuntSimRes+QuntPalRes+3+30] of CampoTabela;



//Função hash, que retornará o valor do simbolo na tabela
function Hash(simbolo: string): Integer;
var
	poscos,i,soma: integer;
begin
	//Tabela Primaria varia de 1 a 59
	//Tabela Secundaria de 60 a 90
	poscos:=60;
	soma:=0;
	
	for i:=1 to Length(simbolo) do
	begin
	if (simbolo[i]<>' ') then
	  soma:=soma+Ord(simbolo[i]);
	end;
	
	Hash:=(soma)mod(poscos-1);
end;

//Primeira rotina do programa, criará uma tabela através de Hashing para os simbolos
//e palavras reservadas.
procedure CriaTabela();
var
	poscos,i,posant: integer;
begin
	poscos:=60;
	posant:=0;
	for i:=1 to QuntPalRes do
	begin
		if (Tabela[Hash(PalavrasReservadas[i])].simbolo = '') then
		begin
			Tabela[Hash(PalavrasReservadas[i])].simbolo:=PalavrasReservadas[i];
			Tabela[Hash(PalavrasReservadas[i])].colisao:=0;
		end
		else
		begin
			if (Tabela[Hash(PalavrasReservadas[i])].colisao = 0) then
			begin
				while (Tabela[poscos].colisao) <> 0 do
		  begin
			poscos:=poscos+1;
		  end;
		Tabela[poscos].simbolo:=PalavrasReservadas[i];
		Tabela[poscos].colisao:=0;
		Tabela[Hash(PalavrasReservadas[i])].colisao := poscos;
	  end
	  else
	  begin
		poscos:=Tabela[Hash(PalavrasReservadas[i])].colisao;
		while (Tabela[poscos].colisao) <> 0 do
		begin
		  posant:=poscos;
		  poscos:=Tabela[poscos].colisao;
		end;
		Tabela[poscos].simbolo:=PalavrasReservadas[i];
		Tabela[poscos].colisao:=0;
		Tabela[posant].colisao := poscos;
	  end; //
	end;  //end do else
	end;

	//Criando simbolos reservados
	for i:=1 to QuntSimRes do
	begin

	if (Tabela[Hash(SimbolosReservados[i])].simbolo = '') then
	begin
	  Tabela[Hash(SimbolosReservados[i])].simbolo:=SimbolosReservados[i];
	  Tabela[Hash(SimbolosReservados[i])].colisao:=0;
	end
	else
	begin
	  if (Tabela[Hash(SimbolosReservados[i])].colisao = 0) then
	  begin
		while (Tabela[poscos].colisao) <> 0 do
		  begin
			poscos:=poscos+1;
		  end;
		Tabela[poscos].simbolo:=SimbolosReservados[i];
		Tabela[poscos].colisao:=0;
		Tabela[Hash(SimbolosReservados[i])].colisao := poscos;
	  end
	  else
	  begin
		poscos:=Tabela[Hash(SimbolosReservados[i])].colisao;
		while (Tabela[poscos].colisao) <> 0 do
		begin
		  posant:=poscos;
		  poscos:=Tabela[poscos].colisao;
		end;
		Tabela[poscos].simbolo:=SimbolosReservados[i];
		Tabela[poscos].colisao:=0;
		Tabela[posant].colisao := poscos;
	  end; //
	end;  //end do else
	end;

end;

{
	* Função que procura uma cadeia de caracteres na tabela gerada por Hashing
	* 
}
function ProcuraTabela(entrada:string) : Boolean;
begin
	ProcuraTabela:=True;
end;


BEGIN
	
	
END.
