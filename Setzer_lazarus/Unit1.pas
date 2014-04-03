unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Buttons, ComCtrls;

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
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ProgressBar1: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
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
  postabela:integer;

implementation

uses Unit2;

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
  ctrl,pos:integer;
  tamanho:integer;
  buffer,buffer2:string;
  bufferhold:char;
begin
  ctrl:=0;
  pos:=1;
  tamanho:=Length(entrada);
  while (true) do
  begin
    //showmessage(IntToStr(pos) + ' / '+buffer);
    if (pos=tamanho) or (pos>tamanho) then Exit;
    case ctrl of
      0: //Estado inicial - Ignora espa�os em branco
      begin
        if (entrada[pos]=' ') or (entrada[pos]=#13) or (entrada[pos]=#10) then
        begin
          ctrl:=0;
          pos:=pos+1;
        end
        else
        begin
          if (PertenceLetras(entrada[pos])) then
            ctrl:=1;
          if (PertenceNumeros(entrada[pos])) then
            ctrl:=2;
          if (PertenceLetras(entrada[pos]) = FALSE) and ( PertenceNumeros(entrada[pos]) = FALSE) then
            ctrl:=3;
          bufferhold:=entrada[pos];
          buffer:=Concat(buffer,bufferhold);
          pos:=pos+1;
        end;
      end;
      1: //Le letras e numeros apenas
      begin
        if ((PertenceLetras(entrada[pos]) or PertenceNumeros(entrada[pos])) = FALSE)  then
        begin
          ctrl:=50;
        end
        else
        begin
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
      end;
      2: //Le apenas numeros
      begin
        if (PertenceNumeros(entrada[pos]) = FALSE) then
        begin
          ctrl:=50;
        end
        else
        begin
          if PertenceNumeros(entrada[pos]) then
          begin
            bufferhold:=entrada[pos];
            buffer:=Concat(buffer,bufferhold);
            ctrl:=2;
            pos:=pos+1;
          end
          else
          begin
            ctrl:=99;
          end;
        end;
      end;
      3:
      begin
        if (entrada[pos]=' ') or (entrada[pos]=#13) or (entrada[pos]=#10) then
        begin
          ctrl:=50;
        end
        else
        begin
          if (PertenceLetras(entrada[pos]) = FALSE) and (PertenceNumeros(entrada[pos]) = FALSE) then
          begin
            bufferhold:=entrada[pos];
            buffer:=Concat(buffer,bufferhold);
            ctrl:=3;
            pos:=pos+1;
          end
          else
          begin
            ctrl:=50;
          end;
        end;
      end;
      4:
      begin

      end;
      50: //Finaliza��o de entrada do buffer
      begin
        if (ProcuraTabela(buffer)) then //Palavra � palavra ou s�mbolo reservado.
        begin
          TabelaLex[postabela].p1:='RESERV';
          TabelaLex[postabela].p2:=buffer;
        end
        else
        begin //N�o � palavra nem s�mbolo reservado (Identificador ou numero)
          if PertenceNumeros(buffer[1]) then  //� um numero
          begin
            TabelaLex[postabela].p1:='NUM_INT';
            TabelaLex[postabela].p2:=buffer;
          end
          else
          begin
            if PertenceLetras(buffer[1]) then //� um identificador
            begin
              TabelaLex[postabela].p1:='IDENT'; //Identificador
              TabelaLex[postabela].p2:=buffer;
            end
            else   //� um operador
            begin
              TabelaLex[postabela].p1:='OPERADOR';
              TabelaLex[postabela].p2:=buffer;
            end;
          end;
        end;
        buffer:='';
        postabela:=postabela+1;
        ctrl:=0;
      end;
      99:
      begin
        Exit;
      end;
    end;
    if (pos-1=tamanho) then Exit;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
CriaTabela;
Memo1.Lines.Clear;
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  j:integer;
begin
  postabela:=1;
  ALex(Memo1.Lines.GetText);
  Form2.StringGrid1.RowCount:=postabela+1;
  Form2.Show;
  for j:=1 to postabela do
  begin
    Form2.StringGrid1.Cells[0,j]:=TabelaLex[j].p1;
    Form2.StringGrid1.Cells[1,j]:=TabelaLex[j].p2;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  escolha: integer;
begin
  escolha := MessageDlg('Come�ar um novo projeto apagar� todos os dados n�o salvos, deseja continuar?',mtConfirmation, mbOKCancel, 0);
  if escolha = mrOK then
  begin
    Memo1.Lines.Clear;
  end;
  if escolha = mrCancel then
  begin
    Exit;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  openDialog1:TOpenDialog;
begin
  openDialog1 := TOpenDialog.Create(self);
  openDialog1.InitialDir := GetCurrentDir;
  openDialog1.Filter :='Arquivos Pascal (*.pas)|*.pas';
  if openDialog1.Execute then
  begin
    Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
  end
  else
    Exit;
  openDialog1.Free;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  saveDialog1:TSaveDialog;
begin
  saveDialog1:= TSaveDialog.Create(self);
  saveDialog1.InitialDir := GetCurrentDir;
  saveDialog1.Filter :='Arquivos Pascal (*.pas)|*.pas';
  if saveDialog1.Execute then
  begin
    Memo1.Lines.SaveToFile(saveDialog1.FileName + '.pas');
    Form1.Caption:=Concat('Compilador Pascal - ' + saveDialog1.Filename);
  end
  else
    Exit;
  saveDialog1.Free;
end;

end.
