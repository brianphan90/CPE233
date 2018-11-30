;------------------------------------------------------------

; I/O constants - Seven Segment, Keyboard, and VGA

;------------------------------------------------------------

.EQU SSEG                = 0x81 ; 7-segment decoder 



.EQU PS2_KEY_CODE        = 0x44 ; ps2 data register


.EQU VGA_HADD            = 0x90 ; high address register

.EQU VGA_LADD            = 0x91 ; low address register

.EQU VGA_COLOR           = 0x92 ; color value register

;------------------------------------------------------------------

; Time Delay Counts

;------------------------------------------------------------------

.EQU INSIDE_FOR_COUNT    = 0xCF     ; Time Delay Constants

.EQU MIDDLE_FOR_COUNT    = 0xAF

.EQU OUTSIDE_FOR_COUNT   = 0x64

;------------------------------------------------------------------

;- Register Usage Key

;------------------------------------------------------------------

;- r4 --- holds Player 1 color (BLUE)

;- r7 and r22 to r25--- Paddle ‘Y’ location value

;- r8 and r26 to r29--- Paddle X location value

;- r11 ball color (WHITE)

;- r12 ball y

;- r30 ball x



;- r17 -- Time delay constant (OUT)

;- r18 -- Time delay constant (MIDDLE)

;- r19 -- Time delay constant (INSIDE)

;- r31 -- keeps score on LEDS



; Interrupt Registers 

;r1 -- interrupt key input

;r10 -- ‘s’ key register (START)


;------------------------------------------------------------------

.CSEG

.ORG 0x20

;------------------------------------------------------------------

; Foreground Task

;------------------------------------------------------------------

init:
    ;;allows interrupts to occur

          SEI
       
 
    ;;clear start button

        MOV        r10, 0x000


       
        ;;paddle color (BLUE)

        MOV        r4, 0x03


        ;PADDLE INITIALIZATION

        MOV        r7,  0x1F           ; paddle pixel 1

        MOV        r8,  0x00


        CALL    draw_paddle1

;;for debug   

    ;CALL    timedelay0
        

        MOV        r22,0x1F            ;paddle pixel 2

        MOV        r26,0x01


        

        CALL    draw_paddle2


;;for debug

;        CALL    timedelay0

        

        MOV        r23,0x1F        ;paddle pixel 3

        MOV        r27,0x02

        CALL    draw_paddle3


;;for debug

 ;       CALL    timedelay0


        MOV        r24,0x1F        ;paddle pixel 4

        MOV        r28,0x03


        CALL    draw_paddle4


;;for debug

;        CALL    timedelay0


        MOV        r25,0x1F        ;paddle pixel 5

        MOV        r29,0x04


        CALL    draw_paddle5


;;for debug

 ;      CALL    timedelay0


        ;;setting the score

        MOV        r31, 0x00

        OUT        r31, SSEG

    

        ;GETTING THE BALL IN PLACE

        MOV        r12, 0x00            ;’y’ coordinate of ball

        MOV        r30, 0x1C            ;x coordinate of ball

        MOV        r11, 0xFF            ;color ball (WHITE)


        CALL    draw_ball


;;waiting for the start button, 's' key


        CMP     r10, 0x01

        BREQ    main

        BRNE    init


main:    MOV    r10, 0x00


move_downleft:

        ;;ball will move downwards to the left at first

        MOV        r11, 0x00        ;;makes sure the ball leaves no footprints

        CALL    draw_ball

        CALL    timedelay0

        ADD        r12, 0x01

        SUB        r30, 0x01

        MOV        r11, 0xFF

        CALL    draw_ball

        CALL    timedelay0

        

        ;;check paddle

        CMP        r12, 0x1E

        BREQ    check_paddle_fromright

        CMP        r12, 0x06

        BREQ    check_paddle_fromright



        ;;check to see if ball touches left wall

        CMP        r30, 0x00

        BREQ    move_downright


        BRN    move_downleft


move_downright:

        MOV        r11, 0x00        ;;makes sure the ball leaves no footprints

        CALL    draw_ball

        CALL    timedelay0

        ADD        r12, 0x01

        ADD        r30, 0x01

        MOV        r11, 0xFF

        CALL    draw_ball

        CALL    timedelay0

        

        ;;check paddle

        CMP        r12, 0x1E

        BREQ    check_paddle_fromleft

        CMP        r12, 0x0

        BREQ    check_paddle_fromleft


        ;;check to see if ball touches right wall

        CMP        r30, 0x27

        BREQ    move_downleft


        BRN    move_downright


move_upright:

        MOV        r11, 0x00        ;;makes sure the ball leaves no footprints

        CALL    draw_ball

        CALL    timedelay0

        SUB        r12, 0x01

        ADD        r30, 0x01

        MOV        r11, 0xFF

        CALL    draw_ball

        CALL    timedelay0

        ;;check for corner right

        CMP        r12, 0x00

        BREQ    rcorner_check


        ;;check to see if ball touches right wall

        CMP        r30, 0x27

        BREQ    move_upleft

        ;;check to see if ball touches top

        CMP        r12, 0x00

        BREQ    move_downright

        BRN       move_upright             ;- continue to poll


move_upleft:

        MOV        r11, 0x00        ;;

        CALL    draw_ball

        CALL    timedelay0

        SUB        r12, 0x01

        SUB        r30, 0x01

        MOV        r11, 0xFF

        CALL    draw_ball

        CALL    timedelay0

        ;;check upper left corner

        CMP        r12, 0x00

        BREQ    lcorner_check

        ;;check to see if ball touches left wall

        CMP        r30, 0x00

        BREQ    move_upright

        ;;check to see if ball touches top

        CMP        r12, 0x00

        BREQ    move_downleft

        BRN       move_upleft

;---------------------------------

;;PADDLE CHECK SUBROUTINES

;----------------------------------


check_paddle_fromleft:    

        CMP        r30, r8

        BREQ    ADD_SCORE_BR

        CMP        r30, r26

        BREQ    ADD_SCORE_BR

        CMP        r30, r27

        BREQ    ADD_SCORE_BR

        CMP        r30, r28

        BREQ    ADD_SCORE_BR

        CMP        r30, r29

        BREQ    ADD_SCORE_BR

        MOV        r11, 0x00    ;clear ball

        CALL    draw_ball

        ;;erase the paddle

        MOV        r4, 0x00

        CALL    draw_paddle1

        CALL    draw_paddle2

        CALL    draw_paddle3

        CALL    draw_paddle4

        CALL    draw_paddle5

        BRN        init


check_paddle_fromright:    

        CMP        r30, r8

        BREQ    ADD_SCORE_BL

        CMP        r30, r26

        BREQ    ADD_SCORE_BL

        CMP        r30, r27

        BREQ    ADD_SCORE_BL

        CMP        r30, r28

        BREQ    ADD_SCORE_BL

        CMP        r30, r29

        BREQ    ADD_SCORE_BL

        MOV        r11, 0x00    ;;clear the ball

        CALL    draw_ball

        ;;erase the paddle

        MOV        r4, 0x00

        CALL    draw_paddle1

        CALL    draw_paddle2

        CALL    draw_paddle3

        CALL    draw_paddle4

        CALL    draw_paddle5

        BRN    init


;---------------------------------------------------

;ADDING A SCORE THEN BOUNCING

;-----------------------------------------------------


ADD_SCORE_BR:

        CALL    timedelay0

        ADD        r31, 0x01

        OUT        r31, SSEG

        ;;check for left corner

        CMP        r30, 0x27

        BRNE    move_upright

        BREQ    move_upleft

        


ADD_SCORE_BL:

        CALL    timedelay0

        ADD        r31, 0x01

        OUT        r31, SSEG

        ;;check for right corner

        CMP        r30, 0x00

        BRNE    move_upleft

        BREQ    move_upright


;---------

;;TO STORE CORNER STUFF

;----------

rcorner_check:

        

        CMP        r30, 0x27

        

        BREQ    move_downleft

        BRNE    move_downright


lcorner_check:

        CMP        r30, 0x00

        BREQ    move_downright

        BRNE    move_downleft

        

    


;--------------------------------------------------------------

; Interrupt Service Routine - Handles Interrupts from Keyboard

;--------------------------------------------------------------

; Sample ISR that looks for various key presses. When a useful

; key press is found, the program does something useful. The 

; code also handles the key-up code and subsequent re-sending

; of the associated scan-code. 

;--------------------------------------------------------------

MY_ISR:    
    
    IN  R1, PS2_KEY_CODE
    
    CMP R1, 0x1B ; 's' key
    
    BREQ START_UP
    
    CMP R1, 0x1C ; 'a' key
    
    BREQ move_left
    
    CMP R1, 0x23 ; 'd' key
    
    BREQ move_right
    
    RETIE


START_UP:

    ADD    r10, 0x01

    RETIE

                  

move_right:



        ;;removing paddle footprints

        CMP        r29, 0x27
        
        BREQ    RETURN

        MOV        r4, 0x00

        CALL    draw_paddle1

        CALL    draw_paddle2

        CALL    draw_paddle3

        CALL    draw_paddle4

        CALL    draw_paddle5

        ADD        r8, 0x01

        ADD        r26,0x01

        ADD        r27,0x01

        ADD        r28,0x01

        ADD        r29,0x01


        ;;drawing new paddle

        MOV        r4, 0x03

        CALL    draw_paddle1

        CALL    draw_paddle2

        CALL    draw_paddle3

        CALL    draw_paddle4

        CALL    draw_paddle5        

        RETIE    


move_left:

        CMP        r8, 0x00

        BREQ    RETURN

        ;;removing paddle footprints

        MOV        r4, 0x00

        CALL    draw_paddle1

        CALL    draw_paddle2

        CALL    draw_paddle3

        CALL    draw_paddle4

        CALL    draw_paddle5

        

        SUB        r8, 0x01

        SUB        r26,0x01

        SUB        r27,0x01

        SUB        r28,0x01

        SUB        r29,0x01


;;drawing new paddle

        MOV        r4, 0x03

        CALL    draw_paddle1

        CALL    draw_paddle2

        CALL    draw_paddle3

        CALL    draw_paddle4

        CALL    draw_paddle5        

        RETIE


;---------------------------------------------------------------------

;- Subroutine: draw_paddle

;---------------------------------------------------------------------


draw_paddle1: 

            OUT       r8,    VGA_LADD

            OUT       r7,    VGA_HADD

            OUT       r4,    VGA_COLOR  


            RET

draw_paddle2:

            OUT        r26,VGA_LADD

            OUT       r22,VGA_HADD

            OUT       r4,VGA_COLOR  


            RET

draw_paddle3:

            OUT        r27,VGA_LADD

            OUT       r23,VGA_HADD

            OUT       r4,VGA_COLOR  


            RET

draw_paddle4:

            OUT        r28,VGA_LADD

            OUT       r24,VGA_HADD

            OUT       r4,VGA_COLOR  


            RET

draw_paddle5:

            OUT        r29,VGA_LADD

            OUT       r25,VGA_HADD

            OUT       r4,VGA_COLOR  


            RET



;---------------------------------------------------------------------

;- Subroutine: draw_ball

;---------------------------------------------------------------------

draw_ball: 

           OUT r30,VGA_LADD   ; write ball y address

           OUT r12,VGA_HADD   ; write ball x address

           OUT r11,VGA_COLOR  ; write ball color

           RET


;--------------------------------------------------------------------

;- Subroutine: timedelay0

;-

;- Slows the clock for a certain amount of time. Used to display the ball

;- projectiles moving across the screen.

;--------------------------------------------------------------------

timedelay0:        

            PUSH    r17                  ; Save r17 value

            PUSH    r18                  ; Save r18 value

            PUSH    r19                  ; Save r19 value


            MOV     R17, OUTSIDE_FOR_COUNT   ; outer counter

outside_for0:     SUB     R17, 0x01              ; decrement

                 MOV     R18, MIDDLE_FOR_COUNT    ; middle counter

middle_for0:      SUB     R18, 0x01              ; decrement

                 MOV     R19, INSIDE_FOR_COUNT    ; predefined inner value

inside_for0:      SUB     R19, 0x01              ; decrement

                 BRNE    inside_for0                

                 OR      R18, 0x00              

                 BRNE    middle_for0

                 OR      R17, 0x00               

                 BRNE    outside_for0


            POP    r19

            POP    r18

            POP    r17


            RET

;---------------------------------------------------------------------

; interrupt vector 

;---------------------------------------------------------------------

.CSEG

.ORG 0x3FF

           BRN MY_ISR

;---------------------------------------------------------------------

;Return Statement
RETURN:    RETIE
