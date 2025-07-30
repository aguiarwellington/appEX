unit FPermitionComponent;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Layouts,
  FMX.ExtCtrls,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  System.Permissions,
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes;

type
  TformPermitions = class(TForm)
    rectformPermition: TRectangle;
    layMainLogin: TLayout;
    lblTitle: TLabel;
    lblPermition: TLabel;
    lblNotPermition: TLabel;
    ImageViewer1: TImageViewer;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formPermitions: TformPermitions;

implementation

{$R *.fmx}

end.
