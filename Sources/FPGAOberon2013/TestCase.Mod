MODULE TestCase;
  IMPORT Texts, Oberon;

  TYPE R = RECORD a: INTEGER END ;
    R0 = RECORD (R) b: INTEGER END ;
    R1 = RECORD (R) b: REAL END ;
    R2 = RECORD (R) b: SET END ;
    R3 = RECORD (R2) c: SET END ;
    P = POINTER TO R;
    P0 = POINTER TO R0;
    P1 = POINTER TO R1;
    P2 = POINTER TO R2;
    P3 = POINTER TO R3;

  VAR W: Texts.Writer;
    p, q: P; p0: P0; p1: P1; p2: P2; p3: P3;

  PROCEDURE CaseNum*;
    VAR S: Texts.Scanner; i, j: INTEGER;
  BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
    IF S.class = Texts.Int THEN i := S.i; j := 9;
      CASE i OF
         2..5  : j := 11                    (*lower case label limit = 2*)
        |8 .. 10 : j := 22
        |13 .. 15: j := 33
        |28 .. 30, 18 .. 22: j := 44
        |33 .. 36, 24: j := 55              (*higher case label limit = 36*)
      (*ELSE j := 66*)
      END  ;
      Texts.WriteInt(W, j, 4)
    ELSE Texts.WriteString(W, " usage: TestCase.CaseNum number")
    END ;
    Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
  END CaseNum;

  PROCEDURE CaseChar*;
    VAR S: Texts.Scanner; ch: CHAR; j: INTEGER;
  BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
    IF (S.class = Texts.Name) OR (S.class = Texts.String) THEN ch := S.s[0]; j := 0;
      CASE ch OF
        "D" .. "F" : j := 22                (*lower case label limit = ORD("D") = 68*)
        |"J" .. "M" : j := 33
        |"f" .. "h", "b" .. "c" : j := 44
        |"r" .. "u", "e", "m"   : j := 55   (*higher case label limit = ORD("u") = 117*)
      (*ELSE j := 66*)
      END  ;
      Texts.WriteInt(W, j, 4)
    ELSE Texts.WriteString(W, " usage: TestCase.CaseChar char")
    END ;
    Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
  END CaseChar;

  PROCEDURE CaseType*;
    VAR S: Texts.Scanner; i, j: INTEGER;
  BEGIN Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
    IF S.class = Texts.Int THEN i := S.i; j := 0; p := q;
      IF i = 0 THEN p := p0
      ELSIF i = 1 THEN p := p1
      ELSIF i = 2 THEN p := p2
      ELSIF i = 3 THEN p := p3
      END ;
      CASE p OF
         P0: j := 22
       | P1: j := 33
       | P3: j := 55  (*P3 is an extension of P2, not P -> test P3 first*)
       | P2: j := 44
       (*ELSE j := 66*)
      END ;
      Texts.WriteInt(W, j, 4)
    ELSE Texts.WriteString(W, " usage: TestCase.CaseType extension (-1 = no extension)")
    END ;
    Texts.WriteLn(W); Texts.Append(Oberon.Log, W.buf)
  END CaseType;

BEGIN Texts.OpenWriter(W); NEW(p); NEW(q); NEW(p0); NEW(p1); NEW(p2); NEW(p3)
END TestCase.

ORP.Compile TestCase.Mod/s ~
System.Free TestCase ~

ORTool.DecObj TestCase.rsc ~

----------------- num ---------------

TestCase.CaseNum 0     TestCase.CaseNum 1       # outside the case label ranges  --> TRAP  (or 66 if the ELSE clause is uncommented)
TestCase.CaseNum 2     TestCase.CaseNum 5       # range 2..5    -->  11
TestCase.CaseNum  8    TestCase.CaseNum 10      # range  8..10  -->  22
TestCase.CaseNum 13    TestCase.CaseNum 15      # range 13..15  -->  33
TestCase.CaseNum 18    TestCase.CaseNum 22      # range 18..22  -->  44
TestCase.CaseNum 33    TestCase.CaseNum 36      # range 33..36  -->  55

TestCase.CaseNum 11    TestCase.CaseNum 17      # outside the case label ranges  --> TRAP  (or 66 if the ELSE clause is uncommented)
TestCase.CaseNum 23    TestCase.CaseNum 32      # outside the case label ranges  --> TRAP  (or 66 if the ELSE clause is uncommented)
TestCase.CaseNum 99    TestCase.CaseNum 255     # outside the case label ranges  --> TRAP  (or 66 if the ELSE clause is uncommented)

TestCase.CaseNum -99   TestCase.CaseNum -1      # outside the case label ranges  --> TRAP  (or 66 if the ELSE clause is uncommented)
TestCase.CaseNum 256   TestCase.CaseNum 1000    # outside the case label ranges  --> TRAP  (or 66 if the ELSE clause is uncommented)

----------------- char ---------------

TestCase.CaseChar A    TestCase.CaseChar C      # outside the case label ranges  --> TRAP  (or 66 if the ELSE clause is uncommented)
TestCase.CaseChar D    TestCase.CaseChar F      # range D..F  -->  22
TestCase.CaseChar J    TestCase.CaseChar M      # range J..M  -->  33
TestCase.CaseChar f    TestCase.CaseChar h      # range f..h  -->  44
TestCase.CaseChar b    TestCase.CaseChar c      # range b..c  -->  44
TestCase.CaseChar r    TestCase.CaseChar u      # range r..u  -->  55
TestCase.CaseChar e    TestCase.CaseChar m      # range e, x  -->  55

TestCase.CaseChar H    TestCase.CaseChar Y      # outside the case label ranges  --> TRAP  (or 66 if the ELSE clause is uncommented)
TestCase.CaseChar "["  TestCase.CaseChar "^"    # outside the case label ranges  --> TRAP  (or 66 if the ELSE clause is uncommented)
TestCase.CaseChar a    TestCase.CaseChar p      # outside the case label ranges  --> TRAP  (or 66 if the ELSE clause is uncommented)
TestCase.CaseChar v    TestCase.CaseChar z      # outside the case label ranges  --> TRAP  (or 66 if the ELSE clause is uncommented)

----------------- type ---------------

TestCase.CaseType -1       # no extension  -->   0  (or 66 if the ELSE clause is uncommented)
TestCase.CaseType  0       # P0            -->  22
TestCase.CaseType  1       # P1            -->  33
TestCase.CaseType  2       # P2            -->  44
TestCase.CaseType  3       # P3            -->  55
TestCase.CaseType  4       # no extension  -->   0  (or 66 if the ELSE clause is uncommented)
