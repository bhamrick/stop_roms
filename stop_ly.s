.include "shell.inc"

main:
    ; Find LY and subLY
    ; We'll treat subLY on a 456/2 = 228
    ; step scale, since video processing does not
    ; double speed in double speed mode.

    ; We want to read LY spaced 460 video cycles apart.
    ; In normal speed, machine cycles are 4 video cycles
    ; so video cycles act like clock cycles.
    ldh a, ($44)    ; 12
    ld b, a         ; 4
    ld d, a         ; 4
    ; 20 cycles have passed here, need to stall for 440 more.
    ld e, 114       ; 8
    ld a, 26        ; 8
stall:
    dec a           ; 4
    jr nz, stall    ; 12/8
    ; Stalled for 16 + 26 * 16 - 4 = 428 cycles, need 12 more.
    nop             ; 4
    nop             ; 4
    nop             ; 4
loop:
    ldh a, ($44)    ; 12
    sub d           ; 4
    jr nc, nocarry  ; 12/8
carry:
    add 154         ; 8
    jr check        ; 12
nocarry:
    ; Stall for 16 cycles to match carry branch (we've already used 4 extra cycles
    ; in the jr)
    nop             ; 4
    nop             ; 4
    nop             ; 4
    nop             ; 4
check:
    dec a           ; 4
    jr nz, store    ; 12/8
nostore:
    jr loopstall    ; 12
store:
    ld c, e         ; 4
    nop             ; 4
loopstall:
    ; Update d with new LY
    inc a           ; 4
    add d           ; 4
    ld d, a         ; 4
    ; 80 cycles have passed out of 460
    ; 16 will be taken from end-of-loop.
    ; Stall for 364 cycles
    ld a, 22        ; 8
loopstallloop:
    dec a           ; 4
    jr nz, loopstallloop ; 12/8
    ; Stalled for 8 + 16*22 - 4 = 356 cycles
    nop             ; 4
    nop             ; 4
    ; Loop
    dec e           ; 4
    jr nz, loop     ; 12/8

    ; This would be the 115th read, but we are 4 cycles early.
    ; Cycle count: 115 * 460 - 4 = 52896

    push bc         ; 16

    ; Execute a stop (Will wait for joypad input)
    ldh a, ($FF)    ; 12 FFFF = IE
    push af         ; 16
    xor a           ; 4
    ldh ($FF), a    ; 12 FFFF = IE
    inc a
    ldh ($0F), a    ; 12 FF0F = IF
    ld a, $00
    ldh ($00), a
    ei              ; 4
    stop            ; ???
    nop             ; 4
    di              ; 4
    pop af          ; 12
    ldh ($FF), a    ; 12 FFFF = IE

    ; In normal speed, machine cycles are 4 video cycles
    ; so video cycles act like clock cycles.
    ldh a, ($44)    ; 12
    ld b, a         ; 4
    ld d, a         ; 4
    ; 20 cycles have passed here, need to stall for 440 more.
    ld e, 114       ; 8
    ld a, 26        ; 8
stall3:
    dec a           ; 4
    jr nz, stall3   ; 12/8
    ; Stalled for 16 + 26 * 16 - 4 = 428 cycles, need 12 more.
    nop             ; 4
    nop             ; 4
    nop             ; 4
loop3:
    ldh a, ($44)    ; 12
    sub d           ; 4
    jr nc, nocarry3 ; 12/8
carry3:
    add 154         ; 8
    jr check3       ; 12
nocarry3:
    ; Stall for 16 cycles to match carry branch (we've already used 4 extra cycles
    ; in the jr)
    nop             ; 4
    nop             ; 4
    nop             ; 4
    nop             ; 4
check3:
    dec a           ; 4
    jr nz, store3   ; 12/8
nostore3:
    jr loopstall3   ; 12
store3:
    ld c, e         ; 4
    nop             ; 4
loopstall3:
    ; Update d with new LY
    inc a           ; 4
    add d           ; 4
    ld d, a         ; 4
    ; 80 cycles have passed out of 460
    ; 16 will be taken from end-of-loop.
    ; Stall for 364 cycles
    ld a, 22        ; 8
loopstallloop3:
    dec a           ; 4
    jr nz, loopstallloop3 ; 12/8
    ; Stalled for 8 + 16*22 - 4 = 356 cycles
    nop             ; 4
    nop             ; 4
    ; Loop
    dec e           ; 4
    jr nz, loop3    ; 12/8

    push bc         ; 16

    pop de
    pop bc
    ld a, b
    call print_a
    ld a, c
    ; Adjust first subLY
    sub 1
    jr nc, no_wrap
    add 114
no_wrap:
    sla a
    call print_a

    print_str newline

    ld a, d
    call print_a
    ld a, e
    ; Adjust third subLY
    sub 1
    jr nc, no_wrap3
    add 114
no_wrap3:
    sla a
    call print_a

    jp tests_passed
