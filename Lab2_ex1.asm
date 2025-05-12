.data
    promt: .asciiz "Enter a string: "
    buffer: .space 1000
    result: .space 1000
.align 2
    freq: .space 380
    indices: .space 380

.text
    li $v0 8
    la $a0 buffer
    li $a1 1000
    syscall

    la $a0 buffer

calc_freq:
    lb $t0 0($a0)
    beq $t0 10 bubble_sort
    addi $t0 $t0 -32
    sll $t0 $t0 2
    la $a1 freq
    la $a2 indices
    add $a1 $a1 $t0
    add $a2 $a2 $t0
    lw $t1 0($a1)
    addi $t1 $t1 1
    sw $t1 0($a1)
    srl $t0 $t0 2
    sw $t0 0($a2)
    addi $a0 $a0 1
    j calc_freq

bubble_sort:
    li $t0 0

outloop:
    beq $t0 95 endloop
    li $t1 0

innerloop:
    beq $t1 94 nextouterloop
    sll $t2 $t1 2
    la $a0 freq
    add $a0 $a0 $t2
    lw $t2 0($a0)
    addi $t3 $t1 1
    sll $t3 $t3 2
    la $a0 freq
    add $a0 $a0 $t3
    lw $t3 0($a0)
    bgt $t2 $t3 swap
    j nextinnerloop

swap:
    la $a0 freq
    sll $t4 $t1 2
    add $a0 $a0 $t4
    sw $t3 0($a0)
    addi $t4 $t1 1
    sll $t4 $t4 2
    la $a0 freq
    add $a0 $a0 $t4
    sw $t2 0($a0)

    la $a0 indices
    sll $t4 $t1 2
    add $a0 $a0 $t4
    lw $t2 0($a0)
    addi $t4 $t1 1
    sll $t4 $t4 2
    la $a0 indices
    add $a0 $a0 $t4
    lw $t3 0($a0)
    sw $t2 0($a0)
    la $a0 indices
    sll $t4 $t1 2
    add $a0 $a0 $t4
    sw $t3 0($a0)
    j nextinnerloop

nextinnerloop:
    addi $t1 $t1 1
    j innerloop

nextouterloop:
    addi $t0 $t0 1
    j outloop

endloop:
    la $a0 result
    la $a1 freq
    la $a2 indices
    li $t0 0

append_result:
    beq $t0 95 endappend
    lw $t1 0($a1)
    lw $t2 0($a2)
    beqz $t2 nextappend
    j appendchar

appendchar:
    addi $t2 $t2 32
    sb $t2 0($a0)
    li $t2 44
    sb $t2 1($a0)
    li $t2 32
    sb $t2 2($a0)
    addi $t1 $t1 48
    sb $t1 3($a0)
    li $t2 59
    sb $t2 4($a0)
    li $t2 32
    sb $t2 5($a0)
    addi $a0 $a0 6
    j nextappend

nextappend:
    addi $a1 $a1 4
    addi $a2 $a2 4
    addi $t0 $t0 1
    j append_result

endappend:
    addi $a0 $a0 -2
    sb $0 0($a0)
    la $a0 result
    li $v0 4
    syscall

    li $v0 10
    syscall
