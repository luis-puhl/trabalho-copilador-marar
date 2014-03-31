object Form1: TForm1
  Left = 192
  Top = 232
  Width = 928
  Height = 480
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Edit1: TEdit
    Left = 96
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'Pesquisa na tabela'
  end
  object Memo1: TMemo
    Left = 16
    Top = 64
    Width = 321
    Height = 337
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Button1: TButton
    Left = 248
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
end
