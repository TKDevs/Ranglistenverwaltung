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
    dblcb_tables: TDBLookupComboBox;
    db_source_start: TDataSource;
    db_connector: TODBCConnection;
    db_transaction: TSQLTransaction;
    db_query_start: TSQLQuery;
    lb_table: TLabel;
    menu_german: TMenuItem;
    menu_english: TMenuItem;
    menu_main: TMainMenu;
    menu_option: TMenuItem;
    menu_language: TMenuItem;
    menu_close: TMenuItem;
    menu_export: TMenuItem;
    procedure bt_show_tableClick(Sender: TObject);
    procedure dblcb_tablesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure menu_closeClick(Sender: TObject);
    procedure menu_englishClick(Sender: TObject);
    procedure menu_germanClick(Sender: TObject);
  private
    procedure ConnectDatabase;
    procedure FormatGUI;
    procedure TabelSelection;
  public
    language: TIniFile;
    procedure AssignLanguageFile(filename:string);
    procedure SqlQuery(satement:AnsiString; var sql_query:TSQLQuery);
  end;

var
  fm_tournament: Tfm_tournament;

implementation

uses utable;

{$R *.lfm}

{ Tfm_tournament }

procedure Tfm_tournament.FormActivate(Sender: TObject);
begin
  ConnectDatabase;
  TabelSelection;
  FormatGUI;
end;

procedure Tfm_tournament.bt_show_tableClick(Sender: TObject);
begin
  fm_table_view.show; 
  fm_tournament.Hide;
end;

procedure Tfm_tournament.dblcb_tablesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Key:=0;
end;

procedure Tfm_tournament.FormCreate(Sender: TObject);
begin
  //Formatierungen der Form
  fm_tournament.Top:=50;
  fm_tournament.Left:=50;
  fm_tournament.Width:=354;
  fm_tournament.Height:=93;

  AssignLanguageFile('deutsch.ini');
end;

procedure Tfm_tournament.FormDestroy(Sender: TObject);
begin
  language.free;  //gibt den Speicherplatz der Ini frei
end;

procedure Tfm_tournament.menu_closeClick(Sender: TObject);
begin
  fm_tournament.Close;
end;

procedure Tfm_tournament.menu_englishClick(Sender: TObject);
begin
  AssignLanguageFile('englisch.ini');
  FormatGUI;
end;

procedure Tfm_tournament.menu_germanClick(Sender: TObject);
begin
  AssignLanguageFile('deutsch.ini'); 
  FormatGUI;
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

procedure Tfm_tournament.AssignLanguageFile(filename:string);
begin
  //Überprüft ob die Sprachdateien vorhanden sind

  language.Free;

  if(FileExists(filename)) then
  	language := TIniFile.Create(filename) //Stellt die Vebindung zur Inifile her
  else
  begin
    ShowMessage('Sprachdateien wurden nicht gefunden!'+ #10#13 +
    	'Das Programm wird geschlossen.');
    Halt; //Application.Terminate; nicht möglich da Application.run erst nach
    			//Form.Create aufgerufen wird
  end;
end;

procedure Tfm_tournament.SqlQuery(satement: AnsiString; var sql_query: TSQLQuery
  );
begin
  //Erleichtert das Ändern einer SQL Abfrage einer TSQLQuery Komponente
  sql_query.Active:=false;
  sql_query.SQL.AddStrings(satement, true);
  sql_query.Active:=true;
end;

procedure Tfm_tournament.FormatGUI;
begin
  //Legt die Formatierungen für alle GUI-Elemente fest

  fm_tournament.Caption:=language.ReadString('GUI','fm_tournament','');
  lb_table.Caption:=language.ReadString('GUI','lb_table','');;
  bt_show_table.Caption:=language.ReadString('GUI','bt_show_table','');
  menu_option.Caption:=language.ReadString('GUI','menu_option','');
  menu_language.Caption:=language.ReadString('GUI','menu_language','');
  menu_export.Caption:=language.ReadString('GUI','menu_export','');
  menu_close.Caption:=language.ReadString('GUI','menu_close','');
  menu_german.Caption:=language.ReadString('GUI','menu_german','');
  menu_english.Caption:=language.ReadString('GUI','menu_english','');
  dblcb_tables.ItemIndex:=0; 
  dblcb_tables.AutoSelect:=false;
  dblcb_tables.Sorted:=true;
end;

procedure Tfm_tournament.TabelSelection;
begin
  //Lässt alle Tabellen der Datenbank in der combobox anzeigen
  SqlQuery('SHOW TABLES;', db_query_start);
  dblcb_tables.ListSource:=db_source_start;
  dblcb_tables.KeyField:='Tables_in_tunierauswertung';
end;

end.

