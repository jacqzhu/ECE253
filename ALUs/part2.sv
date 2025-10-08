module fa(input logic a, b, c_in, output logic s, c_out);
	assign s = a ^ b ^ c_in;
	assign c_out = (a&b)|(c_in&a)|(c_in&b);
endmodule

module part1(input logic [3:0] a, b, input logic c_in, output logic [3:0] s, c_out);
	fa u0 (a[0], b[0], c_in, s[0], c_out[0]);
	fa u1 (a[1], b[1], c_out[0], s[1], c_out[1]);
	fa u2 (a[2], b[2], c_out[1], s[2], c_out[2]);
	fa u3 (a[3], b[3], c_out[2], s[3], c_out[3]);
endmodule
	

module part2(input logic [3:0] A, B, input logic [1:0] Function, output logic [7:0] ALUout);
	logic [3:0] S, C_out;
	part1 u0 (A, B, 1'b0, S, C_out);
	always_comb
	begin
		ALUout = 8'b00000000;
		case (Function)
		2'b00: ALUout = {3'b000, C_out[3], S};
		2'b01: if (|{A,B})
				ALUout = 8'b00000001;
		2'b10: if (&{A,B})
				ALUout = 8'b00000001;
		2'b11: ALUout = {A, B};
		default: ALUout = 8'b00000000;
		endcase
	end
endmodule
		