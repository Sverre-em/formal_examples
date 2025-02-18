

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vld_rdy is
  port (
    clk : in std_logic;
    rst : in std_logic;
    vld : out std_logic;
    rdy : in std_logic;
    data : out std_logic_vector(7 downto 0)
  );
end entity vld_rdy;

architecture rtl of vld_rdy is
begin

  process(clk)
    variable count : unsigned(7 downto 0) := (others => '0');
  begin
    if rising_edge(clk) then
      if rdy = '1' then
        vld <= '0';
        data <=  std_logic_vector(count + 1);
      else
        vld <= '1';
        -- data <=  std_logic_vector(count + 1); -- BUG
      end if;

      if rst = '1' then
        vld <= '0';
        count := (others => '0');
      end if;

    end if;
  end process;

end architecture rtl;