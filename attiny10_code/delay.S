#define DDRB2 2

#define DDRB 0x01

#define PORTB 0x02

#define PB0 1
#define PB1 2
#define PB2 4



#define SHIFTREG_CLK 0x4
#define SHIFTREG_DATA 0x1

.global main


Delay_1sec:
    
    LDI     r16,   8       ; One clock cycle;
Delay1:
    LDI     r17,   125     ; One clock cycle
Delay2:
    LDI     r18,   250     ; One clock cycle
Delay3:
    DEC     r18            ; One clock cycle
    NOP                     ; One clock cycle
    BRNE    Delay3          ; Two clock cycles when jumping to Delay3, 1 clock when continuing to DEC

    DEC     r17            ; One clock cycle
    BRNE    Delay2          ; Two clock cycles when jumping to Delay2, 1 clock when continuing to DEC

    DEC     r16            ; One clock Cycle
    BRNE    Delay1          ; Two clock cycles when jumping to Delay1, 1 clock when continuing to RET
RET



main:
    ldi r16, 0xFF
    out DDRB, r16



loop:
    in r16, PORTB
    andi r16, (~PB2)
    out PORTB, r16

    rcall Delay_1sec

    in r16, PORTB
    ori r16, PB2
    out PORTB, r16

    rcall Delay_1sec

    rjmp loop