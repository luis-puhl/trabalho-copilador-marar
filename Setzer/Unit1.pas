unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Buttons;

type
  CampoTabela = record
    simbolo: string;
    colisao: integer;
  end;
  CampoLex = record
    p1: string;
    p2: string;
  end;

  TForm1 = class(TForm)
    Edit1: TEdit;
    Memo1: TMemo;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  QuntSimRes = 22;   //Quantidade de s�mbolos reservados.
  SimbolosReservados: array[1..QuntSimRes] of string = ('+','-','*','/','=','.',
  ';',':','"','<','>','<=','>=','<>','(',')','[',']','{','}','..',':=' );

  QuntPalRes = 34;  //Quantidade de palavras reservadas.
  PalavrasReservadas : array[1..QuntPalRes] of string = ('and', 'array','begin',
  'case','const','div','do','downto','else','end','file','for','func','goto',
  'if','in','label','mod','nil','not','of','packed','proc','progr','record','repeat',
  'set','then','to','type','until','var','while','with' );

  Letras : array[1..52] of string = ('A','B','C','D','E','F','G','H','I','J','K','L',
  'M','N','O','P','Q','R','S','T','U','V','X','Y','W','Z','a','b','c','d','e','f','g',
  'h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','x','y','w','z');

  Numeros: array[1..10] of integer = (0,1,2,3,4,5,6,7,8,9);

  TamanhoTabelaLex = 500;

var
  Form1: TForm1;
  Tabela: array[1..QuntSimRes+QuntPalRes+3+30] of CampoTabela;
  TabelaLex: array[1..500] of CampoLex;

implementation

{$R *.dfm}

//Fun��o hash, que retornar� o valor do simbolo na tabela
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
  if ((soma)mod(poscos-1))=0 then
    Hash:=(soma)mod(poscos-1)+1
  else
    Hash:=(soma)mod(poscos-1);
end;

//Primeira rotina do programa, criar� uma tabela atrav�s de Hashing para os simbolos
//e palavras reservadas.
procedure CriaTabela();
var
  poscos,i,posnovo: integer;
begin
  poscos:=60;
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
        Tabela[poscos].simbolo:=PalavrasReservadas[i];
        Tabela[poscos].colisao:=0;
        Tabela[Hash(PalavrasReservadas[i])].colisao := poscos;
        poscos:=poscos+1;
      end
      else
      begin
        posnovo:=Tabela[Hash(PalavrasReservadas[i])].colisao;
        while (Tabela[posnovo].colisao) <> 0 do
        begin
          posnovo:=Tabela[posnovo].colisao;
        end;
        Tabela[poscos].simbolo:=PalavrasReservadas[i];
        Tabela[posnovo].colisao:=poscos;
        Tabela[poscos].colisao:=0;
        poscos:=poscos+1;
      end; //
    end;
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
        Tabela[poscos].simbolo:=SimbolosReservados[i];
        Tabela[poscos].colisao:=0;
        Tabela[Hash(SimbolosReservados[i])].colisao := poscos;
        poscos:=poscos+1;
      end
      else
      begin
        posnovo:=Tabela[Hash(SimbolosReservados[i])].colisao;
        while (Tabela[posnovo].colisao) <> 0 do
        begin
          posnovo:=Tabela[posnovo].colisao;
        end;
        Tabela[poscos].simbolo:=SimbolosReservados[i];
        Tabela[posnovo].colisao:=poscos;
        Tabela[poscos].colisao:=0;
        poscos:=poscos+1;
      end; //
    end;  //end do else
  end;

end;


//Fun��o que procura uma cadeia de caracteres na tabela gerada por Hashing
function ProcuraTabela(entrada:string) : Boolean;
var
  poscos:integer;
  retorno:Boolean;
begin
retorno:=False;
  if (Tabela[Hash(entrada)].simbolo = entrada) then
    retorno:=True
  else
  begin
    if (Tabela[Hash(entrada)].colisao = 0) then
      retorno:=False
    else
    begin
      poscos:=Tabela[Hash(entrada)].colisao;
      if (Tabela[poscos].simbolo = entrada) then
        retorno:=True
      else
      begin
        while (Tabela[poscos].colisao) <> 0 do
        begin
          poscos:=Tabela[poscos].colisao;
          if (Tabela[poscos].simbolo = entrada) then
            retorno:=True;
        end;
      end;
    end;
  end;
ProcuraTabela:=retorno;
end;

//Verifica se o caractere � uma letra
function PertenceLetras(entrada: char):Boolean;
var
  i:integer;
  retorno:Boolean;
begin
  retorno:=False;
  for i:=1 to 52 do
  begin
    if Letras[i]=entrada then
    retorno:=True;
  end;
  PertenceLetras:=retorno;
end;

//Verifica se o caractere � um numero
function PertenceNumeros(entrada: char):Boolean;
var
  i:integer;
  retorno:Boolean;
begin
  retorno:=False;
  for i:=1 to 10 do
  begin
    if IntToStr(Numeros[i])=entrada then
    retorno:=True;
  end;
  PertenceNumeros:=retorno;
end;

//Rotina do Analisador L�xico
procedure ALex(entrada: string);
//Considera��es:
//Entrada � o bloco de texto completo.
var
  ctrl,pos,postabela:integer;
  buffer:string;
  bufferhold:char;
begin
  ctrl:=0;
  pos:=1;
  postabela:=1;
  while (true) do
  begin
    if Length(entrada)=pos then begin Exit; end;
    case ctrl of
      0: //Estado inicial - Ignora espa�os em branco
      begin
        if (entrada[pos]=' ') then
          ctrl:=0
        else
        begin
          if (PertenceLetras(entrada[pos])) then
            ctrl:=1;
          if (PertenceNumeros(entrada[pos])) then
            ctrl:=2;
          bufferhold:=entrada[pos];
          buffer:=Concat(buffer,bufferhold);
          pos:=pos+1;
        end;
      end;
      1: //Le letras e numeros apenas
      begin
        if (entrada[pos]=' ') then
          ctrl:=50;
        if (PertenceLetras(entrada[pos]) or PertenceNumeros(entrada[pos])) then
          begin
            bufferhold:=entrada[pos];
            buffer:=Concat(buffer,bufferhold);
            ctrl:=1;
            pos:=pos+1;
          end
          else
          begin
            ctrl:=99;
          end;
      end;
      2: //Le apenas numeros
      begin

      end;
      3:
      begin

      end;
      4:
      begin

      end;
      50: //Finaliza��o de entrada do buffer
      begin
        if (ProcuraTabela(buffer)) then //Palavra � palavra ou s�mbolo reservado.
        begin
        TabelaLex[postabela].p1:=buffer;
        TabelaLex[postabela].p2:=buffer;
        showMessage(TabelaLex[postabela].p1);
        end;
        buffer:='';
        postabela:=postabela+1;
        ctrl:=1;
      end;
      99:
      begin
      
      end;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
CriaTabela;
Memo1.Lines.Clear;
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
ALex(Edit1.Text);
end;

end.
