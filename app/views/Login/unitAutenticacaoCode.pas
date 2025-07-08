unit unitAutenticacaoCode;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Edit,
  FMX.StdCtrls,
  FMX.Controls.Presentation,
  FMX.Objects,
  FMX.Layouts,
  RESTRequest4D,
  System.JSON,
  dmUsuario,
  usuarioClass,
  common.consts,
  System.UITypes,
  FMX.BiometricAuth,
  FMX.DialogService.Async,
  unitUtilsCode;

type
  TAutenticacaoCode = class(TForm)
    Layout6: TLayout;
    rectEntrar: TRectangle;
    btnValidar: TSpeedButton;
    Label15: TLabel;
    edtcode: TEdit;
    lblNewConta: TLabel;
    Label2: TLabel;
    BiometricAuth: TBiometricAuth;
    lblContador: TLabel;
    RecNumber: TRectangle;
    Layout1: TLayout;
    Rectangle2: TRectangle;
    btnNumer: TSpeedButton;
    Label3: TLabel;
    edtNumber: TEdit;
    Label5: TLabel;
    procedure btnValidarClick(Sender: TObject);
    procedure lblNewContaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BiometricAuthFail(Sender: TObject; const FailReason: TBiometricFailReason; const ResultMessage: string);
    procedure BiometricAuthAuthenticateSuccess(Sender: TObject);
    procedure btnNumerClick(Sender: TObject);
    procedure edtNumberExit(Sender: TObject);
    procedure edtNumberTyping(Sender: TObject);
  private
    procedure ValidateCode;
    procedure EnviarCodigoAutenticacao;
    procedure PerguntarBiometria;
    procedure AtivarBiometria;
  public
  end;

var
  AutenticacaoCode: TAutenticacaoCode;

implementation

{$R *.fmx}

uses mainClientes;

procedure TAutenticacaoCode.FormCreate(Sender: TObject);
begin
  //BiometricAuth.OnAuthenticateSuccess := BiometricAuthSuccess;
  BiometricAuth.OnAuthenticateFail := BiometricAuthFail;
end;

procedure TAutenticacaoCode.btnNumerClick(Sender: TObject);
begin
  if edtNumber.ToString <> '' then
  begin
     RecNumber.Visible := false;
     EnviarCodigoAutenticacao;
  end
  else
    ShowMessage('Por favor, informe seu número de telefone.')
end;

procedure TAutenticacaoCode.btnValidarClick(Sender: TObject);
begin
  ValidateCode;
end;

procedure TAutenticacaoCode.edtNumberExit(Sender: TObject);
begin
   TEdit(Sender).Text := MascaraTelefone(TEdit(Sender).Text);
end;

procedure TAutenticacaoCode.edtNumberTyping(Sender: TObject);
begin
  TEdit(Sender).Text := MascaraTelefone(TEdit(Sender).Text);
  TEdit(Sender).CaretPosition := Length(TEdit(Sender).Text);
end;


procedure TAutenticacaoCode.lblNewContaClick(Sender: TObject);
begin
  EnviarCodigoAutenticacao;
end;

procedure TAutenticacaoCode.ValidateCode;
var
  resp: IResponse;
  jsonRequest, jsonResponse: TJSONObject;
begin
  jsonRequest := TJSONObject.Create;
  try
    jsonRequest.AddPair('user_id', TJSONNumber.Create(TSession.id));
    jsonRequest.AddPair('code', edtcode.Text);

    try
      resp := TRequest.New
              .BaseURL(baseURL + '/usuarios/verificar-codigo-existente')
              .AddBody(jsonRequest.ToString)
              .Accept('application/json')
              .Post;

      jsonResponse := TJSONObject.ParseJSONValue(resp.Content) as TJSONObject;

      if jsonResponse.GetValue<string>('status') = 'success' then
      begin
        ShowMessage(jsonResponse.GetValue<string>('mensagem'));
        PerguntarBiometria;
      end
      else
        ShowMessage(jsonResponse.GetValue<string>('mensagem'));
    except
      on E: Exception do
        ShowMessage('Erro de comunicação: ' + E.Message);
    end;
  finally
    jsonRequest.Free;
    if Assigned(jsonResponse) then
      jsonResponse.Free;
  end;
end;

procedure TAutenticacaoCode.PerguntarBiometria;
begin
  if BiometricAuth.IsSupported and BiometricAuth.CanAuthenticate then
  begin
    TDialogServiceAsync.MessageDialog(
      'Deseja ativar o login por digital?',
      TMsgDlgType.mtConfirmation,
      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
      TMsgDlgBtn.mbNo,
      0,
      procedure(const AResult: TModalResult)
      begin
        if AResult = mrYes then
        begin
          BiometricAuth.Authenticate;
        end
        else
        begin
          Self.Close;
          if Assigned(Self.Owner) then
            TForm(Self.Owner).Show
          else if Assigned(Application.MainForm) then
            Application.MainForm.Show;
        end;
      end
    );
  end
  else
  begin
    ShowMessage('Seu dispositivo não suporta biometria.');
    Self.Close;
    if Assigned(Self.Owner) then
      TForm(Self.Owner).Show
    else if Assigned(Application.MainForm) then
      Application.MainForm.Show;
  end;
end;


procedure TAutenticacaoCode.BiometricAuthAuthenticateSuccess(Sender: TObject);
begin
  AtivarBiometria;
end;

procedure TAutenticacaoCode.BiometricAuthFail(Sender: TObject; const FailReason: TBiometricFailReason; const ResultMessage: string);
begin
  ShowMessage('Autenticação falhou: ' + ResultMessage);
end;

procedure TAutenticacaoCode.AtivarBiometria;
var
  resp: IResponse;
  json: TJSONObject;
begin
  json := TJSONObject.Create;
  try
    json.AddPair('user_id', TJSONNumber.Create(TSession.id));
    json.AddPair('ativa', TJSONBool.Create(True));
    resp := TRequest.New
      .BaseURL(baseURL + '/usuarios/ativar-biometria')
      .AddBody(json.ToString)
      .Accept('application/json')
      .Post;

    if resp.StatusCode = 200 then
      ShowMessage('Biometria ativada com sucesso!')
    else
      ShowMessage('Erro ao ativar biometria: ' + resp.Content);
  except
    on E: Exception do
      ShowMessage('Erro ao comunicar com o servidor: ' + E.Message);
  end;

  Close;
  if not Assigned(frmClientes) then
    Application.CreateForm(TfrmClientes, frmClientes);
  frmClientes.Show;
end;


procedure TAutenticacaoCode.EnviarCodigoAutenticacao;
var
  resp: IResponse;
  jsonRequest: TJSONObject;
begin
  jsonRequest := TJSONObject.Create;
  try
    jsonRequest.AddPair('user_id', TJSONNumber.Create(TSession.id));
    jsonRequest.AddPair('phone', edtNumber.ToString);

    try
      resp := TRequest.New
                .BaseURL(baseURL)
                .Resource('/usuarios/enviarCodigo')
                .AddBody(jsonRequest.ToString)
                .Accept('application/json')
                .Post;

      if resp.StatusCode = 200 then
        ShowMessage('Código enviado com sucesso.')
      else
        ShowMessage('Erro ao enviar código: ' + resp.Content);
    except
      on E: Exception do
        ShowMessage('Erro de comunicação: ' + E.Message);
    end;
  finally
    jsonRequest.Free;
  end;
end;

end.

