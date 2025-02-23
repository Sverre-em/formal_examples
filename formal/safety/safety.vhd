
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity safety is
  port (
    clk : in std_logic;
    rst : in std_logic;
    bug_signal : in std_logic;
    data : out std_logic_vector(7 downto 0)
  );
end entity safety;

architecture rtl of safety is

    signal count : unsigned(7 downto 0) := (others => '0');

    type state_t is (IDLE_S, ONE_S, BUG_S);
    signal state : state_t := IDLE_S;
begin

  process(clk)
  begin
    if rising_edge(clk) then
        data <=  std_logic_vector(count);
        case state is
            when IDLE_S =>
                count <= count + 1;
                if count = x"A0" then
                    state <= ONE_S;
                end if;
            when ONE_S =>
                count <= x"00";
                state <= BUG_S;
                
            when BUG_S =>
                if bug_signal = '1' then
                    count <= X"AA";
                end if;
                state <= IDLE_S;
        end case;


      if rst = '1' then
        count <= (others => '0');
      end if;

    end if;
  end process;

  assert count /= x"AA" report "Counter bad" severity FAILURE;

end architecture rtl;