module part3(input logic Clock, Reset_b, input logic [3:0] Data, input logic [2:0] Function, output logic [7:0] ALU_reg_out);
	logic [3:0] A, B;
	logic [7:0] ALUout, ALUreg;
	assign A = Data;
	assign B = ALUreg[3:0];
	
	always_comb
	begin
		ALUout = 8'b00000000;
		case (Function)
			3'b000: ALUout = A + B;
			3'b001: ALUout = A * B;
			3'b010: ALUout = B << A;
			3'b011: ALUout = ALUreg;
			default: ALUout = 8'b00000000;
		endcase	
	end
	
	reg8 u0 (ALUout, Clock, Reset_b, ALUreg);
	assign ALU_reg_out = ALUreg;
	
endmodule

module reg8(input logic [7:0] Data, input logic Clock, Reset_b, output logic [7:0] ALUreg);
	always_ff @(posedge Clock)
	begin
		if (Reset_b) begin
			ALUreg <= 8'b00000000;
		end else begin
			ALUreg <= Data;
		end
	end
endmodule