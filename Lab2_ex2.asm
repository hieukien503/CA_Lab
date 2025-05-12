.data
    print_a: .asciiz "a = "
    print_b: .asciiz "b = "
    print_gcd: .asciiz "GCD = "
    print_lcm: .asciiz ", LCM = "

.text
    la $a0 print_a
    li $v0 4
    syscall

    li $v0 5
    syscall
    move $s0 $v0

    la $a0 print_b
    li $v0 4
    syscall

    li $v0 5
    syscall
    move $s1 $v0
    
    la $a0 print_gcd
    li $v0 4
    syscall
    
    jal gcd
    move $a0 $v0
    move $t1 $v0

    li $v0 1
    syscall

    la $a0 print_lcm
    li $v0 4
    syscall
    
    mul $t0 $s0 $s1
    div $t0 $t1
    mflo $a0
    
    li $v0 1
    syscall

    li $v0, 10 #exit
    syscall

gcd:
    beqz $s1 exit_b
    
    addi $sp $sp -12
    sw $ra 8($sp)
    sw $s0 4($sp)
    sw $s1 0($sp)
    
    move $t0 $s0
    move $s0 $s1
    rem $s1 $t0 $s1
    jal gcd
    
    lw $s0 0($sp)
    lw $s1 4($sp)
    lw $ra 8($sp)
    addi $sp $sp 12
    
    jr $ra

exit_b:
    move $v0 $s0
    jr $ra