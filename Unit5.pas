unit Unit5;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.DBCtrls, SynEditHighlighter, SynHighlighterSQL, SynEdit,
  SynDBEdit, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, FireDAC.Comp.Client, System.JSON, System.IOUtils,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, Vcl.CheckLst, Vcl.Buttons,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, Datasnap.Provider, Datasnap.DBClient,
  SynHighlighterProgress, System.Threading, System.Generics.Collections,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script,
  FireDAC.Phys.IBWrapper, FireDAC.Phys.IBBase, ComObj;

type
  TForm5 = class(TForm)
    Panel1: TPanel;
    SynEdit1: TSynEdit;
    SynSQLSyn1: TSynSQLSyn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel2: TPanel;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    DBGrid1: TDBGrid;
    FDConnection1: TFDConnection;
    ListView1: TListView;
    Panel3: TPanel;
    BitBtn1: TBitBtn;
    CheckBox1: TCheckBox;
    FDQuery1: TFDQuery;
    DataSource1: TDataSource;
    ComboBox1: TComboBox;
    CheckListBox1: TCheckListBox;
    TabSheet5: TTabSheet;
    ListView2: TListView;
    RadioGroup1: TRadioGroup;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    BitBtn2: TBitBtn;
    FDFBOnlineValidate1: TFDFBOnlineValidate;
    BitBtn3: TBitBtn;
    procedure LoadDatabaseInfo;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SaveQueryHistory(const HistoryList: TStringList);
    procedure LoadQueryHistory(ListView: TListView);
    procedure ListView2SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);

  private
    { Private declarations }
    procedure UpdateListViewStatus(const Database, Status: String);
    procedure ProcessDatabase(const Database: string; ClientDataSet: TClientDataSet);
    procedure LogError(const Database: string; const ErrorMessage: string; const ExecutionTime: TDateTime);
  public
    { Public declarations }
    ClientDataSet: TClientDataSet;
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.BitBtn1Click(Sender: TObject);
var
  JSONValue: TJSONValue;
  JSONObject, Group: TJSONObject;
  CurrentPair, Pair: TJSONPair;
  i: Integer;
  SelectedDatabase, QueryHistory: TStringList;
  Database: String;
  Tasks: array of ITask;

begin
  SelectedDatabase := TStringList.Create;
  QueryHistory := TStringList.Create;

  try
    JSONValue := TJSONObject.ParseJSONValue(
      TEncoding.UTF8.GetString(TFile.ReadAllBytes('C:\Users\Admin\Desktop\databases.json')));

    if not (JSONValue is TJSONObject) then
      raise Exception.Create('JSON value is not an object');

    JSONObject := JSONValue as TJSONObject;

    // ������� �� ����� ���� � ��� ������
    for i := 0 to CheckListBox1.Count - 1 do
      if CheckListBox1.Checked[i] then
      begin
        if JSONObject.TryGetValue<TJSONObject>(ComboBox1.Items[ComboBox1.ItemIndex], Group) then
        begin
          for CurrentPair in Group do
            if CurrentPair.JsonString.Value = CheckListBox1.Items[i] then
            begin
              SelectedDatabase.Add(CurrentPair.JsonValue.Value);
              Break;
            end;
        end
        else if ComboBox1.Items[ComboBox1.ItemIndex] = '��� ����' then
        begin
          for Pair in JSONObject do
          begin
            Group := Pair.JsonValue as TJSONObject;
            for CurrentPair in Group do
              if CurrentPair.JsonString.Value = CheckListBox1.Items[i] then
              begin
                SelectedDatabase.Add(CurrentPair.JsonValue.Value);
                Break;
              end;
          end;
        end;
      end;

    if SelectedDatabase.Count = 0 then
    begin
      ShowMessage('����������, �������� ���� �� ���� ���� ������.');
      Exit;
    end;

    // �������������� ������ (������������ ����������)
    SetLength(Tasks, SelectedDatabase.Count);
    for i := 0 to SelectedDatabase.Count - 1 do
    begin
      ProcessDatabase(SelectedDatabase[i], ClientDataSet);
    end;

    // ������� �� ����� � ����������� �� ����������� ��������
    if RadioGroup1.ItemIndex = 1 then
      PageControl1.ActivePage := TabSheet1
    else
      PageControl2.ActivePage := TabSheet4;

    // ��������� ���������� ������
    QueryHistory.Add(SynEdit1.Lines.Text);
    SaveQueryHistory(QueryHistory);

    // ������������� DataSource1 � ����� ClientDataSet
    DataSource1.DataSet := ClientDataSet;

  finally
    SelectedDatabase.Free;
    JSONValue.Free;
  end;
end;


// ��������� �������� ������� �� �����
procedure TForm5.BitBtn2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    // ��������� ��������� ���� � ������ ��� ����������
    SynEdit1.Lines.LoadFromFile(OpenDialog1.FileName);
  end;
end;

procedure TForm5.BitBtn3Click(Sender: TObject);
var
  Excel: Variant;
  Workbook: Variant;
  Worksheet: Variant;
  i, j: Integer;
begin
  // ��������� ������ ���������� �����
  if SaveDialog1.Execute then
  begin
    try
      // ������� OLE ������ ��� Excel
      Excel := CreateOleObject('Excel.Application');
      Excel.Visible := True; // ���������� Excel (�� �����������)

      // ��������� ����� �����
      Workbook := Excel.Workbooks.Add;
      Worksheet := Workbook.Worksheets[1];

      // ��������� ������ ������� �� dataset
      with DataSource1.DataSet do
      begin
        for i := 0 to FieldCount - 1 do
        begin
          // ���������, ����� ���� �� ���� ������
          if Fields[i].DisplayName <> '' then
            Worksheet.Cells[1, i + 1] := Fields[i].DisplayName;
        end;

        // ��������� � ������ ������
        First;

        // ��������� ������
        i := 2; // �������� � ������ ������, ��������� ������ ������ ��� ��������� �����������
        while not Eof do
        begin
          for j := 0 to FieldCount - 1 do
          begin
            // ������������ ������ ���� ������
            case Fields[j].DataType of
              TFieldType.ftString:
                if Fields[j].AsString <> '' then
                  Worksheet.Cells[i, j + 1] := Fields[j].AsString;
              TFieldType.ftInteger:
                if Fields[j].AsInteger <> 0 then
                  Worksheet.Cells[i, j + 1] := Fields[j].AsInteger;
              TFieldType.ftSmallint:
                if Fields[j].AsInteger <> 0 then
                  Worksheet.Cells[i, j + 1] := Fields[j].AsInteger;
              TFieldType.ftFloat:
                if Fields[j].AsFloat <> 0 then
                  Worksheet.Cells[i, j + 1] := Fields[j].AsFloat;
              TFieldType.ftDate:
                if not Fields[j].IsNull then
                  Worksheet.Cells[i, j + 1] := FormatDateTime('yyyy-mm-dd', Fields[j].AsDateTime);
              TFieldType.ftTime:
                if not Fields[j].IsNull then
                  Worksheet.Cells[i, j + 1] := FormatDateTime('hh:nn:ss', Fields[j].AsDateTime);
              TFieldType.ftTimeStamp:
                if not Fields[j].IsNull then
                  Worksheet.Cells[i, j + 1] := FormatDateTime('yyyy-mm-dd hh:nn:ss', Fields[j].AsDateTime);
              // �������� ��������� ��� ������ ����� ������
            else
              // ���� ��� ������ �� ��������������, ����� ������� ��������� ��� ���������� ��� ������
              ShowMessage('�� �������������� ��� ������ ��� ���� ' + Fields[j].FieldName);
            end;
          end;
          Inc(i);
          Next;
        end;
      end;

      // ��������� ����, ���������� � ������������ ����
      if SaveDialog1.FileName <> '' then
        Workbook.SaveAs(SaveDialog1.FileName)
      else
        ShowMessage('���� � ����� �� ������');

    finally
      // ����������� �������
      Workbook := Unassigned;
      Worksheet := Unassigned;
      Excel.Quit;
      Excel := Unassigned;
    end;
  end;
end;

procedure TForm5.CheckBox1Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to CheckListBox1.Count - 1 do
  begin
    if CheckBox1.Checked then
      CheckListBox1.Checked[i] := True
    else
      CheckListBox1.Checked[i] := False;
  end;
end;

procedure TForm5.ComboBox1Change(Sender: TObject);
var
  JSONObject, Group: TJSONObject;
  JSONValue, Database: TJSONValue;
  JSONPair: TJSONPair;
  i: Integer;
begin
  CheckListBox1.Clear;

  // ��������� JSON ����
  JSONValue := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetString(TFile.ReadAllBytes('C:\Users\Admin\Desktop\databases.json')));

  // ��������� ��� ������������ JSON ��������
  if JSONValue is TJSONObject then
    JSONObject := JSONValue as TJSONObject
  else
    raise Exception.Create('JSON value is not an object');

  // ����� ��������� ������
  if JSONObject.TryGetValue<TJSONObject>(ComboBox1.Items[ComboBox1.ItemIndex], Group) then
  begin
    // ���� Group - ��� ������, ���������� ���
    for i := 0 to Group.Count - 1 do
    begin
      CheckListBox1.Items.Add(Group.Pairs[i].JsonString.Value);
    end;
  end
  else if ComboBox1.Items[ComboBox1.ItemIndex] = '��� ����' then
  begin
    // ���� ������� ����� "��� ����", ���������� ��� ������
    for JSONPair in JSONObject do
    begin
      Group := JSONPair.JsonValue as TJSONObject;
      for i := 0 to Group.Count - 1 do
      begin
        CheckListBox1.Items.Add(Group.Pairs[i].JsonString.Value);
      end;
    end;
  end;

  JSONValue.Free;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
  LoadDatabaseInfo;
end;

procedure TForm5.ListView2SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  // ���������, ��� �� ������ �������
  if Selected then
  begin
    // �������� ����� �� ������� "������" � SynEdit1
    SynEdit1.Lines.Text := Item.Caption;
    PageControl2.ActivePage := TabSheet3;
  end;
end;

procedure TForm5.LoadDatabaseInfo;
var
  JSONData: TJSONObject;
  JsonPair: TJSONPair;
  Databases: TJSONObject;
  Key: string;
  ListItem: TListItem;
  DatabaseFile, DatabasePath, ConnectionStatus: string;
  i: Integer;
begin
  DatabaseFile := 'C:\Users\Admin\Desktop\databases.json'; // ������� ���� � JSON �����, ��� ������� �����������

  // ������ � ������ JSON
  JSONData := TJSONObject.ParseJSONValue(TFile.ReadAllText(DatabaseFile)) as TJSONObject;

   // ��������� ComboBox ��������
  for JSONPair in JSONData do
  begin
    ComboBox1.Items.Add(JSONPair.JsonString.Value);
  end;

  // �������� ����� "��� ����"
  ComboBox1.Items.Add('��� ����');

  // ���������� ������ ������
  ComboBox1.ItemIndex := 0;

  // ��������� CheckListBox ������ ��� ��������� ������
  ComboBox1Change(nil);

  // ��������� ������� ��������
  LoadQueryHistory(ListView2);

  // �������������� ClientDataSet
  ClientDataSet := TClientDataSet.Create(nil);

  try
    // ���������� �������� �����
    for i := 0 to JSONData.Count -1 do
    begin
      Key := JSONData.Pairs[i].JsonString.Value; // �������� ����
      Databases := JSONData.Pairs[i].JsonValue as TJSONObject; // �������� �������� ��� ������

      //ComboBoxGroup.Items.Add(Key); // ��������� ������ � ComboBox

      // ���������� ���� ������
      for JsonPair in Databases do
      begin
        // ������� ������� ������
        ListItem := ListView1.Items.Add;
        ListItem.Caption := JsonPair.JsonString.Value;
        ListItem.SubItems.Add(JsonPair.JsonValue.Value);

        // ��������� ��������� � ListView
        ListItem.SubItems.Add(ConnectionStatus);
      end;
    end;
  finally
    JSONData.Free;
  end;
end;

procedure TForm5.SaveQueryHistory(const HistoryList: TStringList);
var
  JSONArray: TJSONArray;
  JSONValue: TJSONObject;
  ExistingJSONArray: TJSONArray;
  i: Integer;
  JSONFile: TStringStream;
  JSONStr: string;
begin
  JSONArray := TJSONArray.Create; // ������� ����� ������
  try
    // ���������, ���������� �� ���� � ��������� ������������ �������
    if FileExists('C:\Users\Admin\Desktop\query_history.json') then
    begin
      JSONStr := TFile.ReadAllText('C:\Users\Admin\Desktop\query_history.json');
      ExistingJSONArray := TJSONArray(TJSONObject.ParseJSONValue(JSONStr));

      if Assigned(ExistingJSONArray) then
      begin
        // ��������� ������ ������� � ����� ������
        for i := 0 to ExistingJSONArray.Count - 1 do
        begin
          JSONArray.AddElement(ExistingJSONArray.Items[i] as TJSONObject);
        end;
      end
      else
      begin
        // ���� ������� �� ������, ������� ������ � ���������
        JSONStr := '';
      end;
    end;

    // ��������� ����� �������
    for i := 0 to HistoryList.Count - 1 do
    begin
      JSONValue := TJSONObject.Create;

      JSONValue.AddPair('query', HistoryList[i]);
      JSONValue.AddPair('timestamp', DateTimeToStr(Now));
      JSONArray.AddElement(JSONValue);
    end;

    // ��������� ����������� ������ � ����
    JSONFile := TStringStream.Create(JSONArray.ToJSON);
    JSONFile.SaveToFile('C:\Users\Admin\Desktop\query_history.json');


  finally
    JSONArray.Free; // ����������� ������
  end;
end;


procedure TFOrm5.LoadQueryHistory(ListView: TListView);
var
  JSONValue: TJSONValue;
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  i: Integer;
  JSONString: string;
begin
  ListView.Items.Clear; // �������� ����� ���������

  if FileExists('C:\Users\Admin\Desktop\query_history.json') then
  begin
    // ������ ���������� ����� � ������
    JSONString := TFile.ReadAllText('C:\Users\Admin\Desktop\query_history.json');

    JSONValue := TJSONObject.ParseJSONValue(JSONString);
    if JSONValue is TJSONArray then
    begin
      JSONArray := JSONValue as TJSONArray;

      for i := 0 to JSONArray.Count - 1 do
      begin
        JSONObject := JSONArray[i] as TJSONObject;

        // ��������� ������� � ListView
        with ListView.Items.Add do
        begin
           Caption := JSONObject.GetValue<string>('query'); // ������
           SubItems.Add(JSONObject.GetValue<string>('timestamp')); // �����
        end;
      end;
    end;
    JSONValue.Free;
  end;
end;

procedure TForm5.ProcessDatabase(const Database: string; ClientDataSet: TClientDataSet);
var
  Task: ITask;
begin
  Task := TTask.Run(
    procedure
    var
      LocalConnection: TFDConnection;
      LocalQuery: TFDQuery;
      LocalScript: TFDScript;
      DataSetProvider: TDataSetProvider;
      Status: string;
    begin
      LocalConnection := TFDConnection.Create(nil);
      LocalQuery := TFDQuery.Create(nil);
      LocalScript := TFDScript.Create(nil);
      try
        TThread.Synchronize(nil,
          procedure
          begin
            UpdateListViewStatus(Database, '�����������');
          end);

        LocalConnection.DriverName := 'FB';
        LocalConnection.Params.Database := Database;
        LocalConnection.Params.UserName := 'MIFUSER';
        LocalConnection.Params.Password := 'MIFROOT';
        LocalConnection.Params.Values['CharacterSet'] := 'WIN1251';
        LocalQuery.Connection := LocalConnection;
        LocalScript.Connection := LocalConnection;
        try
          LocalConnection.Connected := True;

          if RadioGroup1.ItemIndex = 0 then // ��������� ��������� ������� "������"
          begin
            LocalQuery.SQL.Text := SynEdit1.Lines.Text;
            LocalQuery.Open;

            TThread.Synchronize(nil,
              procedure
              begin
                try
                  DataSetProvider := TDataSetProvider.Create(nil);
                  DataSetProvider.DataSet := LocalQuery;
                  ClientDataSet.AppendData(DataSetProvider.Data, True);

                  // �������� ������
                  if ClientDataSet.IsEmpty then
                  begin
                      ShowMessage('ClientDataSet ����');
                  end;

                except
                  on E: Exception do
                  begin
                    LogError(Database, E.Message, Now); // ���������� ��������� �� ������ � ������� ��������
                    ShowMessage('������ ��� ����������� ������: ' + E.Message);
                  end;
                end;
              end);

            Status := '������ �������� �������';
          end
          else if RadioGroup1.ItemIndex = 1 then // ��������� ��������� ������� "������"
          begin
            LocalScript.SQLScripts.Add;
            LocalScript.SQLScripts[0].SQL := SynEdit1.Lines;
            LocalScript.ValidateAll;
            LocalScript.ExecuteAll;

            Status := '������ �������� �������';
          end;

        except
          on E: EFDDBEngineException do
          begin
            LogError(Database, E.Message, Now); // ���������� ��������� �� ������ � ������� ��������
            Status := '������ ����������: ' + E.Message;
          end;
        end;

        TThread.Synchronize(nil,
          procedure
          begin
            UpdateListViewStatus(Database, Status);
          end);
      finally
        LocalQuery.Free;
        LocalScript.Free;
        LocalConnection.Free;
      end;
    end);
end;


// ��������������� ��������� ��� ���������� ������� � ListView
procedure TForm5.UpdateListViewStatus(const Database, Status: String);
var
  i: Integer;
begin
  for i := 0 to ListView1.Items.Count - 1 do
    if ListView1.Items[i].SubItems[0] = Database then
    begin
      if ListView1.Items[i].SubItems.Count > 1 then
      begin
        ListView1.Items[i].SubItems[1] := Status;
      end
      else
      begin
        ShowMessage('������������ ������� ��� ���������� �������.');
      end;
    end;
end;

// ��������� ������ ���� � �� ��������� ����������� �������� � ��������
procedure TForm5.LogError(const Database: string; const ErrorMessage: string; const ExecutionTime: TDateTime);
var
  LogFile: TextFile;
  LogMessage: String;
begin
  AssignFile(LogFile, 'error_log.txt');
  if FileExists('error_log.txt') then
    Append(LogFile) // ���� ���� ����������, ��������� ��� ��� ����������
  else
    Rewrite(LogFile); // ���� ����� ���, ������� �����

  try
    LogMessage := Format('%s - ����: %s, ������: %s',
                 [DateTimeToStr(ExecutionTime), Database, ErrorMessage]);
    Writeln(LogFile, LogMessage); // ���������� ������ � ����
  finally
    CloseFile(LogFile); // ��������� ����
  end;
end;

end.
