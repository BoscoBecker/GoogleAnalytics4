unit Google.Controller.Analytics;
interface
uses
  Google.Controller.Analytics.Interfaces,
  Google.Model.Analytics.Interfaces;
type
  TControllerGoogleAnalytics = Class(TInterfacedObject, iControllerGoogleAnalytics)
  private
    FScreenResolution: TControllerGoogleAnalytics;
    FGooglePropertyID: String;
    FGooogleApiSecretKey: String;
    FClienteID: String;
    FUserID: String;
    FSystemPlatform: String;
    FURL  : String;
    FAppInfo: iModelGoogleAppInfo;
    FX: String;
    FY: String;
    class var FInstance : TControllerGoogleAnalytics;
    function GuidCreate: string;
    function GetSystemPlatform: string;
    function GetScreenResolution: TControllerGoogleAnalytics;
    procedure ValidaDados;
    procedure SetX(const Value: String);
    procedure SetY(const Value: String);  public
    constructor Create(AGooglePropertyID, AGooogleApisecretKey: String; AUserID: String = '');
    destructor Destroy; override;
    class function New(AGooglePropertyID, AGooogleApisecretKey: String; AUserID: String = ''): iControllerGoogleAnalytics;
    function GooglePropertyID: String; overload;
    function GooglePropertyID(Value: String): iControllerGoogleAnalytics; overload;
    function GooogleApiSecretKey(Value: String): iControllerGoogleAnalytics;overload;
    function GooogleApiSecretKey: String; overload;
    function ClienteID: String; overload;
    function ClienteID(Value: String): iControllerGoogleAnalytics; overload;
    function UserID: String; overload;
    function UserID(Value: String): iControllerGoogleAnalytics; overload;
    function SystemPlatform: String;
    function ScreenResolution: iControllerGoogleAnalytics;
    function GetX:String;
    function GetY:String;
    function URL: String; overload;
    function URL(Value: String): iControllerGoogleAnalytics; overload;
    function AppInfo: iModelGoogleAppInfo;
    function Event(ACategory, AAction, ALabel: String; AValue: Integer = 0): iControllerGoogleAnalytics;
    function Exception(ADescription: String; AIsFatal: Boolean): iControllerGoogleAnalytics;
    function ScreenView(AScreenName: String): IControllerGoogleAnalytics;
    function PageView(ADocumentHostName, APage, ATitle: String): IControllerGoogleAnalytics;
    function StartSession: IControllerGoogleAnalytics;
    function EndSession: IControllerGoogleAnalytics;
    public
      property X: String read GetX write SetX;
      property Y: String read GetY write SetY;
  End;
implementation
uses
  Winapi.ActiveX,
  Winapi.Windows,
  System.Classes,
  System.SysUtils,
  System.Win.Registry,
  Vcl.Forms, Google.Model.Analytics.Factory, Google.Model.Analytics.Invoker;

{ TControllerGoogleAnalytics }

function TControllerGoogleAnalytics.AppInfo: iModelGoogleAppInfo;
begin
  Result  :=  FAppInfo;
end;
function TControllerGoogleAnalytics.ClienteID( Value: String): iControllerGoogleAnalytics;
begin
  Result  :=  Self;
  FClienteID :=  Value;
end;
function TControllerGoogleAnalytics.ClienteID: String;
begin
  Result  :=  FClienteID;
end;
constructor TControllerGoogleAnalytics.Create(AGooglePropertyID, AGooogleApisecretKey: String; AUserID: String = '');
begin
  FGooglePropertyID :=  AGooglePropertyID;
  FGooogleApiSecretKey:= AGooogleApisecretKey;
  FUserID :=  AUserID;
  FClienteID  := GuidCreate;
  FSystemPlatform  := GetSystemPlatform;
  FScreenResolution:=  GetScreenResolution;

  FURL:=  'https://www.google-analytics.com/mp/collect?';
  FAppInfo:=  TModelGoogleAnalyticsFactory.New.AppInfo;
end;
destructor TControllerGoogleAnalytics.Destroy;
begin
  Sleep(500); //apenas para resolver o problema com a memoria ao fecha o sistema
  inherited;
end;
function TControllerGoogleAnalytics.EndSession: IControllerGoogleAnalytics;
begin
  Result  :=  Self;
  ValidaDados;
  TModelGoogleAnalyticsInvoker.New
    .Add(TModelGoogleAnalyticsFactory.New
      .Session(Self)
        .Operation(osEnd)
      .Send)
    .Execute;
end;
function TControllerGoogleAnalytics.Event(ACategory, AAction, ALabel: String; AValue: Integer = 0): iControllerGoogleAnalytics;
begin
  Result  :=  Self;
  ValidaDados;
  TModelGoogleAnalyticsInvoker.New
    .Add(TModelGoogleAnalyticsFactory.New
      .Event(Self)
        .Category(ACategory)
        .Action(AAction)
        .EventLabel(ALabel)
        .EventValue(AValue)
      .Send)
    .Execute;
end;
function TControllerGoogleAnalytics.Exception(ADescription: String; AIsFatal: Boolean): iControllerGoogleAnalytics;
begin
  Result  :=  Self;
  ValidaDados;
  TModelGoogleAnalyticsInvoker.New
    .Add(TModelGoogleAnalyticsFactory.New
      .Exception(Self)
        .Description(ADescription)
        .isFatal(AIsFatal)
      .Send)
    .Execute;
end;
function TControllerGoogleAnalytics.GetScreenResolution: TControllerGoogleAnalytics;
begin
  result:= Self;
  SetX(Screen.Width.Tostring);
  SetY(Screen.Height.ToString);
end;
function TControllerGoogleAnalytics.GetSystemPlatform: string;
var
  Reg: TRegistry;
begin
  Result  :=  '';
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows NT\CurrentVersion') then
    begin
      Result := Format('%s - %s', [Reg.ReadString('ProductName'),
                                    Reg.ReadString('BuildLabEx')]);
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

function TControllerGoogleAnalytics.GetX: String;
begin
  result:= FX;
end;

function TControllerGoogleAnalytics.GetY: String;
begin
  result:= FY;
end;

function TControllerGoogleAnalytics.GooglePropertyID( Value: String): iControllerGoogleAnalytics;
begin
  Result:=  Self;
  FGooglePropertyID :=  Value;
end;
function TControllerGoogleAnalytics.GooogleApiSecretKey: String;
begin
  result:= FGooogleApiSecretKey;
end;

function TControllerGoogleAnalytics.GooogleApiSecretKey( Value: String): iControllerGoogleAnalytics;
begin
  result:= Self;
  FGooogleApiSecretKey:= value;
end;

function TControllerGoogleAnalytics.GuidCreate: string;
var
  ID: TGUID;
begin
  Result := '';
  if CoCreateGuid(ID) = S_OK then
    Result := GUIDToString(ID);
end;
function TControllerGoogleAnalytics.GooglePropertyID: String;
begin
  Result  :=  FGooglePropertyID;
end;
class function TControllerGoogleAnalytics.New(AGooglePropertyID, AGooogleApisecretKey: String; AUserID: String = ''): iControllerGoogleAnalytics;
begin
  if not Assigned(FInstance) then
    FInstance := Self.Create(AGooglePropertyID, AGooogleApisecretKey, AUserID)
  else
    FInstance
      .GooglePropertyID(AGooglePropertyID)
      .GooogleApiSecretKey(AGooogleApisecretKey)
      .UserID(AUserID);
  Result := FInstance;
end;
function TControllerGoogleAnalytics.PageView(ADocumentHostName, APage, ATitle: String): IControllerGoogleAnalytics;
begin
  Result  :=  Self;
  ValidaDados;
  TModelGoogleAnalyticsInvoker.New
    .Add(TModelGoogleAnalyticsFactory.New
      .PageView(Self)
        .DocumentHostName(ADocumentHostName)
        .Page(APage)
        .Title(ATitle)
      .Send)
    .Execute;
end;
function TControllerGoogleAnalytics.ScreenResolution: iControllerGoogleAnalytics;
begin
  Result  :=  FScreenResolution;
end;
function TControllerGoogleAnalytics.ScreenView(AScreenName: String): IControllerGoogleAnalytics;
begin
  Result  :=  Self;
  ValidaDados;
  TModelGoogleAnalyticsInvoker.New
    .Add(TModelGoogleAnalyticsFactory.New
      .ScreeView(Self)
        .ScreenName(AScreenName)
      .Send)
    .Execute;
end;
procedure TControllerGoogleAnalytics.SetX(const Value: String);
begin
  FX := Value;
end;

procedure TControllerGoogleAnalytics.SetY(const Value: String);
begin
  FY := Value;
end;

function TControllerGoogleAnalytics.StartSession: IControllerGoogleAnalytics;
begin
  Result  :=  Self;
  ValidaDados;
  TModelGoogleAnalyticsInvoker.New
    .Add(TModelGoogleAnalyticsFactory.New
      .Session(Self)
        .Operation(osStart)
      .Send)
    .Execute;
end;
function TControllerGoogleAnalytics.SystemPlatform: String;
begin
  Result  :=  FSystemPlatform;
end;
function TControllerGoogleAnalytics.URL(
  Value: String): iControllerGoogleAnalytics;
begin
  Result  :=  Self;
  FURL  :=  Value;
end;
function TControllerGoogleAnalytics.URL: String;
begin
  Result  :=  FURL;
end;
function TControllerGoogleAnalytics.UserID(
  Value: String): iControllerGoogleAnalytics;
begin
  Result  :=  Self;
  FUserID :=  Value;
end;
procedure TControllerGoogleAnalytics.ValidaDados;
begin
  if Trim(FGooglePropertyID) = '' then
    raise System.SysUtils.Exception.Create('Google Property ID "TID" não informado!');
end;
function TControllerGoogleAnalytics.UserID: String;
begin
  Result  :=  FUserID;
end;
end.
