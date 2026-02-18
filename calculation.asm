# calculation.asm program
# For CMPSC 64
#
# Don't forget to:
#   make all arguments to any function go in $a0, $a1, $a2
#   make all returned values from functions go in $v0

.text
conv:
    # CODE MISSING: Student to complete this part
    # z
    li $t0, 0
    # x
    move $t1, $a0
    # y
    move $t2, $a1
    # n
    move $t3, $a2
    li $t4, 0

loop_check:
    bge $t4, $t3, done

loop:
    #do the calculation
    sll $t5, $t2, 2
    add $t0, $t0, $t5
    sub $t0, $t0, $t1

    slti $t6, $t1, 2          # t6 = (x < 2)
    bne  $t6, $zero, skip_suby  
    sub $t2, $t2, $t1

skip_suby:

    addi $t1, $t1, 1
    addi $t4, $t4, 1
    j loop_check

done:
    move $v0, $t0
    jr $ra
    
main:  # DO NOT MODIFY THE MAIN SECTION
    li $a0, 5
    li $a1, 7
    li $a2, 7

    jal conv

    move $a0, $v0
    li $v0, 1
    syscall

    li $v0, 10
    syscall