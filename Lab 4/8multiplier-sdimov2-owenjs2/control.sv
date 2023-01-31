module control (	input Clk, Reset, Run, 
						output logic shift, loadA, subtract, setA
						);
						
		enum logic [4:0] {standby, mid, add0, add1, add2, add3, add4, add5, add6, sub7, 
		shift0, shift1, shift2, shift3, shift4, shift5, shift6, shift7,
		hold} curr_state, next_state; // States for add, shift, standby, hold
		
		
		// Assign 'next_state' based on 'state' and 'Execute'
		always_ff @ (posedge Clk /*or posedge Reset*/ ) // make synchronous
		begin
				if (Reset)
					curr_state <= standby; // test
				else
					curr_state <= next_state; //tt
		end
		
		
		// Assign outputs based on ‘state’
		always_comb
		begin
		// Default to be self-looping 		
				next_state = curr_state; 
				
				unique case (curr_state)
						standby : if (Run) // If execute is pressed, can move from standby to add0
								next_state = mid;
														
						mid : next_state = add0;
						
						add0 : next_state = shift0; // Unconditionally run through add and shift states
						shift0 : next_state = add1;
						add1 : next_state = shift1;
						shift1 : next_state = add2;
						add2 : next_state = shift2;
						shift2 : next_state = add3;
						add3 : next_state = shift3;
						shift3 : next_state = add4;
						add4 : next_state = shift4;
						shift4 : next_state = add5;
						add5 : next_state = shift5;
						shift5 : next_state = add6;
						add6 : next_state = shift6;
						shift6 : next_state = sub7;
						sub7 : next_state = shift7;
						shift7: next_state = hold;
						
						hold : if (~Run)
								next_state = standby;
				endcase
				
		end
		
		
		
		// Assign outputs based on ‘state’
		always_comb
		begin
				case (curr_state)
					standby : 
						begin
						loadA = 1'b0;
						shift = 1'b0;
						subtract = 1'b0;
						setA = 1'b0;
						end
					
					mid :
						begin
						loadA = 1'b0;
						shift = 1'b0;
						subtract = 1'b0;
						setA = 1'b1;
						end
								
					add0 :
						begin
						loadA = 1'b1;
						shift = 1'b0;
						subtract = 1'b0;
						setA = 1'b0;
						end
					add1 :
						begin
						loadA = 1'b1;
						shift = 1'b0;
						subtract = 1'b0;
						setA = 1'b0;
						end
					add2 :
						begin
						loadA = 1'b1;
						shift = 1'b0;
						subtract = 1'b0;
						setA = 1'b0;

						end
					add3 :
						begin
						loadA = 1'b1;
						shift = 1'b0;
						subtract = 1'b0;
						setA = 1'b0;

						end
					add4 : 
						begin
						loadA = 1'b1;
						shift = 1'b0;
						subtract = 1'b0;
						setA = 1'b0;
						end
					add5 : 
						begin
						loadA = 1'b1;
						shift = 1'b0;
						subtract = 1'b0;
						setA = 1'b0;
						end
					add6 : 
						begin
						loadA = 1'b1;
						shift = 1'b0;
						subtract = 1'b0;
						setA = 1'b0;
						end
						
					sub7 : 
						begin
						loadA = 1'b1;
						shift = 1'b0;
						subtract = 1'b1;
						setA = 1'b0;
						end
						
					shift0 :
						begin
						loadA = 1'b0;
						shift = 1'b1;
						subtract = 1'b0;
						setA = 1'b0;
						end
					shift1 :
						begin
						loadA = 1'b0;
						shift = 1'b1;
						subtract = 1'b0;
						setA = 1'b0;
						end
					shift2 :
						begin
						loadA = 1'b0;
						shift = 1'b1;
						subtract = 1'b0;
						setA = 1'b0;
						end
					shift3 :
						begin
						loadA = 1'b0;
						shift = 1'b1;
						subtract = 1'b0;
						setA = 1'b0;
						end
					shift4 :
						begin
						loadA = 1'b0;
						shift = 1'b1;
						subtract = 1'b0;
						setA = 1'b0;
						end
					shift5 :
						begin
						loadA = 1'b0;
						shift = 1'b1;
						subtract = 1'b0;
						setA = 1'b0;
						end
					shift6 :
						begin
						loadA = 1'b0;
						shift = 1'b1;
						subtract = 1'b0;
						setA = 1'b0;
						end
					shift7 :
						begin
						loadA = 1'b0;
						shift = 1'b1;
						subtract = 1'b0;
						setA = 1'b0;
						end
						
					hold : 
						begin
						loadA = 1'b0;
						shift = 1'b0;
						subtract = 1'b0;
						setA = 1'b0;
						end
				endcase
		end
		
endmodule