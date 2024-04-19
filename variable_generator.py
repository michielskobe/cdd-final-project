#!/bin/python3
# Author: Robbe Decapmaker <debber@dcpm.be>

#imports:
import yaml


# Load config file
with open('settings.yml', 'r') as file:
    config = yaml.safe_load(file)

ADDER_WIDTH = config['adder']['width']
START_BLOCK = config['adder']['start_block']
START_REPETITION = config['adder']['start_repetition']
MAX_BLOCK_WIDTH = config['adder']['max_block_width']
BLOCK_SIZE_INCREMENT = config['adder']['block_size_increment']


# print the start of the file
def print_start(adder_width):
    string_to_print = """`timescale 1ns / 1ps

module variable_carry_select_adder
    (
    input   wire [{0}-1:0]  iA, iB, 
    input   wire                    iCarry,
    output  wire [{0}-1:0]  oSum, 
    output  wire                    oCarry
    );

    genvar i;
    wire wSel[20-1:0];
    wire[{0}-1:0] wResult;
    reg [{0}-1:0]  riA, riB; 
    reg[{0}:0] rResult;
    reg rCarry;

    always@(*)
    begin
        riA <= iA;
        riB <= iB;
    end
    assign wSel[0] = iCarry;
    """.format(adder_width)
    print(string_to_print)


# print the end of the file
def print_end(last_carry):
    string_to_print = """
    assign oSum = wResult;
    assign oCarry = wSel[{0}];

endmodule
    """.format(last_carry)
    print(string_to_print)

def print_adder_block(block_width, slice_start, slice_end, wSel_in, wSel_out, block_type, inst_number):
    string_to_print = """    {5} #(.BLOCK_WIDTH({0})) adder_inst{6}(.iA(riA[{2}:{1}]), .iB(riB[{2}:{1}]), .iSel(wSel[{3}]), .oSum(wResult[{2}:{1}]), .oCarry(wSel[{4}]));""".format(block_width, slice_start, slice_end, wSel_in, wSel_out, block_type, inst_number)

    print(string_to_print)

def print_RCA(block_width, slice_start, slice_end, wSel_in, wSel_out, block_type, inst_number):
    string_to_print = """    {5} #(.ADDER_WIDTH({0})) adder_inst{6}(.iA(riA[{2}:{1}]), .iB(riB[{2}:{1}]), .iCarry(wSel[{3}]), .oSum(wResult[{2}:{1}]), .oCarry(wSel[{4}]));""".format(block_width, slice_start, slice_end, wSel_in, wSel_out, block_type, inst_number)
    print(string_to_print)

def generate_adder_structure(adder_width, start_block, start_repetition, max_block_width, block_size_increment):
    remaining_bits = adder_width
    current_itteration = 0
    start_repetition += 1
    
    # Print the first adder
    print_RCA(start_block, 0, start_block-1, current_itteration, current_itteration + 1, "ripple_carry_adder_Nb", current_itteration)
    remaining_bits -= start_block
    current_itteration += 1
    
    while(remaining_bits != 0):
        selected_block = "csa_block"
        current_block_size = start_block
        if(current_itteration > start_repetition):
            current_block_size = start_block + (current_itteration - start_repetition)*block_size_increment

        if(current_block_size > max_block_width):
            current_block_size = max_block_width

        if(current_block_size > remaining_bits):
            current_block_size = remaining_bits

        start_slice = adder_width - remaining_bits
        end_slice = start_slice + current_block_size -1

        print_adder_block(current_block_size, start_slice, end_slice, current_itteration, current_itteration + 1, selected_block, current_itteration)

        current_itteration += 1
        remaining_bits -= current_block_size
    print_end(current_itteration)




# main function
def main():
    print_start(ADDER_WIDTH)
    generate_adder_structure(ADDER_WIDTH, START_BLOCK, START_REPETITION, MAX_BLOCK_WIDTH, BLOCK_SIZE_INCREMENT)

# start the main function
if __name__ == "__main__":
    main()

