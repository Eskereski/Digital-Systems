library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
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

    type estados is (T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, skip0, skip1, skip2, HALT);
    signal estado : estados;
	signal proxestado : estados;

begin

    process(clk, RESET)                                         --Atualiza estado
        begin
            if(RESET = '1') then
                estado <= T0;
            elsif(rising_edge(clk)) then
                estado <= proxestado;
            end if;
    end process;

    process(estado, regriDECOD, regN, regZ, regV, regC, regB)   --Controle
        begin

				cargaAC <= '0';            
                cargaN <= '0'; 
                cargaZ <= '0'; 
                cargaV <= '0'; 
                cargaC <= '0'; 
                cargaB <= '0'; 
                cargaREM <= '0';
                cargaRDM <= '0';
                cargaRI <= '0'; 
                
                WR <= "0";

                cargaPC <= '0'; 
                incPC <= '0'; 

                selMUXREM <= '0'; 
                selMUXRDM <= '0'; 
                selULA <= "0000";  -- NOP

                case estado is
                    when T0 =>          --Indica o dado a ser lido da memoria(PC)
                        selMUXREM <= '0'; 
                        cargaREM <= '1';
						proxestado <= skip0;

                    when skip0 =>       --Ganha um clock para sincronizar os dados lidos
                        proxestado <= T1;

                    when T1 =>          --Atualiza a saida da memoria
						selmuxRDM <= '0';
                        cargaRDM <= '1';
						proxestado <= t2;

                    when T2 =>          --Aponta para o próximo dado da memória
                        incPC <= '1';
                        proxestado <= T3;
						
                    when T3 =>          --Atualiza a instrução atual
                        cargaRI <= '1';
						proxestado <= T4;
						
                    when T4 =>      
                        if(regriDECOD(0) = '1') then                            --NOP
                            proxestado <= T0;
                        elsif(regriDECOD(6) = '1') then                         --NOT
                            selULA <= "0100";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            proxestado <= T0;		
                        elsif(
                                (regriDECOD(9) = '1' and regN = '0')    or  --N Jumps condicionais falhados
                                (regriDECOD(10) = '1' and regN = '1')   or  --P 
                                (regriDECOD(11) = '1' and regV = '0')   or  --V 
                                (regriDECOD(12) = '1' and regV = '1')   or  --NV
                                (regriDECOD(13) = '1' and regZ = '0')   or  --Z
                                (regriDECOD(14) = '1' and regZ = '1')   or  --NZ
                                (regriDECOD(15) = '1' and regC = '0')   or  --C
                                (regriDECOD(16) = '1' and regC = '1')   or  --NC
                                (regriDECOD(17) = '1' and regB = '0')   or  --B 
                                (regriDECOD(18) = '1' and regB = '1'))  then--NB
                            incPC <= '1';
                            proxestado <= T0;
                        elsif(regriDECOD(19) = '1') then                        --SHR
                            selULA <= "0110";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            cargaC <= '1';
                            proxestado <= T0;
                        elsif(regriDECOD(20) = '1') then                        --SHL
                            selULA <= "0111";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            cargaC <= '1';
                            proxestado <= T0;
                        elsif(regriDECOD(21) = '1') then                        --ROR
                            selULA <= "1000";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            cargaC <= '1';
                            proxestado <= T0;
                        elsif(regriDECOD(22) = '1') then                        --ROL
                            selULA <= "1001";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            cargaC <= '1';
                            proxestado <= T0;
                        elsif(regriDECOD(23) = '1') then                        --HLT
                            proxestado <= HALT;
                        else
                            cargaREM <= '1';
                            selMUXREM <= '0';
                            proxestado <= skip1;
                        end if;
                    
                    when skip1 =>       --Ganha um clock para sincronizar os dados lidos
                        proxestado <= T5;

                    when T5 =>          --Atualiza a saida da memoria
                        selmuxRDM <= '0';
                        cargaRDM <= '1';
                        proxestado <= T6;
                        
                    when T6 =>          --Aponta para o próximo dado da memória
                        incPC <= '1';
                        proxestado <= T7;

                    when T7 =>
                        if( (regriDECOD(1) = '1') or        --STA
                            (regriDECOD(2) = '1') or        --LDA
                            (regriDECOD(3) = '1') or        --ADD
                            (regriDECOD(4) = '1') or        --OR
                            (regriDECOD(5) = '1') or        --AND
                            (regriDECOD(7) = '1') ) then    --SUB
							selMUXREM <= '1';
							cargaREM <= '1';
							proxestado <= skip2;
                        else
                            cargaPC <= '1';
                            proxestado <= T0;
                        end if;
                    
                    when skip2 =>       --Ganha um clock para sincronizar os dados lidos
                        proxestado <= T8;

                    when T8 =>
                        if(regriDECOD(1) = '1') then        --STA
                            selMUXRDM <= '1';
                            cargaRDM <= '1';
                            proxestado <= T9;
                        else
                            selMUXRDM <= '0';
                            cargaRDM <= '1';
                            proxestado <= T9;
                        end if;

                    when T9 =>
                        if(regriDECOD(1) = '1') then        --STA
                            WR <= "1";
                            proxestado <= T0;
                        elsif(regriDECOD(2) = '1') then     --LDA
                            selULA <= "0000";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            proxestado <= T0;
                        elsif(regriDECOD(3) = '1') then     --ADD
                            selULA <= "0001";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            cargaV <= '1';
                            cargaC <= '1';
                            proxestado <= T0;
                        elsif(regriDECOD(4) = '1') then     --OR
                            selULA <= "0010";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            proxestado <= T0;
                        elsif(regriDECOD(5) = '1') then     --AND
                            selULA <= "0011";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            proxestado <= T0;
                        elsif(regriDECOD(7) = '1') then     --SUB
                            selULA <= "0101";
                            cargaAC <= '1';
                            cargaN <= '1';
                            cargaZ <= '1';
                            cargaV <= '1';
                            cargaB <= '1';
                            proxestado <= T0;
                        else
                            proxestado <= HALT;
                        end if;

                    when HALT =>
                            proxestado <= HALT;
                    when others => proxestado <= HALT;
                end case;   
    end process;         

end Behavioral;