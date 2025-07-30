unit uPermission;

interface

uses
  System.Permissions, FMX.DialogService, FMX.MediaLibrary.Actions,
  System.SysUtils
{$IFDEF ANDROID}
  , Androidapi.Helpers, Androidapi.JNI.JavaTypes, Androidapi.JNI.Net,
    Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.App, Androidapi.JNI.Provider
{$ENDIF}
;

type
  TCallbackProc = procedure(Sender: TObject) of Object;

  TPermissions = class
  public
    procedure SolicitarGaleria(ActionLibrary: TTakePhotoFromLibraryAction;
      ACallBackError: TCallbackProc = nil);
    procedure SolicitarCamera(ActionCamera: TTakePhotoFromCameraAction;
      ACallBackError: TCallbackProc = nil);
  end;

implementation

procedure TPermissions.SolicitarGaleria(ActionLibrary: TTakePhotoFromLibraryAction;
  ACallBackError: TCallbackProc = nil);
const
  PERMISSAO_ANTIGA = 'android.permission.READ_EXTERNAL_STORAGE';
  PERMISSAO_NOVA = 'android.permission.READ_MEDIA_IMAGES';
var
  Permissao: string;
begin
  {$IFDEF ANDROID}
  // Android 13+ usa READ_MEDIA_IMAGES, versões anteriores usam READ_EXTERNAL_STORAGE
  if TOSVersion.Check(13) then
    Permissao := PERMISSAO_NOVA
  else
    Permissao := PERMISSAO_ANTIGA;

  // Se já possui permissão, executa direto
  if PermissionsService.IsPermissionGranted(Permissao) then
    ActionLibrary.Execute
  else
  begin
    // Solicita a permissão (abre a tela padrão do Android)
    PermissionsService.RequestPermissions([Permissao], nil);

    // Verifica se a permissão foi concedida após a solicitação
    if PermissionsService.IsPermissionGranted(Permissao) then
      ActionLibrary.Execute
    else if Assigned(ACallBackError) then
      ACallBackError(Self);
  end;
  {$ENDIF}

  {$IFDEF IOS}
  ActionLibrary.Execute;
  {$ENDIF}

  {$IFDEF MSWINDOWS}
  TDialogService.ShowMessage('Não suportado no Windows');
  {$ENDIF}
end;

procedure TPermissions.SolicitarCamera(ActionCamera: TTakePhotoFromCameraAction;
  ACallBackError: TCallbackProc = nil);
const
  PERMISSAO_CAMERA = 'android.permission.CAMERA';
begin
  {$IFDEF ANDROID}
  if PermissionsService.IsPermissionGranted(PERMISSAO_CAMERA) then
    ActionCamera.Execute
  else
  begin
    PermissionsService.RequestPermissions([PERMISSAO_CAMERA], nil);

    if PermissionsService.IsPermissionGranted(PERMISSAO_CAMERA) then
      ActionCamera.Execute
    else if Assigned(ACallBackError) then
      ACallBackError(Self);
  end;
  {$ENDIF}

  {$IFDEF IOS}
  ActionCamera.Execute;
  {$ENDIF}

  {$IFDEF MSWINDOWS}
  TDialogService.ShowMessage('Não suportado no Windows');
  {$ENDIF}
end;

end.

