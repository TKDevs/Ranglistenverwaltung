unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, odbcconn, sqldb, db, FileUtil, Forms, Controls, Graphics,
  Dialogs, StdCtrls, DBCtrls, DBGrids, Menus, IniFiles;

type

  { Tfm_turnierauswertung }

  Tfm_turnierauswertung = class(TForm)
    bt_tabelle_anzeigen: TButton;
    db_tabellen: TDBComboBox;
    db_start_source: TDataSource;
    db_connector: TODBCConnection;
    db_transaction: TSQLTransaction;
    db_start_query: TSQLQuery;
    Label1: TLabel;
    menu_main: TMainMenu;
    menu_option: TMenuItem;
    menu_language: TMenuItem;
    menu_close: TMenuItem;
    menu_export: TMenuItem;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure ConnectDatabase;
    procedure CheckLanguageFile;
    procedure FormatGUI;
    procedure TabelSelection;
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
  FormatGUI;
  ConnectDatabase;
  TabelSelection;
end;

procedure Tfm_turnierauswertung.FormCreate(Sender: TObject);
begin
  CheckLanguageFile;
end;

procedure Tfm_turnierauswertung.FormDestroy(Sender: TObject);
begin
  language.free;  //gibt den Speicherplatz der Ini frei
end;

procedure Tfm_turnierauswertung.ConnectDatabase;
begin
  //Überprüfen der Verbindung zur Datenbank
  db_connector.DatabaseName:='Turnierauswertung';
  try
    db_connector.Connected:=true;
  except
    on e: Exception do
    begin
  	  ShowMessage(language.readstring('Error','err_db_connector', ''));
    	Application.Terminate;
    end;
  end;

  //Transaction
  db_transaction.DataBase:=db_connector;
  db_connector.Transaction:=db_transaction;
  db_transaction.Active:=true;

  //Query
  db_start_query.Transaction:=db_transaction;
  db_start_query.DataBase:=db_connector;

  //Datasource
  db_start_source.DataSet:=db_start_query;
end;

procedure Tfm_turnierauswertung.CheckLanguageFile;
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

procedure Tfm_turnierauswertung.FormatGUI;
begin
  Label1.Caption:='Datenbanktabelle :';
  bt_tabelle_anzeigen.Caption:='zur Tabellenansicht';
  menu_option.Caption:='Optionen';
  menu_language.Caption:='Sprache';
  menu_export.Caption:='Tabelle exportieren';
  menu_close.Caption:='Beenden';
end;

procedure Tfm_turnierauswertung.TabelSelection;
var query:AnsiString;
begin
  query:='SHOW TABLES';

  db_start_query.SQL.AddStrings(query, true);
  db_start_query.Active:=true;
  db_tabellen.DataSource:=db_start_source;
  db_tabellen.DataField:='Tables_in_tunierauswertung';
end;

end.

