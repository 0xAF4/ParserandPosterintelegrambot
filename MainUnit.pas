unit MainUnit;

interface

uses
  Winapi.Windows, System.Classes, Winapi.Messages, System.SysUtils, System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.DateUtils,
  Vcl.WinXPickers, httpsend, ssl_openssl, System.JSON, NetEncoding, RegExpr, TgBotApi,
  HGM.JSONParams, HGM.ArrayHelpers, TgBotApi.Client, TgBotProc.Test;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    ListBox1: TListBox;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    TimePicker1: TTimePicker;
    Timer1: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button4: TButton;
    Edit3: TEdit;
    Edit4: TEdit;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TimePicker1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UpdatePull;
    procedure Edit1Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
type
  Potok = class(TThread)
  private
    URL: string;
  protected
    procedure Execute; override;
    function Pars(T_, ForS, _T: string): string;
    procedure Sync();
  public
    constructor Create;
    destructor destroy; override;
  end;

type
  pulling = class(TThread)
    private
      addchannel: boolean;
      delChannel: boolean;
    protected
      procedure Execute; override;
    public
      procedure AEnd;
      constructor Create;
      destructor destroy; override;
  end;

const
  Resource = 'https://criptopost.pro/';

var
  Form2: TForm2;
  MyTime: TTime;
  MyThread: Potok;
  Pullin: Pulling;

  errors: integer;
  posted: integer;

  work: boolean;
  tUpdate: boolean;
  PostDataBase: TStringList;

  token: string;
  listofchanells: TStringList;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var sobaka: string;
begin
  if Edit2.Text = '' then raise Exception.Create('Название канала должно быть указано!');
  ListBox1.Items.Add(Edit2.Text);
  listofchanells.Add(Edit2.Text);
  Edit2.Text:='';
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  ListBox1.Items.Delete(ListBox1.ItemIndex);
  listofchanells.Delete(ListBox1.ItemIndex)
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  if token = '' then  raise Exception.Create('Должен быть указан токен!');
  if ListBox1.Count = 0 then raise Exception.Create('Должен быть указан хотя бы один канал!');

  errors := 0;
  posted := 0;

  Label2.Caption:='0';
  Label4.Caption:='0';
  work := True;
  tUpdate := True;
  MyTime := TimePicker1.Time;
  Timer1.Enabled := True;
  MyThread := potok.Create();
end;

function Pars(T_, ForS, _T: string): string;
var
a,b: integer;
begin
  Result:= '';
  if (T_='') or (ForS='') or (_T='') then Exit;
  a:= Pos(T_,ForS);
  if a=0 then Exit else a := a + length(T_);
  ForS := copy(ForS, a, length(ForS)-a+1);
  b:=Pos(_T,ForS);
  result:= copy(ForS, 1, b - 1);
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  var HTTP:=THTTPSend.Create;
  var HTML:=TStringList.Create;
  HTTP.HTTPMethod('GET', 'https://api.telegram.org/bot' + Edit1.Text +
    '/sendMessage?chat_id=' + Edit3.Text + '&text=123');
  HTML.LoadFromStream(HTTP.Document);
  Edit4.Text := Pars('"chat":{"id":', HTML.Text, ',');
  HTTP.Free;
  HTML.Free;
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  work := False;
  Timer1.Enabled := False;
  TimePicker1.Time := MyTime;
end;

procedure TForm2.Button6Click(Sender: TObject);
begin
  TimePicker1.Time :=  StrToTime('01:00:00');
end;

procedure TForm2.Button7Click(Sender: TObject);
begin
  TimePicker1.Time :=  StrToTime('03:00:00');
end;

procedure TForm2.Button8Click(Sender: TObject);
begin
  if token = '' then  raise Exception.Create('Должен быть указан токен!');
  Pullin := Pulling.Create;
end;

procedure TForm2.Button9Click(Sender: TObject);
begin
  try
  Pullin.Terminate;
  Pullin.AEnd;
  except  end;
end;

procedure TForm2.Edit1Change(Sender: TObject);
begin
  token := Edit1.Text;
end;

procedure TForm2.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
if Key = #13 then
  begin
    Key := #0;
    Button1Click(self);
  end;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  listofchanells.Free;
  PostDataBase.Free;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  PostDataBase:=TStringList.Create;
  listofchanells:=TStringList.Create;
  UpdatePull;
end;

procedure TForm2.TimePicker1Click(Sender: TObject);
begin
if work then
  begin
  TimePicker1.Time:=StrToTime('00:00:05');
  TimePicker1.DropDown;
  end;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
  TimePicker1.Time := IncSecond(TimePicker1.Time, -1);
  if StrToTime('00:00:02') > (TimePicker1.Time) then
  begin
    TimePicker1.Time := MyTime;
    tUpdate := True;
  end;
end;

procedure TForm2.UpdatePull;
var HTML: TStringList;
    JSONResponse: TJSONObject;
    JSONArray: TJSONArray;
begin
  HTML:=TStringList.Create;

  if HttpGetText(Resource, HTML) then
    begin
      HTML.Text := utf8toansi(HTML.Text);
      var reg := TRegExpr.Create;
      Reg.Expression:= '<div class="col-12 col-md-6 col-lg-4 mb-4">(.*?)<div class="data">';

      if reg.Exec(HTML.Text) then
      repeat
        var articlelink := Resource+pars('<a href="/', reg.Match[1], '"');
        PostDataBase.Add(articleLink);
      until not reg.ExecNext;

      Reg.Free;
    end
      else
    begin
      ShowMessage('Во время получения списка новостей произошла ошибка, попробуйте позднее!');
      halt;
    end;

  HTML.Free;
end;

{ Potok }

constructor Potok.Create;
begin
  inherited Create(True);
  FreeonTerminate:=True;
  Resume;
end;

destructor Potok.destroy;
begin
  inherited;
end;

function Potok.Pars(T_, ForS, _T: string): string;
var
  a, b: Integer;
begin
  Result := '';
  if (T_ = '') or (ForS = '') or (_T = '') then
    Exit;
  a := Pos(T_, ForS);
  if a = 0 then
    Exit
  else
    a := a + length(T_);
  ForS := copy(ForS, a, length(ForS)-a+1);
  b:=Pos(_T,ForS);
  result:= copy(ForS, 1, b - 1);
end;

procedure Potok.Sync;
begin
  Form2.Label2.Caption:=Posted.ToString;
  Form2.Label4.Caption:=Errors.ToString;
end;

procedure Potok.Execute;
const url = 'https://api.telegram.org/bot%s/sendPhoto?chat_id=%s&photo=%s&caption=%s&parse_mode=HTML';
var HTML: TStringList;
    JSONResponse: TJSONObject;
    JSONArray: TJSONArray;
begin
  while work do
    begin
     if tUpdate then
      begin
        tUpdate := False;
        HTML:=TStringList.Create;

        if HttpGetText(Resource, HTML) then
          begin
            HTML.Text := utf8toansi(HTML.Text);

            var reg := TRegExpr.Create;
            Reg.Expression:= '<div class="col-12 col-md-6 col-lg-4 mb-4">(.*?)<div class="data">';

            if reg.Exec(HTML.Text) then
            repeat
              var imagelink := pars('<img src="', reg.Match[1], '"');
              var articlelink := Resource+pars('<a href="/', reg.Match[1], '"');
              var title := Trim(pars('<h3>', reg.Match[1], '</h3>'));
              if pos(articlelink, PostDataBase.Text)<>0 then Continue;


              var caption:=TNetEncoding.URL.Encode('<b>'+title+'</b>'+sLineBreak+sLineBreak+'<a href="'+articlelink+'">«Читайте на нашем сайте»</a>'+sLineBreak+sLineBreak+'CriptoPost.pro | @tlg_media');
              for var chanell in listofchanells do
                  HttpGetText(Format(url, [token, chanell, imagelink, caption]), HTML);

              PostDataBase.Add(articleLink);
              if PostDataBase.Count > 3000 then PostDataBase.Delete(0);
              Inc(posted);
            until not reg.ExecNext;

            reg.free;
          end else Inc(errors);
        Synchronize(sync);
        HTML.Free;
      end
        else
      begin
        Sleep(3000);
      end;
    end;
end;

{ pulling }

procedure pulling.AEnd;
begin
  Client.Free;
end;

constructor pulling.Create;
begin
  inherited Create(True);
  addchannel := false;
  delchannel := false;
  FreeOnTerminate := True;
  Resume;
end;

destructor pulling.destroy;
begin
  inherited;
end;

procedure pulling.Execute;
const
  SendMess = 'https://api.telegram.org/bot%s/sendmessage?chat_id=%s&text=%s';
begin
  var
    StartCaption :=  TNetEncoding.URL.Encode(
    'Привет, в данном боте доступны следующие команды:'+slineBreak+
    '/startposting - Начать постинг'+slineBreak+
    '/stopposting - Остановить постинг'+slineBreak+
    '/suspend1hour - Пауза на 1 час'+slineBreak+
    '/suspend3hour - Пауза на 3 часа'+slineBreak+
    '/resume - Возобновить работу'+slineBreak+
    '/getchannels - Получить список каналов для постинга'+slineBreak+
    '/addchannel - Добавить канал для постинга'+slineBreak+
    '/deletechannel - Удалить канал из списка'+slineBreak+
    '/getstatistic Получить статистику по публикациям');


  var html := TStringList.Create;
  try
    Client := TtgClient.Create(token);
    Client.Polling(
    procedure(u: TtgUpdate)
    begin
      if Assigned(u.Message) and Assigned(u.Message.Chat) then
      begin
        if addchannel then
        begin
          synchronize(procedure
          begin
            Form2.Edit2.Text := u.Message.Text;
            Form2.Button1Click(Form2);
          end);
          addchannel := false;
          HttpGetText(Format(SendMess, [token, u.Message.Chat.Id.ToString, TNetEncoding.URL.Encode('Канал был добавлен!')]), HTML);
        end
        else if delchannel then
        begin
          try
            var id := StrToInt(u.Message.Text)-1;
            synchronize(procedure
            begin
              Form2.ListBox1.Items.Delete(id);
              listofchanells.Delete(id)
            end);
            delchannel := false;
            HttpGetText(Format(SendMess, [token, u.Message.Chat.Id.ToString, TNetEncoding.URL.Encode('Канал был удален из списка!')]), HTML);
          except
            HttpGetText(Format(SendMess, [token, u.Message.Chat.Id.ToString, TNetEncoding.URL.Encode('Отправьте число!')]), HTML);
          end;
        end
        else if u.Message.Text = '/start' then
        begin
          HttpGetText(Format(SendMess, [token, u.Message.Chat.Id.ToString, StartCaption]), HTML);
        end
        else if u.Message.Text = '/startposting' then
        begin
          if token = '' then
          HttpGetText(Format(SendMess, [token, u.Message.Chat.Id.ToString, TNetEncoding.URL.Encode('Токен не указан!')]), HTML)
          else if Form2.ListBox1.Count = 0 then
          HttpGetText(Format(SendMess, [token, u.Message.Chat.Id.ToString, TNetEncoding.URL.Encode('Должен быть указан хотя бы один канал!')]), HTML)
          else
          begin
            Synchronize(procedure
            begin
              Form2.Button3Click(Form2);
            end);
            HttpGetText(Format(SendMess, [token, u.Message.Chat.Id.ToString, TNetEncoding.URL.Encode('Постинг запущен!')]), HTML);
          end;
        end
        else if u.Message.Text = '/stopposting' then
        begin
          Synchronize(procedure
          begin
            Form2.Button5Click(Form2);
          end);
          HttpGetText(Format(SendMess, [token, u.Message.Chat.Id.ToString, TNetEncoding.URL.Encode('Постинг остановлен!')]), HTML);
        end
        else if u.Message.Text = '/suspend1hour' then
        begin
          Synchronize(procedure
          begin
            Form2.Button6Click(Form2);
          end);
          HttpGetText(Format(SendMess, [token, u.Message.Chat.Id.ToString, TNetEncoding.URL.Encode('Постинг приостановлен на 1 час!')]), HTML);
        end
        else if u.Message.Text = '/suspend3hour' then
        begin
          Synchronize(procedure
          begin
            Form2.Button7Click(Form2);
          end);
          HttpGetText(Format(SendMess, [token, u.Message.Chat.Id.ToString, TNetEncoding.URL.Encode('Постинг приостановлен на 3 часа!')]), HTML);
        end
        else if u.Message.Text = '/resume' then
        begin
          Synchronize(procedure
          begin
            Form2.TimePicker1Click(Form2);
          end);
          HttpGetText(Format(SendMess, [token, u.Message.Chat.Id.ToString, TNetEncoding.URL.Encode('Постинг возобновлен!')]), HTML);
        end
        else if u.Message.Text = '/getchannels' then
        begin
          var channelList := 'Постинг ведется в следующие каналы:'+slineBreak;
          for var i := 0 to Form2.ListBox1.Items.Count-1 do
            channelList := channelList+'['+(i+1).ToString+'] '+Form2.ListBox1.Items[i]+slineBreak;
          HttpGetText(Format(SendMess, [token, u.Message.Chat.Id.ToString, TNetEncoding.URL.Encode(channelList)]), HTML);
        end
        else if u.Message.Text = '/addchannel' then
        begin
          addchannel := true;
          HttpGetText(Format(SendMess, [token, u.Message.Chat.Id.ToString, TNetEncoding.URL.Encode('Отправьте адресс канала с @ или его id!')]), HTML);
        end
        else if u.Message.Text = '/deletechannel' then
        begin
          delchannel := true;
          HttpGetText(Format(SendMess, [token, u.Message.Chat.Id.ToString, TNetEncoding.URL.Encode('Отправьте порядковый номер канала на удаление!')]), HTML);
        end
        else if u.Message.Text = '/getstatistic' then
        begin
          HttpGetText(Format(SendMess, [token, u.Message.Chat.Id.ToString, TNetEncoding.URL.Encode('Опубликовано: '+Form2.label2.Caption+slineBreak+'Ошибки: '+Form2.Label4.Caption)]), HTML);
        end
      end;
    end);
  except
    Client.Free;
  end;
  html.Free;
end;

end.
