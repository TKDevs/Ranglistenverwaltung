unit utable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, DBGrids,
  IniFiles, db, sqldb, FileUtil;

type

  { Tfm_table_view }

  Tfm_table_view = class(TForm)
    menu_german: TMenuItem;
    menu_english: TMenuItem;
    db_source_list: TDataSource;
    dbgrid: TDBGrid;
    menu_export: TMenuItem;
    menu_option: TMenuItem;
    menu_close: TMenuItem;
    menu_language: TMenuItem;
    menu_back: TMenuItem;
    menu_main: TMainMenu;
    db_query_list: TSQLQuery;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure menu_backClick(Sender: TObject);
    procedure menu_closeClick(Sender: TObject);
    procedure menu_englishClick(Sender: TObject);
    procedure menu_germanClick(Sender: TObject);
  private
    procedure FormatGUI;
    procedure ConnectDatabaseToGrid;
    procedure ListSelection;
    procedure ConnectDatabase;
  public
  end;

var
  fm_table_view: Tfm_table_view;

implementation

uses umain;

{$R *.lfm}

{ Tfm_table_view }

procedure Tfm_table_view.FormActivate(Sender: TObject);
begin
  FormatGUI;
  ConnectDatabase;
  ConnectDatabaseToGrid;
  ListSelection;
end;

procedure Tfm_table_view.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  fm_tournament.close;
end;

procedure Tfm_table_view.FormCreate(Sender: TObject);
begin
  //Formatierung der Form
  fm_table_view.Top:=50;
  fm_table_view.Left:=50;
  fm_table_view.dbgrid.Align:=alRight;
  fm_table_view.dbgrid.Anchors:=[akTop,akLeft,akRight,akBottom];
end;

procedure Tfm_table_view.menu_backClick(Sender: TObject);
begin
  fm_tournament.Show;
  fm_table_view.hide;
end;

procedure Tfm_table_view.menu_closeClick(Sender: TObject);
begin
  fm_table_view.close;
  fm_tournament.close;
end;

procedure Tfm_table_view.menu_englishClick(Sender: TObject);
begin
  fm_tournament.AssignLanguageFile('englisch.ini');
  FormatGUI;
end;

procedure Tfm_table_view.menu_germanClick(Sender: TObject);
begin
  fm_tournament.AssignLanguageFile('deutsch.ini');  
  FormatGUI;
end;

procedure Tfm_table_view.FormatGUI;
begin
  //Legt die Formatierungen für alle GUI-Elemente fest

  fm_table_view.Caption:=fm_tournament.language.ReadString('GUI','fm_table_view','');
  menu_language.Caption:=fm_tournament.language.ReadString('GUI','menu_language','');
  menu_option.Caption:=fm_tournament.language.ReadString('GUI','menu_option','');
  menu_back.Caption:=fm_tournament.language.ReadString('GUI','menu_back','');
  menu_close.Caption:=fm_tournament.language.ReadString('GUI','menu_close',''); 
  menu_export.Caption:=fm_tournament.language.ReadString('GUI','menu_export','');
  menu_german.Caption:=fm_tournament.language.ReadString('GUI','menu_german','');
  menu_english.Caption:=fm_tournament.language.ReadString('GUI','menu_english','');

  dbgrid.AutoFillColumns:=true;
end;

procedure Tfm_table_view.ConnectDatabaseToGrid;
begin

  dbgrid.DataSource:=fm_table_view.db_source_list;

end;

procedure Tfm_table_view.ListSelection;
begin
  //Lässt alle Tabellen der Datenbank in der combobox anzeigen
  fm_tournament.SqlQuery('SELECT * FROM ' + fm_tournament.dblcb_tables.Items[fm_tournament.dblcb_tables.ItemIndex] + ';', db_query_list);
  dbgrid.DataSource:=db_source_list;
end;

procedure Tfm_table_view.ConnectDatabase;
begin
  //Query
  db_query_list.Transaction:=fm_tournament.db_transaction;
  db_query_list.DataBase:=fm_tournament.db_connector;

  //Datasource
  db_source_list.DataSet:=db_query_list;
end;
end.

