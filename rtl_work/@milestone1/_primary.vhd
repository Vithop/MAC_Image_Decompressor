library verilog;
use verilog.vl_types.all;
entity Milestone1 is
    generic(
        intit_Y_address : vl_logic_vector(0 to 17) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        intit_U_address : vl_logic_vector(0 to 17) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        intit_V_address : vl_logic_vector(0 to 17) := (Hi0, Hi0, Hi1, Hi1, Hi1, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        init_RGB_address: integer := 146944
    );
    port(
        Clock           : in     vl_logic;
        Resetn          : in     vl_logic;
        Enable          : in     vl_logic;
        SRAM_address    : out    vl_logic_vector(17 downto 0);
        SRAM_read_data  : in     vl_logic_vector(15 downto 0);
        SRAM_write_data : out    vl_logic_vector(15 downto 0);
        SRAM_we_n       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of intit_Y_address : constant is 1;
    attribute mti_svvh_generic_type of intit_U_address : constant is 1;
    attribute mti_svvh_generic_type of intit_V_address : constant is 1;
    attribute mti_svvh_generic_type of init_RGB_address : constant is 1;
end Milestone1;
