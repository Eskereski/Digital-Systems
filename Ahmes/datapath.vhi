
-- VHDL Instantiation Created from source file datapath.vhd -- 23:59:23 03/15/2023
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT datapath
	PORT(
		CLK : IN std_logic;
		RESET : IN std_logic;
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
		WR : IN std_logic_vector(0 to 0);          
		regN : OUT std_logic;
		regZ : OUT std_logic;
		regV : OUT std_logic;
		regC : OUT std_logic;
		regB : OUT std_logic;
		regriDECOD : OUT std_logic_vector(23 downto 0);
		memOUT : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_datapath: datapath PORT MAP(
		CLK => ,
		RESET => ,
		incPC => ,
		cargaPC => ,
		cargaREM => ,
		cargaAC => ,
		cargaRI => ,
		cargaRDM => ,
		cargaN => ,
		cargaZ => ,
		cargaV => ,
		cargaC => ,
		cargaB => ,
		selULA => ,
		selMUXREM => ,
		selMUXRDM => ,
		WR => ,
		regN => ,
		regZ => ,
		regV => ,
		regC => ,
		regB => ,
		regriDECOD => ,
		memOUT => 
	);


