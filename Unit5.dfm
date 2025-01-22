object Form5: TForm5
  Left = 0
  Top = 0
  Caption = 'Form5'
  ClientHeight = 782
  ClientWidth = 1186
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1186
    Height = 782
    Align = alClient
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 1
      Top = 1
      Width = 1184
      Height = 780
      ActivePage = TabSheet2
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = #1041#1072#1079#1099
        object ListView1: TListView
          Left = 0
          Top = 0
          Width = 1176
          Height = 750
          Align = alClient
          Columns = <
            item
              AutoSize = True
              Caption = #1041#1072#1079#1099' '#1076#1072#1085#1085#1099#1093
            end
            item
              AutoSize = True
              Caption = 'IP '#1055#1086#1076#1082#1083#1102#1095#1077#1085#1080#1103
            end
            item
              AutoSize = True
              Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
            end
            item
              AutoSize = True
              Caption = #1057#1090#1072#1090#1091#1089
            end>
          GridLines = True
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'SQL '#1056#1077#1076#1072#1082#1090#1086#1088
        ImageIndex = 1
        object PageControl2: TPageControl
          Left = 0
          Top = 0
          Width = 1176
          Height = 750
          ActivePage = TabSheet3
          Align = alClient
          TabOrder = 0
          object TabSheet3: TTabSheet
            Caption = 'SQL'
            object SynEdit1: TSynEdit
              Left = 0
              Top = 43
              Width = 991
              Height = 677
              Align = alClient
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Consolas'
              Font.Style = []
              Font.Quality = fqClearTypeNatural
              TabOrder = 0
              UseCodeFolding = False
              Gutter.Font.Charset = DEFAULT_CHARSET
              Gutter.Font.Color = clWindowText
              Gutter.Font.Height = -11
              Gutter.Font.Name = 'Consolas'
              Gutter.Font.Style = []
              Gutter.ShowLineNumbers = True
              Gutter.TrackChanges.Visible = True
              Gutter.TrackChanges.ModifiedColor = clForestgreen
              Gutter.Bands = <
                item
                  Kind = gbkMarks
                  Width = 13
                end
                item
                  Kind = gbkLineNumbers
                end
                item
                  Kind = gbkFold
                end
                item
                  Kind = gbkTrackChanges
                end
                item
                  Kind = gbkMargin
                  Width = 3
                end>
              Highlighter = SynSQLSyn1
              SelectedColor.Alpha = 0.400000005960464500
            end
            object Panel3: TPanel
              Left = 0
              Top = 0
              Width = 1168
              Height = 43
              Align = alTop
              TabOrder = 1
              object BitBtn1: TBitBtn
                Left = 0
                Top = 8
                Width = 65
                Height = 27
                Hint = #1042#1099#1087#1086#1083#1085#1080#1090#1100
                Caption = 'BitBtn1'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
                OnClick = BitBtn1Click
              end
              object BitBtn2: TBitBtn
                Left = 71
                Top = 8
                Width = 66
                Height = 29
                Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079
                Caption = 'BitBtn2'
                ParentShowHint = False
                ShowHint = True
                TabOrder = 1
                OnClick = BitBtn2Click
              end
              object BitBtn3: TBitBtn
                Left = 143
                Top = 12
                Width = 75
                Height = 25
                Caption = 'BitBtn3'
                TabOrder = 2
                OnClick = BitBtn3Click
              end
            end
            object Panel2: TPanel
              Left = 991
              Top = 43
              Width = 177
              Height = 677
              Align = alRight
              TabOrder = 2
              object CheckBox1: TCheckBox
                Left = 6
                Top = 410
                Width = 97
                Height = 17
                Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077
                TabOrder = 0
                OnClick = CheckBox1Click
              end
              object ComboBox1: TComboBox
                Left = 6
                Top = 0
                Width = 163
                Height = 23
                TabOrder = 1
                Text = #1042#1099#1073#1086#1088' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093
                OnChange = ComboBox1Change
              end
              object CheckListBox1: TCheckListBox
                Left = 6
                Top = 21
                Width = 163
                Height = 383
                ItemHeight = 15
                TabOrder = 2
              end
              object RadioGroup1: TRadioGroup
                Left = 1
                Top = 571
                Width = 175
                Height = 105
                Align = alBottom
                Caption = #1042#1099#1087#1086#1083#1085#1077#1085#1080#1077
                ItemIndex = 0
                Items.Strings = (
                  #1047#1072#1087#1088#1086#1089
                  #1057#1082#1088#1080#1087#1090)
                TabOrder = 3
              end
            end
          end
          object TabSheet4: TTabSheet
            Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
            ImageIndex = 1
            object DBGrid1: TDBGrid
              Left = 0
              Top = 0
              Width = 1168
              Height = 720
              Align = alClient
              DataSource = DataSource1
              TabOrder = 0
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -12
              TitleFont.Name = 'Segoe UI'
              TitleFont.Style = []
            end
          end
          object TabSheet5: TTabSheet
            Caption = #1048#1089#1090#1086#1088#1080#1103
            ImageIndex = 2
            object ListView2: TListView
              Left = 0
              Top = 0
              Width = 1168
              Height = 720
              Align = alClient
              Columns = <
                item
                  AutoSize = True
                  Caption = #1047#1072#1087#1088#1086#1089
                end
                item
                  AutoSize = True
                  Caption = #1042#1088#1077#1084#1103
                end>
              TabOrder = 0
              ViewStyle = vsReport
              OnSelectItem = ListView2SelectItem
            end
          end
        end
      end
    end
  end
  object SynSQLSyn1: TSynSQLSyn
    KeyAttri.Foreground = clHotLight
    SQLDialect = sqlInterbase6
    Left = 784
    Top = 712
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=FB'
      'User_Name=sysdba'
      'Password=masterkey')
    Left = 897
    Top = 718
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 841
    Top = 714
  end
  object DataSource1: TDataSource
    Left = 689
    Top = 722
  end
  object OpenDialog1: TOpenDialog
    Left = 553
    Top = 717
  end
  object SaveDialog1: TSaveDialog
    Left = 585
    Top = 717
  end
  object FDFBOnlineValidate1: TFDFBOnlineValidate
    Left = 685
    Top = 643
  end
end
