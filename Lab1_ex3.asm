.data
	a: .asciiz "Insert a: "
	b: .asciiz "Insert b: "
	c: .asciiz "Insert c: "
	d: .asciiz "Insert d: "
	F: .asciiz "F = "
	remainder: .asciiz ", remainder = "
.text
	la $a0 a
	li $v0 4
	syscall
	
	li $v0 5
	syscall
	move $t0 $v0
	
	la $a0 b
	li $v0 4
	syscall
	
	li $v0 5
	syscall
	move $t1 $v0
	
	la $a0 c
	li $v0 4
	syscall
	
	li $v0 5
	syscall
	move $t2 $v0
	
	la $a0 d
	li $v0 4
	syscall
	
	li $v0 5
	syscall
	move $t3 $v0
	
	add $s0 $t0 $t1
	add $s0 $s0 $t2
	
	addi $t4 $t0 10
	sub $t1 $t1 $t3
	sll $t0 $t0 1
	sub $t2 $t2 $t0
	
	mul $t0 $t4 $t1
	mul $t0 $t0 $t2
	div $t0 $s0
	
	la $a0 F
	li $v0 4
	syscall
	
	mflo $a0
	li $v0 1
	syscall
	
	la $a0 remainder
	li $v0 4
	syscall
	
	mfhi $a0
	li $v0 1
	syscall

    li $v0 10
    syscall