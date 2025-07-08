unit FMessageComponents;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation;

type
  TMessageComponents = class(TFrame)
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
  public
    procedure MostrarErro(ATitulo, AMensagem: string);
  end;

implementation

{$R *.fmx}

{ TMessageErroComponts }

procedure TMessageComponents.ImageSairClick(Sender: TObject);
begin
     Self.DisposeOf;
end;


procedure TMessageComponents.MostrarErro(ATitulo, AMensagem: string);
var
  LarguraTela, AlturaTela: Single;
begin
  lbTextTitulo.Text := ATitulo;
  TextErro.Text := AMensagem;

  // Pega a largura e altura do próprio componente (frame)
  LarguraTela := Self.Width;
  AlturaTela := Self.Height;

  // Define o tamanho do card
  RecMain.Width := LarguraTela * 0.8;
  RecMain.Height := AlturaTela * 0.4;

  // Centraliza
  RecMain.Position.X := (LarguraTela - RecMain.Width) / 2;
  RecMain.Position.Y := (AlturaTela - RecMain.Height) / 2;

  Self.Visible := True;
end;





end.

