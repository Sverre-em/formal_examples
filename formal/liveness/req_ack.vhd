library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;

entity req_ack is
    port (
        clk   : in std_logic;
        req   : in std_logic;
        ack   : out std_logic
    );
end entity;

architecture rtl of req_ack is
    signal ack_reg : std_logic := '0';
    signal counter : integer range 0 to 5 := 0;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if req = '1' then
                counter <= counter + 1;
                if counter = 5 then
                    ack_reg <= '1';
                end if;
            else
                counter <= 0;
                ack_reg <= '0';
            end if;
        end if;
    end process;

    ack <= ack_reg;


end architecture;
