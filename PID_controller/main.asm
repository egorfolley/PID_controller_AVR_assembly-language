.def error = R16
.def set_ = R17
.def proc = R18
.def P = R14
.def delta = R20
.def time = R21
.def Intgr = R19
.def I = R22
.def Kp = R24
.def Ki = R25
.def out_signal = R12

ldi set_, 7						
ldi proc, 5						
ldi Kp, 3 							
ldi Ki, 10 								
ldi time, 1 							
ldi Intgr, 0

rjmp PID
PID:
	mov error, set_ 						
	sub error, proc 					
	
	mov P, error 						
	mul P, Kp
	movw P, r0 	
	
	mov delta, error 					
	mul delta, time 
	movw delta, r0					
	
	add Intgr, delta
	add I, Intgr					
	mul I, Ki
	movw I, r0

	cpi I, 245
	brsh over	

	cpi I, -245
	brlo under

contin:
	ldi r23, 10

	mov out_signal, P 							
	add out_signal, I 
	
	mov Intgr, I
rjmp PID

over: 
	ldi I, 245
	brne contin

under:
	ldi I, -245
	brne contin

cycle:
	cpi r23, 0x00
	breq PID
	dec r23
	brne cycle
