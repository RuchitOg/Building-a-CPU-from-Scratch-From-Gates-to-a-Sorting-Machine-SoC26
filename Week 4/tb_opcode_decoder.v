

`timescale 1ns/1ps

module tb_opcode_decoder;
    reg  [15:0] C;
    wire [1:0] rx, ry;
    wire [7:0] addr_val_offset;

    wire noop, inputc, inputcf, inputd, inputdf;
    wire move, loadi_loadp, add, addi, sub, subi;
    wire load, loadf, store, storef;
    wire shiftl, shiftr, cmp, jump;
    wire bre_brz, brne_brnz, brg, brge;

    integer i;
    integer errors;
    reg [22:0] got;
    reg [22:0] exp;

    opcode_decoder dut (
        .C(C),
        .rx(rx),
        .ry(ry),
        .addr_val_offset(addr_val_offset),
        .noop(noop),
        .inputc(inputc),
        .inputcf(inputcf),
        .inputd(inputd),
        .inputdf(inputdf),
        .move(move),
        .loadi_loadp(loadi_loadp),
        .add(add),
        .addi(addi),
        .sub(sub),
        .subi(subi),
        .load(load),
        .loadf(loadf),
        .store(store),
        .storef(storef),
        .shiftl(shiftl),
        .shiftr(shiftr),
        .cmp(cmp),
        .jump(jump),
        .bre_brz(bre_brz),
        .brne_brnz(brne_brnz),
        .brg(brg),
        .brge(brge)
    );

    // Output vector order:
    // [22] noop
    // [21:18] inputc,inputcf,inputd,inputdf
    // [17] move
    // [16] loadi_loadp
    // [15] add
    // [14] addi
    // [13] sub
    // [12] subi
    // [11] load
    // [10] loadf
    // [9]  store
    // [8]  storef
    // [7]  shiftl
    // [6]  shiftr
    // [5]  cmp
    // [4]  jump
    // [3:0] bre_brz,brne_brnz,brg,brge
    function [22:0] expected_decode;
        input [15:0] instr;
        begin
            expected_decode = 23'b0;
            case (instr[15:12])
                4'h0: expected_decode[22] = 1'b1;                 // NOOP
                4'h1: begin                                        // INPUT group
                    case (instr[9:8])
                        2'b00: expected_decode[21] = 1'b1;         // INPUTC
                        2'b01: expected_decode[20] = 1'b1;         // INPUTCF
                        2'b10: expected_decode[19] = 1'b1;         // INPUTD
                        2'b11: expected_decode[18] = 1'b1;         // INPUTDF
                    endcase
                end
                4'h2: expected_decode[17] = 1'b1;                 // MOVE
                4'h3: expected_decode[16] = 1'b1;                 // LOADI/LOADP
                4'h4: expected_decode[15] = 1'b1;                 // ADD
                4'h5: expected_decode[14] = 1'b1;                 // ADDI
                4'h6: expected_decode[13] = 1'b1;                 // SUB
                4'h7: expected_decode[12] = 1'b1;                 // SUBI
                4'h8: expected_decode[11] = 1'b1;                 // LOAD
                4'h9: expected_decode[10] = 1'b1;                 // LOADF
                4'hA: expected_decode[9]  = 1'b1;                 // STORE
                4'hB: expected_decode[8]  = 1'b1;                 // STOREF
                4'hC: begin                                        // SHIFT group
                    if (instr[8] == 1'b0)
                        expected_decode[7] = 1'b1;                // SHIFTL
                    else
                        expected_decode[6] = 1'b1;                // SHIFTR
                end
                4'hD: expected_decode[5] = 1'b1;                  // CMP
                4'hE: expected_decode[4] = 1'b1;                  // JUMP
                4'hF: begin                                        // BRANCH group
                    case (instr[9:8])
                        2'b00: expected_decode[3] = 1'b1;         // BRE/BRZ
                        2'b01: expected_decode[2] = 1'b1;         // BRNE/BRNZ
                        2'b10: expected_decode[1] = 1'b1;         // BRG
                        2'b11: expected_decode[0] = 1'b1;         // BRGE
                    endcase
                end
            endcase
        end
    endfunction

    initial begin
        errors = 0;

        for (i = 0; i < 65536; i = i + 1) begin
            C = i[15:0];
            #1;

            got = {noop,
                   inputc, inputcf, inputd, inputdf,
                   move, loadi_loadp,
                   add, addi, sub, subi,
                   load, loadf, store, storef,
                   shiftl, shiftr,
                   cmp, jump,
                   bre_brz, brne_brnz, brg, brge};

            exp = expected_decode(C);

            if (got !== exp) begin
                $display("ERROR: C=%h got=%b expected=%b", C, got, exp);
                errors = errors + 1;
            end

            if (rx !== C[11:10]) begin
                $display("ERROR: C=%h rx=%b expected=%b", C, rx, C[11:10]);
                errors = errors + 1;
            end

            if (ry !== C[9:8]) begin
                $display("ERROR: C=%h ry=%b expected=%b", C, ry, C[9:8]);
                errors = errors + 1;
            end

            if (addr_val_offset !== C[7:0]) begin
                $display("ERROR: C=%h addr_val_offset=%b expected=%b",
                         C, addr_val_offset, C[7:0]);
                errors = errors + 1;
            end
        end

        if (errors == 0)
            $display("PASS: opcode_decoder passed instruction test.");
        else
            $display("FAIL: opcode_decoder found %0d error(s).", errors);

       
    end
endmodule
