# swap_case.asm program
# For CMPSC 64
#
# Data Area
.data
    buffer:         .space 100
    input_prompt:   .asciiz "Enter string:\n"
    output_prompt:  .asciiz "Output:\n"
    convention:     .asciiz "Convention Check\n"
    newline:        .asciiz "\n"

.text

#
# DO NOT MODIFY THE MAIN PROGRAM 
#       OR ANY OF THE CODE BELOW, WITH 1 EXCEPTION!!!
# YOU SHOULD ONLY MODIFY THE SwapCase FUNCTION 
#       AT THE BOTTOM OF THIS CODE
#
main:
    la $a0, input_prompt    # prompt user for string input
    li $v0, 4
    syscall

    li $v0, 8       # take in input
    la $a0, buffer
    li $a1, 100
    syscall
    move $s0, $a0   # save string to s0

    li $s1, 0
    li $s2, 0
    li $s3, 0
    li $s4, 0
    li $s5, 0
    li $s6, 0
    li $s7, 0

    move $a0, $s0
    jal SwapCase

    add $s1, $s1, $s2
    add $s1, $s1, $s3
    add $s1, $s1, $s4
    add $s1, $s1, $s5
    add $s1, $s1, $s6
    add $s1, $s1, $s7
    add $s0, $s0, $s1

    la $a0, output_prompt    # give Output prompt
    li $v0, 4
    syscall

    move $a0, $s0
    jal DispString

    j Exit

DispString:
    addi $a0, $a0, 0
    li $v0, 4
    syscall
    jr $ra

ConventionCheck:
    addi    $t0, $zero, -1
    addi    $t1, $zero, -1
    addi    $t2, $zero, -1
    addi    $t3, $zero, -1
    addi    $t4, $zero, -1
    addi    $t5, $zero, -1
    addi    $t6, $zero, -1
    addi    $t7, $zero, -1
    ori     $v0, $zero, 4
    la      $a0, convention
    syscall
    addi    $v0, $zero, -1
    addi    $v1, $zero, -1
    addi    $a0, $zero, -1
    addi    $a1, $zero, -1
    addi    $a2, $zero, -1
    addi    $a3, $zero, -1
    addi    $k0, $zero, -1
    addi    $k1, $zero, -1
    jr      $ra
    
Exit:
    li $v0, 10
    syscall

# COPYFROMHERE - DO NOT REMOVE THIS LINE

# YOU CAN ONLY MODIFY THIS FILE FROM THIS POINT ONWARDS:
SwapCase:

    addiu $sp, $sp, -16
    sw    $ra, 12($sp)
    sw    $s0,  8($sp)

    move  $s0, $a0          # s0 = pointer to current char

loop:
    lb    $t0, 0($s0)       # t0 = current character (byte)
    beq   $t0, $zero, done  # if '\0' end

    # check 'a'..'z'
    li    $t1, 'a'
    li    $t2, 'z'
    blt   $t0, $t1, check_upper
    bgt   $t0, $t2, check_upper

    # lowercase -> uppercase
    addiu $t3, $t0, -32     # swapped char in t3
    j     do_letter

check_upper:
    # check 'A'..'Z'
    li    $t1, 'A'
    li    $t2, 'Z'
    blt   $t0, $t1, next_char
    bgt   $t0, $t2, next_char

    # uppercase -> lowercase
    addiu $t3, $t0, 32      # swapped char in t3

do_letter:
    # print original char
    li    $v0, 11
    move  $a0, $t0
    syscall

    # print newline
    li    $v0, 11
    li    $a0, '\n'
    syscall

    # print swapped char
    li    $v0, 11
    move  $a0, $t3
    syscall

    # print newline
    li    $v0, 11
    li    $a0, '\n'
    syscall

    # store swapped char back
    sb    $t3, 0($s0)


    jal   ConventionCheck

next_char:
    addiu $s0, $s0, 1
    j     loop

done:

    lw    $s0,  8($sp)
    lw    $ra, 12($sp)
    addiu $sp, $sp, 16

    
    # Do not remove the "jr $ra" line below!!!
    # It should be the last line in your function code!
    jr $ra
