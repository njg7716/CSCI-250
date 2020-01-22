# File:		colony.asm
# Author:	Nicholas Graca
# Description:	Conways Game of Life in MIPS assembly
#
# Purpose:	To get an A in Concepts


#Set things up and call the appropriate functions
#Also implement the algorithm to make the game play properly
#implement the algorithm
        .text
        .align 2
        .globl compute_address
        .globl print_board
        .globl input
        .globl board
        .globl copy
main:
        jal     input
        li      $t8, 0         #gen counter
        la      $t1, board
        jal     print_board     #print gen zero
        li      $t6, 90         #t6 row counter
        li      $t7, 0          #t7 col counter
        la      $t1, copy       #t1 address of copy
        la      $t0, board      #t0 address of og board
        j       copy_array

#t6 and t7 need to 0 before you use copy
#t1 is start address for copy
#t0 is start address for OG Board
#makes a copy of the board
copy_array:                     
        beq     $zero, $t6, clean_up
        lb      $t2, 0($t0)
        sb      $t2, 0($t1)
        addi    $t0, $t0, 1
        addi    $t1, $t1, 1
        addi    $t6, $t6, -1
        j       copy_array

go_back:
        jr      $ra

#reset the pointers to each board after you copy
clean_up:
        addi    $t1, $t1, -90
        addi    $t0, $t0, -90
        j       run_loop

#checks if it reaches the max generations
run_loop:
        beq     $t8, $s1, fin
        j       compute_neighbors

#iterate the gen counter, switch which board you look at and keep looping
cont_run:
        addi    $t8, $t8, 1
        jal     print_board
        move    $t9, $t0                #change the board to look at
        move    $t0, $t1
        move    $t1, $t9
        li      $t6, 90
        jal     copy_array
        j       run_loop


compute_neighbors:
        move    $s3, $zero              #row counter
        move    $s4, $zero              #col counter
        move    $t6, $zero              #used to reset row counter
        move    $t7, $zero              #used to reset col counter

neighbor_loop:
        beq     $s0, $t6, cont_run      #go through row
        j       n_in_loop

#reset the col and iterate the row
cont_neigh:
        move    $t7, $zero
        addi    $t6, $t6, 1
        j       neighbor_loop

#loops through each spot and adds up all the neighbors it has
n_in_loop:
        beq     $t7, $s0, cont_neigh     #go through col
        #t4 is A neighbors
        #t5 is B neighbors
        move    $t4, $zero
        move    $t5, $zero
        move    $s3, $t6                #s3 is row
        move    $s4, $t7                #s4 is col
        jal     comp_curr               #t3 is add computed
        lb      $a3, 0($t3)             #a3 is the center
        move    $s3, $t6                #get the left spot
        move    $s4, $t7
        addi    $s4, $s4, -1
        jal     check_row
        jal     check_col
        jal     comp_curr
        jal     count
        move    $s3, $t6                #get the bottom left spot
        move    $s4, $t7
        addi    $s4, $s4, -1
        addi    $s3, $s3, 1
        jal     check_row
        jal     check_col
        jal     comp_curr
        jal     count
        move    $s3, $t6                #get the bottom spot
        move    $s4, $t7
        addi    $s3, $s3, 1
        jal     check_row
        jal     check_col
        jal     comp_curr
        jal     count
        move    $s3, $t6                #get the bottom right spot
        move    $s4, $t7
        addi    $s4, $s4, 1
        addi    $s3, $s3, 1
        jal     check_row
        jal     check_col
        jal     comp_curr
        jal     count
        move    $s3, $t6                #get the right spot
        move    $s4, $t7
        addi    $s4, $s4, 1
        jal     check_row
        jal     check_col
        jal     comp_curr
        jal     count
        move    $s3, $t6                #get the top right spot
        move    $s4, $t7
        addi    $s4, $s4, 1
        addi    $s3, $s3, -1
        jal     check_row
        jal     check_col
        jal     comp_curr
        jal     count
        move    $s3, $t6                #get the top spot
        move    $s4, $t7
        addi    $s3, $s3, -1
        jal     check_row
        jal     check_col
        jal     comp_curr
        jal     count
        move    $s3, $t6                #get the top left spot
        move    $s4, $t7
        addi    $s4, $s4, -1
        addi    $s3, $s3, -1
        jal     check_row
        jal     check_col
        jal     comp_curr
        jal     count                   #t4 is A neigh and t5 is B neigh
        li      $s4, 1
        beq     $s4, $a3, center_A      #if the center is an A
        li      $s4, 2
        beq     $s4, $a3, center_B      #if the center is a B
        slt     $s4, $t4, $t5           #if the center is empty
        beq     $s4, $zero, check_A
        sub     $s4, $t5, $t4
        li      $s3, 3
        bne     $s4, $s3, end_in_loop
        move    $s3, $t6
        move    $s4, $t7
        jal     comp_addr
        li      $s3, 2
        sb      $s3, 0($t3)
        j       end_in_loop

#find if the diffence in the types of neighbors is 3, if so cell becomes alive
check_A:
        sub     $s4, $t4, $t5
        li      $s3, 3
        bne     $s4, $s3, end_in_loop
        move    $s3, $t6
        move    $s4, $t7
        jal     comp_addr
        li      $s3, 1
        sb      $s3, 0($t3)
        j       end_in_loop

end_in_loop:
        addi    $t7, $t7, 1             #increase col
        j       n_in_loop

#check if the amount of neighbors is greater than 1
center_A:
        li      $s4, 2
        slt     $t9, $t4, $s4
        beq     $zero, $t9, more_A
        move    $s3, $t6
        move    $s4, $t7
        jal     comp_addr
        sb      $zero, 0($t3)           #if not, cell dies
        j       end_in_loop

#check if the amount of neighbors is less than 4
more_A:         
        li      $s4, 3
        slt     $s4, $s4, $t4
        beq     $s4, $zero, end_in_loop
        move    $s3, $t6
        move    $s4, $t7
        jal     comp_addr
        sb      $zero, 0($t3)           #if not, cell dies
        j       end_in_loop

#check if the amount of neighbors is greater than 1
center_B:
        li      $s4, 2
        slt     $t9, $t5, $s4
        beq     $zero, $t9, more_B
        move    $s3, $t6
        move    $s4, $t7
        jal     comp_addr
        sb      $zero, 0($t3)           #if not, cell dies
        j       end_in_loop

#check if the amount of neighbors is less than 4
more_B:
        li      $s4, 3
        slt     $s4, $s4, $t5
        beq     $s4, $zero, end_in_loop
        move    $s3, $t6
        move    $s4, $t7
        jal     comp_addr
        sb      $zero, 0($t3)           #if not, cell dies
        j       end_in_loop

#check if row is less than the size to compute wrapped neighbors        
check_row:
        slt     $t3, $s3, $s0
        bne     $t3, $zero, row2
        move    $s3, $zero
        jr      $ra

#check if row is greater than zero to compute wrapped neighbors
row2:
        slt     $t3, $s3, $zero
        beq     $t3, $zero, go_back
        move    $s3, $s0
        addi    $s3, $s3, -1
        jr      $ra

#check if col is less than size
check_col:
        slt     $t3, $s4, $s0
        bne     $t3, $zero, col2
        move    $s4, $zero
        jr      $ra

#check if col is greater than zero
col2:
        slt     $t3, $s4, $zero
        beq     $t3, $zero, go_back
        move    $s4, $s0
        addi    $s4, $s4, -1
        jr      $ra

#computes the address to the board you are looking at
comp_curr:                              #s3 is row, s4 is col
        mult    $s3, $s0                #compute address to an B
        mflo    $t9
        add     $t3, $t9, $s4
        add     $t3, $t3, $t0           #t3 is the address you are looking for
        jr      $ra

#computes the address to the board you are changing
comp_addr:                              #s3 is row, s4 is col
        mult    $s3, $s0                #compute address to an B
        mflo    $t9
        add     $t3, $t9, $s4
        add     $t3, $t3, $t1           #t3 is the address you are looking for
        jr      $ra

#adds up the 2 types of neighbors
count:
        lb      $t2, 0($t3)
        li      $t3, 1
        bne     $t2, $t3, count_cont

add_A:
        addi    $t4, $t4, 1
     
count_cont:
        li      $t3, 2
        bne     $t2, $t3, go_back

add_B:
        addi    $t5, $t5, 1
        jr      $ra

#exits program
fin:
        li      $v0, 10
        syscall
