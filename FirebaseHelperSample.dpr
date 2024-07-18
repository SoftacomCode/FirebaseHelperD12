program FirebaseHelperSample;


uses
  System.StartUpCopy,
  FMX.Forms,
  FirebaseHelperClass in 'FirebaseHelperClass.pas',
  Main in 'Main.pas' {MainForm};

{$R *.res}
begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
