unit utable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, IniFiles, FileUtil;

type

  { Tfm_table_view }

  Tfm_table_view = class(TForm)
    menu_export: TMenuItem;
    menu_option: TMenuItem;
    menu_close: TMenuItem;

    menu_language: TMenuItem;
    menu_back: TMenuItem;
    menu_main: TMainMenu;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure menu_backClick(Sender: TObject);
    procedure menu_closeClick(Sender: TObject);
  private
    procedure FormatGUI;
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
end;

procedure Tfm_table_view.FormCreate(Sender: TObject);
begin
  fm_table_view.Top:=50;
  fm_table_view.Left:=50;
end;

procedure Tfm_table_view.menu_backClick(Sender: TObject);
begin
  fm_tournament.Show;
  fm_table_view.hide;
end;

procedure Tfm_table_view.menu_closeClick(Sender: TObject);
begin
  fm_table_view.close;
end;

procedure Tfm_table_view.FormatGUI;
begin
  //Legt die Formatierungen für alle GUI-Elemente fest

  fm_table_view.Caption:=fm_tournament.language.ReadString('GUI','fm_table_view','');
  menu_language.Caption:=fm_tournament.language.ReadString('GUI','menu_option','');
  menu_option.Caption:=fm_tournament.language.ReadString('GUI','menu_language','');
  menu_back.Caption:=fm_tournament.language.ReadString('GUI','menu_back','');
  menu_close.Caption:=fm_tournament.language.ReadString('GUI','menu_close',''); 
  menu_export.Caption:=fm_tournament.language.ReadString('GUI','menu_export','');
end;

end.

