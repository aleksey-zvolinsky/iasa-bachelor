object MainForm: TMainForm
  Left = 285
  Top = 149
  Width = 830
  Height = 582
  Caption = #1053#1072#1093#1086#1078#1076#1077#1085#1080#1077' '#1086#1087#1090#1080#1084#1072#1083#1100#1085#1086#1075#1086' '#1086#1073#1098#1077#1084#1072' '#1101#1082#1089#1087#1086#1088#1090#1072' '#1080' '#1080#1084#1087#1086#1088#1090#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 822
    Height = 535
    ActivePage = ts
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #1055#1086#1096#1072#1075#1086#1074#1086#1077' '#1088#1077#1096#1077#1085#1080#1077
      object StringGrid1: TStringGrid
        Left = 0
        Top = 227
        Width = 814
        Height = 280
        Align = alBottom
        Anchors = [akLeft, akTop, akRight, akBottom]
        FixedCols = 0
        FixedRows = 0
        TabOrder = 0
      end
      object reOutput: TRichEdit
        Left = 0
        Top = 68
        Width = 814
        Height = 159
        Align = alBottom
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object bIterate: TButton
        Left = 96
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Iterate'
        TabOrder = 2
        OnClick = bIterateClick
      end
      object bPrint: TButton
        Left = 16
        Top = 40
        Width = 75
        Height = 25
        Caption = 'Print'
        TabOrder = 3
        OnClick = bPrintClick
      end
      object bInit: TButton
        Left = 16
        Top = 8
        Width = 75
        Height = 25
        Caption = 'Init'
        TabOrder = 4
        OnClick = bInitClick
      end
      object bClear: TButton
        Left = 96
        Top = 40
        Width = 75
        Height = 25
        Caption = 'Clear'
        TabOrder = 5
        OnClick = bClearClick
      end
    end
    object ts: TTabSheet
      Caption = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1103
      ImageIndex = 1
      DesignSize = (
        814
        507)
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 107
        Height = 13
        Caption = #1050#1086#1083'-'#1074#1086' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1081' :'
      end
      object Label2: TLabel
        Left = 128
        Top = 0
        Width = 106
        Height = 13
        Caption = #1050#1086#1083'-'#1074#1086' '#1087#1077#1088#1077#1084#1077#1085#1085#1099#1093' :'
      end
      object Label4: TLabel
        Left = 264
        Top = 0
        Width = 144
        Height = 13
        Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1086#1087#1090#1080#1084#1080#1079#1072#1094#1080#1080' :'
      end
      object Label3: TLabel
        Left = 0
        Top = 40
        Width = 96
        Height = 13
        Caption = #1062#1077#1083#1077#1074#1072#1103' '#1092#1091#1085#1082#1094#1080#1103' :'
      end
      object sgLimitParams: TStringGrid
        Left = 0
        Top = 88
        Width = 665
        Height = 413
        Anchors = [akLeft, akTop, akRight, akBottom]
        DefaultColWidth = 34
        FixedCols = 0
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
        TabOrder = 0
      end
      object eLimit: TEdit
        Left = 0
        Top = 16
        Width = 121
        Height = 21
        TabOrder = 1
        Text = '5'
        OnChange = eLimitChange
        OnKeyPress = eLimitKeyPress
      end
      object eVar: TEdit
        Left = 128
        Top = 16
        Width = 129
        Height = 21
        TabOrder = 2
        Text = '5'
        OnChange = eLimitChange
        OnKeyPress = eLimitKeyPress
      end
      object sgLimitSigns: TStringGrid
        Left = 672
        Top = 88
        Width = 65
        Height = 413
        Anchors = [akTop, akRight, akBottom]
        ColCount = 1
        DefaultColWidth = 34
        FixedCols = 0
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
        TabOrder = 3
      end
      object sgLimitRight: TStringGrid
        Left = 744
        Top = 88
        Width = 65
        Height = 413
        Anchors = [akTop, akRight, akBottom]
        ColCount = 1
        DefaultColWidth = 34
        FixedCols = 0
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
        TabOrder = 4
      end
      object bbSave: TBitBtn
        Left = 672
        Top = 14
        Width = 65
        Height = 29
        Action = ActionSave
        Anchors = [akTop, akRight]
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        TabOrder = 5
      end
      object bbLoad: TBitBtn
        Left = 744
        Top = 14
        Width = 65
        Height = 29
        Action = ActionLoad
        Anchors = [akTop, akRight]
        Caption = #1054#1090#1082#1088#1099#1090#1100
        TabOrder = 6
      end
      object cbTaskType: TComboBoxEx
        Left = 264
        Top = 16
        Width = 145
        Height = 22
        ItemsEx = <
          item
            Caption = 'MAX'
          end
          item
            Caption = 'MIN'
          end>
        ItemHeight = 16
        TabOrder = 7
        DropDownCount = 8
      end
      object sgFunc: TStringGrid
        Left = 0
        Top = 54
        Width = 665
        Height = 29
        Anchors = [akLeft, akTop, akRight]
        DefaultColWidth = 34
        FixedCols = 0
        RowCount = 1
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
        TabOrder = 8
      end
    end
  end
  object MainMenu: TMainMenu
    Left = 444
    Top = 128
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N7: TMenuItem
        Caption = #1053#1086#1074#1099#1081
      end
      object N5: TMenuItem
        Action = ActionSave
      end
      object N6: TMenuItem
        Action = ActionLoad
      end
    end
    object N8: TMenuItem
      Caption = #1056#1077#1096#1077#1085#1080#1077
      object N9: TMenuItem
        Action = ActionCalcRun
      end
    end
    object N2: TMenuItem
      Caption = #1055#1086#1084#1086#1097#1100
      object N3: TMenuItem
        Action = ActionHelp
      end
      object N4: TMenuItem
        Action = ActionShowAbout
      end
    end
  end
  object ActionList: TActionList
    Left = 404
    Top = 128
    object ActionSave: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ShortCut = 16467
      OnExecute = ActionSaveExecute
    end
    object ActionLoad: TAction
      Caption = #1054#1090#1082#1088#1099#1090#1100
      ShortCut = 16463
      OnExecute = ActionLoadExecute
    end
    object ActionShowAbout: TAction
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      OnExecute = ActionShowAboutExecute
    end
    object ActionHelp: TAction
      Caption = #1057#1087#1088#1072#1074#1082#1072
      ShortCut = 112
    end
    object ActionCalcRun: TAction
      Caption = #1047#1072#1087#1091#1089#1082
      ShortCut = 120
      OnExecute = ActionCalcRunExecute
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'tpr'
    Filter = '*.tpr|*.tpr'
    Left = 300
    Top = 128
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'tpr'
    Filter = '*.tpr|*.tpr'
    Left = 332
    Top = 128
  end
end
