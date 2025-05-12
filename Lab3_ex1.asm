.data
    a: .asciiz "Please enter a: "
    b: .asciiz "Please enter b: "
    c: .asciiz "Please enter c: "
    x1: .asciiz "There are two solutions, x1 = "
    x2: .asciiz " and x2 = "
    one_sol: .asciiz "There is one solution, x = "
    no_sol: .asciiz "There is no real solution"
    many_sol: .asciiz "There are infinitely many solutions"
    four: .float 4.0
    two: .float 2.0
    zero: .float 0.0

.text
    li $v0 4
    la $a0 a
    syscall

    li $v0 6
    syscall
    mov.s $f1 $f0

    li $v0 4
    la $a0 b
    syscall

    li $v0 6
    syscall
    mov.s $f2 $f0

    li $v0 4
    la $a0 c
    syscall
    
    li $v0 6
    syscall
    mov.s $f3 $f0

    la $t0 zero
    l.s $f0 0($t0)
    c.eq.s $f1 $f0
    bc1t linear

    # Calculate the discriminant
    mul.s $f4 $f1 $f3
    la $t0 four
    l.s $f5 0($t0)
    mul.s $f4 $f4 $f5
    mul.s $f5 $f2 $f2
    sub.s $f5 $f5 $f4

    c.lt.s $f5 $f0
    bc1t no_solution
    c.eq.s $f5 $f0
    bc1t one_solution
    j two_solutions

linear:
    c.eq.s $f2 $f0
    bc1t check_many_sol

    neg.s $f3 $f3
    div.s $f3 $f3 $f2

    la $a0 one_sol
    li $v0 4
    syscall

    mov.s $f12 $f3
    li $v0 2
    syscall

    li $v0 10
    syscall

check_many_sol:
    c.eq.s $f3 $f0
    bc1t many_solutions
    j no_solution

no_solution:
    la $a0 no_sol
    li $v0 4
    syscall

    li $v0 10
    syscall
    
many_solutions:
    la $a0 many_sol
    li $v0 4
    syscall

    li $v0 10
    syscall

one_solution:
    la $a0 one_sol
    li $v0 4
    syscall

    la $t0 two
    l.s $f6 0($t0)
    mul.s $f6 $f6 $f1
    neg.s $f2 $f2
    div.s $f6 $f2 $f6

    mov.s $f12 $f6
    li $v0 2
    syscall

    li $v0 10
    syscall

two_solutions:
    la $a0 x1
    li $v0 4
    syscall

    sqrt.s $f5 $f5
    la $t0 two
    l.s $f6 0($t0)
    mul.s $f6 $f6 $f1
    neg.s $f2 $f2
    add.s $f7 $f2 $f5
    div.s $f7 $f7 $f6

    mov.s $f12 $f7
    li $v0 2
    syscall

    la $a0 x2
    li $v0 4
    syscall
    
    sub.s $f7 $f2 $f5
    div.s $f7 $f7 $f6

    mov.s $f12 $f7
    li $v0 2
    syscall
    
    li $v0 10
    syscall