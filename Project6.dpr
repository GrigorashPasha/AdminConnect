program Project6;

uses
  Vcl.Forms,
  Unit5 in 'C:\Users\Admin\Documents\Embarcadero\Studio\Projects\Unit5.pas' {Form5};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
