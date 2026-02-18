# print_array.asm program
# For CMPSC 64
#
# Don't forget to:
#   make all arguments to any function go in $a0, $a1
#   make all returned values from functions go in $v0

# Example array and alen - your code should work for any integer array of any length > 1.
.data
    array:  .word 6, 4, 0, 1, 2, 9, 3, 5, 8, 7
    alen:   .word 10
    newline: .asciiz "\n"
    space:  .asciiz " "

.text
bubble:
	# CODE MISSING: Student to complete this part
    # array
    move $t0, $a0
    # alen
    lw $t1, 0($a1)
    #i
    addi $t2, $t1, -1

outLoop:
    blt $t2, $zero, done
    li $t3, 1

inLoop:
    bgt $t3, $t2, next_i

    # compute address of array[j-1]
    sll $t5, $t3, 2
    add $t5, $t5, $t0

    addi $t6, $t3, -1
    sll $t6, $t6, 2
    add $t6, $t6, $t0

    lw $t7, 0($t6)
    lw $t8, 0($t5)

    ble $t7, $t8, skip_swap

    move $t4, $t7
    sw $t8, 0($t6)
    sw $t4, 0($t5)

skip_swap:
    addi $t3, $t3, 1
    j inLoop

next_i:
    addi $t2, $t2, -1
    j outLoop

done:
    jr $ra

printArray:
	# CODE MISSING: Student to complete this part
    move $t0, $a0
    lw $t1, 0($a1)
    li $t2, 0

print_loop:
    bge  $t2, $t1, print_done   # if i >= size stop

    # compute address array[i]
    sll  $t3, $t2, 2      # i * 4
    add  $t3, $t3, $t0    # base + offset

    lw   $t4, 0($t3)      # load array[i]

    # print integer
    move $a0, $t4
    li   $v0, 1
    syscall

    # print space
    la   $a0, space
    li   $v0, 4
    syscall

    addi $t2, $t2, 1      # i++
    j print_loop

print_done:
    # print newline
    la   $a0, newline
    li   $v0, 4
    syscall
    jr $ra

main:
    la $a0, array
    la $a1, alen
    jal printArray

    la $a0, array
    la $a1, alen
    jal bubble

    la $a0, array
    la $a1, alen
    jal printArray

    li $v0, 10
    syscall	