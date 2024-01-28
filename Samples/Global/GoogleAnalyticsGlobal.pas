unit GoogleAnalyticsGlobal;

interface

uses
  Google.Controller.Analytics.Interfaces;

var _GoogleAnalytics: iControllerGoogleAnalytics;

implementation

uses
  Google.Controller.Analytics;

const
  //Google Analytics property ID.
  GooglePropertyID =  'ID DA MÉTRICA';
  GooogleApiSecretKey = 'YOURKEYHERE';
  AppName = 'Minha Aplicacao';
  AppLicense = 'Comercial';
  AppEdition = 'ERP';
  VersaoSistema = '1.0.0';

initialization
  _GoogleAnalytics  :=  TControllerGoogleAnalytics
                          .New(GooglePropertyID, GooogleApiSecretKey);

  _GoogleAnalytics.AppInfo
    .AppName(AppName)
    .AppVersion(VersaoSistema)
    .AppLicense(AppLicense)
    .AppEdition(AppEdition);

end.
