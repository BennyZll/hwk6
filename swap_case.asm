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
    addiu $sp, $sp, -8
    sw    $ra, 4($sp)
    sw    $s0, 0($sp)
    move  $s0, $a0         

Loop:
    lb    $t0, 0($s0)     
    beq   $t0, $zero, Done 
    sll   $zero, $zero, 0  
    li    $t1, 'a'
    li    $t2, 'z'
    blt   $t0, $t1, CheckUpper
    sll   $zero, $zero, 0
    bgt   $t0, $t2, CheckUpper
    sll   $zero, $zero, 0

    addiu $t3, $t0, -32     # lower -> upper
    j     DoLetter
    sll   $zero, $zero, 0

CheckUpper:
    li    $t1, 'A'
    li    $t2, 'Z'
    blt   $t0, $t1, NextChar
    sll   $zero, $zero, 0
    bgt   $t0, $t2, NextChar
    sll   $zero, $zero, 0

    addiu $t3, $t0, 32      # upper -> lower

DoLetter:
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

    # store swapped char back into string
    sb    $t3, 0($s0)

    # call ConventionCheck (must preserve $ra for nested call)
    jal   ConventionCheck
    sll   $zero, $zero, 0

NextChar:
    addiu $s0, $s0, 1
    j     Loop
    sll   $zero, $zero, 0

Done:
    # --- epilogue: restore saved regs ---
    lw    $s0, 0($sp)
    lw    $ra, 4($sp)
    addiu $sp, $sp, 8

    # Do not remove the "jr $ra" line below!!!
    # It should be the last line in your function code!
    jr $ra
