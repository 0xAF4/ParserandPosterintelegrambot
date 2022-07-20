object Form2: TForm2
  Left = 672
  Top = 299
  BorderStyle = bsDialog
  Caption = 'PosterBot'
  ClientHeight = 234
  ClientWidth = 459
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 327
    Top = 101
    Width = 84
    Height = 13
    Caption = #1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085#1085#1086':'
  end
  object Label2: TLabel
    Left = 442
    Top = 101
    Width = 6
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = '0'
    ParentBiDiMode = False
  end
  object Label3: TLabel
    Left = 327
    Top = 120
    Width = 44
    Height = 13
    Caption = #1054#1096#1080#1073#1082#1080':'
  end
  object Label4: TLabel
    Left = 442
    Top = 120
    Width = 6
    Height = 13
    BiDiMode = bdRightToLeft
    Caption = '0'
    ParentBiDiMode = False
  end
  object Edit1: TEdit
    Left = 8
    Top = 8
    Width = 193
    Height = 21
    TabOrder = 0
    TextHint = 'auth Token'
    OnChange = Edit1Change
  end
  object ListBox1: TListBox
    Left = 8
    Top = 35
    Width = 193
    Height = 134
    ItemHeight = 13
    TabOrder = 1
    OnDblClick = Button2Click
  end
  object Edit2: TEdit
    Left = 8
    Top = 175
    Width = 193
    Height = 21
    TabOrder = 2
    TextHint = '@chanell_name'
    OnKeyPress = Edit2KeyPress
  end
  object Button1: TButton
    Left = 8
    Top = 202
    Width = 89
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 112
    Top = 201
    Width = 89
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 207
    Top = 39
    Width = 114
    Height = 25
    Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1087#1086#1089#1090#1080#1085#1075
    TabOrder = 5
    OnClick = Button3Click
  end
  object TimePicker1: TTimePicker
    Left = 207
    Top = 101
    Width = 114
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    TabOrder = 6
    Time = 0.003472222222222222
    TimeFormat = 'hh:mm:ss'
    OnClick = TimePicker1Click
  end
  object Button4: TButton
    Left = 207
    Top = 174
    Width = 241
    Height = 25
    Caption = 'GetID'
    TabOrder = 7
    OnClick = Button4Click
  end
  object Edit3: TEdit
    Left = 207
    Top = 148
    Width = 241
    Height = 21
    TabOrder = 8
    TextHint = '@chanell_name'
  end
  object Edit4: TEdit
    Left = 207
    Top = 205
    Width = 241
    Height = 21
    TabOrder = 9
    TextHint = 'chat_id'
  end
  object Button5: TButton
    Left = 327
    Top = 39
    Width = 121
    Height = 25
    Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086#1089#1090#1080#1085#1075
    TabOrder = 10
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 207
    Top = 70
    Width = 114
    Height = 25
    Caption = #1055#1072#1091#1079#1072' 1 '#1095#1072#1089
    TabOrder = 11
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 327
    Top = 70
    Width = 121
    Height = 25
    Caption = #1055#1072#1091#1079#1072' 3 '#1095#1072#1089
    TabOrder = 12
    OnClick = Button7Click
  end
  object Button8: TButton
    Left = 207
    Top = 8
    Width = 114
    Height = 25
    Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1041#1086#1090#1072
    TabOrder = 13
    OnClick = Button8Click
  end
  object Button9: TButton
    Left = 327
    Top = 8
    Width = 121
    Height = 25
    Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1041#1086#1090#1072
    TabOrder = 14
    OnClick = Button9Click
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 152
    Top = 120
  end
end
