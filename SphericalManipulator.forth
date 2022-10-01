( Spherical Manipulator Platform in ESP-FORTH 7 )
( Servo #1 is connected to pin 16 / channel 2 )
( Servo #2 is connected to pin 17 / channel 4 )
( Servo #3 is connected to pin 18 / channel 6 )

FORTH DEFINITIONS also LEDC   ( vocabulary ) 
 
DECIMAL
  
( 'timing' words )
: WAIT-STEP 150 ms ;
: WAIT-SET 800 ms ;

( Initialize the single servos )
: INIT-1 16 2 ledcAttachPin DROP 2 50000 10 ledcSetup ;
: INIT-2 17 4 ledcAttachPin DROP 4 50000 10 ledcSetup ;
: INIT-3 18 6 ledcAttachPin DROP 6 50000 10 ledcSetup ;
: INIT INIT-1 INIT-2 INIT-3 2DROP ;

INIT

( Deinitialize the single servos )
: DEINIT-1 16 2 ledcDetachPin DROP ;
: DEINIT-2 17 4 ledcDetachPin DROP ;
: DEINIT-3 18 6 ledcDetachPin DROP ;
: DEINIT DEINIT-1 DEINIT-2 DEINIT-3 ;

( ticks to degree for my sg90 )
 25 constant sg90_0 125 constant sg90_180
: deg-to-ticks ( n -- ) sg90_180 sg90_0 - * 180 / sg90_0 + ;

( move one of the servos )
: MOVE-1 ( n1 -- ) deg-to-ticks 2 swap ledcWrite ;
: MOVE-2 ( n1 -- ) deg-to-ticks 4 swap ledcWrite ;
: MOVE-3 ( n1 -- ) deg-to-ticks 6 swap ledcWrite ;

( Move all the servos to there home position )
: HOME-1 90 MOVE-1 ;
: HOME-2 90 MOVE-2 ;
: HOME-3 90 MOVE-3 ;
: HOME HOME-1 HOME-2 HOME-3 800 ms ;

( sweep one of the servos )
: sweep-1-cw  ( t f -- ) do 180 i - move-1 200 ms 5 +loop ;
: sweep-1-ccw ( t f -- ) do i move-1 200 ms 5 +loop ;
: sweep-2-cw  ( t f -- ) do 180 i - move-2 200 ms 5 +loop ;
: sweep-2-ccw ( t f -- ) do i move-2 200 ms 5 +loop ;
: sweep-3-cw  ( t f -- ) do 180 i - move-3 200 ms 5 +loop ;
: sweep-3-ccw ( t f -- ) do i move-3 200 ms 5 +loop ;

( Sample 1: SMP_CALIBRATE - calibate the platform )
: CALIBRATE HOME ;

( Sample 2: TOGGLE-1 : toggle the 1st platform )
: TOGGLE-1 140 90 sweep-1-ccw 140 move-1 200 ms 140 40 sweep-1-cw 40 move-1 200 ms 90 40 sweep-1-ccw 90 move-1 200 ms ;

( Sample 3: TOGGLE-2 : toggle the 2nd platform )
: TOGGLE-2 140 90 sweep-2-ccw 140 move-2 200 ms 140 40 sweep-2-cw 40 move-2 200 ms 90 40 sweep-2-ccw 90 move-2 200 ms ;

( Sample 4: TOGGLE-3 : toggle the 3rd platform )
: TOGGLE-3 140 90 sweep-3-ccw 140 move-3 200 ms 140 40 sweep-3-cw 40 move-3 200 ms 90 40 sweep-3-ccw 90 move-3 200 ms ;

( for simple testing )
: TOGGLE-DEMO INIT HOME 4 0 DO TOGGLE-1 TOGGLE-2 TOGGLE-3 LOOP DEINIT ;

( Sample 4: ROTATE-STAGE )
( Moves all servos with same value using the same LEDC channel )
: INIT-ALL 16 2 ledcAttachPin 17 2 ledcAttachPin 18 2 ledcAttachPin 2 50000 10 ledcSetup DROP ;
: DEINIT-ALL 16 2 ledcDetachPin DROP 17 2 ledcDetachPin DROP 18 2 ledcDetachPin DROP ;
: MOVE-ALL ( n1 -- ) deg-to-ticks 2 swap ledcWrite ;
: HOME-ALL 90 MOVE-ALL ;
: sweep-all-cw  ( t f -- ) do 180 i - move-all 200 ms 5 +loop ;
: sweep-all-ccw ( t f -- ) do i move-all 200 ms 5 +loop ;
: ROTATE-STAGE HOME-ALL 160 90 sweep-all-ccw 160 move-all 200 ms 160 20 sweep-all-cw 20 move-all 200 ms 90 20 sweep-all-ccw 90 move-all 200 ms ;
: ROTATE-STAGE-DEMO INIT-ALL ROTATE-STAGE DEINIT-ALL ;
