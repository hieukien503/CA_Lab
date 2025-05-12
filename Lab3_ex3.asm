.data
    fin: .asciiz "raw_input.txt"
    fout: .asciiz "formatted_result.txt"
    buffer: .space 5000
    student_info: .asciiz "------ Student personal information ------\n"
    name: .asciiz "Name: "
    id: .asciiz "ID: "
    address: .asciiz "Address: "
    age: .asciiz "Age: "
    religion: .asciiz "Religion: "
    new_line: .asciiz "\n"

.align 2
    length: .word 20

.text
    li $v0 13
    la $a0 fin
    li $a1 0
    li $a2 0
    syscall

    move $s0 $v0

    li $t0 0

read_loop:
    li $v0 14
    move $a0 $s0
    la $a1 buffer
    add $a1 $a1 $t0
    li $a2 1
    syscall
    blez $v0 end_loop
    addi $t0 $t0 1
    j read_loop

end_loop:
    la $a0 buffer
    add $a0 $a0 $t0
    sb $0 0($a0)
    li $v0 16
    move $a0 $s0
    syscall

    li $t0 0    # For iterating through the buffer
    li $t1 0    # 0: name, 1: id, 2: address, 3: age, 4: religion
    li $t2 0    # For storing the index of character right after comma

process_input:
    la $a0 buffer
    add $a0 $a0 $t0
    lb $s0 0($a0)
    beq $s0 $0 substr
    beq $s0 44 substr
    j next_char

next_char:
    addi $t0 $t0 1
    j process_input

change_id:
    addi $t1 $t1 1
    addi $t2 $t9 1
    j next_char

substr:
    sub $t3 $t0 $t2
    la $a1 length
    sll $t1 $t1 2
    add $a1 $a1 $t1
    sw $t3 0($a1)
    srl $t1 $t1 2

    li $s0 0
    beq $t1 $s0 append_name
    li $s0 1
    beq $t1 $s0 append_id
    li $s0 2
    beq $t1 $s0 append_address
    li $s0 3
    beq $t1 $s0 append_age
    li $s0 4
    beq $t1 $s0 append_religion
    j change_id

append_name:
    li $v0 9
    add $a0 $0 $t3
    syscall
    move $t4 $v0
    move $s2 $t4
    add $s0 $0 $t2
    add $t9 $t2 $t3

loop_name:
    beq $s0 $t9 end_loop_name
    la $a0 buffer
    add $a0 $a0 $s0
    lb $s1 0($a0)
    sb $s1 0($s2)
    addi $s0 $s0 1
    addi $s2 $s2 1
    j loop_name

end_loop_name:
    sb $0 0($s2)
    j change_id

append_id:
    li $v0 9
    add $a0 $0 $t3
    syscall
    move $t5 $v0
    move $s2 $t5
    add $s0 $0 $t2
    add $t9 $t2 $t3

loop_id:
    beq $s0 $t9 end_loop_id
    la $a0 buffer
    add $a0 $a0 $s0
    lb $s1 0($a0)
    sb $s1 0($s2)
    addi $s0 $s0 1
    addi $s2 $s2 1
    j loop_id

end_loop_id:
    sb $0 0($s2)
    j change_id

append_address:
    li $v0 9
    add $a0 $0 $t3
    syscall
    move $t6 $v0
    move $s2 $t6
    add $s0 $0 $t2
    add $t9 $t2 $t3

loop_address:
    beq $s0 $t9 end_loop_address
    la $a0 buffer
    add $a0 $a0 $s0
    lb $s1 0($a0)
    sb $s1 0($s2)
    addi $s0 $s0 1
    addi $s2 $s2 1
    j loop_address

end_loop_address:
    sb $0 0($s2)
    j change_id

append_age:
    li $v0 9
    add $a0 $0 $t3
    syscall
    move $t7 $v0
    move $s2 $t7
    add $s0 $0 $t2
    add $t9 $t2 $t3

loop_age:
    beq $s0 $t9 end_loop_age
    la $a0 buffer
    add $a0 $a0 $s0
    lb $s1 0($a0)
    sb $s1 0($s2)
    addi $s0 $s0 1
    addi $s2 $s2 1
    j loop_age

end_loop_age:
    sb $0 0($s2)
    j change_id

append_religion:
    li $v0 9
    add $a0 $0 $t3
    syscall
    move $t8 $v0
    move $s2 $t8
    add $s0 $0 $t2
    add $t9 $t2 $t3

loop_religion:
    beq $s0 $t9 append_all
    la $a0 buffer
    add $a0 $a0 $s0
    lb $s1 0($a0)
    sb $s1 0($s2)
    addi $s0 $s0 1
    addi $s2 $s2 1
    j loop_religion
    
append_all:
    sb $0 0($s2)
    j write_to_file

write_to_file:
    li $v0 13
    la $a0 fout
    li $a1 1
    li $a2 0
    syscall

    move $s0 $v0

    li $v0 15
    move $a0 $s0
    la $a1 student_info
    li $a2 43
    syscall

    li $v0 15
    move $a0 $s0
    la $a1 name
    li $a2 6
    syscall

    li $v0 15
    move $a0 $s0
    move $a1 $t4
    la $s1 length
    lw $a2 0($s1)
    syscall

    li $v0 15
    move $a0 $s0
    la $a1 new_line
    li $a2 1
    syscall

    li $v0 15
    move $a0 $s0
    la $a1 id
    li $a2 4
    syscall

    li $v0 15
    move $a0 $s0
    move $a1 $t5
    la $s1 length
    lw $a2 4($s1)
    syscall

    li $v0 15
    move $a0 $s0
    la $a1 new_line
    li $a2 1
    syscall
    
    li $v0 15
    move $a0 $s0
    la $a1 address
    li $a2 9
    syscall
    
    li $v0 15
    move $a0 $s0
    move $a1 $t6
    la $s1 length
    lw $a2 8($s1)
    syscall

    li $v0 15
    move $a0 $s0
    la $a1 new_line
    li $a2 1
    syscall
    
    li $v0 15
    move $a0 $s0
    la $a1 age
    li $a2 5
    syscall
    
    li $v0 15
    move $a0 $s0
    move $a1 $t7
    la $s1 length
    lw $a2 12($s1)
    syscall

    li $v0 15
    move $a0 $s0
    la $a1 new_line
    li $a2 1
    syscall
    
    li $v0 15
    move $a0 $s0
    la $a1 religion
    li $a2 10
    syscall
    
    li $v0 15
    move $a0 $s0
    move $a1 $t8
    la $s1 length
    lw $a2 16($s1)
    syscall
    
    li $v0 16
    move $a0 $s0
    syscall

print_result:
    la $a0 student_info
    li $v0 4
    syscall

    la $a0 name
    li $v0 4
    syscall

    move $a0 $t4
    li $v0 4
    syscall

    la $a0 new_line
    li $v0 4
    syscall
    
    la $a0 id
    li $v0 4
    syscall

    move $a0 $t5
    li $v0 4
    syscall 

    la $a0 new_line
    li $v0 4
    syscall
    
    la $a0 address
    li $v0 4
    syscall

    move $a0 $t6
    li $v0 4
    syscall

    la $a0 new_line
    li $v0 4
    syscall

    la $a0 age
    li $v0 4
    syscall

    move $a0 $t7
    li $v0 4
    syscall

    la $a0 new_line
    li $v0 4
    syscall

    la $a0 religion
    li $v0 4
    syscall

    move $a0 $t8
    li $v0 4
    syscall

    li $v0 10
    syscall
