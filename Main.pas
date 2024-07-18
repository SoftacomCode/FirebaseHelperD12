unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Effects,
  FMX.StdCtrls, FMX.Controls.Presentation, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, System.Rtti,
  FMX.Grid.Style, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Controls, FMX.Edit, FMX.Layouts,
  Fmx.Bind.Navigator, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.ScrollBox, FMX.Grid,
  FMX.Memo, FMX.TabControl, FireDAC.Stan.StorageBin, FMX.Memo.Types, Json,
  FMX.Objects, FMX.EditBox, FMX.SpinBox, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, FirebaseHelperClass,
  FMX.ComboEdit;

type
  TMainForm = class(TForm)
    NetHTTPClient1: TNetHTTPClient;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    Label4: TLabel;
    EditName: TEdit;
    Label2: TLabel;
    EditProfession: TEdit;
    Label5: TLabel;
    EditSurname: TEdit;
    btnDelete: TButton;
    btnPut: TButton;
    btnGetAll: TButton;
    btnGetBySurname: TButton;
    TabItem2: TTabItem;
    Memo1: TMemo;
    ToolBar1: TToolBar;
    Label1: TLabel;
    ShadowEffect4: TShadowEffect;
    procedure btnGetAllClick(Sender: TObject);
    procedure btnGetBySurnameClick(Sender: TObject);
    procedure btnPutClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FSecretKey: string;
    FDatabaseURL: string;
  public
    { Public declarations }
    property SecretKey: string read FSecretKey write FSecretKey;
    property DatabaseURL: string read FDatabaseURL write FDatabaseURL;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  System.Threading, System.Net.Mime, System.IOUtils;

procedure TMainForm.btnDeleteClick(Sender: TObject);
var
  FirebaseObject: IFirebaseHelper;
  ResponseFromFirebase: string;
begin
  Memo1.Lines.Clear;
  FirebaseObject := TFirebaseHelper.Create(NetHttpClient1, FDatabaseURL, FSecretKey);
  TTask.Run(
    procedure
    begin
      try
        ResponseFromFirebase := FirebaseObject.Delete('MyNewData/' + EditSurname.Text);
      finally
        TThread.Synchronize(nil,
        procedure
        begin
          Memo1.Text := ResponseFromFirebase;
          if ResponseFromFireBase = 'null' then
            Memo1.Text := 'Record ' + EditSurname.Text + ' deleted!';
          TabControl1.GotoVisibleTab(1);
        end);
      end;
    end);
end;

procedure TMainForm.btnGetAllClick(Sender: TObject);
var
  JsonResponse: string;
  FirebaseObject: IFirebaseHelper;
begin
  Memo1.Lines.Clear;
  FirebaseObject := TFirebaseHelper.Create(NetHttpClient1, FDatabaseURL, FSecretKey);
  TTask.Run(
    procedure
    begin
      JsonResponse := FirebaseObject.Get('MyNewData/');
      TThread.Synchronize(nil,
      procedure
      begin
        Memo1.Lines.Add(JsonResponse);
        TabControl1.GotoVisibleTab(1);
      end);
    end);
end;

procedure TMainForm.btnGetBySurnameClick(Sender: TObject);
var
  JsonResponse: string;
  FirebaseObject: IFirebaseHelper;
begin
  Memo1.Lines.Clear;
  FirebaseObject := TFirebaseHelper.Create(NetHttpClient1, FDatabaseURL, FSecretKey);
  TTask.Run(
    procedure
    begin
      JsonResponse := FirebaseObject.Get('MyNewData/' + EditSurname.Text);
      TThread.Synchronize(nil,
      procedure
      begin
        Memo1.Lines.Add(JsonResponse);
        TabControl1.GotoVisibleTab(1);
      end);
    end);
end;

procedure TMainForm.btnPutClick(Sender: TObject);
var
  JsonToDB : TJSONObject;
  FirebaseObject: IFirebaseHelper;
  AnswerFromFirebase: string;
begin
  Memo1.Lines.Clear;
  FirebaseObject := TFirebaseHelper.Create(NetHttpClient1, FDatabaseURL, FSecretKey);
  TTask.Run(procedure
    begin
      JsonToDB := TJSONObject.Create;
      try
        JsonToDB.AddPair('Name', EditName.Text);
        JsonToDB.AddPair('Surname', EditSurname.Text);
        JsonToDB.AddPair('Profession', EditProfession.Text);
        AnswerFromFirebase := FirebaseObject.Put(JsonToDB, 'MyNewData/' + EditSurname.Text);
        TThread.Synchronize(nil,
        procedure
        begin
          Memo1.Text := AnswerFromFirebase;
          TabControl1.GotoVisibleTab(1);
        end);
      finally
        JsonToDB.Free;
      end;
    end);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DatabaseURL := 'https://mytestproj-60b0b-default-rtdb.firebaseio.com/';
  SecretKey := 'DOG2VuwIQC1a9mQvl9XjmWwqTpOFis16eOPXLVcC';
end;



end.

