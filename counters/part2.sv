module RateDivider
#(parameter CLOCK_FREQUENCY = 500)  
(input logic ClockIn, input logic Reset, input logic [1:0] Speed, output logic Enable);

    logic [31:0] Count;
    logic [31:0] Limit;

    always_comb
    begin
        case (Speed)
            2'b00: Limit = 0;   // Full speed (no division)
            2'b01: Limit = CLOCK_FREQUENCY - 1;   // 1Hz (1-second pulse)
            2'b10: Limit = CLOCK_FREQUENCY * 2 - 1;   // 0.5Hz (2-second pulse)
            2'b11: Limit = CLOCK_FREQUENCY * 4 - 1;   // 0.25Hz (4-second pulse)
            default: Limit = 0;
        endcase
		
    end

    always_ff @(posedge ClockIn or posedge Reset)
    begin
        if (Reset) begin
            Count <= Limit; 
        end else if (Count == 0) begin
            Count <= Limit;
        end else if (Count > 0) begin
            Count <= Count - 1; 
        end
    end	
	assign Enable = (Speed == 2'b00) ? ClockIn : (Count == 0);
endmodule

module DisplayCounter(input logic Clock, Reset, EnableDC, output logic [3:0] CounterValue);

    always_ff @(posedge Clock or posedge Reset) 
    begin
        if (Reset) begin
            CounterValue <= 4'b0000;
        end else if (EnableDC) begin
            if (CounterValue == 4'b1111) begin
                CounterValue <= 4'b0000;
            end else begin
                CounterValue <= CounterValue + 1'b1;
			end
        end
    end
endmodule

module part2 
#(parameter CLOCK_FREQUENCY = 500) 
(input logic ClockIn, input logic Reset, input logic [1:0] Speed, output logic [3:0] CounterValue);

    logic Enable;

    RateDivider #(CLOCK_FREQUENCY) u0(ClockIn, Reset, Speed, Enable);
    DisplayCounter u1(ClockIn, Reset, Enable, CounterValue);

endmodule