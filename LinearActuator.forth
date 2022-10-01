( Linear Actuator Sliding Mechanism in ESP-FORTH 7.0.5 )
( Uses an unipolar stepper to perform movement         )
( Uses limit swithces in NO mode to limit movement     )

FORTH DEFINITIONS ( vocabulary ) 
 
DECIMAL
( Unipolar stepper connected to pin 15, 16,17,18 )

15 constant PIN_A
16 constant PIN_B
17 constant PIN_C
18 constant PIN_D
  
( 'timing' words )
: WAIT-MICRO-STEP 3 ms ;

( pin words )
: WRITE-A ( n -- ) PIN_A swap digitalWrite ;
: WRITE-B ( n -- ) PIN_B swap digitalWrite ;
: WRITE-C ( n -- ) PIN_C swap digitalWrite ;
: WRITE-D ( n -- ) PIN_D swap digitalWrite ;

( micro 'stepping' words )
: MICRO-STEP-1 1 WRITE-A 0 WRITE-B 0 WRITE-C 0 WRITE-D WAIT-MICRO-STEP ;
: MICRO-STEP-2 1 WRITE-A 1 WRITE-B 0 WRITE-C 0 WRITE-D WAIT-MICRO-STEP ;
: MICRO-STEP-3 0 WRITE-A 1 WRITE-B 0 WRITE-C 0 WRITE-D WAIT-MICRO-STEP ;
: MICRO-STEP-4 0 WRITE-A 1 WRITE-B 1 WRITE-C 0 WRITE-D WAIT-MICRO-STEP ;
: MICRO-STEP-5 0 WRITE-A 0 WRITE-B 1 WRITE-C 0 WRITE-D WAIT-MICRO-STEP ;
: MICRO-STEP-6 0 WRITE-A 0 WRITE-B 1 WRITE-C 1 WRITE-D WAIT-MICRO-STEP ;
: MICRO-STEP-7 0 WRITE-A 0 WRITE-B 0 WRITE-C 1 WRITE-D WAIT-MICRO-STEP ;
: MICRO-STEP-8 1 WRITE-A 0 WRITE-B 0 WRITE-C 1 WRITE-D WAIT-MICRO-STEP ;

: MICRO-STOP   0 WRITE-A 0 WRITE-B 0 WRITE-C 0 WRITE-D WAIT-MICRO-STEP ;

( initialization )
PIN_A output pinMode
PIN_B output pinMode
PIN_C output pinMode
PIN_D output pinMode

( single clockwise step )
: STEP-CW MICRO-STEP-1 MICRO-STEP-2 MICRO-STEP-3 MICRO-STEP-4 MICRO-STEP-5 MICRO-STEP-6 MICRO-STEP-7 MICRO-STEP-8 ;
( single counter clockwise step )
: STEP-CCW MICRO-STEP-8 MICRO-STEP-7 MICRO-STEP-6 MICRO-STEP-5 MICRO-STEP-4 MICRO-STEP-3 MICRO-STEP-2 MICRO-STEP-1 ;

( test stepper )
: LOOP-CW 512 0  DO I STEP-CW  DROP  1 +LOOP MICRO-STOP ;
: LOOP-CCW 512 0 DO I STEP-CCW DROP  1 +LOOP MICRO-STOP ;

( limit switches in NO mode )
22 constant PIN_CLOSE
23 constant PIN_OPEN

( init limit switches )
PIN_CLOSE input pinMode
PIN_OPEN  input pinMode

( check if limit switch is closed or opened )
: LIMIT-CLOSED ( n -- tf ) digitalRead ;
: LIMIT-OPENED ( n -- tf ) digitalRead 1 - ;

( sliding commands )
: STEP-CLOSE-LIMITED PIN_CLOSE LIMIT-OPENED IF STEP-CW ELSE MICRO-STOP THEN ;
: SLIDE-CLOSE 426 0 DO I STEP-CLOSE-LIMITED DROP 1 +LOOP MICRO-STOP ;
: STEP-OPEN-LIMITED PIN_OPEN LIMIT-OPENED IF STEP-CCW ELSE MICRO-STOP THEN ;
: SLIDE-OPEN 426 0 DO I DROP STEP-OPEN-LIMITED DROP 1 +LOOP MICRO-STOP ;
: SLIDE-OPERATE PIN_CLOSE LIMIT-CLOSED IF SLIDE-OPEN ELSE SLIDE-CLOSE THEN ;
