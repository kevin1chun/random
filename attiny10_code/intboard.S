#define DDRB2 2

#define DDRB 0x01

#define PORTB 0x02

#define PUEB 0x03

#define PINB 0x0

#define PB0 1
#define PB1 2
#define PB2 4

#define SHIFTREG_CLK 1
#define SHIFTREG_DATA 4

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



write_shift_reg:
    ; r16 to contain 8 bits to write
    ; shift reg capable of shifting at 1MHZ
    ; SHIFTREG_CLK
    ; SHIFTREG_DATA -> 0x1
    
    mov r18, r16 ; store input at r18


    in r17, PORTB ; hold sr clk down 
    andi r17, (~SHIFTREG_CLK)
    out PORTB, r17

    ldi r20, 0
cont_write:

    mov r16, r18
    andi r16, 1 ; 
    lsl r16
    lsl r16


    in r19, PORTB
    andi r19, ~SHIFTREG_DATA ;clear 2nd bit of PORTB
    or r19, r16 ; write the data bit
    out PORTB, r19

 

    ; output clock pulse
    in r17, PORTB 
    ori r17, (SHIFTREG_CLK)
    out PORTB, r17 
    nop
    andi r17, (~SHIFTREG_CLK)
    out PORTB, r17 
    ; end output clock pulse
    nop


    lsr r18
    subi r20, -1

    cpi r20, 9
    brne cont_write

RET


blank_1_sec: 
    rcall Delay_1sec
    rcall Delay_1sec
    rcall Delay_1sec
    ldi r16, 0x00
    rcall write_shift_reg
    rcall Delay_1sec
RET

check_hall:

    in r16, PINB
    andi r16, PB1
    cpi r16, 0
    brne end_write_msg






write_msg:
    ldi r16, 0x00
    rcall write_shift_reg
    rcall Delay_1sec
    rcall Delay_1sec
    rcall Delay_1sec


   
    ldi r16, 0x4F    
    rcall write_shift_reg
    rcall blank_1_sec


    ldi r16, 0x4E    
    rcall write_shift_reg
    rcall blank_1_sec

    ldi r16, 0x45    
    rcall write_shift_reg
    rcall blank_1_sec


  
    ldi r16, 0x4F    
    rcall write_shift_reg
    rcall blank_1_sec

    ldi r16, 0x46   
    rcall write_shift_reg
    rcall blank_1_sec




    ldi r16, 0x41    
    rcall write_shift_reg
    rcall blank_1_sec




    ldi r16, 0x4B       
    rcall write_shift_reg
    rcall blank_1_sec

    ldi r16, 0x49   
    rcall write_shift_reg
    rcall blank_1_sec

    ldi r16, 0x4E    
    rcall write_shift_reg
    rcall blank_1_sec

    ldi r16, 0x44 
    rcall write_shift_reg
    rcall blank_1_sec



    rcall Delay_1sec



end_write_msg:

RET

main:
    ldi r16, 0xFD ; port B goes to output (except pb1)
    out DDRB, r16

    ldi r24, 0x00

    in r16, PORTB
    ori r16, ~PB2
    out PORTB, r16
    
    ldi r16, PB1
    out PUEB, r16


loop:




lelf_right:
    ldi r16, 15
    rcall write_shift_reg

    rcall Delay_1sec

    ldi r16, 240
    rcall write_shift_reg

    rcall Delay_1sec

    ldi r16, 15
    rcall write_shift_reg

    rcall Delay_1sec

    ldi r16, 240
    rcall write_shift_reg

    rcall Delay_1sec

    ldi r16, 15
    rcall write_shift_reg

    rcall Delay_1sec

    ldi r16, 240
    rcall write_shift_reg

    rcall Delay_1sec
adder_setup: 
    ldi r24, 0x00

adder:
    rcall check_hall

    mov r16, r24
    rcall write_shift_reg

    subi r24, -1 

    rcall Delay_1sec

    cpi r24, 255
    breq endadder
    rjmp adder

endadder: 



rjmp loop




