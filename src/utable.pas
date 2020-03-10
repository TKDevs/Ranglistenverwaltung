unit utable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, IniFiles, FileUtil;

type

  { Tfm_table_view }

  Tfm_table_view = class(TForm)
    menu_option: TMenuItem;
    menu_close: TMenuItem;

    menu_language: TMenuItem;
    menu_back: TMenuItem;
    menu_main: TMainMenu;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure FormatGUI;
    procedure ChecklanguageFile;
  public

  end;

var
  fm_table_view: Tfm_table_view;
  language: TIniFile;

implementation

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
  ChecklanguageFile;
end;

procedure Tfm_table_view.FormDestroy(Sender: TObject);
begin
  language.Free;
end;


procedure Tfm_table_view.FormatGUI;
begin
  //Legt die Formatierungen für alle GUI-Elemente fest

  fm_table_view.Caption:=language.ReadString('GUI','fm_tournament','');
  menu_language.Caption:=language.ReadString('GUI','menu_option','');
  menu_option.Caption:=language.ReadString('GUI','menu_language','');
  //menu_back.Caption:=language.ReadString('GUI','menu_close','');
  menu_close.Caption:=language.ReadString('GUI','menu_close','');
end;

procedure Tfm_table_view.CheckLanguageFile;
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

end.

