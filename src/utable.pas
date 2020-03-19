unit utable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, DBGrids,
  DBCtrls, StdCtrls, ComCtrls, IniFiles, db, sqldb, FileUtil;

type

  { Tfm_table_view }

  Tfm_table_view = class(TForm)
    bt_insert_game: TButton;
    db_source_team1: TDataSource;
    db_source_team2: TDataSource;
    db_source_teams: TDataSource;
    dblcb_team1: TDBLookupComboBox;
    dblcb_team2: TDBLookupComboBox;
    ed_search: TEdit;
    ed_points_team1: TEdit;
    ed_points_team2: TEdit;
    gb_team: TGroupBox;
    gb_points: TGroupBox;
    lb_search: TLabel;
    lb_vs: TLabel;
    menu_german: TMenuItem;
    menu_english: TMenuItem;
    db_source_table: TDataSource;
    dbgrid: TDBGrid;
    menu_export: TMenuItem;
    menu_option: TMenuItem;
    menu_close: TMenuItem;
    menu_language: TMenuItem;
    menu_back: TMenuItem;
    menu_main: TMainMenu;
    db_query_table: TSQLQuery;
    db_query_teams: TSQLQuery;
    pc_controlles: TPageControl;
    sd_export: TSaveDialog;
    db_query_team1: TSQLQuery;
    db_query_team2: TSQLQuery;
    db_query_change: TSQLQuery;
    tab1: TTabSheet;
    tab2: TTabSheet;
    procedure bt_insert_gameClick(Sender: TObject);
    procedure dblcb_team1Exit(Sender: TObject);
    procedure dblcb_team2Exit(Sender: TObject);
    procedure ed_points_team1KeyPress(Sender: TObject; var Key: char);
    procedure ed_points_team2KeyPress(Sender: TObject; var Key: char);
    procedure ed_searchChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure menu_backClick(Sender: TObject);
    procedure menu_closeClick(Sender: TObject);
    procedure menu_englishClick(Sender: TObject);
    procedure menu_exportClick(Sender: TObject);
    procedure menu_germanClick(Sender: TObject);
  private
    procedure SQLUpdate(statement: AnsiString; var sql_query: TSQLQuery);
    procedure FormatGUI;
    procedure ConnectDatabaseToGrid;
    procedure TableSelection;
    procedure ConnectDatabase;
    procedure TeamSelection;
    procedure ExportTable(const grid:TDBGrid;const path:string);
  public
  end;

var
  fm_table_view: Tfm_table_view;

implementation

uses umain;

//preprocessing commands
{$R *.lfm}
{$macro on}
{$define ACTIVE_TABLE := fm_tournament.dblcb_tables.Items[fm_tournament.dblcb_tables.ItemIndex]}
{$define LOAD_TRANSLATION := fm_tournament.language.ReadString}

{ Tfm_table_view }

procedure Tfm_table_view.FormActivate(Sender: TObject);
begin
  ConnectDatabase;
  ConnectDatabaseToGrid;
  TableSelection;
  TeamSelection;
  FormatGUI;
end;

procedure Tfm_table_view.ed_searchChange(Sender: TObject);
begin
  fm_tournament.SqlQuery('SELECT * FROM ' + ACTIVE_TABLE + ' WHERE Teamname like '+#39+'%'+ ed_search.text + '%' +#39+ ';', db_query_table);
end;

procedure Tfm_table_view.dblcb_team1Exit(Sender: TObject);
var
  temp:integer;
begin
  temp:=dblcb_team2.ItemIndex;
  if(dblcb_team1.ItemIndex<>-1)then
  begin
    fm_tournament.SqlQuery('SELECT Teamname FROM ' + ACTIVE_TABLE + ' WHERE NOT Teamname = ' + #39 + dblcb_team1.Text + #39 + ';', db_query_team2);
    dblcb_team2.ListSource:=db_source_team2;
    dblcb_team2.KeyField:='Teamname';
  end;            
  dblcb_team2.ItemIndex:=temp;
end;

procedure Tfm_table_view.bt_insert_gameClick(Sender: TObject);
begin
  if(dblcb_team1.text='')or(dblcb_team2.text='')or(ed_points_team1.text='')or(ed_points_team2.text='')then
  begin
    ShowMessage('Bitte die alle Felder korrekt ausfüllen!');
  end
  else
  begin
    if((StrtoInt(ed_points_team1.text))=(StrtoInt(ed_points_team2.text)))then
    begin
      showmessage('Es herrschte Gleichstand, daher werden keine Punkte vergeben!');
    end
    else if((StrtoInt(ed_points_team1.text))<(StrtoInt(ed_points_team2.text)))then
    begin
      fm_table_view.SqlUpdate('UPDATE ' + ACTIVE_TABLE + ' SET Siege=Siege+1 WHERE Teamname=' + #39 + dblcb_team2.text + #39 + ';', db_query_change);
      fm_table_view.SqlUpdate('UPDATE ' + ACTIVE_TABLE + ' SET Niederlagen=Niederlagen+1 WHERE Teamname=' + dblcb_team1.text + #39 + ';', db_query_change);
    end
    else
    begin
      fm_table_view.SqlUpdate('UPDATE ' + ACTIVE_TABLE + ' SET Siege=Siege+1 WHERE Teamname=' + #39 + dblcb_team1.text + #39 + ';', db_query_change);
      fm_table_view.SqlUpdate('UPDATE ' + ACTIVE_TABLE + ' SET Niederlagen=Niederlagen+1 WHERE Teamname=' + #39 + dblcb_team2.text + #39 +';', db_query_change);

    end;
  end;
end;

procedure Tfm_table_view.dblcb_team2Exit(Sender: TObject);
var
  temp:integer;
begin
  temp:=dblcb_team1.ItemIndex;
  if(dblcb_team2.ItemIndex<>-1)then
  begin
    fm_tournament.SqlQuery('SELECT Teamname FROM ' + ACTIVE_TABLE + ' WHERE NOT Teamname = ' + #39 + dblcb_team2.Text + #39 + ';', db_query_team1);
    dblcb_team1.ListSource:=db_source_team1;
    dblcb_team1.KeyField:='Teamname';
  end;
  dblcb_team1.ItemIndex:=temp;
end;

procedure Tfm_table_view.ed_points_team1KeyPress(Sender: TObject; var Key: char
  );
begin
  if ((Length(ed_points_team1.text)>3) and (key<>#8))then key:=#0;
  if not(key IN ['1'..'9',#8])then key:=#0;
end;

procedure Tfm_table_view.ed_points_team2KeyPress(Sender: TObject; var Key: char
  );
begin
  if ((Length(ed_points_team2.text)>3) and (key<>#8))then key:=#0;
  if not(key IN ['1'..'9',#8])then key:=#0;
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
  fm_table_view.dbgrid.Align:=alNone;
  fm_table_view.Constraints.MinHeight:=470;
  fm_table_view.Constraints.MaxHeight:=470;
  fm_table_view.Constraints.MinWidth:=910;
  fm_table_view.Constraints.MaxWidth:=910;
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

procedure Tfm_table_view.menu_exportClick(Sender: TObject);
begin
  if (sd_export.Execute) then
  begin
    try
      ExportTable(dbgrid, sd_export.FileName);
    except
      on e: Exception do
      ShowMessage(LOAD_TRANSLATION('Info','inf_save_fail',''));
    end;
    ShowMessage(LOAD_TRANSLATION('Info','inf_save_success',''));
  end;
end;

procedure Tfm_table_view.menu_germanClick(Sender: TObject);
begin
  fm_tournament.AssignLanguageFile('deutsch.ini');  
  FormatGUI;
end;

procedure Tfm_table_view.SQLUpdate(statement: AnsiString;
  var sql_query: TSQLQuery);
begin
  sql_query.Active:=false;
  sql_query.UpdateSQL.AddStrings(statement, true);
  sql_query.Active:=true;
end;

procedure Tfm_table_view.FormatGUI;
begin
  //Legt die Formatierungen für alle GUI-Elemente fest
  //Spracheinstellungen
  fm_table_view.Caption:=LOAD_TRANSLATION('GUI','fm_table_view','');
  menu_language.Caption:=LOAD_TRANSLATION('GUI','menu_language','');
  menu_option.Caption:=LOAD_TRANSLATION('GUI','menu_option','');
  menu_back.Caption:=LOAD_TRANSLATION('GUI','menu_back','');
  menu_close.Caption:=LOAD_TRANSLATION('GUI','menu_close','');
  menu_export.Caption:=LOAD_TRANSLATION('GUI','menu_export','');
  menu_german.Caption:=LOAD_TRANSLATION('GUI','menu_german','');
  menu_english.Caption:=LOAD_TRANSLATION('GUI','menu_english','');
  lb_vs.Caption:=LOAD_TRANSLATION('GUI', 'lb_vs','');
  gb_team.Caption:=LOAD_TRANSLATION('GUI','gb_team','');
  gb_points.Caption:=LOAD_TRANSLATION('GUI','gb_points','');
  lb_search.Caption:=LOAD_TRANSLATION('GUI','lb_search','');
  tab1.Caption:=LOAD_TRANSLATION('GUI','tab1','');
  tab2.Caption:=LOAD_TRANSLATION('GUI','tab2','');
  bt_insert_game.Caption:='Speil eintragen';

  //Objektdarstellung
  //grid
  dbgrid.FastEditing:=false;
  dbgrid.Enabled:=false;
  dbgrid.Top:=40;
  dbgrid.Left:=10;
  dbgrid.Width:=500;
  dbgrid.Height:=400;
  dbgrid.AutoFillColumns:=true;
  dbgrid.ScrollBars:=ssNone;

  //lookupcombobox
  dblcb_team1.ListSource:=db_source_teams;
  dblcb_team1.KeyField:='Teamname';    
  dblcb_team1.AutoDropDown:=true;
  dblcb_team2.ListSource:=db_source_teams;
  dblcb_team2.KeyField:='Teamname';
  dblcb_team2.AutoDropDown:=true;

  //edits
  ed_points_team1.text:='';
  ed_points_team2.text:='';
  ed_search.Text:='';

  //pagecontroller
  pc_controlles.Top:=10;
  pc_controlles.Left:=530;
  pc_controlles.Width:=370;
  pc_controlles.Height:=430;

end;

procedure Tfm_table_view.ConnectDatabaseToGrid;
begin
  dbgrid.DataSource:=fm_table_view.db_source_table;
end;

procedure Tfm_table_view.TableSelection;
begin
  //Anzeigen der ausgewählten Tabelle
  fm_tournament.SqlQuery('SELECT * FROM ' + ACTIVE_TABLE + ';', db_query_table);
  dbgrid.DataSource:=db_source_table;
end;

procedure Tfm_table_view.ConnectDatabase;
begin
  //Query
  db_query_table.Transaction:=fm_tournament.db_transaction;
  db_query_table.DataBase:=fm_tournament.db_connector;
  db_query_teams.Transaction:=fm_tournament.db_transaction;
  db_query_teams.DataBase:=fm_tournament.db_connector;

  db_query_team1.Transaction:=fm_tournament.db_transaction;
  db_query_team1.DataBase:=fm_tournament.db_connector;
  db_query_team2.Transaction:=fm_tournament.db_transaction;
  db_query_team2.DataBase:=fm_tournament.db_connector;

  db_query_change.Transaction:=fm_tournament.db_transaction;
  db_query_change.DataBase:=fm_tournament.db_connector;

  //Datasource
  db_source_table.DataSet:=db_query_table;
  db_source_teams.DataSet:=db_query_teams;
  db_source_team1.DataSet:=db_query_team1;
  db_source_team2.DataSet:=db_query_team2;
end;

procedure Tfm_table_view.TeamSelection;
begin
  //Lässt alle Teams Anzeigen
  fm_tournament.SqlQuery('SELECT Teamname FROM ' + ACTIVE_TABLE + ';', db_query_teams);
end;

procedure Tfm_table_view.ExportTable(const grid: TDBGrid; const path: string);
var i,j:integer;
    sl:TStringList;
begin
  sl:= TStringList.Create;
  db_source_table.DataSet.First;
  for i:= 1 to  db_source_table.DataSet.RecordCount do
  begin
    sl.Add('');
    db_source_table.DataSet.RecNo := i;
    for j := 0 to db_source_table.DataSet.Fields.Count - 1 do
      sl[SL.Count - 1]:= sl[sl.Count - 1] + db_source_table.DataSet.Fields[j].AsString + ';';
  end;
  sl.SaveToFile(path);
  sl.Free;
end;

end.

