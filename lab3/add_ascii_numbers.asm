# File:		add_ascii_numbers.asm
# Author:	K. Reek
# Contributors:	P. White, W. Carithers
#		Nicholas Graca
#
# Updates:
#		3/2004	M. Reek, named constants
#		10/2007 W. Carithers, alignment
#		09/2009 W. Carithers, separate assembly
#
# Description:	Add two ASCII numbers and store the result in ASCII.
#
# Arguments:	a0: address of parameter block.  The block consists of
#		four words that contain (in this order):
#
#			address of first input string
#			address of second input string
#			address where result should be stored
#			length of the strings and result buffer
#
#		(There is actually other data after this in the
#		parameter block, but it is not relevant to this routine.)
#
# Returns:	The result of the addition, in the buffer specified by
#		the parameter block.
#

	.globl	add_ascii_numbers

add_ascii_numbers:
A_FRAMESIZE = 40

#
# Save registers ra and s0 - s7 on the stack.
#
	addi 	$sp, $sp, -A_FRAMESIZE
	sw 	$ra, -4+A_FRAMESIZE($sp)
	sw 	$s7, 28($sp)
	sw 	$s6, 24($sp)
	sw 	$s5, 20($sp)
	sw 	$s4, 16($sp)
	sw 	$s3, 12($sp)
	sw 	$s2, 8($sp)
	sw 	$s1, 4($sp)
	sw 	$s0, 0($sp)
	
# ##### BEGIN STUDENT CODE BLOCK 1 #####
        lw      $t1, 0($a0)             #digit one is in t1
        la      $a1, 0($a0)
        lw      $t2, 4($a0)             #digit two is in t2
        la      $a2, 4($a0)
        lw      $t3, 8($a0)             #address of result in t3
        move    $s5, $t3
        lw      $t4, 12($a0)            #length of strings in t4
        move    $s1, $t4                #s1 hold the place in the number to add
        j       getDigit1

math:
        beq     $t4, $zero, done
        lb      $s2, 0($t1)
        lb      $s3, 0($t2)
        add     $s4, $s2, $s3
        li      $t5, -48
        add     $s4, $s4, $t5
        li      $t5 , 58
        slt     $t5, $s4, $t5
        beq     $t5, $zero, carry       #check if you need to carry
        j       moreMath

moreMath:
        sb      $s4, 0($t3)             #put the digit in the result
        la      $t3, -1($t3)            #move all the pointers over
        la      $t1, -1($t1)            #^
        la      $t2, -1($t2)            #^
        add     $t4, $t4, $t6           #decrement the counter
        j       math

carry:
        li      $t5, -10
        add     $s4, $s4, $t5           #make the number what it should be
        la      $s6, -1($t1)
        lb      $s2, 0($s6)
        li      $t5, 1
        add     $s2, $s2, $t5           #add one to the next spot over
        sb      $s2, 0($s6)
        j       moreMath       

getDigit1:
        beq     $t4, $zero, storeDigit1
        li      $t6, -1
        add     $t4, $t4, $t6
        la      $t1, 1($t1)             #t1 has address of last byte in d1
        la      $t3, 1($t3)
        j       getDigit1

getDigit2:
        beq     $t4, $zero, storeDigit2
        li      $t6, -1
        add     $t4, $t4, $t6
        la      $t2, 1($t2)             #t2 is at the last spot in the digit
        la      $t3, 1($t3)             #t3 is at the last spot in the result
        j       getDigit2       

storeDigit1:
        move    $t4, $s1
        move    $t3, $s5
        j       getDigit2

storeDigit2:
        move    $t4, $s1
        la      $t3, -1($t3)            #put the pointers at the last digit
        la      $t1, -1($t1)            #^
        la      $t2, -1($t2)            #^
        j       math

done:
# ###### END STUDENT CODE BLOCK 1 ######

#
# Restore registers ra and s0 - s7 from the stack.
#
	lw 	$ra, -4+A_FRAMESIZE($sp)
	lw 	$s7, 28($sp)
	lw 	$s6, 24($sp)
	lw 	$s5, 20($sp)
	lw 	$s4, 16($sp)
	lw 	$s3, 12($sp)
	lw 	$s2, 8($sp)
	lw 	$s1, 4($sp)
	lw 	$s0, 0($sp)
	addi 	$sp, $sp, A_FRAMESIZE

	jr	$ra			# Return to the caller.
