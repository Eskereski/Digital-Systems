
-- VHDL Instantiation Created from source file Controle.vhd -- 03:04:04 03/03/2023
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

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
		WR : OUT std_logic;
		RD : OUT std_logic
		);
	END COMPONENT;

	Inst_Controle: Controle PORT MAP(
		CLK => ,
		RESET => ,
		regN => ,
		regZ => ,
		regV => ,
		regC => ,
		regB => ,
		regriDECOD => ,
		cargaN => ,
		cargaZ => ,
		cargaV => ,
		cargaC => ,
		cargaB => ,
		cargaPC => ,
		incPC => ,
		cargaAC => ,
		cargaREM => ,
		cargaRDM => ,
		selMUXREM => ,
		selMUXRDM => ,
		selULA => ,
		cargaRI => ,
		WR => ,
		RD => 
	);


