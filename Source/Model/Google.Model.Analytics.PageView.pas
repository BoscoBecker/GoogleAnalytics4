unit Google.Model.Analytics.PageView;
interface
uses
  Google.Model.Analytics.Interfaces,
  Google.Controller.Analytics.Interfaces;
type
  TModelGoogleAnalyticsPageView = Class(TInterfacedObject, iModelGooglePageView, iCommand)
  private
    [weak]
    FParent: iControllerGoogleAnalytics;
    FHostName: String;
    FPage: String;
    FTitle: String;
  public
    constructor Create(AParent: iControllerGoogleAnalytics);
    destructor Destroy; override;
    class function New(AParent: iControllerGoogleAnalytics): iModelGooglePageView;
    function DocumentHostName: String; overload;
    function DocumentHostName(Value: String): iModelGooglePageView; overload;
    function Page: String; overload;
    function Page(Value: String): iModelGooglePageView; overload;
    function Title: String; overload;
    function Title(Value: String): iModelGooglePageView; overload;
    function Send: iCommand;
    function BuidJsonEvent: String;
    function Execute: iCommand;
  End;
implementation

{ TModelGoogleAnalyticsPageView }
uses
  System.Net.HttpClientComponent, System.Classes, System.SysUtils;

function TModelGoogleAnalyticsPageView.BuidJsonEvent: String;
begin
   result:=
   StringReplace(
    '{                                            '+
    '    "client_id":"'+FParent.ClienteID+'",     '+
    '    "events":[                               '+
    '        {                                    '+
    '            "name":"page_view",              '+
    '            "params":{                       '+
    '                "page_location":"'+FPage+'", '+
    '                "page_title":"'+FTitle+'",  '+
    '							   "send_page_view":"True"      '+
    '            }                                '+
    '        }                                    '+
    '    ]                                        '+
    '}                                            '+
'                                             ',#9,'',[rfreplaceall]);
end;

constructor TModelGoogleAnalyticsPageView.Create(AParent: iControllerGoogleAnalytics);
begin
  FParent :=  AParent;
end;
destructor TModelGoogleAnalyticsPageView.Destroy;
begin
  inherited;
end;
function TModelGoogleAnalyticsPageView.Execute: iCommand;
var
  HTTPClient: TNetHTTPClient;
  Params: TStringList;
  ResponseStream : TStringStream;
  ResponseContent : string;
begin
  Result  :=  Self;
  var json := '';
  ResponseStream:= TStringStream.Create(self.BuidJsonEvent,TEncoding.UTF8);
  HTTPClient:= TNetHTTPClient.Create(nil);
  HTTPClient.CustomHeaders['Content-Type'] := 'application/json';
  try
    Params := TStringList.Create;
    try
      Params.Values['&api_secret']:= StringReplace(FParent.GooogleApiSecretKey,#$D#$A,'',[rfReplaceAll]);
      Params.Values['&measurement_id']:= StringReplace(FParent.GooglePropertyID,#$D#$A,'',[rfReplaceAll]);;
      try
        ResponseContent:= HTTPClient.Post(StringReplace(FParent.URL+Params.Text,#$D#$A,'',[rfReplaceAll]),ResponseStream).StatusCode.ToString;
      except  on E : Exception do
        raise Exception.Create('Erro na classe: '+E.ClassName+' Mensagem de erro: '+E.Message+ ' Linha: ' + E.StackTrace + 'Status Code'+ ResponseContent);
      end;
    finally
      Params.Free;
      ResponseStream.Free;
    end;
  finally
    HTTPClient.Free;
  end;
end;
function TModelGoogleAnalyticsPageView.DocumentHostName: String;
begin
  Result  :=  FHostName;
end;

function TModelGoogleAnalyticsPageView.DocumentHostName( Value: String): iModelGooglePageView;
begin
  Result  :=  Self;
  FHostName :=  Value;
end;

class function TModelGoogleAnalyticsPageView.New(AParent: iControllerGoogleAnalytics): iModelGooglePageView;
begin
  Result := Self.Create(AParent);
end;
function TModelGoogleAnalyticsPageView.Page(
  Value: String): iModelGooglePageView;
begin
  Result  :=  Self;
  FPage :=  Value;
end;
function TModelGoogleAnalyticsPageView.Page: String;
begin
  Result  :=  FPage;
end;
function TModelGoogleAnalyticsPageView.Send: iCommand;
begin
  Result  :=  Self;
end;
function TModelGoogleAnalyticsPageView.Title(
  Value: String): iModelGooglePageView;
begin
  Result  :=  Self;
  FTitle :=  Value;
end;
function TModelGoogleAnalyticsPageView.Title: String;
begin
  Result  :=  FTitle;
end;
end.
