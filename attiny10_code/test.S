#define DDRB2 2

#define DDRB 0x01

#define PORTB 0x02

#define PB3 0x1

#define PB2 0x2

#define PB1 0x4

.global main
main:
        ldi r16, 0xFF
        out DDRB, r16




loop:
		in r16, PORTB
        andi r16, (~PB2)
        out PORTB, r16

		in r16, PORTB
        andi r16, (~PB1)
        out PORTB, r16

        ldi r19, 0

startwait:
        ldi r17, 0

wait:
		subi r17, -1
		cpi r17, 0
		breq donewait
		rjmp wait
donewait:
		subi r19, -1
		cpi r19, 100
		breq turnon
		rjmp startwait

turnon:
		in r16, PORTB
        ori r16, PB2
        out PORTB, r16

		in r16, PORTB
        ori r16, PB1
        out PORTB, r16

        ldi r17, 0
wait1:
		subi r17, -1
		cpi r17, 0
		breq donewait2
		rjmp wait1

		
donewait2:
        rjmp loop