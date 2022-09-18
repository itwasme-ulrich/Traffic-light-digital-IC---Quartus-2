library verilog;
use verilog.vl_types.all;
entity traffic_light_vlg_check_tst is
    port(
        green           : in     vl_logic;
        red             : in     vl_logic;
        yellow          : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end traffic_light_vlg_check_tst;
