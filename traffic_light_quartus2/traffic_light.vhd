-----------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
-----------------------------------------------
entity traffic_light is
	port (stby, clk : in std_logic;
			red, yellow, green : out std_logic
			);
end entity traffic_light;
--Ngõ vào Stanby ép đèn vào trạng thái off
-----------------------------------------------
architecture state_machine of traffic_light is
	TYPE state is (off, vang , do , xanh);
	--Dùng xung 1Hz sẽ có đơn vị là second
	CONSTANT timeMAX : integer := 5;
	CONSTANT timeRED : integer := 1;
	CONSTANT timeGRN : integer := 1;
	CONSTANT timeYEL : integer := 5;
	SIGNAL pr_state, nx_state : state;
	--Trạng thái hiện tại pr_state
	--Trạng thái kế nx_state
	--Giá trị biến đếm hiện tại pr_state
	--Giá trị biến đếm kế nx_counter
	SIGNAL pr_counter, nx_counter : integer
							range 0 to timeMAX := 1;
	SIGNAL reset_counter : std_logic;
	--Tín hiệu reset bộ counter
begin
-------------------Array FF--------------------
	process(clk, stby)
	begin
		if (stby = '1') then 
			pr_state <= off;
		elsif (clk'event and clk = '1') then
	--Hoạt động với xung dương;
			pr_state <= nx_state;
			pr_counter <= nx_counter;
		end if;
	end process;
	
	nx_counter <= 1 when reset_counter = '1'
								else pr_counter + 1;
--Nếu tín hiệu reset tích cực => reset bộ đếm
--Còn nếu không, thì counter lên 1	
------------------Mạch tổ hợp------------------
	process(pr_counter, pr_state)
	begin
		case pr_state is
			when off => --OFF đến khi Stby tắt
				red <='0';green <='0';yellow <='0';
				nx_state <= vang; 
				reset_counter <= '1';
				
			when vang => --vàng(5s) -> đỏ 
				red <='0';green <='0';yellow <='1';
--Nếu bộ đếm = với timeYEL nghĩa là đã qua 5s
--=> chuyển sang đỏ
--Còn nếu không, thì counter + 1 để đếm tiếp
--Tương tự
				if pr_counter = timeYEL then
					nx_state <= do;
					reset_counter <= '1';
				else 
					nx_state <= pr_state;
					reset_counter <= '0';
				end if;

			when do => --đỏ(1s) -> xanh 
				red <='1';green <='0';yellow <='0';
				if pr_counter = timeRED then
					nx_state <= xanh;
					reset_counter <= '1';
				else 
					nx_state <= pr_state;
					reset_counter <= '0';	
				end if;

			when xanh => --xanh(1s) -> vàng 
				red <='0';green <='1';yellow <='0';
				if pr_counter = timeGRN then
					nx_state <= vang;
					reset_counter <= '1';
				else 
					nx_state <= pr_state;
					reset_counter <= '0';
				end if;
		end case;
	end process;
end architecture state_machine;
					

	