module ALU(
    input logic SR2MUX,
    input logic [1:0] ALUK,
    input logic [15:0] SR1, SR2, IR,
    output logic [15:0] DataALU
);

logic [15:0] B;
always_comb begin : Determine_B
    case (SR2MUX)
        1'b0 :
            B = SR2; // SR2
        1'b1 :
            B = { {11{IR[4]}}, IR[4:0]}; // sext(offset5)
    endcase
end

always_comb begin : ALU
    case (ALUK)
        2'b00 : 
            DataALU = B + SR1; // ADD
        2'b01 : 
            DataALU = B & SR1; // AND
        2'b10 : 
            DataALU = ~SR1; // NOT SR1
        default: 
            DataALU = SR1; // Default to just pass SR1
    endcase
end

endmodule 