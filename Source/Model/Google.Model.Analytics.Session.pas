unit Google.Model.Analytics.Session;
interface
uses
  Google.Model.Analytics.Interfaces,
  Google.Controller.Analytics.Interfaces;
type
  TModelGoogleAnalyticsSession = Class(TInterfacedObject, iModelGoogleSession, iCommand)
  private
    [weak]
    FParent: iControllerGoogleAnalytics;
    FOperation: TOperationSession;
  public
    constructor Create(AParent: iControllerGoogleAnalytics);
    destructor Destroy; override;
    class function New(AParent: iControllerGoogleAnalytics): iModelGoogleSession;
    function Operation(AOperation: TOperationSession): iModelGoogleSession; overload;
    function Operation: TOperationSession; overload;
    function Send: iCommand;
    function Execute: iCommand;
    function BuildJsonEvent: String;
   End;
implementation
{ TModelGoogleAnalyticsSession }
uses
  System.Net.HttpClientComponent, System.Classes, System.SysUtils,dialogs,REST.Client,REST.Types,
  System.JSON;

function TModelGoogleAnalyticsSession.BuildJsonEvent: String;
var
  RootObject, EventObject, ParamsObject: TJSONObject;
  EventsArray: TJSONArray;
begin
  RootObject := TJSONObject.Create;
  try
    RootObject.AddPair('client_id', FParent.ClienteID);

    EventsArray := TJSONArray.Create;
    RootObject.AddPair('events', EventsArray);

    EventObject := TJSONObject.Create;
    EventObject.AddPair('name', 'Start Session');

    ParamsObject := TJSONObject.Create;
    ParamsObject.AddPair('engagement_time_msec', '1000');
    ParamsObject.AddPair('session_id', '999');

    EventObject.AddPair('params', ParamsObject);
    EventsArray.AddElement(EventObject);

    Result := RootObject.ToJSON;
  finally
    RootObject.Free;
  end;
end;

constructor TModelGoogleAnalyticsSession.Create(AParent: iControllerGoogleAnalytics);
begin
  FParent :=  AParent;
  FOperation  :=  osStart;
end;
destructor TModelGoogleAnalyticsSession.Destroy;
begin
  inherited;
end;
function TModelGoogleAnalyticsSession.Execute: iCommand;
var
  HTTPClient: TNetHTTPClient;
  Params: TStringList;
  ResponseStream : TStringStream;
  ResponseContent : string;
begin
  Result  :=  Self;
  ResponseStream:= TStringStream.Create(Self.BuildJsonEvent,TEncoding.UTF8);
  HTTPClient:= TNetHTTPClient.Create(nil);
  HTTPClient.CustomHeaders['Content-Type'] := 'application/json';
  try
    Params := TStringList.Create;
    try
      Params.Values['&api_secret']:= FParent.GooogleApiSecretKey;
      Params.Values['&measurement_id']:= FParent.GooglePropertyID;
      try
        ResponseContent:= HTTPClient.Post(StringReplace(FParent.URL+Params.Text,#$D#$A,'',[rfReplaceAll]),ResponseStream).StatusCode.ToString;
      except on E : Exception do
        ShowMessage(E.ClassName+' error raised, with message : '+E.Message);
      end;
    finally
      Params.Free;
    end;
  finally
    HTTPClient.Free;
  end;
end;

class function TModelGoogleAnalyticsSession.New(AParent: iControllerGoogleAnalytics): iModelGoogleSession;
begin
  Result := Self.Create(AParent);
end;
function TModelGoogleAnalyticsSession.Operation: TOperationSession;
begin
  Result  :=  FOperation;
end;
function TModelGoogleAnalyticsSession.Operation(
  AOperation: TOperationSession): iModelGoogleSession;
begin
  Result  :=  Self;
  FOperation  :=  AOperation;
end;
function TModelGoogleAnalyticsSession.Send: iCommand;
begin
  Result  :=  Self;
end;
end.
