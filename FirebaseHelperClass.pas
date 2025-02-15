unit FirebaseHelperClass;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.StdCtrls,
  FMX.Controls.Presentation, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, JSON, System.Threading,
  System.Net.Mime, System.Generics.Collections;

type
  IFirebaseHelper = interface
    function Put(const Data: TJsonObject; Path: string): string;
    function Get(const Path: string): string;
    function Delete(const Path: string): string;
  end;

  TFirebaseHelper = class(TInterfacedObject, IFirebaseHelper)
  private
    FNetHttpClient: TNetHTTPClient;
    FSecretKey: string;
    FDatabaseURL: string;
    function FormatJSON(const JSON: string): string;
  public
    constructor Create(const NetHttpClient: TNetHTTPClient; const DatabaseURL: string;
    const SecretKey: string);
    function Put(const Data:TJsonObject; Path: string): string;
    function Get(const Path: string): string;
    function Delete(const Path: string): string;
end;

implementation

{ TFirebaseHelper }

constructor TFirebaseHelper.Create(const NetHttpClient: TNetHTTPClient;
  const DatabaseURL: string; const SecretKey: string);
begin
  FNetHttpClient := NetHttpClient;
  if SecretKey <> '' then
    FSecretKey := SecretKey
  else
  begin
    ShowMessage('Secret key is empty!');
    Exit;
  end;
  if DatabaseURL <> '' then
    FDatabaseURL := DatabaseURL
  else
  begin
    ShowMessage('Database URL is empty!');
    Exit;
  end;
end;

function TFirebaseHelper.Delete(const Path: string): string;
var
  ResponseContent: TStringStream;
begin
  ResponseContent := nil;
  try
    ResponseContent := TStringStream.Create;
    FNetHttpClient.Delete(FDatabaseURL + Path + '.json?auth=' + FSecretKey, ResponseContent);
    Result := FormatJSON(ResponseContent.DataString);
  finally
    ResponseContent.Free;
  end;
end;

function TFirebaseHelper.FormatJSON(const JSON: string): string;
var
  JsonValue: TJsonValue;
  JsonObject: TJsonObject;
begin
  JsonValue := TJsonObject.ParseJSONValue(JSON);
  try
    if JsonValue is TJSONNull then
      Result := JSON
    else
    begin
      JsonObject := TJsonObject(JsonValue) as TJsonObject;
      Result := JsonObject.Format();
    end;
  finally
    JsonValue.Free;
  end;
end;

function TFirebaseHelper.Get(const Path: string): string;
var
  ResponseContent: TStringStream;
begin
  ResponseContent := nil;
  try
    ResponseContent := TStringStream.Create;
    FNetHttpClient.Get(FDatabaseURL + Path + '.json?auth=' + FSecretKey, ResponseContent);
    Result := FormatJSON(ResponseContent.DataString);
  finally
    ResponseContent.Free;
  end;
end;

function TFirebaseHelper.Put(const Data: TJsonObject; Path: string): string;
var
  Stream, ResponseContent: TStringStream;
begin
  Stream := nil;
  ResponseContent := nil;
  try
    Stream := TStringStream.Create(FormatJSON(Data.ToJSON), TEncoding.UTF8);
    ResponseContent := TStringStream.Create;
    FNetHttpClient.Put(FDatabaseURL + Path + '.json?auth=' + FSecretKey,
      Stream, ResponseContent);
    Result := FormatJSON(ResponseContent.DataString);
  finally
    Stream.Free;
    ResponseContent.Free;
  end;
end;

end.
