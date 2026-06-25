///////////////////////////////////////////////
//module lemming_1
//////////////////////////////////////////////

module lemming_1(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right); // 
    //Number of state 2 left=0,right=1 
	//left means lemming is walking left and so for right
    // parameter LEFT=0, RIGHT=1, ...
    reg state, next_state;
	
    always @(*) begin
        // State transition logic
        case(state)
            1'b0: if(bump_left) next_state = 1;
            else next_state = 0;
            1'b1: if(bump_right) next_state = 0;
            else next_state = 1;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        // State flip-flops with asynchronous reset
        if(areset) state <= 0;
        else state <= next_state;
    end

    // Output logic
    assign walk_left = (state == 0);
    assign walk_right = (state == 1);

endmodule


///////////////////////////////////////////////////
//module lemming_2
///////////////////////////////////////////////////


module leming_2(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 
    
    //Number of states: 4 
    //00:walk_left 01: walk_right 10:fall while walking left 11: fall while walking right 
    reg [1:0] state,next_state;
    
    always @(*) begin
        case(state)
            2'b00:if(ground)begin
                if(bump_left) next_state = 2'b01;
                else next_state = 2'b00;
            end
            else next_state =2'b10;
            2'b01:if(ground)begin
                if(bump_right) next_state = 2'b00;
                else next_state = 2'b01;
            end
			else next_state =2'b11;
            2'b10:if(ground) next_state = 2'b00;
            else next_state = 2'b10;
            2'b11:if(ground) next_state = 2'b01;
            else next_state = 2'b11;
        endcase
    end
    
    always @(posedge clk or posedge areset)begin
        if(areset) state[0] <= 0;
        else state <= next_state;
    end
    
    assign aaah = (state[1]==1);
    assign walk_left = (state == 2'b00);
    assign walk_right = (state == 2'b01);
    
endmodule



/////////////////////////////////////////
//module lemming_3 
////////////////////////////////////////



module lemming_3(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

	//Number of states 6 
	//left = 000, right = 001, fall left = 010, fall right = 011, dig left = 100, dig right = 101
    
    reg [2:0] state,next_state;
    
    always @(*) begin
        case(state)
            3'b000:if(dig&ground) next_state = 3'b100;
            else if(ground)begin
                if(bump_left) next_state = 3'b001;
                else next_state = 3'b000;
            end
            else next_state = 3'b010;
            3'b001:if(dig&ground) next_state = 3'b101;
            else if(ground)begin
                if(bump_right) next_state = 3'b000;
                else next_state = 3'b001;
            end
            else next_state = 3'b011;
            3'b010:if(ground) next_state = 3'b000;
            else next_state = 3'b010;
            3'b011:if(ground) next_state = 3'b001;
            else next_state = 3'b011;
            3'b100:if(ground==0) next_state = 3'b010;
            else next_state = 3'b100;
            3'b101:if(ground==0) next_state = 3'b011;
            else next_state = 3'b101;
            default:next_state = 3'bxxx;
        endcase
    end
    
    always @(posedge clk or posedge areset)begin
        if(areset)begin 
            state[0] = 0; 
            state[2] = 0;
        end
        else state = next_state;
    end
    
    assign digging = (state[2]==1);
    assign aaah = (state[1]==1);
    assign walk_left = (state == 3'b000);
    assign walk_right = (state == 3'b001);
    

endmodule



/////////////////////////////////////////
//module: lemming_4
////////////////////////////////////////



module lemming_4(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);
    //Number of state 7 
    //left = 0,right = 1,fall left = 2,fall right = 3,dig left =4,dig right = 5,dead = 6

    localparam LEFT       = 3'd0;
    localparam RIGHT      = 3'd1;
    localparam FALL_LEFT  = 3'd2;
    localparam FALL_RIGHT = 3'd3;
    localparam DIG_LEFT   = 3'd4;
    localparam DIG_RIGHT  = 3'd5;
    localparam DEAD       = 3'd6;

    reg [2:0] state, next_state;
    reg [4:0] fall_count;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
            fall_count <= 5'd0;
        end
        else begin
            state <= next_state;

            if (next_state == FALL_LEFT || next_state == FALL_RIGHT) begin
                if (state == FALL_LEFT || state == FALL_RIGHT) begin
                    if (fall_count < 5'd31)
                        fall_count <= fall_count + 5'd1;
                    else
                        fall_count <= fall_count;
                end
                else begin
                    fall_count <= 5'd1;
                end
            end
            else begin
                fall_count <= 5'd0;
            end
        end
    end

    always @(*) begin
        case (state)

            LEFT: begin
                if (!ground)
                    next_state = FALL_LEFT;
                else if (dig)
                    next_state = DIG_LEFT;
                else if (bump_left)
                    next_state = RIGHT;
                else
                    next_state = LEFT;
            end

            RIGHT: begin
                if (!ground)
                    next_state = FALL_RIGHT;
                else if (dig)
                    next_state = DIG_RIGHT;
                else if (bump_right)
                    next_state = LEFT;
                else
                    next_state = RIGHT;
            end

            FALL_LEFT: begin
                if (ground) begin
                    if (fall_count > 5'd20)
                        next_state = DEAD;
                    else
                        next_state = LEFT;
                end
                else begin
                    next_state = FALL_LEFT;
                end
            end

            FALL_RIGHT: begin
                if (ground) begin
                    if (fall_count > 5'd20)
                        next_state = DEAD;
                    else
                        next_state = RIGHT;
                end
                else begin
                    next_state = FALL_RIGHT;
                end
            end

            DIG_LEFT: begin
                if (!ground)
                    next_state = FALL_LEFT;
                else
                    next_state = DIG_LEFT;
            end

            DIG_RIGHT: begin
                if (!ground)
                    next_state = FALL_RIGHT;
                else
                    next_state = DIG_RIGHT;
            end

            DEAD: begin
                next_state = DEAD;
            end

            default: next_state = LEFT;

        endcase
    end

    assign walk_left  = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah       = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging    = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule