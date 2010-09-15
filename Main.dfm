object MainForm: TMainForm
  Left = 208
  Top = 114
  Width = 830
  Height = 582
  Caption = 'MainForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object reOutput: TRichEdit
    Left = 0
    Top = 146
    Width = 822
    Height = 409
    Align = alBottom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object bPrint: TButton
    Left = 40
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Print'
    TabOrder = 1
    OnClick = bPrintClick
  end
  object bInit: TButton
    Left = 40
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Init'
    TabOrder = 2
    OnClick = bInitClick
  end
  object bClear: TButton
    Left = 184
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Clear'
    TabOrder = 3
    OnClick = bClearClick
  end
  object bIterate: TButton
    Left = 40
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Iterate'
    TabOrder = 4
    OnClick = bIterateClick
  end
end
