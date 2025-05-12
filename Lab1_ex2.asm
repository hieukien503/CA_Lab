.data
	promt1: .asciiz "Please input element "
	colon: .asciiz ": "
	promt2: .asciiz "Please enter index: "
.align 2
	array: .space 20
.text
	li $t0 0
	la $t1 array
	move $t2 $t1 # Store the base address of `array` for later uses
	
loop:
	la $a0 promt1
	li $v0 4
	syscall
	
	move $a0 $t0
	li $v0 1
	syscall
	
	la $a0 colon
	li $v0 4
	syscall
	
	li $v0 5
	syscall
	
	sw $v0 0($t1)
	addi $t1 $t1 4 # Move to next position x 4 bytes
	addi $t0 $t0 1
	bne $t0 5 loop
	
exit:
	la $a0 promt2
	li $v0 4
	syscall
	
	li $v0 5
	syscall
	
	li $t0 0
	
find_value:
	beq $t0 $v0 exit_find_value
	addi $t0 $t0 1
	j find_value

exit_find_value:
	sll $t0 $t0 2 # Jump to the index x 4 bytes
	add $t2 $t2 $t0 # Move to the address at index
	lw $a0 0($t2)
	li $v0 1
	syscall
	
	li $v0 10
    syscall
