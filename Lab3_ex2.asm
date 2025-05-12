.data
    u: .asciiz "Please enter u: "
    v: .asciiz "Please enter v: "
    a: .asciiz "Please enter a: "
    b: .asciiz "Please enter b: "
    c: .asciiz "Please enter c: "
    d: .asciiz "Please enter d: "
    e: .asciiz "Please enter e: "
    result: .asciiz "The value of the integral is: "
    seven: .float 7.0
    six: .float 6.0
    two: .float 2.0
    three: .float 3.0
    one: .float 1.0
    four: .float 4.0

.text
    li $v0 4
    la $a0 u
    syscall

    li $v0 6
    syscall
    mov.s $f1 $f0

    li $v0 4
    la $a0 v
    syscall

    li $v0 6
    syscall
    mov.s $f2 $f0

    li $v0 4
    la $a0 a
    syscall

    li $v0 6
    syscall
    mov.s $f3 $f0

    li $v0 4
    la $a0 b
    syscall

    li $v0 6
    syscall
    mov.s $f4 $f0
    
    li $v0 4
    la $a0 c
    syscall

    li $v0 6
    syscall
    mov.s $f5 $f0

    li $v0 4
    la $a0 d
    syscall

    li $v0 6
    syscall
    mov.s $f6 $f0

    li $v0 4
    la $a0 e
    syscall

    li $v0 6
    syscall
    mov.s $f7 $f0

    mov.s $f12 $f6
    la $a0 four
    l.s $f14 0($a0)
    jal pow
    mov.s $f6 $f0

    mov.s $f12 $f7
    la $a0 three
    l.s $f14 0($a0)
    jal pow
    mov.s $f7 $f0

    # Calculate d^4 + e^3
    add.s $f19 $f6 $f7

    # Calculate u^7, v^7, u^6, v^6, u^2, v^2
    mov.s $f12 $f1
    la $a0 seven
    l.s $f14 0($a0)
    jal pow
    mov.s $f8 $f0
    
    mov.s $f12 $f2
    la $a0 seven
    l.s $f14 0($a0)
    jal pow
    mov.s $f9 $f0
    
    mov.s $f12 $f1
    la $a0 six
    l.s $f14 0($a0)
    jal pow
    mov.s $f10 $f0
    
    mov.s $f12 $f2
    la $a0 six
    l.s $f14 0($a0)
    jal pow
    mov.s $f11 $f0

    mov.s $f12 $f1
    la $a0 two
    l.s $f14 0($a0)
    jal pow
    mov.s $f20 $f0
    
    mov.s $f12 $f2
    la $a0 two
    l.s $f14 0($a0)
    jal pow
    mov.s $f21 $f0

    # a * (u^7 / 7 - v^7 / 7) + b * (u^6 / 6 - v^6 / 6) + c * (u^2 / 2 - v^2 / 2)
    la $a0 seven
    l.s $f0 0($a0)
    div.s $f15 $f8 $f0
    div.s $f16 $f9 $f0
    sub.s $f15 $f15 $f16
    mul.s $f15 $f3 $f15

    la $a0 six
    l.s $f0 0($a0)
    div.s $f16 $f10 $f0
    div.s $f17 $f11 $f0
    sub.s $f16 $f16 $f17
    mul.s $f16 $f4 $f16

    la $a0 two
    l.s $f0 0($a0)
    div.s $f17 $f20 $f0
    div.s $f18 $f21 $f0
    sub.s $f17 $f17 $f18
    mul.s $f17 $f5 $f17

    add.s $f15 $f15 $f16
    add.s $f15 $f15 $f17

    # Divide by d^4 + e^3
    div.s $f15 $f15 $f19
    
    # Print the result
    li $v0 4
    la $a0 result
    syscall

    li $v0 2
    mov.s $f12 $f15
    syscall

    li $v0 10
    syscall

    # Raise a floating point numbers with an integer power
pow:
    la $a0 one
    l.s $f22 0($a0)
    l.s $f23 0($a0)
    l.s $f24 0($a0)
    j loop

loop:
    c.le.s $f23 $f14
    bc1f endLoop
    mul.s $f22 $f22 $f12
    add.s $f23 $f23 $f24
    j loop

endLoop:
    mov.s $f0 $f22
    jr $ra