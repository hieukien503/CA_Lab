.data:
    prompt: .asciiz "Please insert a element:\n"
    value: .asciiz "Second largest value is "
    index: .asciiz ", found in index "
    string: .space 32

.align 2
    arr: .space 40

.text:
    la $a0 prompt
    li $v0 4
    syscall

    li $t0 0
    la $a1 arr

loop:
    beq $t0 10 exit_input
    li $v0 5
    syscall

    sw $v0 0($a1)
    addi $t0 $t0 1
    addi $a1 $a1 4
    j loop

exit_input:
    la $a0 arr
    lw $t0 0($a0)  # fmax = arr[0]
    move $t1 $t0   # smax = arr[0]
    li $t2 1
    addi $a0 $a0 4

second_large:
    beq $t2 10 exit_second_large
    lw $t3 0($a0)
    slt $t4 $t0 $t3
    beq $t4 1 assign_fmax
    slt $t4 $t1 $t3
    beq $t4 1 assign_smax
    j next_elem

assign_fmax:
    move $t1 $t0    # Update smax
    move $t0 $t3
    j next_elem

assign_smax:
    slt $t4 $t0 $t3
    beq $t4 0 update_second_max
    j next_elem

update_second_max:
    move $t1 $t3
    
next_elem:
    addi $t2 $t2 1
    addi $a0 $a0 4
    j second_large

exit_second_large:
    la $a0 value
    li $v0 4
    syscall

    move $a0 $t1
    li $v0 1
    syscall

    la $a0 index
    li $v0 4
    syscall

    la $a1 arr
    li $t0 0
    li $t3 0

find_index:
    beq $t0 10 exit_find_index
    lw $t2 0($a1)
    beq $t2 $t1 append_string
    j next_index

append_string:
    la $a0 string
    add $a0 $a0 $t3
    addi $t4 $t0 48
    sb $t4 0($a0)
    addi $t4 $0 44
    addi $t3 $t3 1
    addi $a0 $a0 1
    sb $t4 0($a0)
    addi $t4 $0 32
    addi $t3 $t3 1
    addi $a0 $a0 1
    sb $t4 0($a0)
    addi $t3 $t3 1
    j next_index

next_index:
    addi $t0 $t0 1
    addi $a1 $a1 4
    j find_index

exit_find_index:
    addi $a0 $a0 -1
    sb $0 0($a0)

    la $a0 string
    li $v0 4
    syscall

    li $v0 10
    syscall