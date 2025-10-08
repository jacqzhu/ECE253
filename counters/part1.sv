module dff(input logic D, Clock, Reset_b, output logic Q);
    always_ff @(posedge Clock) begin
        if (Reset_b) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
        end
    end
endmodule

module part1(input logic clock, reset, ParallelLoadn, RotateRight, ASRight, input logic [3:0] Data_IN, output logic [3:0] Q);

    logic [3:0] D, Q_temp;

    always_comb
	begin
        if (!ParallelLoadn) begin
            D = Data_IN;
		end else begin
			if (RotateRight) begin
				if (ASRight) begin
					Q_temp[3] = D[3];
					Q_temp[2] = D[3];
					Q_temp[1] = D[2];
					Q_temp[0] = D[1];
				end else begin
					Q_temp[3] = D[0];
					Q_temp[2] = D[3];
					Q_temp[1] = D[2];
					Q_temp[0] = D[1];
				end
			end else begin
				Q_temp[3] = D[2];
				Q_temp[2] = D[1];
				Q_temp[1] = D[0];
				Q_temp[0] = D[3];
			end
			D = Q_temp;
		end
	end

	dff u0(D[0], clock, reset, Q[0]);
    dff u1(D[1], clock, reset, Q[1]);
    dff u2(D[2], clock, reset, Q[2]);
    dff u3(D[3], clock, reset, Q[3]);
	
endmodule


