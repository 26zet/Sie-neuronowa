program plik_testowy;

uses Math;

type Tablica=Array of Array of Real;
     Wektor=Array of Real;

const
          beta=4.2;     //wspolczynnik beta
          lin=35;       //liczba el. wektorów wejscia
           n1=32;       //liczba neuronów w 1 warstwie ukrytej
           n2=28;       //liczba neuronów w 2 warstwie ukrytej
           n3=26;       //liczba neuronów w 3 warstwie ukrytej
           lout=26;     //liczba el. wektorów wyjscia


var  wagi: Text;
    wagi1,wagi2,wagi3,wagi4: Tablica;
    input: Array[0..lin-1] of Real;
    ukryty0,ukryty1,ukryty2,ukryty3,ukryty4: Wektor;
    max,i,j:Integer;

    procedure wczytuj(a,b:Integer;var tab: Tablica;var plik: Text);

          var i,j: Integer;

              begin
                   SetLength(tab,a,b);
                   For i:=0 to a-1 do
                   begin
                        For j:=0 to b-1 do
                             Read(plik,tab[i,j]);
                        Readln(plik);
                   end;
              end;
procedure neuron(a,b: Integer;var tab:Tablica;var ukr1,ukr2:Wektor);

          var i,j: Integer;

          begin
               Setlength(ukr2,b);
          For i:=0 to b-1 do
              begin
                   ukr2[i]:=0;
                   For j:=0 to a-1 do
                       ukr2[i]:=ukr2[i]+ukr1[j]*tab[j,i];
              end;

              For i:=0 to b-1 do
              ukr2[i]:=1/(power(Exp(1),-beta*ukr2[i])+1);
          end;

begin
  //Wczytanie wag:

  Assign(wagi, 'wagi.txt');
  Reset(wagi);
  wczytuj(lin,n1,wagi1,wagi);
  wczytuj(n1,n2,wagi2,wagi);
  wczytuj(n2,n3,wagi3,wagi);
  wczytuj(n3,lout,wagi4,wagi);
  Close(wagi);

  //Wpisanie wektora wejsciowego:
  Writeln('Wpisz wektor wejsciowy:');
  For i:=0 to lin-1 do
  Read(input[i]);
  Readln;
  Writeln;

  //Warstwy ukryte:

  SetLength(ukryty0,lin);
  For i:=0 to lin-1 do
  ukryty0[i]:=input[i];

  neuron(lin,n1,wagi1,ukryty0,ukryty1);
  neuron(n1,n2,wagi2,ukryty1,ukryty2);
  neuron(n2,n3,wagi3,ukryty2,ukryty3);
  neuron(n3,lout,wagi4,ukryty3,ukryty4);

  //Indeks maksimum ukryty4:

  max:=0;
  For i:=1 to lout-1 do
  If ukryty4[i]>ukryty4[max] then
  max:=i;

  //Odpowiednia litera:

  Case max of
  0: Write('A');
  1: Write('B');
  2: Write('C');
  3: Write('D');
  4: Write('E');
  5: Write('F');
  6: Write('G');
  7: Write('H');
  8: Write('I');
  9: Write('J');
  10: Write('K');
  11: Write('L');
  12: Write('M');
  13: Write('N');
  14: Write('O');
  15: Write('P');
  16: Write('Q');
  17: Write('R');
  18: Write('S');
  19: Write('T');
  20: Write('U');
  21: Write('W');
  22: Write('V');
  23: Write('X');
  24: Write('Y');
  25: Write('Z');
  end;

  Writeln;

  For i:=0 to lout-1 do
  Write(ukryty4[i]:5:10,' ');
  Readln;

end.

