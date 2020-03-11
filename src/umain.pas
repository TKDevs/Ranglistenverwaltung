unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, odbcconn, sqldb, db, FileUtil, Forms, Controls, Graphics,
  Dialogs, StdCtrls, DBCtrls, DBGrids, Menus, IniFiles;

type

  { Tfm_tournament }

  Tfm_tournament = class(TForm)
    bt_show_table: TButton;
    dbcb_table: TDBComboBox;
    db_source_start: TDataSource;
    db_connector: TODBCConnection;
    db_transaction: TSQLTransaction;
    db_query_start: TSQLQuery;
    Label1: TLabel;
    menu_main: TMainMenu;
    menu_option: TMenuItem;
    menu_language: TMenuItem;
    menu_close: TMenuItem;
    menu_export: TMenuItem;
    procedure bt_show_tableClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure menu_closeClick(Sender: TObject);
  private
    procedure ConnectDatabase;
    procedure FormatGUI;
    procedure TabelSelection;   
    procedure CheckLanguageFile;
  public
  	language: TIniFile;
  end;

var
  fm_tournament: Tfm_tournament;

implementation

uses utable;

{$R *.lfm}

{ Tfm_tournament }

procedure Tfm_tournament.FormActivate(Sender: TObject);
begin
  FormatGUI;
  ConnectDatabase;
  TabelSelection;
end;

procedure Tfm_tournament.bt_show_tableClick(Sender: TObject);
begin
  fm_table_view.show; 
  fm_tournament.Hide;
end;

procedure Tfm_tournament.FormCreate(Sender: TObject);
begin
  fm_tournament.Top:=50;
  fm_tournament.Left:=50;
  CheckLanguageFile;
end;

procedure Tfm_tournament.FormDestroy(Sender: TObject);
begin
  language.free;  //gibt den Speicherplatz der Ini frei
end;

procedure Tfm_tournament.menu_closeClick(Sender: TObject);
begin
  fm_tournament.Close;
end;

procedure Tfm_tournament.ConnectDatabase;
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
  db_query_start.Transaction:=db_transaction;
  db_query_start.DataBase:=db_connector;

  //Datasource
  db_source_start.DataSet:=db_query_start;
end;

procedure Tfm_tournament.CheckLanguageFile;
begin
  //Überprüft ob die Sprachdateien vorhanden sind

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

procedure Tfm_tournament.FormatGUI;
begin
  //Legt die Formatierungen für alle GUI-Elemente fest

  fm_tournament.Caption:=language.ReadString('GUI','fm_tournament','');
  Label1.Caption:=language.ReadString('GUI','Label1','');;
  bt_show_table.Caption:=language.ReadString('GUI','bt_show_table','');
  dbcb_table.ReadOnly:=true;
  dbcb_table.Sorted:=true;
  menu_option.Caption:=language.ReadString('GUI','menu_option','');
  menu_language.Caption:=language.ReadString('GUI','menu_language','');
  menu_export.Caption:=language.ReadString('GUI','menu_export','');
  menu_close.Caption:=language.ReadString('GUI','menu_close','');
end;

procedure Tfm_tournament.TabelSelection;
var query:AnsiString;
begin
  //Lässt alle Tabellen der Datenbank in der combobox anzeigen

  query:='SHOW TABLES';

  db_query_start.SQL.AddStrings(query, true);
  db_query_start.Active:=true;
  dbcb_table.DataSource:=db_source_start;
  dbcb_table.DataField:='Tables_in_tunierauswertung';
end;

end.

