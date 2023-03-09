library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Controle is
    Port (  CLK : in  STD_LOGIC;
            RESET : in  STD_LOGIC;
            regN : in  STD_LOGIC;
            regZ : in  STD_LOGIC;
            regV : in  STD_LOGIC;
            regC : in  STD_LOGIC;
            regB : in  STD_LOGIC;

            regriDECOD : in STD_LOGIC_VECTOR(23 downto 0);

            cargaN : out  STD_LOGIC;
            cargaZ : out  STD_LOGIC;
            cargaV : out  STD_LOGIC;
            cargaC : out  STD_LOGIC;
            cargaB : out  STD_LOGIC;

            cargaPC : out STD_LOGIC;
            incPC : out STD_LOGIC; 
				
			cargaAC : out STD_LOGIC;
            cargaREM : out STD_LOGIC;
            cargaRDM : out STD_LOGIC;
            selMUXREM : out STD_LOGIC;
            selMUXRDM : out STD_LOGIC;

            selULA : out STD_LOGIC_VECTOR(3 downto 0);

            cargaRI : out STD_LOGIC;

            WR : out STD_LOGIC_VECTOR(0 downto 0)
		   );
end Controle;

architecture Behavioral of Controle is

    type estados is (t0, t1, t2, t3, t4, t5, t6, t7, HALT);
    signal estado : estados := t0;
	signal proxestado : estados := t0;

begin

    process(clk, RESET) --Atualiza proxestado
        begin
            if(RESET = '1') then
                estado <= t0;
            elsif(rising_edge(clk)) then
                estado <= proxestado;
            end if;
    end process;

    process(clk, RESET) --Controle
        begin
            if(RESET= '1') then
				proxestado <= t0;
                cargaN <= '0'; 
                cargaZ <= '0'; 
                cargaV <= '0'; 
                cargaC <= '0'; 
                cargaB <= '0'; 
                cargaPC <= '0';  
                incPC <= '0'; 
                cargaREM <= '0';
                cargaRDM <= '0';
                selMUXREM <= '0'; 
                selMUXRDM <= '0'; 
                selULA <= "1111"; 
                cargaRI <= '0'; 
                WR <= "0";
            elsif(rising_edge(clk)) then
                case estado is
                    when t0 =>
                        selMUXREM <= '0';  --Acho q eh o rem mas n tenho ctz
                        cargaREM <= '1';
						proxestado <= t1;

                    when t1 =>
                        WR <= "0";  --Não sei oq eh pra ser "read"
                        incPC <= '1';
						proxestado <= t2;
						
                    when t2 =>
                        cargaRI <= '1';
						proxestado <= t3;
						
                    when t3 =>
                        if(regriDECOD(6) = '1') then        --NOT
                            selULA <= "0100";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            proxestado <= t0;		
                        elsif(  (regriDECOD(9) = '1' and regN = '0')   or       --JN 
                                (regriDECOD(10) = '1' and regN = '1')  or       --JP 
                                (regriDECOD(11) = '1' and regV = '0')  or       --JV 
                                (regriDECOD(12) = '1' and regV = '1')  or       --JNV
                                (regriDECOD(13) = '1' and regZ = '0')  or       --JZ
                                (regriDECOD(14) = '1' and regZ = '1')  or       --JNZ
                                (regriDECOD(15) = '1' and regC = '0')  or       --JC
                                (regriDECOD(16) = '1' and regC = '1')  or       --JNC
                                (regriDECOD(17) = '1' and regB = '0')  or       --JB 
                                (regriDECOD(18) = '1' and regB = '1')) then     --JNB
                            incPC <= '1';
                            proxestado <= t0;
                        elsif(regriDECOD(0) = '1') then                         --NOP
                            proxestado <= t0;
                        elsif(regriDECOD(23) = '1') then
                            proxestado <= HALT;                                 --HLT
                        else
                            selMUXREM <= '0';
                            cargaREM <= '1';
                            proxestado <= t4;
                        end if;

                    when t4 =>
                        if( (regriDECOD(1) = '1') or                --STA             
                            (regriDECOD(2) = '1') or                --LDA
                            (regriDECOD(3) = '1') or                --ADD
                            (regriDECOD(4) = '1') or                --OR
                            (regriDECOD(5) = '1')) then             --AND
                            WR <= "0";   --Não sei oq eh pra ser "read"
                            incPC <= '1';
                            proxestado <= t5;
                        else
                            WR <= "0";	 --Não sei oq eh pra ser "read"
                            proxestado <= t5;
                        end if;
                        
                    when t5 =>
                        if( (regriDECOD(1) = '1') or        --STA
                            (regriDECOD(2) = '1') or        --LDA
                            (regriDECOD(3) = '1') or        --ADD
                            (regriDECOD(4) = '1') or        --OR
                            (regriDECOD(5) = '1') or        --AND
                            (regriDECOD(7) = '1') or        --SUB
                            (regriDECOD(19) = '1') or       --SHR
                            (regriDECOD(20) = '1') or       --SHL
                            (regriDECOD(21) = '1') or       --ROR
                            (regriDECOD(22) = '1')) then    --ROL
							selMUXREM <= '1';
							cargaREM <= '1';
							proxestado <= t6;
                        else
                            cargaPC <= '1';
                            proxestado <= t0;
                        end if;

                    when t6 =>
                        if(regriDECOD(1) = '1') then    --STA
                            cargaRDM <= '1';
                            proxestado <= t7;
                        else
                            WR <= "0";   --Não sei oq eh pra ser "read"
                            proxestado <= t7;
                        end if;

                    when t7 =>
                        if(regriDECOD(1) = '1') then        --STA
                            WR <= "1";  --Não sei oq eh pra ser "Write"
                            proxestado <= t0;
                        elsif(regriDECOD(2) = '1') then     --LDA
                            selULA <= "0000";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            proxestado <= t0;
                        elsif(regriDECOD(3) = '1') then     --ADD
                            selULA <= "0001";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            cargaV <= '1';
                            cargaC <= '1';
                            proxestado <= t0;
                        elsif(regriDECOD(4) = '1') then     --OR
                            selULA <= "0010";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            proxestado <= t0;
                        elsif(regriDECOD(5) = '1') then     --AND
                            selULA <= "0011";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            proxestado <= t0;
                        elsif(regriDECOD(7) = '1') then     --SUB
                            selULA <= "0101";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            cargaV <= '1';
                            cargaB <= '1';
                            proxestado <= t0;
                        elsif(regriDECOD(19) = '1') then    --SHR
                            selULA <= "0110";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            cargaC <= '1';
                            proxestado <= t0;
                        elsif(regriDECOD(20) = '1') then    --SHL
                            selULA <= "0111";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            cargaC <= '1';
                            proxestado <= t0;
                        elsif(regriDECOD(21) = '1') then    --ROR
                            selULA <= "1000";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            cargaC <= '1';
                            proxestado <= t0;
                        elsif(regriDECOD(19) = '1') then    --ROL
                            selULA <= "1001";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            cargaC <= '1';
                            proxestado <= t0;
                        else
                            proxestado <= HALT;
                        end if;


                    when HALT =>
                            proxestado <= HALT;
                    when others => proxestado <= HALT;
                end case;
            end if;  
                
    end process;         

end Behavioral;

