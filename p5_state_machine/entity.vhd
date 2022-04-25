library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Moore is
    Port (Takt, Sisend, Resett, Sisend2: in STD_LOGIC;
         V2ljund, V2ljund2 : out STD_LOGIC);
end Moore;
architecture Moore_arhit of Moore is
    TYPE Staatus IS (A, B, C);
    SIGNAL s : Staatus;
    
    TYPE Staatus2 IS (X, Y);
    SIGNAL z : Staatus2;
    
begin

    Moore:process(Resett, Takt)
    begin
        if Resett = '0' Then s <= A;
        ElsIf (rising_edge(Takt)) Then
            Case s IS
                When A =>
                    If Sisend = '0'
 THEN s <= A;
                    Else s <= B;
                    End If;
                When B =>
                    If Sisend = '0'
 THEN s <= A;
                    Else s <= C;
                    End If;
                When C =>
                    If Sisend = '0'
 THEN s <= A;
                    Else s <= C;
                    End If;
            End Case;
        End If;
    End process Moore;

    V2ljund <= '1' When s = C Else '0';

    Mealy:process(Resett, Takt)
    begin
        If Resett = '0' Then
            z <= X;
        ElsIf (rising_edge(Takt)) Then
            Case z IS
                When X =>
                    If Sisend2 = '0'
                        Then z <= X;
                    Else z <= Y;
                    End If;
                When Y =>
                    If Sisend2 = '0'
                        Then z <= X;
                    Else z <= Y;
                    End If;
            End Case;
        End If;
    End Process Mealy;
    
    Mealy2:process(z, Sisend2)
    Begin
        Case z IS
            When X =>
                V2ljund2 <= '0';
            When Y =>
                V2ljund2 <= Sisend2;
        End Case;
    End Process Mealy2;

end Moore_arhit;
