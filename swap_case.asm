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
# YOU CAN ONLY MODIFY THIS FILE FROM THIS POINT ONWARDS:
SwapCase:
    # Prolouge: Save $ra and preserved registers to stack
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    move $s0, $a0        # Copy base address to $s0 (preserved across calls)

loop:
    lb $s1, 0($s0)       # Load current character
    beq $s1, $zero, done # If null terminator, exit loop
    
    # Check if character is a letter [A-Z] or [a-z]
    li $t0, 'A'
    blt $s1, $t0, skip_char
    li $t0, 'Z'
    ble $s1, $t0, is_letter
    
    li $t0, 'a'
    blt $s1, $t0, skip_char
    li $t0, 'z'
    bgt $s1, $t0, skip_char

is_letter:
    # Step 2: Print current character
    move $a0, $s1
    li $v0, 11           
    syscall
    
    la $a0, newline      
    li $v0, 4
    syscall

    # Step 3: Swap case and print new character
    # Toggle 5th bit (0x20) to switch between upper and lower case
    xori $s1, $s1, 0x20
    sb $s1, 0($s0)       # Update string in memory
    
    move $a0, $s1        
    li $v0, 11
    syscall
    
    la $a0, newline      
    li $v0, 4
    syscall

    # Step 4: Call ConventionCheck
    jal ConventionCheck

skip_char:
    addi $s0, $s0, 1     # Increment string pointer
    j loop

done:
    # Epilogue: Restore registers and stack pointer
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    
    # Do not remove the "jr $ra" line below!!!
    jr $ra