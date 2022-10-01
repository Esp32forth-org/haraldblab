\ SG90 servo PWM control
\ Based on: example how to use RC servos without libraries, by PeterForth
\ Changes: changed frequency to 50 Hz, sweep words from tests

FORTH DEFINITIONS also LEDC   ( vocabulary ) 
 
DECIMAL
  
  15 constant PWMR     2 constant chRIGHT
  
: init-pwm    PWMR chRIGHT      ledcAttachPin 
	           chRIGHT 50000 10  ledcSetup ;

: deinit-pwm    PWMR chRIGHT      ledcAttachPin ;
 
: move-ticks ( speed -- )  chRIGHT swap ledcWrite ; 

( ticks to degree for my sg90 )
 25 constant sg90_0 125 constant sg90_180

( movement in degrees )
: deg-to-ticks ( n -- ) sg90_180 sg90_0 - * 180 / sg90_0 + ;
: move-to ( speed -- ) deg-to-ticks move-ticks ;
 
( single movements - do not work as expected )
: to-start  0 move-to ;
: to-end  180 move-to ;
     
init-pwm

( sweep words )
: sweep-cw  ( t f -- ) do 180 i - move-to 200 ms 5 +loop to-start 200 ms ;
: sweep-ccw ( t f -- ) do i move-to 200 ms 5 +loop to-end 200 ms ;
: sweep 180 10 sweep-ccw 180 10 sweep-cw ;

( demo words )
: sweep-demo to-start 800 ms 4 0 do sweep loop ;
: move-demo 4 0 0 move-to 800 ms 45 move-to 800 ms 90 move-to 800 ms 135 move-to 800 ms 180 move-to  ;

( tests )
: test1 0 deg-to-ticks ;
: test2 180 deg-to-ticks ;
: test3 90 deg-to-ticks ;
