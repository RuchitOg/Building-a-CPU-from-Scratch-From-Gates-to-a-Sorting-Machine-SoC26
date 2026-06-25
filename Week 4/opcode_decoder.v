// opcode_decoder.v
// i281 OPCODE Decoding Circuit



//   C[15:12] : main opcode group
//   C[11:10] : RX register field
//   C[9:8]   : RY register field OR subgroup selector for INPUT/BRANCH
//   C[8]     : subgroup selector for SHIFT group
//   C[7:0]   : address / immediate value / PC offset

`timescale 1ns/1ps

module decoder_1to2 (
    input  wire en,
    input  wire w0,
    output wire y0,
    output wire y1
);
    assign y0 = en & ~w0;
    assign y1 = en &  w0;
endmodule

module decoder_2to4 (
    input  wire en,
    input  wire [1:0] w,
    output wire [3:0] y
);
    assign y = en ? (4'b0001 << w) : 4'b0000;
endmodule

module decoder_4to16 (
    input  wire en,
    input  wire [3:0] w,
    output wire [15:0] y
);
    assign y = en ? (16'h0001 << w) : 16'h0000;
endmodule

module opcode_decoder (
    input  wire [15:0] C,

    // Operand fields passed through from the instruction word
    output wire [1:0] rx,
    output wire [1:0] ry,
    output wire [7:0] addr_val_offset,

    // One-hot decoded instruction outputs
    output wire noop,
    output wire inputc,
    output wire inputcf,
    output wire inputd,
    output wire inputdf,
    output wire move,
    output wire loadi_loadp,
    output wire add,
    output wire addi,
    output wire sub,
    output wire subi,
    output wire load,
    output wire loadf,
    output wire store,
    output wire storef,
    output wire shiftl,
    output wire shiftr,
    output wire cmp,
    output wire jump,
    output wire bre_brz,
    output wire brne_brnz,
    output wire brg,
    output wire brge
);
    wire [15:0] main_dec;
    wire [3:0]  input_dec;
    wire [3:0]  branch_dec;
    wire [1:0]  shift_dec;

    // Direct operand-field extraction
    assign rx = C[11:10];
    assign ry = C[9:8];
    assign addr_val_offset = C[7:0];

    // Main 4-to-16 decoder for C15..C12
    decoder_4to16 main_decoder (
        .en(1'b1),
        .w(C[15:12]),
        .y(main_dec)
    );

    // Sub-decoders enabled only inside their main opcode group
    // INPUT group format: 0001_dd_ss_ADDR, where ss=C[9:8]
    decoder_2to4 input_decoder (
        .en(main_dec[4'h1]),
        .w(C[9:8]),
        .y(input_dec)
    );

    // SHIFT group format: 1100_RX_d_s_dddddddd, where s=C[8]
    decoder_1to2 shift_decoder (
        .en(main_dec[4'hC]),
        .w0(C[8]),
        .y0(shift_dec[0]),
        .y1(shift_dec[1])
    );

    // BRANCH group format: 1111_dd_cc_PCOFFSET, where cc=C[9:8]
    decoder_2to4 branch_decoder (
        .en(main_dec[4'hF]),
        .w(C[9:8]),
        .y(branch_dec)
    );

    // Main opcode outputs
    assign noop        = main_dec[4'h0];
    assign inputc      = input_dec[2'b00];
    assign inputcf     = input_dec[2'b01];
    assign inputd      = input_dec[2'b10];
    assign inputdf     = input_dec[2'b11];
    assign move        = main_dec[4'h2];
    assign loadi_loadp = main_dec[4'h3];
    assign add         = main_dec[4'h4];
    assign addi        = main_dec[4'h5];
    assign sub         = main_dec[4'h6];
    assign subi        = main_dec[4'h7];
    assign load        = main_dec[4'h8];
    assign loadf       = main_dec[4'h9];
    assign store       = main_dec[4'hA];
    assign storef      = main_dec[4'hB];
    assign shiftl      = shift_dec[0];
    assign shiftr      = shift_dec[1];
    assign cmp         = main_dec[4'hD];
    assign jump        = main_dec[4'hE];
    assign bre_brz     = branch_dec[2'b00];
    assign brne_brnz   = branch_dec[2'b01];
    assign brg         = branch_dec[2'b10];
    assign brge        = branch_dec[2'b11];
endmodule
