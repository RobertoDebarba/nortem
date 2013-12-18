{ <description>

  Copyright (C) <2013> <Jonathan Eli Suptitz, Roberto Luiz Debarba> <jonny.suptitz@gmail.com, roberto.debarba@gmail.com>

  Este arquivo é parte do programa NORTEM.

  NORTEM é um software livre; você pode redistribuir e/ou modificá-los
  sob os termos da GNU Library General Public License como publicada pela Free
  Software Foundation; ou a versão 3 da Licença, ou (a sua escolha) qualquer
  versão posterior.

  Este código é distribuído na esperança de que seja útil, mas SEM
  QUALQUER GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE ou
  ADEQUAÇÃO A UMA FINALIDADE PARTICULAR. Veja a licença GNU General Public
  License para maiores detalhes.

  Você deve ter recebido uma cópia da licença GNU Library General Public
  License juntamente com esta biblioteca; senão, escreva a Free Software
  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
}

unit uresolucao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TFrmResolucao }

  TFrmResolucao = class(TForm)
  Button1: TButton;
  ComboBox1: TComboBox;
  Edit1: TEdit;
  Image1: TImage;
  Image2: TImage;
  Labelanos: TLabel;
  Labelminutos: TLabel;
  Labelhoras: TLabel;
  Labeldias: TLabel;
  Labelmeses: TLabel;
  Label30: TLabel;
  Label4: TLabel;
  Label50: TLabel;
  Label60: TLabel;
  Label10: TLabel;
  LabelResultado: TLabel;
  Memo1: TMemo;
  Panel1: TPanel;
  Panel2: TPanel;
  Timer2: TTimer;
  procedure FormCreate(Sender: TObject);
  procedure Label30Click(Sender: TObject);
  procedure next;
  procedure Button1Click(Sender: TObject);
  procedure Edit1KeyPress(Sender: TObject; var Key: char);
  function limitcasas(numero : real) : string;
  function tempo(numero : integer) : string;
  function Passo(source: integer) : integer;
  procedure NormalizarDados(source: integer; valor : real);
  procedure Timer2StopTimer(Sender: TObject);
  procedure Timer2Timer(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FrmResolucao: TFrmResolucao;
    ReferenciaTempo : integer;
    proximo : boolean;
    labelatual : Tlabel;
    componente : string;
    primeiroclick : integer;

implementation

{$R *.lfm}

//limita casas decimais sem arredondar valor
function TFrmResolucao.limitcasas(numero: real): string;
const
  Ccasas : integer = 4;
var
    x, num: integer;
    numSTR : string;
    controle : boolean;

begin
  controle := false;
  numSTR := floatToStr(numero);
  for x := 0 to length(NumStr) do
  begin
    if ((numSTR[x]) = '.') then
    begin
      num := (x + Ccasas);
      result := copy(numSTR, 1, num);
      controle := true;
    end;
  end;
  if not(controle) then
    result := numSTR;
end;
//---------

// evento click botao
procedure TfrmResolucao.Button1Click(Sender: TObject);
begin
  if primeiroclick = 2 then
  begin
    proximo := true;
    Timer2.Enabled := false;
  end
  else if primeiroclick = 1 then
  begin
    LabelResultado.caption := '';
    timer2.enabled := false;
    memo1.lines.Clear;

    if ComboBox1.Text = 'segundos' then
       ReferenciaTempo := 6
    else if ComboBox1.Text = 'minutos' then
       ReferenciaTempo := 5
    else if ComboBox1.Text = 'horas' then
       ReferenciaTempo := 4
    else if ComboBox1.Text = 'dias' then
       ReferenciaTempo := 3
    else if ComboBox1.Text = 'meses' then
       ReferenciaTempo := 2
    else
      ShowMessage('Selecione o tempo!');

    if edit1.text = '' then
      ShowMessage('Digite um valor!');

    if (ComboBox1.text <> '') and (edit1.text <> '') then
    begin
      primeiroclick := 2;
      button1.Caption := 'Proximo Passo';
      button1.Color := clAqua;
      NormalizarDados(ReferenciaTempo, strToFloat(edit1.text));
    end;
  end
  else
  begin
    primeiroclick := 1;
  end;
end;
//-------------

//permitir apenas numeros no edit
procedure TFrmResolucao.Edit1KeyPress(Sender: TObject; var Key: char);
begin
    if (not (Key in ['0'..'9'])) and (Key <> #8) then
    Key := #0;
end;
//--------------------

// Atribui o valor da operação atual
function TfrmResolucao.Passo(source: integer) : integer;
begin
  case source of
      0: result := 12;
  		1: Result := 12;
      2: Result := 30;
      3: Result := 24;
      4: Result := 60;
      5: Result := 60;
      6: Result := 60;
  end;
end;
//----------------------------

//converte valor para nome do tipo de tempo
function TfrmResolucao.tempo(numero : integer): string;
begin
  if numero = 6 then
     result := 'segundos'
  else if numero = 5 then
     result := 'minutos'
  else if numero = 4 then
     result := 'horas'
  else if numero = 3 then
     result := 'dias'
  else if numero = 2 then
     result := 'meses'
  else if numero = 1 then
    result := 'anos'
  else if numero = 0 then
    result := 'anos';

end;
//------------------------------------

//ativar timer de piscar label
procedure TFrmResolucao.next;
begin
  if componente <> '' then
  begin
    while not(proximo) do
    begin
      timer2.Enabled := true;
      application.ProcessMessages;
    end;
  end
  else
    while not(proximo) do
    begin
        application.ProcessMessages;
    end;

  proximo := false;
end;
//---------------------------------------------

// form creat
procedure TFrmResolucao.FormCreate(Sender: TObject);
begin
  primeiroclick := 1;
end;

procedure TFrmResolucao.Label30Click(Sender: TObject);
begin

end;

// ----------------------------------------------------


// Normaliza a unidade de tempo
procedure TfrmResolucao.NormalizarDados(source: integer; valor : real);
var
  resto, resultado : real;
begin
  resto := 0;
  resultado := 0;

  // Divisão ate ultima possivel
  while (source > 1) and (valor >= Passo(source-1)) do
  begin
    Memo1.lines.Add(
      'O valor ' + limitcasas(valor) + ' '+ tempo(source) +
      ' não é um formato normal de tempo.' + #13#10
      + #13#10 + 'Por isso devemos dividi-lo para chegar em um valor válido.'
      + #13#10 + '-----' + #13#10);

    componente := '';
    next;

    Memo1.lines.Add(
      'Valor para cálculo atual: ' + limitcasas(valor) + ' '+ tempo(source) + #13#10);
    Memo1.lines.Add(
      'Dividir ' + limitcasas(valor) + ' ' + tempo(source) + ' por '
      + IntToStr(Passo(source-1)) + ' para converter esse valor para ' + tempo(source-1)
      + '. Vide tabela no canto inferior esquerdo.'
      + #13#10);

    componente := ('Label' + (tempo(source-1)));
    next;

    Memo1.lines.Add(
      'Cálculo: ' + limitcasas(valor) + ' / ' + IntToStr(Passo(source-1))
      + #13#10);

    valor := valor / Passo(source-1);

    dec(source);

    Memo1.lines.Add(
      'Resultado: ' + limitcasas(valor) + ' ' + tempo(source) + #13#10 +
      ' (Valor truncado para exibição)'+ #13#10 + '-----' + #13#10);

    componente := '';
    next;
  end;
  //-----------------------------

  Resultado := int(valor);

  LabelResultado.caption := floatToStr(Resultado) + ' ' + tempo(source);

  Memo1.lines.Add(
    'Fim das divisões, pois o valor já é normal e não pode mais ser convertido!' + #13#10
    + #13#10 +  '----------' + #13#10 +
    'A partir de agora, a parte inteira dos resultados entram para o resultado final.'
    + #13#10 + #13#10);

  componente := '';
  next;

  Memo1.lines.Add(
    'Então a parte inteira desse último resultado, o número ' + limitcasas(Resultado)
    + ', já é o inicio do resultado final.' + #13#10
    + '--------------------' + #13#10);

  componente := '';
  next;
  //------------------------------

  //multiplicaçao obtenção do resultados
  while (source <> 6) and ((frac((int(valor * 100)) / 100)) <> 0.00) do
  begin
    Resto := frac(valor);

    memo1.lines.Add(
        'Agora utilizar apenas a parte decimal do valor ' + limitcasas(valor)
        + ' ' + tempo(source) + ' que é ' + limitcasas(Resto)
        + ' ' + tempo(source)  + #13#10 + '----------' + #13#10);

    componente := '';
    next;

    Memo1.lines.Add(
        'Multiplicar ' + limitcasas(Resto) + ' '+ tempo(source) + ' por '
        + IntToStr(Passo(source)) + ' para converter para ' + tempo(source+1)
        + '. Vide tabela no canto inferior esquerdo.' + #13#10);

    componente := ('Label' + (tempo(source)));
    next;

    Memo1.lines.Add(
        'Cálculo atual : ' + limitcasas(Resto) + ' * '
        + IntToStr(passo(source))+ #13#10);

    valor := resto * passo(source);
    inc(source);

    Memo1.lines.Add(
        'Resultado atual : ' + limitcasas(valor) + ' ' + tempo(source)
        + #13#10 +
        ' (Valor truncado para exibição)' + #13#10 + '----------' + #13#10);

    componente := '';
    next;

    resultado := frac(valor);

    if ( resultado > 0.89) then
    begin
      Resultado := round(valor);

      Memo1.lines.Add(
        'Então arredondamos o valor ' + limitcasas(valor) + ' ' + tempo(source)
        + ' para ' + limitcasas(Resultado) + ' ' + tempo(source)
        + ' pois o valor terminou em "X".999999'
        + #13#10 + '----------' + #13#10);

      valor := resultado;
    end
    else if (source = 6) then
    begin
      Resultado := round(valor);

      Memo1.lines.Add(
        'Então arredondamos o valor ' + limitcasas(valor) + ' ' + tempo(source)
        + ' para ' + limitcasas(Resultado) + ' ' + tempo(source)
        + ' pois chegamos a segundos' + #13#10 + '----------' + #13#10);

      componente := '';
      next;
    end
    else
    begin
      Resultado := int(valor);

      Memo1.lines.Add(
        'A parte inteira desse último resultado, o número ' + limitcasas(Resultado)
        + ' faz parte resultado final.'
        + #13#10 + '----------' + #13#10);
    end;

    LabelResultado.caption := LabelResultado.caption + ' '
      + floatToStr(Resultado) + ' ' + tempo(source);
    end;

    Memo1.lines.Add(
      'Fim dos cálculos!' + #13#10);

    ShowMessage('Fim dos Cálculos!');

    button1.Caption := 'Fim';

    componente := 'labelresultado';
    next;

    primeiroclick := 1;

    //limpar campos e voltar botão ao normal
    button1.Color := clNone;
    button1.Caption := 'Resolver';
    Edit1.clear;
    ComboBox1.ClearSelection;
  end;
//---------------------------------------------------------------

// label que piscar voltar a visibilidade
procedure TFrmResolucao.Timer2StopTimer(Sender: TObject);
begin
    if assigned(Tlabel(FindComponent(componente))) then
    begin
      labelatual := Tlabel(findcomponent(componente));
      Labelatual.visible := true;
    end;
end;

//----------------------------------------------------------------------

// evento timer fazer piscar label
procedure TFrmResolucao.Timer2Timer(Sender: TObject);
begin
  if componente = 'Labelsegundos' then
  componente := 'Labelminutos';

  labelatual := Tlabel(findcomponent(componente));

    with labelatual  do
      if not(visible) then
        Labelatual.visible := true
      else
        Labelatual.visible := false;

  application.ProcessMessages;
end;
//------------------------------------------------------------------------------

end.

