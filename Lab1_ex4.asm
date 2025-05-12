.data
	result: .asciiz "Its binary form is: "
	attempt: .asciiz "Please enter a positive integer less than 16: "
	buffer: .space 5 # max number 15 -> 1111 (only need 4 bits + null terminator)
.text
loop:
	la $a0 attempt
	li $v0 4
	syscall
	
	li $v0 5
	syscall
	
	sgt $t1 $v0 0
	li $t0 16
	slt $t2 $v0 $t0
	and $t1 $t1 $t2
	
	bne $t1 1 loop

	move $t0 $v0
	la $s0 buffer
	li $t2 0 # length of buffer
	
dec2bin:
	beq $t0 0 rev_str
	andi $t1 $t0 1
	srl $t0 $t0 1
	addi $t1 $t1 48
	sb $t1 0($s0)
	addi $s0 $s0 1
	addi $t2 $t2 1
	j dec2bin
	
rev_str:
	addi $s0 $s0 1
	sb $0 0($s0)
	la $s0 buffer
	addi $t2 $t2 -1
	add $s0 $s0 $t2
	la $s1 buffer
	
rev_loop:
	bge $s1 $s0 exit
	lb $t1 0($s0)
	lb $t2 0($s1)
	sb $t1 0($s1)
	sb $t2 0($s0)
	subi $s0 $s0 1
	addi $s1 $s1 1
	j rev_loop
	
exit:
	la $a0 result
	li $v0 4
	syscall 
	
	la $a0 buffer
	li $v0 4
	syscall
	
	li $v0 10
    syscall