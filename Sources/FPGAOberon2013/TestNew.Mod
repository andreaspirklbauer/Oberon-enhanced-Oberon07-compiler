MODULE TestNew;
  IMPORT SYSTEM, Out;

  TYPE PtrArr = POINTER TO Arr;
    Arr = ARRAY OF BYTE;

    PtrRec = POINTER TO Rec;
    Rec = RECORD i, j, k: INTEGER;
      ptrarr: PtrArr
    END ;
    RecArr = ARRAY 100 OF Rec;
    PtrRecArr = POINTER TO RecArr;

  VAR ptr0: PtrRec; ptr1: PtrRecArr; i, len: INTEGER;

  PROCEDURE Write0*;
  BEGIN NEW(ptr0); NEW(ptr0.ptrarr, 100); INC(i);
    ptr0.ptrarr[11] := i; Out.Str("Wrote "); Out.Int(i, 3); Out.Ln
  END Write0;

  PROCEDURE Read0*;
  BEGIN Out.Str("Read"); Out.Int(ptr0.ptrarr[11], 6); Out.Ln
  END Read0;

  PROCEDURE Clear0*;
  BEGIN ptr0 := NIL; Out.Str("ptr0 set to NIL"); Out.Ln
  END Clear0;

  PROCEDURE Write1*;
  BEGIN NEW(ptr1); INC(i);
    ptr1[22].j := i; Out.Str("Wrote "); Out.Int(i, 3); Out.Ln
  END Write1;

  PROCEDURE Read1*;
  BEGIN Out.Str("Read"); Out.Int(ptr1[22].j, 6); Out.Ln
  END Read1;

  PROCEDURE Clear1*;
  BEGIN ptr1 := NIL; Out.Str("ptr1 set to NIL"); Out.Ln
  END Clear1;

  PROCEDURE WriteAndRead0*;
    VAR a0: INTEGER; b: BYTE;
  BEGIN INC(i);
    NEW(ptr0); NEW(ptr0.ptrarr, 100); ptr0.ptrarr[33] := i;
    a0 := SYSTEM.ADR(ptr0.ptrarr^[33]); SYSTEM.GET(a0, b);
    Out.Str("Read"); Out.Int(b, 6); Out.Ln
  END WriteAndRead0;

  PROCEDURE WriteAndRead1*;
  BEGIN DEC(len); Out.Str("len ="); Out.Int(len, 6); Out.Ln;
    (*NEW(ptr0); NEW(ptr0.ptrarr, 0); NEW(ptr0.ptrarr, -10)*)  (*would lead to compile time error*)
    NEW(ptr0); NEW(ptr0.ptrarr, len);  (*runtime trap when n reaches 0 (len must be > 0)*)
    INC(i); ptr0.ptrarr[0] := i; Out.Str("Read"); Out.Int(ptr0.ptrarr[0], 3); Out.Ln
  END WriteAndRead1;

BEGIN i := 0; len := 3
END TestNew.

ORP.Compile TestNew.Mod/s ~
System.Free TestNew ~

TestNew.Write0
TestNew.Read0
TestNew.Clear0    # after this, Read0 generates a trap (have to call Write0 again)

TestNew.Write1
TestNew.Read1
TestNew.Clear1    # after this, Read1 generates a trap (have to call Write1 again)

TestNew.WriteAndRead0
TestNew.WriteAndRead1



