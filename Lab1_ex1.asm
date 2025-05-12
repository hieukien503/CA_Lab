.data
	greetings: .asciiz "Enter your name: "
	hello: .asciiz "Hello "
	name: .space 100 # The buffer of name is at most 100 characters
.text
	la $a0 greetings
	li $v0 4
	syscall
	
	li $v0 8
	la $a0 name
	li $a1 100
	syscall
	
	la $a0 hello
	li $v0 4
	syscall
	
	la $a0 name
	li $v0 4
	syscall

    li $v0 10
    syscall