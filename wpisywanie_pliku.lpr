program wpisywanie_pliku;

uses Math;

type Tablica=Array of Array of Real;
     Wektor=Array of Real;

const lw=130;   //liczba wektorów wejsciowych
      beta=2.0;   //wspolczynnik beta
      q=0.9;       //wspolczynnik bledu
      s=1.0;       //wspolczynnik momentum
      lin=35;       //liczba el. wektorów wejscia
        n1=32;       //liczba neuronów w 1 warstwie ukrytej
        n2=28;       //liczba neuronów w 2 warstwie ukrytej
        n3=26;       //liczba neuronów w 3 warstwie ukrytej
        lout=26;     //liczba el. wektorów wyjscia
        f=100;        //Liczba epok w jednym przejsciu programu
var input1,output1,wagi,wagiout,bledy: Text;
    super: Array[0..lw-1,0..lin+lout-1] of Real;
    input: Array[0..lin-1] of Real;
    output: Array[0..lout-1] of Real;
    bladw: Array[0..lw-1] of Real;
    wagi1,wagi2,wagi3,wagi4,
    wagip1,wagip2,wagip3,wagip4: Tablica;
    ukryty0,ukryty1,ukryty2,ukryty3,ukryty4,
    wekbl1,wekbl2,wekbl3,wekbl4: Wektor;
    i,k,l,m: Integer;
    blad: Real;
    ch: char;
                //zerowanie wag do momentum
procedure zeruj(a,b: Integer;var tab: Tablica);

    var i,j: Integer;

        begin
          SetLength(tab,a,b);
          For i:=0 to a-1 do
          For j:=0 to b-1 do
          tab[i,j]:=0;
        end;
                      // losowanie wag
procedure losuj(a,b: Integer;var tab: Tablica);

          var i,j: Integer;

        begin
          Randomize;
          SetLength(tab,a,b);
          For i:=0 to a-1 do
          For j:=0 to b-1 do
          tab[i,j]:=Random-0.5;
        end;
                  //wczytywanie wag z pliku
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

              //wpisywanie do pliku:
procedure pisz(a,b:Integer;var tab: Tablica;var plik: Text);

          var i,j: Integer;

              begin
              For i:=0 to a-1 do
                   begin
                   For j:=0 to b-1 do
                       Write(plik,tab[i,j]:5:10,' ');
                   Writeln(plik);
                   end;
              end;
              //4 warstwy ukryte
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
                    //zmiana wag
procedure zmiana(a,b: Integer;var tab1,tab2:Tablica;var ukr,wek: Wektor);

          var i,j:Integer;

              begin
              For j:=0 to b-1 do
                  For i:=0 to a-1 do
                  begin
                       tab1[i,j]:=tab1[i,j]+q*wek[j]*ukr[i]+tab2[i,j]*s;
                       tab2[i,j]:=q*wek[j]*ukr[i];
                  end;
              end;
                     //liczenie bledu w warstwie ukrytej
procedure  bladwst(a,b:Integer;var tab:Tablica;var ukr,wek1,wek2:Wektor);

           var i,j:Integer;

           begin
           SetLength(wek1,a);
           For i:=0 to a-1 do
           begin
                wek1[i]:=0;
                For j:=0 to b-1 do
                begin
                     wek1[i]:=wek1[i]+tab[i,j]*wek2[j];
                     wek1[i]:=wek1[i]*beta*(1-ukr[i])*ukr[i];
                end;
           end;
           end;


begin

  Assign(bledy,'bledy.txt');
  Rewrite(bledy);
  //zerowanie wag do momentum:

  zeruj(lin,n1,wagip1);
  zeruj(n1,n2,wagip2);
  zeruj(n2,n3,wagip3);
  zeruj(n3,lout,wagip4);

  //bledy:

  For i:=0 to lw-1 do
  bladw[i]:=100;

  //Ustalanie wag:
  Writeln('l - losowanie wag, inna literka, wpisywanie z pliku wagi1.txt');
  Readln(ch);
  If ch='l' then
  begin
  losuj(lin,n1,wagi1);
  losuj(n1,n2,wagi2);
  losuj(n2,n3,wagi3);
  losuj(n3,lout,wagi4);
  end
  else
  begin
  Assign(wagiout,'wagi1.txt');
  Reset(wagiout);
  wczytuj(lin,n1,wagi1,wagiout);
  wczytuj(n1,n2,wagi2,wagiout);
  wczytuj(n2,n3,wagi3,wagiout);
  wczytuj(n3,lout,wagi4,wagiout);
  Close(wagiout);
  end;

  // ustalanie wektora super (input+output):

  Assign(input1, 'input.txt');
  Reset(input1);
  Assign(output1,'output.txt');
  Reset(output1);

  For k:=0 to lw-1 do
  begin
  For i:=0 to lin-1 do
  begin
  Read(input1,input[i]);
  super[k,i]:=input[i];
  end;
  Readln(input1);

  For i:=0 to lout-1 do
  begin
  Read(output1,output[i]);
  super[k,i+lin]:=output[i];
  end;
  Readln(output1);
  end;

  Close(input1);
  Close(output1);

  Writeln('t - liczenie bledu, inna literka, zakończenie programu');
  Readln(ch);

  //funkcja while

  while ch='t' do
  begin
  For m:=1 to f do
  begin


  //ilosc wektorow wejsciowych i wyjsciowych:

  For k:=0 to lw-1 do
  begin

  For i:=0 to lin-1 do
  input[i]:=super[k,i];

  For i:=0 to lout-1 do
  output[i]:=super[k,i+lin];

  SetLength(ukryty0,lin);
  For i:=0 to lin-1 do
  ukryty0[i]:=input[i];

  //4 warstwy ukryte

  neuron(lin,n1,wagi1,ukryty0,ukryty1);
  neuron(n1,n2,wagi2,ukryty1,ukryty2);
  neuron(n2,n3,wagi3,ukryty2,ukryty3);
  neuron(n3,lout,wagi4,ukryty3,ukryty4);

  //blad:

  blad:=0;

  //petla przyspieszajaca proces:

  while blad<bladw[k] do
  begin
       blad:=0;
       For i:=0 to lout-1 do
       blad:=blad+power(abs(output[i]-ukryty4[i]),2);
       bladw[k]:=blad;

  //propagacja wsteczna:

  //bledy na wyjsciu:

  SetLength(wekbl4,lout);

  For i:=0 to lout-1 do
  begin
  wekbl4[i]:=0;
  wekbl4[i]:=output[i]-ukryty4[i];
  wekbl4[i]:=wekbl4[i]*beta*(1-ukryty4[i])*ukryty4[i];
  end;

  // zmiana wag:

  zmiana(n3,lout,wagi4,wagip4,ukryty3,wekbl4);
  bladwst(n3,lout,wagi4,ukryty3,wekbl3,wekbl4);
  zmiana(n2,n3,wagi3,wagip3,ukryty2,wekbl3);
  bladwst(n2,n3,wagi3,ukryty2,wekbl2,wekbl3);
  zmiana(n1,n2,wagi2,wagip2,ukryty1,wekbl2);
  bladwst(n1,n2,wagi2,ukryty1,wekbl1,wekbl2);
  zmiana(lin,n1,wagi1,wagip1,ukryty0,wekbl1);

 end;   //koniec pierwszego while

  blad:=0;
  For i:=1 to lw do
  blad:=blad+bladw[i];

  blad:=blad/lw;
  Writeln(blad:3:7);
  end; //koniec pierwszego for




   //  koniec drugiego for

  //Wypisanie bledu do pliku
  Write(bledy,blad:3:7,', ');

  end;
  Writeln('t - liczenie bledu, inna literka, zakończenie programu');
  Readln(ch);
  end;     //koniec while

  //wypisanie wag do pliku:

  Assign(wagi, 'wagi.txt');
  Rewrite(wagi);

  pisz(lin,n1,wagi1,wagi);
  pisz(n1,n2,wagi2,wagi);
  pisz(n2,n3,wagi3,wagi);
  pisz(n3,lout,wagi4,wagi);

  Close(wagi);
  Close(bledy);

end.


