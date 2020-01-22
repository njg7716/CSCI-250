# File:		input.asm
# Author:	Nicholas Graca
# Description:	Ask the user for input and check if it is valid
#
# Purpose:	Make sure no one can break my code

#Ask for input and check if it is worthy

#syscall codes  
INT_INT =	1
PRINT_STRING = 	4
READ_INT = 	5
READ_STRING =   8
EXIT =  10

        .data
        .align 2

size:
        .word 0
gens:
        .word 0
live_A:
        .word 0
live_B:
        .word 0
        
board:
        .space 90

copy:
        .space 90

banner:
        .asciiz "\n**********************\n****    Colony    ****\n"

banner_2:
        .asciiz "**********************\n\n"

prompt1:
        .asciiz "Enter board size: "

error_board_size:
        .asciiz "\nWARNING: illegal board size, try again: "

prompt2:
        .asciiz "\nEnter number of generations to run: "

error_generation:
        .asciiz "\nWARNING: illegal number of generations, try again: "

prompt3:
        .asciiz "\nEnter number of live cells for colony A: "

prompt4:
        .asciiz "\nEnter number of live cells for colony B: "
error_cells:
        .asciiz "\nWARNING: illegal number of live cells, try again: "

start:
        .asciiz "\nStart entering locations\n"

error_location:
        .asciiz "\nERROR: illegal point location\n"

newline:
        .asciiz "\n"

        .text
        .align 2

#print the banner
input: 
        move    $s5, $ra
        li      $v0, PRINT_STRING
        la      $a0, banner
        syscall
        li      $v0, PRINT_STRING
        la      $a0, banner_2
        syscall
        li      $v0, PRINT_STRING
        la      $a0, prompt1
        syscall
        li      $t0, 90
        la      $t1, board
        la      $t2, copy

#make sure the board is empty before you add to it
clear_board:
        beq     $t0, $zero, get_size
        sb      $zero, 0($t1)
        sb      $zero, 0($t2)
        addi    $t1, $t1, 1
        addi    $t2, $t2, 1
        addi    $t0, $t0, -1
        j       clear_board

#prompts the user for the size of the board and checks that it is legal
get_size:
        li      $v0, READ_INT
        la      $a0, size
        syscall
        move    $s0, $v0                #s0 is board size
        li      $t0, 31
        slt     $t1, $s0, $t0
        beq     $t1, $zero, size_err
        li      $t0, 4
        slt     $t1, $s0, $t0
        bne     $t1, $zero, size_err
        li      $v0, PRINT_STRING
        la      $a0, prompt2
        syscall

#prompts user for number of generations and checks it
get_gens:
        li      $v0, READ_INT
        la      $a0, gens
        syscall
        move    $s1, $v0                #s1 is number of gens
        li      $t0, 21
        slt     $t1, $s1, $t0
        beq     $t1, $zero, gen_err
        slt     $t1, $s0, $zero
        bne     $t1, $zero, gen_err
        li      $v0, PRINT_STRING
        la      $a0, prompt3
        syscall

#gets the number of live cells from the user and checks it
get_live_A:
        li      $v0, READ_INT
        la      $a0, live_A
        syscall
        move    $s2, $v0                #s2 is number of live A cells
        mult    $s0, $s0
        mflo    $t0
        slt     $t1, $s2, $t0
        beq     $t1, $zero, live_A_err
        slt     $t1, $s2, $zero
        bne     $t1, $zero, live_A_err
        slt     $t1, $s0, $zero
        bne     $t1, $zero, live_A_err
        li      $v0, PRINT_STRING
        la      $a0, start
        syscall
        beq     $s2,$zero, get_live_B
        move    $s7, $s2                #counter for corrs

#loops and get the coordinates and checks them
coor_A:
        beq     $s7, $zero, get_live_B
        li      $v0, READ_INT
        la      $a0, newline
        syscall
        move    $s3, $v0                #s3 is the row
        li      $v0, READ_INT
        la      $a0, newline
        syscall
        move    $s4, $v0                #s4 is the col
        slt     $t2, $s0, $s3           #check if row < size
        bne     $t2, $zero, bad_loc
        slt     $t2, $s3, $zero         #check if row > 0
        bne     $t2, $zero, bad_loc
        slt     $t2, $s0, $s4           #check if col < size
        bne     $t2, $zero, bad_loc
        slt     $t2, $s4, $zero
        bne     $t2, $zero, bad_loc
        jal     compute_address
        lb      $t1, 0($t3)
        bne     $t1, $zero, bad_loc
        li      $t2, 1                  #1 represents A 
        sb      $t2, 0($t3)
        addi    $s7, $s7, -1            #sub 1 for edge case
        j       coor_A

#gets the number of live B cells from user and checks it
get_live_B:
        li      $v0, PRINT_STRING
        la      $a0, prompt4
        syscall
        li      $v0, READ_INT
        la      $a0, live_B
        syscall
        move    $s2, $v0                #s2 is number of live B cells
        mult    $s0, $s0
        mflo    $t0
        slt     $t1, $s2, $t0
        beq     $t1, $zero, live_B_err
        slt     $t1, $s2, $zero
        bne     $t1, $zero, live_B_err
        slt     $t1, $s0, $zero
        bne     $t1, $zero, live_B_err
        li      $v0, PRINT_STRING
        la      $a0, start
        syscall
        beq     $s2, $zero, end
        move    $s7, $s2                #counter for coors

#loops and gets all the corrdinates and checks them
coor_B:
        beq     $s7, $zero, end
        li      $v0, READ_INT
        la      $a0, newline
        syscall
        move    $s3, $v0                #s3 is the row
        li      $v0, READ_INT
        la      $a0, newline
        syscall
        move    $s4, $v0                #s4 is the col
        slt     $t2, $s0, $s3           #check if row < size
        bne     $t2, $zero, bad_loc
        slt     $t2, $s3, $zero         #check if row > 0
        bne     $t2, $zero, bad_loc
        slt     $t2, $s0, $s4           #check if col < size
        bne     $t2, $zero, bad_loc
        slt     $t2, $s4, $zero
        bne     $t2, $zero, bad_loc
        jal     compute_address
        lb      $t1, 0($t3)
        bne     $t1, $zero, bad_loc
        li      $t2, 2                  #2 represents B 
        sb      $t2, 0($t3)
        addi    $s7, $s7, -1            #sub 1 for edge case
        j       coor_B

#finds the address in the board when given the row and col
compute_address:                        #s3 is row, s4 is col
        mult    $s3, $s0                #compute address to an B
        mflo    $t9
        add     $t9, $t9, $s4
        la      $t3, board
        add     $t3, $t3, $t9           #t3 is the address you are looking for
        jr      $ra


#if user messed up the input, tell them and ask again
bad_loc:
        li      $v0, PRINT_STRING
        la      $a0, error_location
        syscall
        j       breaks

size_err:
        li      $v0, PRINT_STRING
        la      $a0, error_board_size
        syscall
        j       get_size

gen_err:
        li      $v0, PRINT_STRING
        la      $a0, error_generation
        syscall
        j       get_gens

live_A_err:
        li      $v0, PRINT_STRING
        la      $a0, error_cells
        syscall
        j       get_live_A

live_B_err:
        li      $v0, PRINT_STRING
        la      $a0, error_cells
        syscall
        j       get_live_B

end:
        la      $s2, board              #s2 is address of board
        jr      $s5

breaks:
        li      $v0, 10
        syscall
