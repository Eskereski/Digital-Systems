library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
		   mainOUT : out STD_LOGIC_VECTOR(7 downto 0)
	);
end main;

architecture Behavioral of main is
	COMPONENT Controle
	PORT(
		CLK : IN std_logic;
		RESET : IN std_logic;
		regN : IN std_logic;
		regZ : IN std_logic;
		regV : IN std_logic;
		regC : IN std_logic;
		regB : IN std_logic;
		regriDECOD : IN std_logic_vector(23 downto 0); 
		cargaN : OUT std_logic;
		cargaZ : OUT std_logic;
		cargaV : OUT std_logic;
		cargaC : OUT std_logic;
		cargaB : OUT std_logic;
		cargaPC : OUT std_logic;
		incPC : OUT std_logic;
		cargaAC : OUT std_logic;
		cargaREM : OUT std_logic;
		cargaRDM : OUT std_logic;
		selMUXREM : OUT std_logic;
		selMUXRDM : OUT std_logic;
		selULA : OUT std_logic_vector(3 downto 0);
		cargaRI : OUT std_logic;
		WR : OUT std_logic_vector(0 downto 0)
		);
	END COMPONENT;
	
	COMPONENT datapath
	PORT(
		CLK : IN std_logic;
		RESET : IN std_logic;
		memOUT : OUT std_logic_vector(7 downto 0);
		incPC : IN std_logic;
		cargaPC : IN std_logic;
		cargaREM : IN std_logic;
		cargaAC : IN std_logic;
		cargaRI : IN std_logic;
		cargaRDM : IN std_logic;
		cargaN : IN std_logic;
		cargaZ : IN std_logic;
		cargaV : IN std_logic;
		cargaC : IN std_logic;
		cargaB : IN std_logic;
		selULA : IN std_logic_vector(3 downto 0);
		selMUXREM : IN std_logic;
		selMUXRDM : IN std_logic;
		WR : IN std_logic_vector(0 downto 0);         
		regN : OUT std_logic;
		regZ : OUT std_logic;
		regV : OUT std_logic;
		regC : OUT std_logic;
		regB : OUT std_logic;
		regriDECOD : OUT std_logic_vector(23 downto 0)
		);
	END COMPONENT;
	-----------------------------------------------------
	--                     Signals                     --
	-----------------------------------------------------
	signal memOUT : STD_LOGIC_VECTOR(7 downto 0);
	signal incPC : STD_LOGIC;
	signal cargaPC : STD_LOGIC;
	signal cargaREM : STD_LOGIC;
	signal cargaAC : STD_LOGIC;
	signal cargaRI : STD_LOGIC;
	signal cargaRDM : STD_LOGIC;
	signal cargaN : STD_LOGIC;
	signal cargaZ : STD_LOGIC;
	signal cargaV : STD_LOGIC;
	signal cargaC : STD_LOGIC;
	signal cargaB : STD_LOGIC;
	signal selULA : STD_LOGIC_VECTOR(3 downto 0);
	signal selMUXREM : STD_LOGIC;
	signal selMUXRDM : STD_LOGIC;
	signal WR : STD_LOGIC_VECTOR(0 to 0);
	signal regN : STD_LOGIC;
	signal regZ : STD_LOGIC;
	signal regV : STD_LOGIC;
	signal regC : STD_LOGIC;
	signal regB : STD_LOGIC;
	signal regriDECOD : STD_LOGIC_VECTOR(23 downto 0);

begin
		
	mainOUT<= memOUT;

	PO: datapath PORT MAP(		-- Datapath
		CLK => CLK,
		RESET => RESET,
		memOUT => memOUT,
		incPC => incPC,
		cargaPC => cargaPC,
		cargaREM => cargaREM,
		cargaAC => cargaAC,
		cargaRI => cargaRI,
		cargaRDM => cargaRDM,
		cargaN => cargaN,
		cargaZ => cargaZ,
		cargaV => cargaV,
		cargaC => cargaC,
		cargaB => cargaB,
		selULA => selULA,
		selMUXREM => selMUXREM,
		selMUXRDM => selMUXRDM,
		WR => WR,
		regN => regN,
		regZ => regZ,
		regV => regV,
		regC => regC,
		regB => regB,
		regriDECOD => regriDECOD
	);
	
	PC: Controle PORT MAP(		--Controle
		CLK => CLK,
		RESET => RESET,
		regN => regN,
		regZ => regZ,
		regV => regV,
		regC => regC,
		regB => regB,
		regriDECOD => regriDECOD,
		cargaN => cargaN,
		cargaZ => cargaZ,
		cargaV => cargaV,
		cargaC => cargaC,
		cargaB => cargaB,
		cargaPC => cargaPC,
		incPC => incPC,
		cargaAC => cargaAC,
		cargaREM => cargaREM,
		cargaRDM => cargaRDM,
		selMUXREM => selMUXREM,
		selMUXRDM => selMUXRDM,
		selULA =>selULA,
		cargaRI => cargaRI,
		WR => WR
		);


end Behavioral;

