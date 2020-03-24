unit utable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, DBGrids,
  DBCtrls, StdCtrls, ComCtrls, ExtCtrls, IniFiles, db, sqldb, FileUtil;

type

  TTeampoints = array[1..2]of integer;

  { Tfm_table_view }

  Tfm_table_view = class(TForm)
    bt_delete_team: TButton;
    bt_edit_team: TButton;
    bt_insert_game: TButton;
    bt_add_team: TButton;
    dblcb_delete_team: TDBLookupComboBox;
    dblcb_add_team: TDBLookupComboBox;
    dblcb_edit_team: TDBLookupComboBox;
    db_source_team1: TDataSource;
    db_source_team2: TDataSource;
    db_source_teams: TDataSource;
    dblcb_team1: TDBLookupComboBox;
    dblcb_team2: TDBLookupComboBox;
    ed_edit_teamname: TEdit;
    ed_search: TEdit;
    ed_points_team1: TEdit;
    ed_points_team2: TEdit;
    gb_delete_team: TGroupBox;
    gb_edit_team: TGroupBox;
    gb_team: TGroupBox;
    gb_points: TGroupBox;
    gb_add_team: TGroupBox;
    lb_add_teamname: TLabel;
    lb_edit_old_teamname: TLabel;
    lb_edit_new_teamname: TLabel;
    lb_search: TLabel;
    lb_delete_teamname: TLabel;
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
    procedure dbgridTitleClick(Column: TColumn);
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
    Teampoints:TTeampoints;
    procedure SQLUpdate(statement: AnsiString; var sql_query: TSQLQuery);
    procedure FormatGUI;
    procedure ConnectDatabaseToGrid;
    procedure TableSelection;
    procedure ConnectDatabase;
    procedure TeamSelection;
    procedure ExportTable(const grid:TDBGrid;const path:string);
    function Pointdifference:TTeampoints;
  public
  protected
    table_sorted:boolean;
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
  table_sorted:=false;

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
  lastindex:integer;
begin
  lastindex:=dblcb_team2.ItemIndex;
  if(dblcb_team1.ItemIndex<>-1)then
  begin
    fm_tournament.SqlQuery('SELECT Teamname FROM ' + ACTIVE_TABLE + ' WHERE NOT Teamname = ' + #39 + dblcb_team1.Text + #39 + ';', db_query_team2);
    dblcb_team2.ListSource:=db_source_team2;
    dblcb_team2.KeyField:='Teamname';
  end;
  if(lastindex=-1)then
  begin
    dblcb_team2.ItemIndex:=lastindex;
  end
  else if(lastindex>=dblcb_team2.ItemIndex)then
  begin
    dblcb_team2.ItemIndex:=lastindex+1;
  end
  else if(lastindex>dblcb_team2.itemindex)then
  begin
    dblcb_team2.ItemIndex:=lastindex;
  end;
end;

procedure Tfm_table_view.bt_insert_gameClick(Sender: TObject);
var temp:AnsiString;
begin
  temp:=ACTIVE_TABLE;
  if(dblcb_team1.text='')or(dblcb_team2.text='')or(ed_points_team1.text='')or(ed_points_team2.text='')then
  begin
    ShowMessage(LOAD_TRANSLATION('Info','inf_fields_empty',''));
  end
  else
  begin
    if((StrtoInt(ed_points_team1.text))=(StrtoInt(ed_points_team2.text)))then
    begin
      //gleichstand
    end
    else if((StrtoInt(ed_points_team1.text))<(StrtoInt(ed_points_team2.text)))then
    begin
      //Siege und Niederlagen um 1 erhöhen
      //fieldauswählen
      fm_table_view.SqlUpdate('UPDATE ' + temp + ' SET Siege=Siege+1 WHERE Teamname=' + #39 + dblcb_team2.text + #39 + ';', db_query_change);
      db_query_change.Edit;
      db_query_change.FieldByName('Siege').AsString:=inttostr(db_query_change.FieldByName('Siege').AsInteger+1);
      db_query_change.post;

      //fieldauswählen
      fm_table_view.SqlUpdate('UPDATE ' + temp + ' SET Niederlagen=Niederlagen+1 WHERE Teamname=' + #39 + dblcb_team1.text + #39 + ';', db_query_change);
      db_query_change.Edit;
      db_query_change.FieldByName('Niederlagen').AsString:=inttostr(db_query_change.FieldByName('Niederlagen').AsInteger+1);
      db_query_change.post;

      //Ranglistenpunktzahl eintragen
      Pointdifference;
      fm_table_view.SqlUpdate('UPDATE ' + temp + ' SET Punktzahl=Punktzahl+' + Inttostr(Teampoints[1]) + ' WHERE Teamname=' + #39 + dblcb_team1.text + #39 + ';', db_query_change);
      db_query_change.Edit;
      db_query_change.FieldByName('Punktzahl').AsString:=inttostr(db_query_change.FieldByName('Punktzahl').AsInteger+Teampoints[1]);
      db_query_change.post;
      db_query_change.Clear;
      fm_table_view.SqlUpdate('UPDATE ' + temp + ' SET Punktzahl=Punktzahl+' + Inttostr(Teampoints[2]) + ' WHERE Teamname=' + #39 + dblcb_team2.text + #39 + ';', db_query_change);
      db_query_change.Edit;
      db_query_change.FieldByName('Punktzahl').AsString:=inttostr(db_query_change.FieldByName('Punktzahl').AsInteger+Teampoints[2]);
      db_query_change.post;
    end
    else
    begin
      //Siege und Niederlagen um 1 erhöhen
      //fieldauswählen
      fm_table_view.SqlUpdate('UPDATE ' + temp + ' SET Siege=Siege+1 WHERE Teamname=' + #39 + dblcb_team1.text + #39 + ';', db_query_change);
      db_query_change.Edit;
      db_query_change.FieldByName('Siege').AsString:=inttostr(db_query_change.FieldByName('Siege').AsInteger+1);
      db_query_change.post;

      //fieldauswählen
      fm_table_view.SqlUpdate('UPDATE ' + temp + ' SET Niederlagen=Niederlagen+1 WHERE Teamname=' + #39 + dblcb_team2.text + #39 + ';', db_query_change);
      db_query_change.Edit;
      db_query_change.FieldByName('Niederlagen').AsString:=inttostr(db_query_change.FieldByName('Niederlagen').AsInteger+1);
      db_query_change.post;
      db_query_change.Clear;

      //Ranglistenpunkte eintragen
      Pointdifference;
      fm_table_view.SqlUpdate('UPDATE ' + temp + ' SET Punktzahl=Punktzahl+' + Inttostr(Teampoints[1]) + ' WHERE Teamname=' + #39 + dblcb_team1.text + #39 + ';', db_query_change);
      db_query_change.Edit;
      db_query_change.FieldByName('Punktzahl').AsString:=inttostr(db_query_change.FieldByName('Punktzahl').AsInteger+Teampoints[1]);
      db_query_change.post;
      fm_table_view.SqlUpdate('UPDATE ' + temp + ' SET Punktzahl=Punktzahl+' + Inttostr(Teampoints[2]) + ' WHERE Teamname=' + #39 + dblcb_team2.text + #39 + ';', db_query_change);
      db_query_change.Edit;
      db_query_change.FieldByName('Punktzahl').AsString:=inttostr(db_query_change.FieldByName('Punktzahl').AsInteger+Teampoints[2]);
      db_query_change.post;
    end;
  end;

  //Da beim Hochladen der Information der Datenstrom in die andere Richtung geht muss nach der Änderung die Verbindung neu Aktiviert werden
  fm_tournament.db_transaction.Active:=true;
  db_query_table.Active:=true;
  db_query_change.Active:=true;
  db_query_team1.Active:=true; 
  db_query_team2.Active:=true;
  db_query_teams.Active:=true;
  //leeren der Felder
  dblcb_team1.ItemIndex:=-1;  
  dblcb_team2.ItemIndex:=-1;
  ed_points_team1.Text:=''; 
  ed_points_team2.Text:='';
end;

procedure Tfm_table_view.dbgridTitleClick(Column: TColumn);
begin
  if(table_sorted) then
  begin
    fm_tournament.SqlQuery('SELECT * FROM '+ACTIVE_TABLE+' ORDER BY '+Column.FieldName+' ASC;', db_query_table);
    table_sorted:=false;
  end
  else
  begin
    fm_tournament.SqlQuery('SELECT * FROM '+ACTIVE_TABLE+' ORDER BY '+Column.FieldName+' DESC;', db_query_table);
    table_sorted:=true;
  end;
end;

procedure Tfm_table_view.dblcb_team2Exit(Sender: TObject);
var
  lastindex:integer;
begin
  lastindex:=dblcb_team1.ItemIndex;
  if(dblcb_team2.ItemIndex<>-1)then
  begin
    fm_tournament.SqlQuery('SELECT Teamname FROM ' + ACTIVE_TABLE + ' WHERE NOT Teamname = ' + #39 + dblcb_team2.Text + #39 + ';', db_query_team1);
    dblcb_team1.ListSource:=db_source_team1;
    dblcb_team1.KeyField:='Teamname';
  end;
  if(lastindex=-1)then
  begin
    dblcb_team1.ItemIndex:=lastindex;
  end
  else if(lastindex>=dblcb_team1.ItemIndex)then
  begin
    dblcb_team1.ItemIndex:=lastindex+1;
  end
  else if(lastindex>dblcb_team1.itemindex)then
  begin
    dblcb_team1.ItemIndex:=lastindex;
  end;
end;

procedure Tfm_table_view.ed_points_team1KeyPress(Sender: TObject; var Key: char
  );
begin
  if ((Length(ed_points_team1.text)>3) and (key<>#8))then key:=#0;
  if not(key IN ['0'..'9',#8])then key:=#0;
end;

procedure Tfm_table_view.ed_points_team2KeyPress(Sender: TObject; var Key: char
  );
begin
  if ((Length(ed_points_team2.text)>3) and (key<>#8))then key:=#0;
  if not(key IN ['0'..'9',#8])then key:=#0;
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
  fm_tournament.show;
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
  sql_query.UpdateSQL.text:=statement;
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
  bt_insert_game.Caption:=LOAD_TRANSLATION('GUI','bt_insert_game','');
  lb_add_teamname.Caption:=LOAD_TRANSLATION('GUI','lb_add_teamname','');
  gb_add_team.Caption:=LOAD_TRANSLATION('GUI','gb_add_team','');
  bt_add_team.Caption:=LOAD_TRANSLATION('GUI','bt_add_team','');      
  lb_delete_teamname.Caption:=LOAD_TRANSLATION('GUI','lb_delete_teamname','');
  gb_delete_team.Caption:=LOAD_TRANSLATION('GUI','gb_delete_team','');
  bt_delete_team.Caption:=LOAD_TRANSLATION('GUI','bt_delete_team','');
  lb_edit_old_teamname.Caption:=LOAD_TRANSLATION('GUI','lb_edit_old_teamname','');
  lb_edit_new_teamname.Caption:=LOAD_TRANSLATION('GUI','lb_edit_new_teamname','');
  gb_edit_team.Caption:=LOAD_TRANSLATION('GUI','gb_edit_team','');
  bt_edit_team.Caption:=LOAD_TRANSLATION('GUI','bt_edit_team','');

  //Objektdarstellung
  //grid
  dbgrid.FastEditing:=false;
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
  dblcb_add_team.ListSource:=db_source_teams;
  dblcb_add_team.KeyField:='Teamname';
  dblcb_delete_team.ListSource:=db_source_teams;
  dblcb_delete_team.KeyField:='Teamname';
  dblcb_edit_team.ListSource:=db_source_teams;
  dblcb_edit_team.KeyField:='Teamname';

  //edits
  ed_points_team1.text:='';
  ed_points_team2.text:='';
  ed_search.Text:='';
  ed_edit_teamname.Text:='';

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
  fm_tournament.SqlQuery('SELECT * FROM ' + ACTIVE_TABLE + ';', db_query_change);
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
  db_query_change.Options:=[sqoAutoApplyUpdates,sqoAutoCommit];

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

function Tfm_table_view.Pointdifference: TTeampoints;
var
  difference:integer;
begin
  //Gibt die Ranglistenpunkte anhand der Korbdifferenz(Punktedifferenz) aus
  difference:=StrtoInt(ed_points_team1.text)-StrtoInt(ed_points_team2.text);
  if (difference=0)then
  begin
    Teampoints[1]:=500;
    Teampoints[2]:=500;
  end
  else if(difference>0)then
  //Team 1 Gewinnt
  begin
    if(difference<10)then
    begin
      Teampoints[1]:=600;
      Teampoints[2]:=400;
    end
    else if(difference<20)then
    begin
      Teampoints[2]:=700;
      Teampoints[1]:=300;
    end
    else Teampoints[1]:=800;Teampoints[2]:=200;
  end
  else if(difference<0)then
  //Team 2 Gewinnt
  begin
    if(difference>-10)then
    begin
      Teampoints[2]:=600;
      Teampoints[1]:=400;
    end
    else if(difference>-20)then
    begin
      Teampoints[2]:=700;
      Teampoints[1]:=300;
    end
    else Teampoints[2]:=800;Teampoints[1]:=200;
  end;
  Teampoints[1]:=0;
  Teampoints[2]:=0;
end;

end.

