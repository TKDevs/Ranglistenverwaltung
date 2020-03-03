unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, odbcconn, FileUtil, Forms, Controls, Graphics, Dialogs,
  IniFiles;

type

  { Tfm_turnierauswertung }

  Tfm_turnierauswertung = class(TForm)
    db_connector: TODBCConnection;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

  public

  end;

var
  fm_turnierauswertung: Tfm_turnierauswertung;
  language: TIniFile;

implementation

{$R *.lfm}

{ Tfm_turnierauswertung }

procedure Tfm_turnierauswertung.FormActivate(Sender: TObject);
begin
  //Überprüfen der Verbindung zur Datenbank
  //db_connector.DatabaseName:='Turnierauswertung';
  try
    db_connector.Connected:=true;
  except
    on e: Exception do
    begin
  	  ShowMessage(language.readstring('Error','err_db_connector', ''));
    	Application.Terminate;
    end;
  end;
end;

procedure Tfm_turnierauswertung.FormCreate(Sender: TObject);
begin
  if(FileExists('deutsch.ini')) then
  	language := TIniFile.Create('deutsch.ini') //Stellt die Vebrindung zur Inifile her
  else
  begin
    ShowMessage('Sprachdateien wurden nicht gefunden!'+ #10#13 +
    	'Das Programm wird geschlossen.');
    Halt; //Application.Terminate; nicht möglich da Application.run erst nach
    			//Form.Create aufgerufen wird
  end;
end;

procedure Tfm_turnierauswertung.FormDestroy(Sender: TObject);
begin
  language.free;  //gibt den Speicherplatz der Ini frei
end;

end.

