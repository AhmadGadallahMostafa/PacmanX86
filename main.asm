;Owners : Ahmad Mostafa El Sayed 
;         Muhab Hossam El Din
;         Mazen Amr 
;         Youssef Shams 

;start Date : 25/12/2020
;Project Description : Simple pac man game including two players competeing for the highest score
;-------------------------------------------------------------------------------------------------------------------------------------
include io.inc
 .model medium 
 .stack 64
.data
	player1    db 15 , ? , 30 dup("$")        	;variable holding player 1 name
	player2    db 15 , ? , 30 dup("$")        	;variable holding player 2 name
	nameMsg    db 'Please Enter Your Name : $'	;Message displayed to prompt the user to enter his name
	enterMsg   db 'Press Enter to Continue $'
	welcomeMsg dw 'Welcome To our Game  $'
	welcomePosition db 0                                  
.code
main proc far
	     mov           ax,@data
	     mov           ds,ax
	     DisplayString welcomeMsg




main endp
end main
