unit unitLogin;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.Edit,
  FMX.Objects,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.TabControl,
  usuarioClass,
  utilsLoadig,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin,
  Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FMX.Controls.Presentation,
  REST.Authenticator.OAuth.WebForm.FMX,
  REST.Types, REST.Client,
  Data.Bind.Components,
  Data.Bind.ObjectScope,
  REST.Authenticator.OAuth,
  REST.Utils,
  System.UITypes,
  System.JSON,
  Web.HTTPApp,
  RESTRequest4D,
  REST.Response.Adapter,
  FMX.VirtualKeyboard,
  FMX.Platform,
  common.consts,
   System.Types,
 // FMX.BiometricAuth,
  System.IOUtils,
  System.IniFiles, FMX.BiometricAuth,
  FMessageComponents,
  FMessageSucessComponents,
  System.Math;

type
  TfrmLogin = class(TForm)
    TabControl: TTabControl;
    tabLogin: TTabItem;
    Layout2: TLayout;
    lblCriarConta: TLabel;
    tabNovaConta: TTabItem;
    Layout4: TLayout;
    Label8: TLabel;
    Label9: TLabel;
    edtNome: TEdit;
    Label10: TLabel;
    edtSenhaCad: TEdit;
    rectCriarConta: TRectangle;
    btnCriarOk: TSpeedButton;
    Label11: TLabel;
    edtUltimoNome: TEdit;
    tabEntrarComEmail: TTabItem;
    layMainLogin: TLayout;
    Label14: TLabel;
    edtSenha: TEdit;
    rectEntrar: TRectangle;
    btnEntrar: TSpeedButton;
    Label15: TLabel;
    edtEmail: TEdit;
    rectEmail: TRectangle;
    btnAcessarEmail: TSpeedButton;
    lblNovaConta: TLabel;
    lbTextUser: TLabel;
    edtEmailCadastro: TEdit;
    Rectangle1: TRectangle;
    SpeedButton1: TSpeedButton;
    Layout1: TLayout;
    Image1: TImage;
    Label1: TLabel;
    Label5: TLabel;
    lblTextUserCadastro: TLabel;
   BiometricAuth: TBiometricAuth;
    lblMessage: TLabel;
    SBNovaConta: TScrollBox;
    showPassword1: TImageControl;
    showPassword: TImageControl;

    procedure btnEntrarClick(Sender: TObject);
    procedure lblNovaContaClick(Sender: TObject);
    procedure lbTextUserClick(Sender: TObject);
    procedure btnCriarOkClick(Sender: TObject);
    procedure btnAcessarEmailClick(Sender: TObject);
    procedure lblExitClick(Sender: TObject);
    procedure lblExit1Click(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure ShowSenhaClick(Sender: TObject);
    procedure ShowPasswordClick(Sender: TObject);
    procedure showPassword1Click(Sender: TObject);
    procedure edtNomeKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure edtUltimoNomeKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure edtEmailCadastroKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure edtSenhaCadKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure edtEmailKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
  private
     AlturaOriginalLayout4: Single;
     CadastroOk: Boolean;
     FVKBounds: TRect;
    FKeyboardVisible: Boolean;
    procedure TerminateLoading(sender: TObject);
    procedure TerminateCadastro(sender: TObject);
    procedure MostrarMensagemUsuario(const Msg: string);
    procedure MostrarMensagemUsuarioCadastro(const Msg: string);
   procedure BiometricAuthAuthenticateFail(Sender: TObject;
     const FailReason: TBiometricFailReason; const ResultMessage: string);
    procedure BiometricAuthAuthenticateSuccess(Sender: TObject);
    procedure CarregarLoginSalvo;
    procedure SalvarLoginLocal(UserID: Integer);
    procedure AjustarScroll(Sender: TObject);
    procedure MostrarMensagemErro(ATitulo, AMensagem: string);
    procedure MostrarMensagemSucesso(ATitulo, AMensagem: string;
      OnClose: TProc);

  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}
{$R *.XLgXhdpiTb.fmx ANDROID}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.Moto360.fmx ANDROID}

uses dmUsuario, mainClientes, unitAutenticacaoCode;

procedure TfrmLogin.btnEntrarClick(Sender: TObject);
begin
  TLoading.ExecuteThread(
    procedure
    begin
      if Trim(edtEmail.Text) = '' then
      begin
        TThread.Synchronize(nil, procedure begin
          MostrarMensagemUsuario('Preencha o campo E-mail.');
        end);
        Exit;
      end;

      if Trim(edtSenha.Text) = '' then
      begin
        TThread.Synchronize(nil, procedure begin
          MostrarMensagemUsuario('Preencha o campo de senha.');
        end);
        Exit;
      end;

      try
        dm.Login(edtEmail.Text, edtSenha.Text);
      except
        on E: Exception do
        begin
          TThread.Synchronize(nil,
            procedure begin
              MostrarMensagemUsuario('Erro no login: ' + E.Message);
            end
          );
        end;
      end;
    end,
    TerminateLoading
  );
end;

procedure TfrmLogin.btnVoltarClick(Sender: TObject);
begin
   TabControl.GotoVisibleTab(0);
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  AlturaOriginalLayout4 := 0;
  TabControl.GotoVisibleTab(0);
  CarregarLoginSalvo;

  BiometricAuth.OnAuthenticateSuccess := BiometricAuthAuthenticateSuccess;
  BiometricAuth.OnAuthenticateFail := BiometricAuthAuthenticateFail;

  edtNome.OnEnter := AjustarScroll;
  edtUltimoNome.OnEnter := AjustarScroll;
  edtEmailCadastro.OnEnter := AjustarScroll;
  edtSenhaCad.OnEnter := AjustarScroll;
end;

procedure TfrmLogin.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
     SBNovaConta.Padding.Bottom := 0;

  if AlturaOriginalLayout4 > 0 then
    Layout4.Height := AlturaOriginalLayout4;

  // Reseta scroll
  SBNovaConta.ViewportPosition := PointF(0, 0);
end;

procedure TfrmLogin.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
var
  KeyboardHeight: Single;
  ScreenSize: TPointF;
  ScreenService: IFMXScreenService;
  i: Integer;
  Focado: TControl;
  CampoPosicao, ScrollPosicao: TPointF;
  Deslocamento: Single;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, ScreenService) then
    ScreenSize := ScreenService.GetScreenSize
  else
    Exit;

  KeyboardHeight := ScreenSize.Y - Bounds.Top;

  if KeyboardVisible then
  begin
    if AlturaOriginalLayout4 = 0 then
      AlturaOriginalLayout4 := Layout4.Height;

    SBNovaConta.Padding.Bottom := KeyboardHeight;
    Layout4.Height := AlturaOriginalLayout4 + 50;

    // Rola até o campo focado
    for i := 0 to Layout4.ChildrenCount - 1 do
    begin
      if (Layout4.Children[i] is TEdit) and (TEdit(Layout4.Children[i]).IsFocused) then
      begin
        Focado := TEdit(Layout4.Children[i]);
        CampoPosicao := Focado.LocalToAbsolute(PointF(0, 0));
        ScrollPosicao := SBNovaConta.LocalToAbsolute(PointF(0, 0));
        Deslocamento := CampoPosicao.Y - ScrollPosicao.Y;
        SBNovaConta.ViewportPosition := PointF(0, Max(Deslocamento - KeyboardHeight / 2, 0));
        Break;
      end;
    end;
  end
  else
  begin
    SBNovaConta.Padding.Bottom := 0;

    if AlturaOriginalLayout4 > 0 then
      Layout4.Height := AlturaOriginalLayout4;

    SBNovaConta.ViewportPosition := PointF(0, 0);
  end;
end;

procedure TfrmLogin.ShowPasswordClick(Sender: TObject);
begin
  if edtSenhaCad.Password then
    edtSenhaCad.Password := false
  else
  if edtSenhaCad.Password = false then
    edtSenhaCad.Password := true
  else
     edtSenhaCad.Password := false;
end;

procedure TfrmLogin.ShowSenhaClick(Sender: TObject);
begin
     edtSenhaCad.Password := false;
end;

procedure TfrmLogin.AjustarScroll(Sender: TObject);
begin
  if (Sender is TControl) and Assigned(SBNovaConta) then
  begin
    // Rola a tela verticalmente até o campo, com pequeno deslocamento
    SBNovaConta.ViewportPosition := PointF(0, (Sender as TControl).Position.Y - 10);
  end;
end;

procedure TfrmLogin.CarregarLoginSalvo;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(TPath.Combine(TPath.GetDocumentsPath, 'config.ini'));
  try
    TSession.id := Ini.ReadInteger('Login', 'UserID', 0);
  finally
    Ini.Free;
  end;
end;

procedure TfrmLogin.edtEmailCadastroKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
begin
   if key = vkReturn then
    edtSenhaCad.SetFocus;
end;

procedure TfrmLogin.edtEmailKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
begin
     if Key = vkReturn then
    edtSenha.SetFocus;
end;

procedure TfrmLogin.edtNomeKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
begin
  if Key = vkReturn then
    edtUltimoNome.SetFocus;
end;

procedure TfrmLogin.edtSenhaCadKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
begin
  if key = vkReturn then
    edtSenhaCad.SetFocus;
end;

procedure TfrmLogin.edtUltimoNomeKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
begin
   if key = vkReturn then
    edtEmailCadastro.SetFocus;
end;

procedure TfrmLogin.BiometricAuthAuthenticateSuccess(Sender: TObject);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      if not Assigned(frmClientes) then
        Application.CreateForm(TfrmClientes, frmClientes);
      frmClientes.Show;
      Self.Hide;
    end);
end;

procedure TfrmLogin.SalvarLoginLocal(UserID: Integer);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(TPath.Combine(TPath.GetDocumentsPath, 'config.ini'));
  try
    Ini.WriteInteger('Login', 'UserID', UserID);
    Ini.UpdateFile; // força escrita no disco
  finally
    Ini.Free;
  end;
end;

procedure TfrmLogin.showPassword1Click(Sender: TObject);
begin
  if edtSenha.Password then
    edtSenha.Password := false
  else
  if edtSenha.Password = false then
    edtSenha.Password := true
  else
     edtSenha.Password := false;
end;

procedure TfrmLogin.BiometricAuthAuthenticateFail(Sender: TObject;
  const FailReason: TBiometricFailReason; const ResultMessage: string);
begin
  MostrarMensagemUsuario('Falha na autenticação biométrica: ' + ResultMessage);
end;

procedure TfrmLogin.TerminateLoading(Sender: TObject);
begin
  if (Trim(edtEmail.Text) = '') or (Trim(edtSenha.Text) = '') then
    Exit;

  if TSession.LoginStatus = 'pending_code' then
  begin
    MostrarMensagemUsuario('Seu código expirou ou ainda não foi validado. Redirecionando...');

    if not Assigned(AutenticacaoCode) then
      Application.CreateForm(TAutenticacaoCode, AutenticacaoCode);
    AutenticacaoCode.Show;
    Self.Hide;
    Exit;
  end;

  if TSession.LoginStatus = 'success' then
  begin
    SalvarLoginLocal(TSession.id);

    if TSession.requires2FA and TSession.biometria then
    begin
      if BiometricAuth.IsSupported and BiometricAuth.CanAuthenticate then
      begin
        BiometricAuth.OnAuthenticateSuccess := BiometricAuthAuthenticateSuccess;
        BiometricAuth.OnAuthenticateFail := BiometricAuthAuthenticateFail;
        BiometricAuth.Authenticate;
        Exit;
      end
      else
        MostrarMensagemUsuario('Biometria não suportada no dispositivo.');
    end;

    // Acesso direto sem biometria
    if not Assigned(frmClientes) then
      Application.CreateForm(TfrmClientes, frmClientes);
    frmClientes.Show;
    Self.Hide;
    Exit;
  end;

  MostrarMensagemUsuario('Login falhou. Verifique e-mail e senha.');
end;

 procedure TfrmLogin.MostrarMensagemUsuario(const Msg: string);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      lbTextUser.Visible := true;
      lbTextUser.Text := Msg;

      TThread.CreateAnonymousThread(
        procedure
        begin
          Sleep(3000);
          TThread.Synchronize(nil,
            procedure
            begin
              lbTextUser.Text := '';
              lbTextUser.Visible := false;
            end
          );
        end
      ).Start;
    end
  );
end;

procedure TfrmLogin.MostrarMensagemUsuarioCadastro(const Msg: string);
begin
  lblTextUserCadastro.Visible := false;
  lblTextUserCadastro.Text := Msg;

  TThread.CreateAnonymousThread(
    procedure
    begin
      Sleep(3000);
      TThread.Queue(nil,
        procedure
        begin
          lblTextUserCadastro.Text := '';
          lblTextUserCadastro.Visible := False;
          edtNome.Text := '';
          edtUltimoNome.Text := '';
          edtEmailCadastro.Text := '';
          edtSenhaCad.Text := '';
        end
      );
    end
  ).Start;
end;

procedure TfrmLogin.TerminateCadastro(Sender: TObject);
begin
  if CadastroOk then
  begin
    MostrarMensagemSucesso('Sucesso', 'Cadastro realizado com sucesso!',
      procedure
      begin
        TabControl.GotoVisibleTab(0);
      end
    );
  end;
end;

procedure TfrmLogin.MostrarMensagemSucesso(ATitulo, AMensagem: string; OnClose: TProc);
var
  MsgSucesso: TFrMessageSucessComponents;
begin
  MsgSucesso := TFrMessageSucessComponents.Create(Self);
  MsgSucesso.Parent := Self;
  MsgSucesso.MessageSucess(ATitulo, AMensagem, OnClose);
end;

procedure TfrmLogin.lblNovaContaClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(1);
end;

procedure TfrmLogin.lblExit1Click(Sender: TObject);
begin
 TabControl.GotoVisibleTab(0);
end;

procedure TfrmLogin.lblExitClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(0);
end;

procedure TfrmLogin.lbTextUserClick(Sender: TObject);
begin
  TabControl.GotoVisibleTab(1);
end;

procedure TfrmLogin.btnCriarOkClick(Sender: TObject);
var
  Nome, Sobrenome, Email, Senha: string;
begin
  Nome := Trim(edtNome.Text);
  Sobrenome := Trim(edtUltimoNome.Text);
  Email := Trim(edtEmailCadastro.Text);
  Senha := Trim(edtSenhaCad.Text);

  if Nome = '' then
  begin
    MostrarMensagemErro('Error','O campo "Nome" é obrigatório.');
    Exit;
  end;

  if Sobrenome = '' then
  begin
    MostrarMensagemErro('Error','O campo "Último nome" é obrigatório.');
    Exit;
  end;

  if Email = '' then
  begin
     MostrarMensagemErro('Error','O campo "E-mail" é obrigatório.');
    Exit;
  end;

  if Senha = '' then
  begin
    MostrarMensagemErro('Error','O campo "Senha" é obrigatório.');
    Exit;
  end;

  CadastroOk := False;

 TLoading.ExecuteThread(
  procedure
  begin
    try
      dm.cadastrarUsuario(Nome, Sobrenome, Email, Senha);
      CadastroOk := True;
    except
      on E: Exception do
      begin
        TThread.Synchronize(nil,
          procedure
          begin
            if Pos('Duplicate', E.Message) > 0 then
              MostrarMensagemErro('Erro', 'E-mail já cadastrado. Insira um diferente.')
            else if Pos('Connection', '') > 0 then
              MostrarMensagemErro('Erro', 'Falha de conexão. Verifique se o servidor está ativo.')
            else
              MostrarMensagemErro('Erro', 'Falha ao cadastrar. Verifique se o servidor está ativo. ');
          end
        );
      end;
    end;
  end,
  TerminateCadastro
);
end;

procedure TfrmLogin.btnAcessarEmailClick(Sender: TObject);
begin
  if TSession.id <= 0 then
  begin
    TabControl.GotoVisibleTab(2); // Vai pro login normal
    Exit;
  end;

  TThread.CreateAnonymousThread(
    procedure
    var
      SessaoValida, CodigoValidado, BiometriaAtiva: Boolean;
      resp: IResponse;
      jsonRequest, jsonResponse: TJSONObject;
    begin
      SessaoValida := False;
      CodigoValidado := False;
      BiometriaAtiva := False;
      jsonRequest := nil;
      jsonResponse := nil;

      try
        try
          // Verifica se sessão está válida
          try
            SessaoValida := dm.ValidarSessao;
          except
            on E: Exception do
            begin
              SessaoValida := False;
              TThread.Synchronize(nil,
                procedure
                begin
                  MostrarMensagemErro('Conexão', 'Não foi possível conectar ao servidor. Verifique sua internet ou tente novamente.');
                end);
              Exit;
            end;
          end;

          if not SessaoValida then
          begin
            TThread.Synchronize(nil,
              procedure
              begin
                MostrarMensagemErro('Conexão', 'Sessão inválida ou expirada.');
              end);
            Exit;
          end;

          // Monta requisição para verificar biometria e código
          jsonRequest := TJSONObject.Create;
          jsonRequest.AddPair('user_id', TJSONNumber.Create(TSession.id));

          try
            resp := TRequest.New
              .BaseURL(baseURL + '/usuarios/verificar-codigo-existente')
              .AddBody(jsonRequest.ToString)
              .Accept('application/json')
              .Post;
          except
            on E: Exception do
            begin
              TThread.Synchronize(nil,
                procedure
                begin
                  MostrarMensagemErro('Conexão', 'Falha ao verificar 2FA: ' + E.Message);
                end);
              Exit;
            end;
          end;

          if (not Assigned(resp)) or (resp.Content.Trim = '') then
          begin
            TThread.Synchronize(nil,
              procedure
              begin
                MostrarMensagemErro('Conexão', 'Não foi possível conectar ao servidor. Verifique sua internet ou tente novamente.');
              end);
            Exit;
          end;

          jsonResponse := TJSONObject.ParseJSONValue(resp.Content) as TJSONObject;

          if Assigned(jsonResponse) then
          begin
            CodigoValidado := jsonResponse.GetValue<Boolean>('codigo_validado', False);
            BiometriaAtiva := jsonResponse.GetValue<Boolean>('biometria_ativa', False);
          end;
        except
          on E: Exception do SessaoValida := False;
        end;

        TThread.Synchronize(nil,
          procedure
          begin
            if not SessaoValida then
            begin
              MostrarMensagemErro('Sessão Expirada', 'Sua sessão expirou. Faça login novamente.');
              TabControl.GotoVisibleTab(2);
              Exit;
            end;

            if not CodigoValidado then
            begin
              MostrarMensagemErro('2FA Pendente', 'Código de verificação 2FA não validado.');
              TabControl.GotoVisibleTab(2);
              Exit;
            end;

            SalvarLoginLocal(TSession.id);

            if BiometriaAtiva then
            begin
              if BiometricAuth.IsSupported and BiometricAuth.CanAuthenticate then
              begin
                BiometricAuth.OnAuthenticateSuccess := BiometricAuthAuthenticateSuccess;
                BiometricAuth.OnAuthenticateFail := BiometricAuthAuthenticateFail;
                BiometricAuth.Authenticate;
                Exit;
              end
              else
              begin
                MostrarMensagemErro('Biometria Indisponível', 'Seu dispositivo não suporta biometria.');
                TabControl.GotoVisibleTab(2);
                Exit;
              end;
            end;

            TabControl.GotoVisibleTab(2);
          end
        );
      finally
        FreeAndNil(jsonRequest);
        FreeAndNil(jsonResponse);
      end;
    end
  ).Start;
end;



procedure TfrmLogin.MostrarMensagemErro(ATitulo, AMensagem: string);
var
  MsgErro: TMessageComponents;
begin
  MsgErro := TMessageComponents.Create(Self);
  MsgErro.Parent := Self;
  MsgErro.MostrarErro(ATitulo, AMensagem);
end;

end.

