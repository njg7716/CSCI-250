#File:		print_stuff.asm
# Author:	Nicholas Graca
# Description:	Print out all the banners and the game board
#
# Purpose:	Make it look pretty to the user
PRINT_INT =     1
PRINT_STRING =  4
READ_INT =      5
READ_STRING =   8
EXIT =  10

        .data
	.align 2

gen_part1:
        .asciiz "\n====    GENERATION "

gen_part2:
        .asciiz "    ====\n+"

side:   
        .asciiz "|"

top:
        .asciiz "-"

corner:
        .asciiz "+"

space:
        .asciiz " "

A:
        .asciiz "A"

B:
        .asciiz "B"

new_line:
        .asciiz "\n"

	.text
	.align 2
        .globl board
        .globl copy

#Prints the generation number
print_board:
        move    $s7, $ra
        li      $v0, PRINT_STRING
        la      $a0, gen_part1
        syscall
        li      $v0, PRINT_INT
        move    $a0, $t8                #t8 is gen counter
        syscall
        li      $v0, PRINT_STRING
        la      $a0, gen_part2
        syscall
        move    $t9, $zero
        jal     print_top
        jal     print_corner
        li      $v0, PRINT_STRING
        la      $a0, new_line
        syscall
        move    $s4, $zero              #col counter
        li      $s6, 2
        div     $t8, $s6
        mfhi    $s6
        beq     $s6, $zero, og_board    #checks the generation to knwo which
                                        #board to print
        la      $s5, copy               #address pointer
        move    $s6, $zero
        j       print_array        

og_board:
        la      $s5, board              #address pointer
        move    $s6, $zero              #counter
        j       print_array

#bottom and top are the same so write it once
bottom:
        jal     print_corner
        move    $t9, $zero
        jal     print_top
        jal     print_corner
        li      $v0, PRINT_STRING
        la      $a0, new_line
        syscall
        jr      $s7
        
#loops through the whole array and prints the character that corresponds to the
#value. Also prints the sides and new lines for the new row
print_array:
        beq     $s0, $s6, bottom
        li      $v0, PRINT_STRING
        la      $a0, side
        syscall
        jal     inner_loop
        li      $v0, PRINT_STRING
        la      $a0, side
        syscall
        li      $v0, PRINT_STRING
        la      $a0, new_line
        syscall
        move    $s4, $zero
        addi    $s6, $s6, 1
        j       print_array

#just loops through the row and calls the write print function
inner_loop:
        beq     $s4, $s0, bac
        lb      $t9, 0($s5)
        beq     $t9, $zero, print_space
        li      $a3, 1
        beq     $a3, $t9, print_A
        li      $v0, PRINT_STRING
        la      $a0, B
        syscall                         #prints a B for 2
        j       inner_loop_end

#prints a space for 0
print_space:
        li      $v0, PRINT_STRING
        la      $a0, space
        syscall
        j       inner_loop_end

#prints an A for 1
print_A:
        li      $v0, PRINT_STRING
        la      $a0, A
        syscall
        j       inner_loop_end


inner_loop_end:
        addi    $s4, $s4, 1
        addi    $s5, $s5, 1
        j       inner_loop

#prints a hyphen
print_top:
        beq     $t9, $s0, bac
        li      $v0, PRINT_STRING
        la      $a0, top
        syscall
        addi    $t9, $t9, 1
        j       print_top

#prints a plus for the corners
print_corner:
        li      $v0, PRINT_STRING
        la      $a0, corner
        syscall
        jr      $ra

#prints a bar for the side
print_side:
        li      $v0, PRINT_STRING
        la      $a0, side
        syscall
        jr      $ra
        
bac:
        jr      $ra
