unit FMessageSucessComponents;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts;

type
  TFrMessageSucessComponents = class(TFrame)
    RecMain: TRectangle;
    LayErroImage: TLayout;
    imageErro: TImageControl;
    LayErroTitulo: TLayout;
    lbTextTitulo: TLabel;
    LayErros: TLayout;
    TextErro: TText;
    LaySair: TLayout;
    BtnSair: TRoundRect;
    ImageSair: TImageControl;
    procedure ImageSairClick(Sender: TObject);
  private
    { Private declarations }
    FOnClose: TProc;
  public
    { Public declarations }
    Procedure MessageSucess(ATitulo, AMensagem: string; AonClose: TProc);
  end;

implementation

{$R *.fmx}

{ TFrMessageSucessComponents }

procedure TFrMessageSucessComponents.ImageSairClick(Sender: TObject);
begin
  if Assigned(FOnClose) then
    FOnClose;

  Self.DisposeOf;
end;

procedure TFrMessageSucessComponents.MessageSucess(ATitulo, AMensagem: string; AonClose: TProc);
var
  LarguraTela, AlturaTela: Single;
begin
  FOnClose := AOnClose;
  lbTextTitulo.Text := ATitulo;
  TextErro.Text := AMensagem;

  LarguraTela := Self.Width;
  AlturaTela := Self.Height;

  RecMain.Width := LarguraTela * 0.8;
  RecMain.Height := AlturaTela * 0.4;

  RecMain.Position.X := (LarguraTela - RecMain.Width) / 2;
  RecMain.Position.Y := (AlturaTela - RecMain.Height) / 2;

  Self.Visible := True;
end;


end.
