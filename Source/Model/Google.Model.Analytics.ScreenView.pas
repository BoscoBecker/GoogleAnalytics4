unit Google.Model.Analytics.ScreenView;
interface
uses
  Google.Model.Analytics.Interfaces,
  Google.Controller.Analytics,
  Google.Controller.Analytics.Interfaces;
type
  TModelGoogleAnalyticsScreenView = Class(TInterfacedObject, iModelGoogleScreeView, iCommand)
  private
    [weak]
    FParent: iControllerGoogleAnalytics;
    FScreenName: String;
  public
    constructor Create(AParent: iControllerGoogleAnalytics);
    destructor Destroy; override;
    class function New(AParent: iControllerGoogleAnalytics): iModelGoogleScreeView;
    //iGoogleScreeView
    function ScreenName: String; overload;
    function ScreenName(Value: String): iModelGoogleScreeView; overload;
    function Send: iCommand;
    function BuidJsonEvent: String;
    function GetJsonScreenResolution: String;
    function GetJsonOS: String;
    //iCommand
    function Execute: iCommand;
  End;
implementation
{ TModelGoogleAnalyticsScreenView }
uses
  System.Net.HttpClientComponent, System.Classes, System.SysUtils;

constructor TModelGoogleAnalyticsScreenView.Create(AParent: iControllerGoogleAnalytics);
begin
  FParent :=  AParent;
end;
destructor TModelGoogleAnalyticsScreenView.Destroy;
begin
  inherited;
end;
function TModelGoogleAnalyticsScreenView.Execute: iCommand;
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
      ResponseStream.Free;

      /// Send Screen Resolution
      ResponseStream:= TStringStream.Create(self.GetJsonScreenResolution,TEncoding.UTF8);
      Params.Values['&api_secret']:= StringReplace(FParent.GooogleApiSecretKey,#$D#$A,'',[rfReplaceAll]);
      Params.Values['&measurement_id']:= StringReplace(FParent.GooglePropertyID,#$D#$A,'',[rfReplaceAll]);;
      try
        ResponseContent:= HTTPClient.Post(StringReplace(FParent.URL+Params.Text,#$D#$A,'',[rfReplaceAll]),ResponseStream).StatusCode.ToString;
      except  on E : Exception do
        raise Exception.Create('Erro na classe: '+E.ClassName+' Mensagem de erro: '+E.Message+ ' Linha: ' + E.StackTrace + 'Status Code'+ ResponseContent);
      end;
      ResponseStream.Free;

      /// Send OS
      ResponseStream:= TStringStream.Create(self.GetJsonOS,TEncoding.UTF8);
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
function TModelGoogleAnalyticsScreenView.GetJsonOS: String;
begin
   result:=
   StringReplace(
    '{                                               '+
    '    "client_id":"'+FParent.ClienteID+'",        '+
    '	  "events":[                                   '+
    '        {                                       '+
    '            "name":"SistemaOperacional",         '+
    '            "params":{                          '+
    '            "SistemaOperacionalNome":"'+ 'Windows ' + FParent.SystemPlatform +'"'+
    '            }                                   '+
    '        }                                       '+
    '    ]                                           '+
    '}                                               '+
    '                                       ',#9,'',[rfreplaceall]);
end;

function TModelGoogleAnalyticsScreenView.GetJsonScreenResolution: String;
begin
   result:=
   StringReplace(
    '{                                               '+
    '    "client_id":"'+FParent.ClienteID+'",        '+
    '	  "events":[                                   '+
    '        {                                       '+
    '            "name":"screen_resolution",         '+
    '            "params":{                          '+
    '            "screen_width":"'+ FParent.ScreenResolution.GetX +'",'+
		'				   	 "screen_height":"'+ FParent.ScreenResolution.GetY +'"'+
    '            }                                   '+
    '        }                                       '+
    '    ]                                           '+
    '}                                               '+
    '                                       ',#9,'',[rfreplaceall]);
end;

function TModelGoogleAnalyticsScreenView.BuidJsonEvent: String;
begin
   result:=
   StringReplace(
    '{                                               '+
    '    "client_id":"'+FParent.ClienteID+'",        '+
    '	  "events":[                                   '+
    '        {                                       '+
    '            "name":"screen_view",               '+
    '            "params":{                          '+
    '                "screen_name":"'+FScreenName+'" '+
    '            }                                   '+
    '        }                                       '+
    '    ]                                           '+
    '}                                               '+
    '                                       ',#9,'',[rfreplaceall]);
end;

class function TModelGoogleAnalyticsScreenView.New(AParent: iControllerGoogleAnalytics): iModelGoogleScreeView;
begin
  Result := Self.Create(AParent);
end;
function TModelGoogleAnalyticsScreenView.ScreenName(
  Value: String): iModelGoogleScreeView;
begin
  Result  :=  Self;
  FScreenName :=  Value;
end;
function TModelGoogleAnalyticsScreenView.Send: iCommand;
begin
  Result  :=  Self;
end;
function TModelGoogleAnalyticsScreenView.ScreenName: String;
begin
  Result  :=  FScreenName;
end;
end.
