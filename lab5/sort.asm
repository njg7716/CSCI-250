#
# FILE:         $File$
# AUTHOR:       Phil White, RIT 2016
# CONTRIBUTORS:
#		W. Carithers
#		Nicholas Graca
#
# DESCRIPTION:
#	This program is an implementation of merge sort in MIPS
#	assembly 
#
# ARGUMENTS:
#	None
#
# INPUT:
# 	The numbers to be sorted.  The user will enter a 9999 to
#	represent the end of the data
#
# OUTPUT:
#	A "before" line with the numbers in the order they were
#	entered, and an "after" line with the same numbers sorted.
#
# REVISION HISTORY:
#	Aug  08		- P. White, original version
#

#-------------------------------

#
# Numeric Constants
#

PRINT_STRING = 4
PRINT_INT = 1

#-------------------------------

#

# ********** BEGIN STUDENT CODE BLOCK 1 **********

#
# Make sure to add any .globl that you need here
#
        .globl  merge
# Name:         sort
# Description:  sorts an array of integers using the merge sort
#		algorithm
# 		Arguments Note: a1 and a2 specify the range inclusively
#
# Arguments:    a0:     a parameter block containing 3 values
#                       - the address of the array to sort
#                       - the address of the scrap array needed by merge
#                       - the address of the compare function to use
#                         when ordering data
#               a1:     the index of the first element in the range to sort
#               a2:     the index of the last element in the range to sort
# Returns:      none
#
sort:

        move    $s1, $a1
        move    $s2, $a2
        addi    $sp, $sp, -12   #allocate room on stack
        sw      $s1, 0($sp)
        sw      $s2, 4($sp)
        sw      $ra, 8($sp)
        sub     $t0, $a2, $a1
        slti    $t1, $t0, 2
        bne     $t1, $zero, done #if the size is trivial, return
        li      $t1, 2
        div     $s3, $a2, $t1   #get middle
        move    $a3, $s3        #middle of array to pass to merge
        move    $a2, $s3        #make lower half range
        jal     sort            #Where the black magic happens
        lw      $s1, 0($sp)     #restore local vars from stack
        lw      $s2, 4($sp)
        lw      $ra, 8($sp)
        move    $a2, $s2        #make upper half range
        move    $a1, $s3
        jal     sort            #more black magic
        lw      $s1, ($sp)     #restore from stack
        lw      $s2, 4($sp)
        lw      $ra, 8($sp)
        addi    $sp, $sp, 12
        j       merge           #call merge function

done:
        jr      $ra
# ********** END STUDENT CODE BLOCK 1 **********
#
# End of Merge sort routine.
#
