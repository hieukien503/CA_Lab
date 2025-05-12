.data:
    player_1: .asciiz "Player 1, please input your coordinates: "
    player_2: .asciiz "Player 2, please input your coordinates: "
    tie: .asciiz "Tie!\n"
    player_1_win: .asciiz "Player 1 wins\n"
    player_2_win: .asciiz "Player 2 wins\n"
    invalid_input: .asciiz "Invalid input. Please try again.\n"
    invalid_coordinates: .asciiz "Invalid coordinates. Please try again.\n"
    occupied_space: .asciiz "The cell is already occupied. Please try again.\n"
    new_line: .asciiz "\n"
    space: .asciiz " "
    comma: .asciiz ","
    vertical_line: .asciiz "|"
    horizontal_line: .asciiz " ----------------------------- \n"
    welcome: .asciiz "Welcome to Five in a Row, a game of strategy and skill.\n"
    instructions: .asciiz "Player 1 will be X and Player 2 will be O.\n"
    instructions_2: .asciiz "Enter the coordinates of your move in the format 'row,column'.\n"
    instructions_3: .asciiz "For example, to place an X in the top-left corner, enter '0,0'.\n"
    instructions_4: .asciiz "The board is 15x15, so the coordinates range from 0 to 14.\n"
    instructions_5: .asciiz "Good luck!\n"
    file_name: .asciiz "result.txt"
    result_string: .asciiz "The final board is:\n"
    player_1_move: .asciiz "Player 1 places an X at coordinates: "
    player_2_move: .asciiz "Player 2 places an O at coordinates: "
    player_1_input_error: .asciiz "Player 1 inputs an invalid string: "
    player_2_input_error: .asciiz "Player 2 inputs an invalid string: "
    player_1_input_error_2: .asciiz "Player 1 inputs an invalid coordinate: "
    player_2_input_error_2: .asciiz "Player 2 inputs an invalid coordinate: "
    player_1_occupied_space: .asciiz "Player 1 inputs an already occupied coordinate: "
    player_2_occupied_space: .asciiz "Player 2 inputs an already occupied coordinate: "
    charX: .asciiz "X"
    charO: .asciiz "O"
    turn: .asciiz "Turn "
    colon: .asciiz ": "

    board: .space 225                               # 15x15 board
    buffer: .space 1000                             # Buffer for input

.align 2
    result: .space 8                                # Result of the input
    direction_row: .word 0, -1, -1, -1
    direction_column: .word -1, -1, 0, 1
    
.text:
    jal initialize_board

    la $a0 welcome
    li $v0 4
    syscall
    
    la $a0 instructions
    li $v0 4
    syscall

    la $a0 instructions_2
    li $v0 4
    syscall

    la $a0 instructions_3
    li $v0 4
    syscall

    la $a0 instructions_4
    li $v0 4
    syscall

    la $a0 instructions_5
    li $v0 4
    syscall

    li $t0 1                                        # 1 for player 1, 2 for player 2
    li $t1 0                                        # Loop through the board
    li $t2 0                                        # 0 for tie, 1 for player 1 win, 2 for player 2 win

    li $v0 13
    la $a0 file_name
    li $a1 1
    li $a2 0
    syscall

    move $s0 $v0

loop_start_game:
    beq $t1 225 end_game
    srl $s1 $t1 1
    addi $s1 $s1 1
    li $t3 0
    j convert_number_to_string

convert_number_to_string:
    beq $s1 0 end_convert_number_to_string
    li $t4 10
    div $s1 $t4
    mflo $s1
    mfhi $t5
    addi $t5 $t5 48
    la $t6 buffer
    add $t6 $t6 $t3
    sb $t5 0($t6)
    addi $t3 $t3 1
    j convert_number_to_string

end_convert_number_to_string:
    la $t6 buffer
    add $t6 $t6 $t3
    li $t7 10
    sb $t7 0($t6)
    li $t7 0
    addi $t3 $t3 -1
    j reverse_string

reverse_string:
    bge $t7 $t3 end_reverse_string
    la $t6 buffer
    add $t6 $t6 $t7
    lb $t8 0($t6)
    la $t6 buffer
    add $t6 $t6 $t3
    lb $t9 0($t6)
    sb $t8 0($t6)
    la $t6 buffer
    add $t6 $t6 $t7
    sb $t9 0($t6)
    addi $t3 $t3 -1
    addi $t7 $t7 1
    j reverse_string

end_reverse_string:
    jal print_board
    beq $t0 1 write_turn
    j end_write_turn

write_turn:
    li $v0 15
    move $a0 $s0
    la $a1 turn
    li $a2 5
    syscall

    jal length_of_input
    move $a2 $v0
    li $v0 15
    move $a0 $s0
    la $a1 buffer
    syscall

    li $v0 15
    move $a0 $s0
    la $a1 colon
    li $a2 2
    syscall
    
    li $v0 15
    move $a0 $s0
    la $a1 new_line
    li $a2 1
    syscall
    j end_write_turn

end_write_turn:
    beq $t0 1 player_1_turn
    beq $t0 2 player_2_turn

player_1_turn:
    la $a0 player_1
    li $v0 4
    syscall
    jal get_and_parse_input
    beqz $v0 player_1_turn
    la $t3 result
    lw $a0 0($t3)
    lw $a1 4($t3)
    li $a2 88
    jal place_piece
    beqz $v0 player_1_turn
    jal check_win
    beq $v0 1 switch_flag_player_1
    li $t0 2
    addi $t1 $t1 1
    j loop_start_game

player_2_turn:
    la $a0 player_2
    li $v0 4
    syscall
    jal get_and_parse_input
    beqz $v0 player_2_turn
    la $t3 result
    lw $a0 0($t3)
    lw $a1 4($t3)
    li $a2 79
    jal place_piece
    beqz $v0 player_2_turn
    jal check_win
    beq $v0 1 switch_flag_player_2
    li $t0 1
    addi $t1 $t1 1
    j loop_start_game

switch_flag_player_1:
    li $t2 1
    j end_game

switch_flag_player_2:
    li $t2 2
    j end_game

end_game:
    jal print_board
    beq $t2 0 print_tie
    beq $t2 1 print_player_1_win
    beq $t2 2 print_player_2_win

end_program:
    li $v0 10
    syscall

# Utility functions
length_of_input:
    addi $sp $sp -8
    sw $t3 0($sp)
    sw $t4 4($sp)
    li $t3 0

length_of_input_loop:
    la $a0 buffer
    add $a0 $a0 $t3
    lb $t4 0($a0)
    beq $t4 10 end_length_of_input
    addi $t3 $t3 1
    j length_of_input_loop

end_length_of_input:
    move $v0 $t3
    lw $t3 0($sp)
    lw $t4 4($sp)
    addi $sp $sp 8
    jr $ra

coordinates_to_indices:
    addi $sp $sp -4
    sw $t3 0($sp)
    mul $t3 $a0 15
    add $t3 $t3 $a1
    move $v0 $t3
    lw $t3 0($sp)
    addi $sp $sp 4
    jr $ra

initialize_board:
    addi $sp $sp -4
    sw $ra 0($sp)
    li $t3 0

outer_loop_initialize_board:
    beq $t3 15 end_outer_loop_initialize_board
    li $t4 0

inner_loop_initialize_board:
    beq $t4 15 end_inner_loop_initialize_board
    la $t5 board
    move $a0 $t3
    move $a1 $t4
    jal coordinates_to_indices
    add $t5 $t5 $v0
    sb $zero 0($t5)
    addi $t4 $t4 1
    j inner_loop_initialize_board

end_inner_loop_initialize_board:
    addi $t3 $t3 1
    j outer_loop_initialize_board

end_outer_loop_initialize_board:
    lw $ra 0($sp)
    addi $sp $sp 4
    jr $ra

print_board:
    addi $sp $sp -4
    sw $ra 0($sp)
    li $t3 0
outer_loop_print_board:
    beq $t3 15 end_outer_loop_print_board
    li $t4 0
    la $a0 horizontal_line
    li $v0 4
    syscall

inner_loop_print_board:
    beq $t4 15 end_inner_loop_print_board
    la $a0 vertical_line
    li $v0 4
    syscall

    move $a0 $t3
    move $a1 $t4
    jal coordinates_to_indices
    la $t6 board
    add $t6 $t6 $v0
    lb $t5 0($t6)
    beq $t5 0 print_space
    beq $t5 88 print_x
    beq $t5 79 print_o

print_space:
    la $a0 space
    li $v0 4
    syscall
    j next_column_print_board

print_x:
    li $a0 88
    li $v0 11
    syscall
    j next_column_print_board

print_o:
    li $a0 79
    li $v0 11
    syscall
    j next_column_print_board

next_column_print_board:
    addi $t4 $t4 1
    j inner_loop_print_board

end_inner_loop_print_board:
    la $a0 vertical_line
    li $v0 4
    syscall
    la $a0 new_line
    li $v0 4
    syscall
    addi $t3 $t3 1
    j outer_loop_print_board

end_outer_loop_print_board:
    la $a0 horizontal_line
    li $v0 4
    syscall
    lw $ra 0($sp)
    addi $sp $sp 4
    jr $ra

get_and_parse_input:
    addi $sp $sp -4
    sw $ra 0($sp)

    li $t3 0                                        # Index of the buffer
    li $t4 0                                        # Number of comma

    la $a0 buffer
    li $a1 1000
    li $v0 8
    syscall

check_length:
    jal length_of_input
    bgt $v0 5 warning_invalid_input
    blt $v0 3 warning_invalid_input
    li $t3 0
    li $t4 0
    j check_comma

warning_invalid_input:
    beq $t0 1 write_player_1_input_error
    j write_player_2_input_error

write_player_1_input_error:
    li $v0 15
    move $a0 $s0
    la $a1 player_1_input_error
    li $a2 35
    syscall

    jal length_of_input
    move $a2 $v0
    li $v0 15
    move $a0 $s0
    la $a1 buffer
    syscall

    li $v0 15
    move $a0 $s0
    la $a1 new_line
    li $a2 1
    syscall

    j end_write_player_input_error

write_player_2_input_error:
    li $v0 15
    move $a0 $s0
    la $a1 player_2_input_error
    li $a2 35
    syscall

    jal length_of_input
    move $a2 $v0
    li $v0 15
    move $a0 $s0
    la $a1 buffer
    syscall

    li $v0 15
    move $a0 $s0
    la $a1 new_line
    li $a2 1
    syscall

    j end_write_player_input_error

end_write_player_input_error:
    la $a0 invalid_input
    li $v0 4
    syscall

    li $v0 0
    j end_get_and_parse_input

check_comma:
    la $a0 buffer
    add $a0 $a0 $t3
    lb $t5 0($a0)
    beq $t5 10 end_check_comma
    beq $t5 44 next_check_comma
    addi $t3 $t3 1
    j check_comma

next_check_comma:
    addi $t3 $t3 1
    addi $t4 $t4 1
    j check_comma

end_check_comma:
    bne $t4 1 warning_invalid_input
    li $t3 0
    li $t4 0
    li $t6 0
    j parse_number

parse_number:
    la $a0 buffer
    add $a0 $a0 $t3
    lb $t5 0($a0)
    beq $t5 10 end_parse_number
    beq $t5 44 check_digit_both_sides
    blt $t5 48 warning_invalid_input
    bgt $t5 57 warning_invalid_input
    seq $t7 $t6 0
    seq $t8 $t5 48
    and $t9 $t7 $t8
    beq $t9 1 check_leading_zero
    mul $t6 $t6 10
    addi $t5 $t5 -48
    add $t6 $t6 $t5
    addi $t3 $t3 1
    j parse_number

check_digit_both_sides:
    beqz $t3 warning_invalid_input
    addi $a0 $a0 1
    lb $t5 0($a0)
    bne $t5 10 reset_t6
    j warning_invalid_input

check_leading_zero:
    addi $a0 $a0 1
    lb $t5 0($a0)
    beq $t5 44 reset_t6
    beq $t5 10 end_parse_number
    j warning_invalid_input

reset_t6:
    la $a0 result
    sw $t6 0($a0)
    li $t6 0
    addi $t3 $t3 1
    j parse_number

end_parse_number:
    la $a0 result
    sw $t6 4($a0)
    li $v0 1
    j end_get_and_parse_input

end_get_and_parse_input:
    lw $ra 0($sp)
    addi $sp $sp 4
    jr $ra

check_coordinates:
    addi $sp $sp -8
    sw $t4 0($sp)
    sw $t3 4($sp)
    li $t4 14
    slt $t3 $a0 $zero
    bne $t3 0 end_check_coordinates
    sgt $t3 $a0 $t4
    bne $t3 0 end_check_coordinates
    slt $t3 $a1 $zero
    bne $t3 0 end_check_coordinates
    sgt $t3 $a1 $t4
    bne $t3 0 end_check_coordinates
    li $v0 1
    j exit_check_coordinates

end_check_coordinates:
    li $v0 0
    j exit_check_coordinates

exit_check_coordinates:
    lw $t4 0($sp)
    lw $t3 4($sp)
    addi $sp $sp 8
    jr $ra

place_piece:
    addi $sp $sp -16
    sw $ra 0($sp)
    sw $a0 4($sp)
    sw $a1 8($sp)
    sw $a2 12($sp)

    jal check_coordinates
    beq $v0 0 warning_invalid_coordinates
    jal has_occupied_space
    beq $v0 0 warning_occupied_space
    jal place_piece_on_board

has_occupied_space:
    addi $sp $sp -4
    sw $ra 0($sp)
    jal coordinates_to_indices
    move $t3 $v0
    la $t4 board
    add $t4 $t4 $t3
    lb $t5 0($t4)
    bne $t5 $0 space_occupied
    li $v0 1
    j end_has_occupied_space

space_occupied:
    li $v0 0
    j end_has_occupied_space

end_has_occupied_space:
    lw $ra 0($sp)
    addi $sp $sp 4
    jr $ra

warning_invalid_coordinates:
    beq $t0 1 write_invalid_coordinates_1
    j write_invalid_coordinates_2

write_invalid_coordinates_1:
    li $v0 15
    move $a0 $s0
    la $a1 player_1_input_error_2
    li $a2 39
    syscall

    jal length_of_input
    move $a2 $v0
    li $v0 15
    move $a0 $s0
    la $a1 buffer
    syscall

    li $v0 15
    move $a0 $s0
    la $a1 new_line
    li $a2 1
    syscall

    j end_write_invalid_coordinates

write_invalid_coordinates_2:
    li $v0 15
    move $a0 $s0
    la $a1 player_2_input_error_2
    li $a2 39
    syscall

    jal length_of_input
    move $a2 $v0
    li $v0 15
    move $a0 $s0
    la $a1 buffer
    syscall

    li $v0 15
    move $a0 $s0
    la $a1 new_line
    li $a2 1
    syscall

    j end_write_invalid_coordinates

end_write_invalid_coordinates:
    la $a0 invalid_coordinates
    li $v0 4
    syscall

    li $v0 0
    j end_place_piece

warning_occupied_space:
    beq $t0 1 write_player_1_occupied_space
    j write_player_2_occupied_space

write_player_1_occupied_space:
    li $v0 15
    move $a0 $s0
    la $a1 player_1_occupied_space
    li $a2 48
    syscall

    jal length_of_input
    move $a2 $v0
    li $v0 15
    move $a0 $s0
    la $a1 buffer
    syscall

    li $v0 15
    move $a0 $s0
    la $a1 new_line
    li $a2 1
    syscall

    j end_write_player_occupied_space
    
write_player_2_occupied_space:
    li $v0 15
    move $a0 $s0
    la $a1 player_2_occupied_space
    li $a2 48
    syscall 

    jal length_of_input
    move $a2 $v0
    li $v0 15
    move $a0 $s0
    la $a1 buffer
    syscall

    li $v0 15
    move $a0 $s0
    la $a1 new_line
    li $a2 1
    syscall

    j end_write_player_occupied_space

end_write_player_occupied_space:
    la $a0 occupied_space
    li $v0 4
    syscall

    li $v0 0
    j end_place_piece

place_piece_on_board:
    jal coordinates_to_indices
    move $t3 $v0
    la $t4 board
    add $t4 $t4 $t3
    sb $a2 0($t4)

    j write_make_move

write_make_move:
    beq $t0 1 write_make_move_1
    j write_make_move_2

write_make_move_1:
    li $v0 15
    move $a0 $s0
    la $a1 player_1_move
    li $a2 37
    syscall

    jal length_of_input
    move $a2 $v0
    li $v0 15
    move $a0 $s0
    la $a1 buffer
    syscall

    li $v0 15
    move $a0 $s0
    la $a1 new_line
    li $a2 1
    syscall

    j end_write_make_move

write_make_move_2:
    li $v0 15
    move $a0 $s0
    la $a1 player_2_move
    li $a2 37
    syscall

    jal length_of_input
    move $a2 $v0
    li $v0 15
    move $a0 $s0
    la $a1 buffer
    syscall

    li $v0 15
    move $a0 $s0
    la $a1 new_line
    li $a2 1
    syscall

    j end_write_make_move

end_write_make_move:
    li $v0 1
    j end_place_piece

end_place_piece:
    lw $ra 0($sp)
    lw $a0 4($sp)
    lw $a1 8($sp)
    lw $a2 12($sp)
    addi $sp $sp 16
    jr $ra

check_win:
    addi $sp $sp -16
    sw $ra 0($sp)
    sw $a0 4($sp)
    sw $a1 8($sp)
    sw $a2 12($sp)

    li $t3 1                                        # Number of cells to check
    li $t4 0                                        # Direction index                                    
    
loop_direction:
    beq $t4 4 end_loop_direction
    move $a3 $a0
    move $t9 $a1
    li $t3 1
    j loop_check_direction

loop_check_direction:
    la $t5 direction_row
    sll $t6 $t4 2
    add $t5 $t5 $t6
    lw $t7 0($t5)
    la $t5 direction_column
    add $t5 $t5 $t6
    lw $t8 0($t5)
    add $a0 $a0 $t7
    add $a1 $a1 $t8
    jal check_coordinates
    beq $v0 0 init_loop_inverse_direction
    jal coordinates_to_indices
    move $t7 $v0
    la $t6 board
    add $t6 $t6 $t7
    lb $t8 0($t6)
    bne $t8 $a2 init_loop_inverse_direction
    addi $t3 $t3 1
    beq $t3 5 has_five_in_a_row
    j loop_check_direction

has_five_in_a_row:
    li $v0 1
    j end_check_win

init_loop_inverse_direction:
    move $a0 $a3
    move $a1 $t9
    j loop_inverse_direction

loop_inverse_direction:
    la $t5 direction_row
    sll $t6 $t4 2
    add $t5 $t5 $t6
    lw $t7 0($t5)
    la $t5 direction_column
    add $t5 $t5 $t6
    lw $t8 0($t5)
    sub $a0 $a0 $t7
    sub $a1 $a1 $t8
    jal check_coordinates
    beq $v0 0 end_loop_check_direction
    jal coordinates_to_indices
    move $t7 $v0
    la $t6 board
    add $t6 $t6 $t7
    lb $t8 0($t6)
    bne $t8 $a2 end_loop_check_direction
    addi $t3 $t3 1
    beq $t3 5 has_five_in_a_row
    j loop_inverse_direction

end_loop_check_direction:
    addi $t4 $t4 1
    move $a0 $a3
    move $a1 $t9
    j loop_direction

end_loop_direction:
    li $v0 0
    j end_check_win

end_check_win:
    lw $ra 0($sp)
    lw $a0 4($sp)
    lw $a1 8($sp)
    lw $a2 12($sp)
    addi $sp $sp 16
    jr $ra

print_tie:
    la $a0 tie
    li $v0 4
    syscall

print_player_1_win:
    la $a0 player_1_win
    li $v0 4
    syscall

    j write_result_to_file

print_player_2_win:
    la $a0 player_2_win
    li $v0 4
    syscall

    j write_result_to_file

write_result_to_file:
    li $v0 15
    move $a0 $s0
    la $a1 result_string
    li $a2 20
    syscall

write_board_to_file:
    li $t0 0

outer_loop_build_string:
    beq $t0 15 end_outer_loop_build_string
    li $v0 15
    move $a0 $s0
    la $a1 horizontal_line
    li $a2 32
    syscall
    li $v0 9
    li $a0 32
    syscall
    move $t5 $v0
    li $t1 0

inner_loop_build_string:
    beq $t1 15 end_inner_loop_build_string
    move $t9 $t5
    mul $t3 $t1 2
    add $t9 $t9 $t3
    li $t8 124
    sb $t8 0($t9)
    addi $t9 $t9 1
    move $a0 $t0
    move $a1 $t1
    jal coordinates_to_indices
    move $t7 $v0
    la $t6 board
    add $t6 $t6 $t7
    lb $t8 0($t6)
    beqz $t8 append_space
    beq $t8 88 append_x
    beq $t8 79 append_o

append_space:
    li $t8 32
    sb $t8 0($t9)
    j end_append

append_x:
    li $t8 88
    sb $t8 0($t9)
    j end_append

append_o:
    li $t8 79
    sb $t8 0($t9)
    j end_append

end_append:
    addi $t1 $t1 1
    j inner_loop_build_string

end_inner_loop_build_string:
    move $t9 $t5
    addi $t9 $t9 30
    li $t8 124
    sb $t8 0($t9)
    addi $t9 $t9 1
    li $t8 10
    sb $t8 0($t9)
    li $v0 15
    move $a0 $s0
    move $a1 $t5
    li $a2 32
    syscall
    addi $t0 $t0 1
    j outer_loop_build_string

end_outer_loop_build_string:
    li $v0 15
    move $a0 $s0
    la $a1 horizontal_line
    li $a2 32
    syscall

    j write_game_result

write_game_result:
    beq $t2 0 write_tie
    beq $t2 1 write_player_1_win
    beq $t2 2 write_player_2_win

write_tie:
    li $v0 15
    move $a0 $s0
    la $a1 tie
    li $a2 5
    syscall
    j end_write_file

write_player_1_win:
    li $v0 15
    move $a0 $s0
    la $a1 player_1_win
    li $a2 14
    syscall
    j end_write_file

write_player_2_win:
    li $v0 15
    move $a0 $s0
    la $a1 player_2_win
    li $a2 14
    syscall
    j end_write_file

end_write_file:
    li $v0 16
    move $a0 $s0
    syscall
    j end_program