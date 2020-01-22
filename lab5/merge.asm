#
# FILE:         $File$
# AUTHOR:       Phil White, RIT 2016
#               
# CONTRIBUTORS:
#		Nicholas Graca
#
# DESCRIPTION:
#	This file contains the merge function of mergesort
#

#-------------------------------

#
# Numeric Constants
#

PRINT_STRING = 4
PRINT_INT = 1


#***** BEGIN STUDENT CODE BLOCK 2 ***************************


#
# Make sure to add any .globl that you need here
#
        .globl  sort
#
# Name:         merge
# Description:  takes two individually sorted areas of an array and
#		merges them into a single sorted area
#
#		The two areas are defined between (inclusive)
#		area1:	low   - mid
#		area2:	mid+1 - high
#
#		Note that the area will be contiguous in the array
#
# Arguments:    a0:     a parameter block containing 3 values
#			- the address of the array to sort
#			- the address of the scrap array needed by merge
#			- the address of the compare function to use
#			  when ordering data
#               a1:     the index of the first element of the area
#               a2:     the index of the last element of the area
#               a3:     the index of the middle element of the area
# Returns:      none
# Destroys:     t0,t1
#
merge:
        lw      $s0, 0($a0)             #s0 is the beginning of first array
        lw      $s1, 4($a0)             #s1 is the beginning of scrap array
        lw      $s2, 8($a0)             #s2 is compare function
        li      $t1, 4
        mult    $t1, $a3
        mflo    $t1
        add     $s3, $s0, $t1           #s3 is at beginning of second array
        addi    $s3, $s3, 4
        move    $s4, $a1                #current position in the first array
        move    $s5, $a3                #s5 is the counter array 2
        addi    $s5, $s5, 1             #current position in second array
        move    $s6, $a2
        move    $s7, $ra
        move    $t6, $a1                #save the indexes
        move    $t7, $a2
        j       while

while:
        slt     $t0, $a3, $s4
        bne     $t0, $zero, emptysecond #if subarray 1 is empty, empty array 2
        slt     $t0, $t7, $s5
        bne     $t0, $zero, emptyfirst  #if subarray 2 is empty, empty array 1
        lw      $a0, 0($s0)
        lw      $a1, 0($s3)   
        addi    $sp, $sp, -12
        sw      $t6, 0($sp)
        sw      $t7, 4($sp)
        sw      $ra, 8($sp)
        jalr    $s2                     #compare function
        lw      $t6, 0($sp)
        lw      $t7, 4($sp)
        lw      $ra, 8($sp)
        beq     $v0, $zero, second
        sw      $a0, 0($s1)             #put a0 in scrap array
        addi    $s1, $s1, 4
        addi    $s0, $s0, 4
        addi    $s4, $s4, 1
        j       while        

second:                                 #put a1 in scrap array
        sw      $a1, 0($s1)
        addi    $s1, $s1, 4
        addi    $s3, $s3, 4
        addi    $s5, $s5, 1
        j       while

emptysecond:
        slt     $t0, $t7, $s5
        bne     $t0, $zero, almost
        lw      $a1, 0($s3)
        sw      $a1, 0($s1)
        addi    $s3, $s3, 4
        addi    $s1, $s1, 4
        addi    $s5, $s5, 1
        j       emptysecond

emptyfirst:
        slt     $t0, $a3, $s4
        bne     $t0, $zero, almost
        lw      $a0, 0($s0)             #s0 cursor in first array
        sw      $a0, 0($s1)
        addi    $s1, $s1, 4
        addi    $s0, $s0, 4
        addi    $s4, $s4, 1
        j       emptyfirst

almost:
        li      $t0, -4                 #move back to beginning of array
        mult    $s6, $t0
        mflo    $t0
        add     $s0, $s0, $t0
        add     $s1, $s1, $t0
        j       copy

copy:
        slt     $t0, $t7, $t6
        bne     $t0, $zero, final
        lw      $t0, 0($s1)             #take out of scrap array
        sw      $t0, 0($s0)             #put in final array
        addi    $s1, $s1, 4             #move to next index
        addi    $s0, $s0, 4
        addi    $t6, $t6, 1
        j       copy

final:
        jr      $ra
# ********** END STUDENT CODE BLOCK 2 **********

#
# End of Merge routine.
#
