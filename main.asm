;Authors : Ahmad Mostafa El Sayed
;          Muhab Hossam El Din
;          Mazen Amr
;          Youssef Shams

;	Start Date : 25/12/2020
;	Project Description : Simple PacMan game including two players competeing for the highest score

;Naming convention guidelines (PLEASE FOLLOW):
;	1-	Variables use camelCase
;	2-	Jumps and Macros use PascalCase

;---------------------------------------------------------------------------------------
include macros.asm
.model huge
.386 
.stack 0ffffh
.data
	player1Name         db  15 , ? , 30 dup("$")
	player2Name         db  15 , ? , 30 dup("$")
	clearMessage        db  50 dup(0), 10 dup("$")
	nameMessage         db  'Please Enter Your Name: $'
	enterMessage        db  'Press Enter to Continue$'
	welcomeMessage1     db  'Welcome To Our Game, Player 1!$'
	welcomeMessage2     db  'Welcome To Our Game, Player 2!$'
	warningMessage      db  '$$Please Enter a Valid Name!$'
	chattingInfo        db  '*To start chatting press F1$'
	gameStartInfo       db  '*To Start the Game press F2$'
	endgameInfo         db  '*To end the game press ESC$'
	level1Msg           db  '*To start level 1 press F1$'
	level2Msg           db  '*To start level 2 press F2$'
	notificationBar     db  '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -$'
	chooseLevelMsg      db  'Please Choose a level: $'
	player1WinsMsg      db  '!!!! PLAYER1 WINS !!!!$'
	player2WinsMsg      db  '!!!! PLAYER2 WINS !!!!$'
	welcomePosition     dw  0h
	scoreMessage1       db  'Score #1: $'
	scoreMessage2       db  'Score #2: $'
	player1Score        dw  0h
	player2Score        dw  0h
	livesMessage1       db  'Lives #1: $'
	livesMessage2       db  'Lives #2: $'
	player1Lives        dw  3h
	player2Lives        dw  3h
	scanF1              equ 3Bh
	;Scan code for F2 - change to 00h if using emu8086 else keep 3Ch
	scanF2              equ 3Ch
	scanF4              equ 3Eh
	scanESC             equ 1Bh
	grid                db  480 dup(dotCode)
	grid2               db  cornerLeftUpCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,    horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightUpCode,vacantCode,vacantCode,cornerLeftUpCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,              horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightUpCode,vacantCode
	                    db  verticalWallCode,dotCode,dotCode,dotCode,dotCode,dotCode,127,dotCode,dotCode,dotCode,                                                                                                                                           dotCode,dotCode,dotCode,cornerLeftDownCode,horizontalWallCode,horizontalWallCode,cornerRightDownCode,dotCode,dotCode,dotCode,                                                                                    127,dotCode,dotCode,dotCode,127,dotCode,dotCode,dotCode,cornerLeftDownCode,cornerRightUpCode
	                    db  verticalWallCode,dotCode,dotCode,cornerLeftUpCode,cornerRightUpCode,dotCode,cornerLeftUpCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,                                                      horizontalWallCode,cornerRightUpCode,dotCode,dotCode,127,dotCode,dotCode,dotCode,cornerLeftUpCode,horizontalWallCode,                                                                                        horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightUpCode,dotCode,cornerLeftUpCode,cornerRightUpCode,dotCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,cornerLeftUpCode,cornerRightDownCode,verticalWallCode,dotCode,verticalWallCode,vacantCode,vacantCode,vacantCode,                                                               vacantCode,verticalWallCode,dotCode,cornerLeftUpCode,horizontalWallCode,horizontalWallCode,cornerRightUpCode,dotCode,cornerLeftDownCode,horizontalWallCode,                                      horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightDownCode,dotCode,verticalWallCode,cornerLeftDownCode,cornerRightUpCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,verticalWallCode,vacantCode,verticalWallCode,dotCode,cornerLeftDownCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,                                              horizontalWallCode,cornerRightDownCode,dotCode,verticalWallCode,dotCode,dotCode,verticalWallCode,dotCode,dotCode,dotCode,                                                                                        dotCode,dotCode,127,dotCode,127,verticalWallCode,vacantCode,verticalWallCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,verticalWallCode,vacantCode,verticalWallCode,127,dotCode,dotCode,dotCode,dotCode,                                                                                                          dotCode,dotCode,127,endWallDownCode,dotCode,dotCode,endWallDownCode,dotCode,cornerLeftUpCode,horizontalWallCode,                                                                                             horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightUpCode,127,verticalWallCode,vacantCode,verticalWallCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,verticalWallCode,vacantCode,verticalWallCode,dotCode,cornerLeftUpCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,                                                horizontalWallCode,cornerRightUpCode,dotCode,dotCode,dotCode,dotCode,dotCode,127,cornerLeftDownCode,horizontalWallCode,                                                                                      horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightDownCode,dotCode,cornerLeftDownCode,horizontalWallCode,cornerRightDownCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,cornerLeftDownCode,horizontalWallCode,cornerRightDownCode,dotCode,cornerLeftDownCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,                                 horizontalWallCode,cornerRightDownCode,dotCode,endWallLeftCode,triWallUpCode,cornerRightUpCode,dotCode,dotCode,dotCode,dotCode,                                                                              127,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,                                                                                                                                           dotCode,dotCode,dotCode,dotCode,cornerLeftDownCode,triWallDownCode,endWallRightCode,dotCode,cornerLeftUpCode,horizontalWallCode,                                                                             horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightUpCode,dotCode,cornerLeftUpCode,horizontalWallCode,cornerRightUpCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,cornerLeftUpCode,horizontalWallCode,cornerRightUpCode,dotCode,cornerLeftUpCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,                                       horizontalWallCode,cornerRightUpCode,dotCode,dotCode,dotCode,127,dotCode,dotCode,cornerLeftDownCode,horizontalWallCode,                                                                                      horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightDownCode,127,verticalWallCode,vacantCode,verticalWallCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,verticalWallCode,vacantCode,verticalWallCode,127,cornerLeftDownCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,                                              horizontalWallCode,cornerRightDownCode,dotCode,endWallUpCode,dotCode,dotCode,endWallUpCode,dotCode,dotCode,dotCode,                                                                                              dotCode,dotCode,127,dotCode,dotCode,verticalWallCode,vacantCode,verticalWallCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,verticalWallCode,vacantCode,verticalWallCode,dotCode,dotCode,dotCode,dotCode,dotCode,                                                                                                          dotCode,dotCode,dotCode,verticalWallCode,dotCode,dotCode,verticalWallCode,dotCode,cornerLeftUpCode,horizontalWallCode,                                                                                           horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightUpCode,dotCode,verticalWallCode,vacantCode,verticalWallCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,cornerLeftDownCode,cornerRightUpCode,verticalWallCode,dotCode,cornerLeftUpCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,                                       horizontalWallCode,cornerRightUpCode,dotCode,cornerLeftDownCode,horizontalWallCode,horizontalWallCode,cornerRightDownCode,127,verticalWallCode,vacantCode,                                   vacantCode,vacantCode,vacantCode,verticalWallCode,127,verticalWallCode,cornerLeftUpCode,cornerRightDownCode,dotCode,verticalWallCode
	                    db  verticalWallCode,dotCode,dotCode,cornerLeftDownCode,cornerRightDownCode,dotCode,cornerLeftDownCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,                                                horizontalWallCode,cornerRightDownCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,cornerLeftDownCode,horizontalWallCode,                                                                                    horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightDownCode,dotCode,cornerLeftDownCode,cornerRightDownCode,127,dotCode,verticalWallCode
	                    db  cornerLeftDownCode,cornerRightUpCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,dotCode,                                                                                                                           dotCode,dotCode,dotCode,cornerLeftUpCode,horizontalWallCode,horizontalWallCode,cornerRightUpCode,dotCode,dotCode,dotCode,                                                                                        dotCode,127,dotCode,dotCode,dotCode,127,dotCode,dotCode,127,verticalWallCode
	                    db  vacantCode,cornerLeftDownCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,          horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightDownCode,vacantCode,vacantCode,cornerLeftDownCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,          horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,horizontalWallCode,cornerRightDownCode
	
	black               equ 00h
	blue                equ 01h
	green               equ 02h
	cyan                equ 03h
	red                 equ 04h
	magenta             equ 05h
	brown               equ 06h
	lightGray           equ 07h
	darkGray            equ 08h
	lightBlue           equ 09h
	lightGreen          equ 0ah
	lightCyan           equ 0bh
	lightRed            equ 0ch
	lightMagenta        equ 0dh
	yellow              equ 0eh
	white               equ 0fh
	filllvl1            equ 68h
	filllvl2            equ 0dbh
	borderlvl1          equ white
	player1InitialColor equ yellow
	player1Color        db  player1InitialColor
	player2InitialColor equ lightGreen
	player2Color        db  player2InitialColor
	borderColor         db  0
	backgroundColor     equ black
	fillColor           db  0
	ghostInitialColor   equ lightMagenta
	ghostColor          db  ghostInitialColor
	dotColor            equ white
	gridStartX          equ 10
	gridStartY          equ 20
	gridStep            equ 10
	gridXCount          equ 30
	gridYCount          equ 16
	;-------------------------- ITEMS CODES
	player1Code         equ 16
	player2Code         equ 17
	snowflakeCode       equ 18
	cherryCode          equ 19
	dotCode             equ 20
	bigDotCode          equ 21
	trapCode            equ 22
	extraLifeCode       equ 23
	decLifeCode         equ 24
	vacantCode          equ 25
	cornerLeftUpCode    equ 1
	cornerLeftDownCode  equ 2
	cornerRightUpCode   equ 3
	cornerRightDownCode equ 4
	horizontalWallCode  equ 5
	verticalWallCode    equ 6
	quadWallCode        equ 7
	triWallDownCode     equ 8
	triWallUpCode       equ 9
	triWallLeftCode     equ 10
	triWallRightCode    equ 11
	endWallDownCode     equ 12
	endWallUpCode       equ 13
	endWallLeftCode     equ 14
	endWallRightCode    equ 15
	ghostCode           equ 128
	;------------------------- END
	currentXPlayer1     dw  1
	currentYPlayer1     dw  1
	currentXPlayer2     dw  28
	currentYPlayer2     dw  14
	player1Orientation  db  'R'
	player2Orientation  db  'L'
	isOpen              db  1
	rightArrowScan      equ 4dh
	leftArrowScan       equ 4bh
	upArrowScan         equ 48h
	downArrowScan       equ 50h
	currentX            dw  gridStartX
	currentY            dw  gridStartY
	player1Moved        db  0
	player2Moved        db  0
	wScanCode           equ 11h
	aSCanCode           equ 1eh
	sSCanCode           equ 1fh
	dScanCode           equ 20h
	gridColor           db  0
	ghostsIsFrozen      db  0
	player2IsFrozen     db  0
	player1IsFrozen     db  0
	player1IsBigDot     dw  0
	player2IsBigDot     dw  0
	player1IsGreenDot   db  0
	player2IsGreenDot   db  0
	freezeDuration      equ 25
	player1FreezeDur    db  freezeDuration
	player2FreezeDur    db  freezeDuration
	ghostFreezeDur      db  freezeDuration
	bigDotDuartion      equ 15
	player1BigDotDur    db  bigDotDuartion
	player2BigDotDur    db  bigDotDuartion
	greenDotDuration    equ 15
	player1GreenDotDur  db  greenDotDuration
	player2GreenDotDur  db  greenDotDuration
	ghostX              db  0
	ghostY              db  0
	searchX             db  0
	searchY             db  0
	nodeX               db  0
	nodeY               db  0
	searchCount         dw  0
	rightValue          dw  0ffh
	leftValue           dw  0ffh
	upValue             dw  0ffh
	downValue           dw  0ffh
	maxValue            dw  0ffh
	nextMove            db  0
	isPlayer1Dead       db  0
	isPlayer2Dead       db  0
	isGameFinished      db  0
	player1Respawn      db  0
	player2Respawn      db  0
	player1Initial      dw  0
	player2Initial      dw  0
	player1Lvl1Initial  equ 31
	player2lvl1Initial  equ 448
	player1Lvl2Initial  equ 31
	player2Lvl2Initial  equ 448
	IsF4Pressed         db  0
	zerogrid            db  480 dup(dotcode)
	IsLevel2            db  0
	letterToSend        db  ?
	msgToSend           db  60,?,60 dup('$')
	MsgToReceive        db  60,?,60 dup('$')
	letterToReceive     db  ?
	confirmReceive      db  10
	ghostCount          dw  4
	ghostPositions      dw  16 dup(?)
	ghostPeriod         equ 20
	ghostTimer          db  1
	powerUpPosition     dw  ?
	powerUpPeriod       equ 30
	powerUpTimer        db  1
	seed                dw  ?
	dotcount            db  0

.code
AddPowerUp proc
	                         dec                     powerUpTimer
	                         jnz                     EndAddPowerUp
	                         mov                     powerUpTimer, powerUpPeriod
	                         GetRandomNumber         480
	                         mov                     bx, ax
	FindEmptyCellPowerup:    
	                         cmp                     grid[bx], 127d
	                         je                      EmptyCellFoundPowerup
	                         inc                     bx
	                         cmp                     bx, 480
	                         jb                      FindEmptyCellPowerup
	                         jmp                     EndAddPowerUp
	EmptyCellFoundPowerup:   
	                         cmp                     grid[bx], 127
	                         jne                     EndAddPowerUp

	                         GetRandomNumber         50
	                         cmp                     ax, 10
	                         jb                      AddCherry
	                         cmp                     ax, 20
	                         jb                      AddSnowFlake
	                         cmp                     ax, 30
	                         jb                      AddTrap
	                         cmp                     ax, 40
	                         jb                      AddExtraLife
	                         cmp                     ax, 50
	                         jb                      AddDecLife
	AddCherry:               
	                         mov                     grid[bx], cherryCode
	                         jmp                     EndAddPowerUp
	AddSnowFlake:            
	                         mov                     grid[bx], snowflakeCode
	                         jmp                     EndAddPowerUp
	AddTrap:                 
	                         mov                     grid[bx], trapCode
	                         jmp                     EndAddPowerUp
	AddExtraLife:            
	                         mov                     grid[bx], extraLifeCode
	                         jmp                     EndAddPowerUp
	AddDecLife:              
	                         mov                     grid[bx], decLifeCode
	                         jmp                     EndAddPowerUp
	EndAddPowerUp:           
	                         ret
AddPowerUp endp

MoveGhosts proc
	                         dec                     ghostTimer
	                         jnz                     EndMoveGhost
	                         cmp                     ghostsIsFrozen, 1
	                         je                      EndMoveGhost
	                         mov                     ghostTimer, ghostPeriod
	                         mov                     cx, ghostCount
	                         mov                     si, 0
	LoopOverGhosts:          
	                         mov                     di, ghostPositions[si]
	                         cmp                     grid[di], 128
	                         jb                      DontClearGhost
	                         mov                     grid[di], 127
	DontClearGhost:          
	                         GetRandomNumber         480
	                         mov                     bx, ax
	FindEmptyCellGhost:      
	                         cmp                     grid[bx], 127d
	                         je                      EmptyCellFoundGhost
	                         inc                     bx
	                         cmp                     bx, 480
	                         jb                      FindEmptyCellGhost
	ContinueLoopOverGhosts:  
	                         add                     si, 2
	                         dec                     cx
	                         jnz                     LoopOverGhosts
	                         jmp                     EndMoveGhost
	EmptyCellFoundGhost:     
	                         mov                     grid[bx], 128d
	                         mov                     ghostPositions[si], bx
	                         jmp                     ContinueLoopOverGhosts
	EndMoveGhost:            
	                         ret
MoveGhosts endp

MovePacman proc
	                         mov                     player1Moved,0
	                         mov                     player2Moved,0
	MoveLoop:                
	                         mov                     ah,1
	                         int                     16h
	                         jz                      endMovePacMan
	                         mov                     ah,0
	                         int                     16h
	                         cmp                     ah, scanF4
	                         je                      ApplyF4InMove
	                         cmp                     ah, scanF1
	                         je                      InGameChat
	AfterF4Check:            
	; Added part for Freeze effect:
	; The dec of FreezeDuration and setting it to zero when the Duration = 0 is in the IsFrozen proc.
	; If Player 1 is frozen we will jmp straight to the part of the code that reads the scancodes responsible for the movement of player2
	                         cmp                     player1IsFrozen,1
	                         je                      Player2MovmentCodes
	                         cmp                     isPlayer1Dead, 1
	                         je                      Player2MovmentCodes
	                         cmp                     ah,rightArrowScan
	                         je                      MovePlayer1Right
	                         cmp                     ah,leftArrowScan
	                         je                      MovePlayer1Left
	                         cmp                     ah,upArrowScan
	                         je                      MovePlayer1Up
	                         cmp                     ah,downArrowScan
	                         je                      MovePlayer1Down
	; If Player2 is frozen we will skip the part where it moves him and we will continue the rest of the movement procedure.
	                         cmp                     player2IsFrozen,1
	                         je                      MoveLoop
	Player2MovmentCodes:     
	                         cmp                     isPlayer2Dead,1
	                         je                      moveLoop
	                         cmp                     ah,dScanCode
	                         je                      MovePlayer2Right
	                         cmp                     ah,aSCanCode
	                         je                      MovePlayer2Left
	                         cmp                     ah,wScanCode
	                         je                      MovePlayer2Up
	                         cmp                     ah,sSCanCode
	                         je                      MovePlayer2Down
	                         jmp                     MoveLoop
	ApplyF4InMove:           
	                         mov                     IsF4Pressed, 1
	                         jmp                     AfterF4Check
	MovePlayer1Right:        
	                         cmp                     player1Moved,0
	                         jne                     MoveLoop
	                         mov                     player1Orientation, 'R'
	;check walls
	                         inc                     currentXPlayer1
	                         GridToCell              currentXPlayer1 ,currentYPlayer1
	                         dec                     currentXPlayer1
	                         cmp                     grid[bx],16
	                         jb                      MoveLoop
	;end check walls
	;check ghost
	                         inc                     currentXPlayer1
	                         GridToCell              currentXPlayer1, currentYPlayer1
	                         dec                     currentXPlayer1
	                         cmp                     grid[bx], 128
	                         jae                     GhostRightPlayer1
	;end check ghost
	;check player2
	                         inc                     currentXPlayer1
	                         GridToCell              currentXPlayer1 ,currentYPlayer1
	                         dec                     currentXPlayer1
	                         cmp                     grid[bx],player2Code
	                         je                      player2right
	;end check player2
	ContMoveRight1:          
	                         GridToCell              currentXPlayer1, currentYPlayer1
	                         mov                     grid[bx],127
	                         add                     currentXPlayer1,1
	                         jmp                     ChangePlayer1Pacman
	MovePlayer1Left:         
	                         cmp                     player1Moved,0
	                         jne                     MoveLoop
	                         mov                     player1Orientation, 'L'
	;check walls
	                         dec                     currentXPlayer1
	                         GridToCell              currentXPlayer1 ,currentYPlayer1
	                         inc                     currentXPlayer1
	                         cmp                     grid[bx],16
	                         jb                      MoveLoop
	;end check walls
	;check ghost
	                         dec                     currentXPlayer1
	                         GridToCell              currentXPlayer1, currentYPlayer1
	                         inc                     currentXPlayer1
	                         cmp                     grid[bx], 128
	                         jae                     GhostLeftPlayer1
	;check player2
	ContMoveLeft1:           
	                         dec                     currentXPlayer1
	                         GridToCell              currentXPlayer1 ,currentYPlayer1
	                         inc                     currentXPlayer1
	                         cmp                     grid[bx],player2Code
	                         je                      player2left
	;end check player2
	;end check ghost
	                         GridToCell              currentXPlayer1, currentYPlayer1
	                         mov                     grid[bx],127
	                         sub                     currentXPlayer1,1
	                         jmp                     ChangePlayer1Pacman
	MovePlayer1Up:           
	                         cmp                     player1Moved,0
	                         jne                     MoveLoop
	                         mov                     player1Orientation, 'U'
	;check walls
	                         dec                     currentYPlayer1
	                         GridToCell              currentXPlayer1 ,currentYPlayer1
	                         inc                     currentYPlayer1
	                         cmp                     grid[bx],16
	                         jb                      MoveLoop
	;end check walls
	;check Ghost
	                         dec                     currentYPlayer1
	                         GridToCell              currentXPlayer1 ,currentYPlayer1
	                         inc                     currentYPlayer1
	                         cmp                     grid[bx],128
	                         jae                     GhostUpPlayer1
	;end check Ghosts
	;check player2
	ContMoveUp1:             
	                         dec                     currentYPlayer1
	                         GridToCell              currentXPlayer1 ,currentYPlayer1
	                         inc                     currentYPlayer1
	                         cmp                     grid[bx],player2Code
	                         je                      player2up
	;end check player2
	                         GridToCell              currentXPlayer1, currentYPlayer1
	                         mov                     grid[bx],127
	                         sub                     currentYPlayer1,1
	                         jmp                     ChangePlayer1Pacman
	MovePlayer1Down:         
	                         cmp                     player1Moved,0
	                         jne                     MoveLoop
	                         mov                     player1Orientation, 'D'
	;check walls
	                         inc                     currentYPlayer1
	                         GridToCell              currentXPlayer1 ,currentYPlayer1
	                         dec                     currentYPlayer1
	                         cmp                     grid[bx],16
	                         jb                      MoveLoop
	;end check walls
	;check Ghosts
	                         inc                     currentYPlayer1
	                         GridToCell              currentXPlayer1 ,currentYPlayer1
	                         dec                     currentYPlayer1
	                         cmp                     grid[bx],128
	                         jae                     GhostDownPlayer1
	;end check Ghosts
	;check player2
	ContMoveDown1:           
	                         inc                     currentYPlayer1
	                         GridToCell              currentXPlayer1 ,currentYPlayer1
	                         dec                     currentYPlayer1
	                         cmp                     grid[bx],player2Code
	                         je                      player2down
	;end check player2
	                         GridToCell              currentXPlayer1, currentYPlayer1
	                         mov                     grid[bx],127
	                         add                     currentYPlayer1,1
	                         jmp                     ChangePlayer1Pacman
	ChangePlayer1Pacman:     
	                         GridToCell              currentXPlayer1, currentYPlayer1
	                         jmp                     CheckPowerUpsPlayer1
	AfterPowerUp1:           
	                         cmp                     player1Lives, 0
	                         je                      Player1Deadd
	                         mov                     grid[bx],player1Code
	                         mov                     player1Moved,1
	                         jmp                     MoveLoop
	Player1Deadd:            
	                         mov                     isPlayer1Dead, 1
	                         jmp                     MoveLoop
	CheckPowerUpsPlayer1:    
	                         push                    bx
	                         cmp                     grid[bx], dotCode
	                         je                      ApplyDot1
	                         cmp                     grid[bx], snowflakeCode
	                         je                      ApplyFreeze1
	                         cmp                     grid[bx], cherryCode
	                         je                      ApplyCherry1
	                         cmp                     grid[bx], bigDotCode
	                         je                      ApplyBigDot1
	                         cmp                     grid[bx], trapCode
	                         je                      ApplyGreenDot1
	                         cmp                     grid[bx], extraLifeCode
	                         je                      ApplyPacmanLife1
	                         cmp                     grid[bx], decLifeCode
	                         je                      ApplyPacmanUnLife1
	ReturningToMovePlayer1:  
	                         pop                     bx
	                         jmp                     AfterPowerUp1
	ApplyDot1:               
	                         add                     player1Score, 1
	                         jmp                     ReturningToMovePlayer1
	ApplyFreeze1:            
	                         mov                     player2FreezeDur, freezeDuration
	                         mov                     ghostFreezeDur, freezeDuration
	                         mov                     player2IsFrozen, 1
	                         mov                     ghostsIsFrozen, 1
	                         jmp                     ReturningToMovePlayer1
	ApplyCherry1:            
	                         add                     player1Score,10
	                         jmp                     ReturningToMovePlayer1
	ApplyBigDot1:            
	                         mov                     player1BigDotDur, bigDotDuartion
	                         mov                     player1IsBigDot, 1
	                         mov                     player1IsGreenDot, 0
	                         jmp                     ReturningToMovePlayer1
	ApplyGreenDot1:          
	                         mov                     player1GreenDotDur, bigDotDuartion
	                         mov                     player1IsGreenDot, 1
	                         mov                     player1IsBigDot, 0
	                         jmp                     ReturningToMovePlayer1

	ApplyPacmanLife1:        
	                         add                     player1Lives, 1
	                         jmp                     ReturningToMovePlayer1
	ApplyPacmanUnLife1:      
	                         cmp                     player2Lives,0
	                         je                      SetPlayer2Dead
	                         sub                     player2Lives, 1
	                         je                      SetPlayer2Dead
	                         jmp                     ReturningToMovePlayer1
	SetPlayer2Dead:          
	                         mov                     isPlayer2Dead, 1
	                         jmp                     ReturningToMovePlayer1

	
	SetDead1:                
	                         mov                     isPlayer1Dead, 1
	                         jmp                     moveLoop
	GhostRightPlayer1:       
	                         mov                     ax,player1IsBigDot
	                         cmp                     ax,1
	                         je                      eatghostrightplayer1
	                         GridToCell              currentXPlayer1,currentYPlayer1
	                         mov                     grid[bx],127
	                         dec                     player1Lives
	                         cmp                     player1Lives, 0
	                         je                      SetDead1
	                         mov                     currentXPlayer1,1
	                         mov                     currentYPlayer1,1
	                         mov                     player1Respawn, 1
	                         jmp                     MoveLoop
	eatghostRightplayer1:    
	                         GridToCell              currentXPlayer1,currentYPlayer1
	                         mov                     grid[bx],127
	                         add                     player1Score,10
	                         add                     currentXPlayer1,1
	                         jmp                     ChangePlayer1Pacman
	GhostUpPlayer1:          
	                         mov                     ax,player1IsBigDot
	                         cmp                     ax,1
	                         je                      eatghostUpplayer1
	                         GridToCell              currentXPlayer1,currentYPlayer1
	                         mov                     grid[bx],127
	                         dec                     player1Lives
	                         cmp                     player1Lives, 0
	                         je                      SetDead1
	                         mov                     currentXPlayer1,1
	                         mov                     currentYPlayer1,1
	                         mov                     player1Respawn, 1
	                         jmp                     MoveLoop
	eatghostUpplayer1:       
	                         GridToCell              currentXPlayer1,currentYPlayer1
	                         mov                     grid[bx],127
	                         add                     player1Score,10
	                         sub                     currentYPlayer1,1
	                         jmp                     ChangePlayer1Pacman

	GhostDownPlayer1:        
	                         mov                     ax,player1IsBigDot
	                         cmp                     ax,1
	                         je                      eatghostDownplayer1
	                         GridToCell              currentXPlayer1,currentYPlayer1
	                         mov                     grid[bx],127
	                         dec                     player1Lives
	                         cmp                     player1Lives, 0
	                         je                      SetDead1
	                         mov                     currentXPlayer1,1
	                         mov                     currentYPlayer1,1
	                         mov                     player1Respawn, 1
	                         jmp                     MoveLoop
	eatghostDownplayer1:     
	                         GridToCell              currentXPlayer1,currentYPlayer1
	                         mov                     grid[bx],127
	                         add                     player1Score,10
	                         add                     currentYPlayer1,1
	                         jmp                     ChangePlayer1Pacman

	GhostLeftPlayer1:        
	                         mov                     ax,player1IsBigDot
	                         cmp                     ax,1
	                         je                      eatghostLeftplayer1
	                         GridToCell              currentXPlayer1,currentYPlayer1
	                         mov                     grid[bx],127
	                         dec                     player1Lives
	                         cmp                     player1Lives, 0
	                         je                      SetDead1
	                         mov                     currentXPlayer1,1
	                         mov                     currentYPlayer1,1
	                         mov                     player1Respawn, 1
	                         jmp                     MoveLoop
	eatghostLeftplayer1:     
	                         GridToCell              currentXPlayer1,currentYPlayer1
	                         mov                     grid[bx],127
	                         add                     player1Score,10
	                         sub                     currentXPlayer1,1
	                         jmp                     ChangePlayer1Pacman

	player2right:            
	                         cmp                     player1IsGreenDot,1
	                         je                      eatplayer2Right
	                         jmp                     moveLoop
	eatplayer2Right:         mov                     grid[bx], 127
	                         dec                     player2Lives
	                         mov                     currentXPlayer2,28
	                         mov                     currentYPlayer2,14
	                         add                     player1Score,20
	                         inc                     currentXPlayer1
	                         mov                     player2Respawn, 1
	                         jmp                     ContMoveRight1

	player2left:             
	                         cmp                     player1IsGreenDot,1
	                         je                      eatplayer2left
	                         jmp                     moveLoop
	eatplayer2left:          mov                     grid[bx], 127
	                         dec                     player2Lives
	                         mov                     currentXPlayer2,28
	                         mov                     currentYPlayer2,14
	                         add                     player1Score,20
	                         dec                     currentXPlayer1
	                         mov                     player2Respawn, 1
	                         jmp                     ContMoveLeft1

	player2up:               
	                         cmp                     player1IsGreenDot,1
	                         je                      eatplayer2up
	                         jmp                     moveLoop
	eatplayer2up:            mov                     grid[bx], 127
	                         dec                     player2Lives
	                         mov                     currentXPlayer2,28
	                         mov                     currentYPlayer2,14
	                         add                     player1Score,20
	                         inc                     currentYPlayer1
	                         mov                     player2Respawn, 1
	                         jmp                     ContMoveUp1

	player2down:             
	                         cmp                     player1IsGreenDot,1
	                         je                      eatplayer2down
	                         jmp                     moveLoop
	eatplayer2down:          mov                     grid[bx], 127
	                         dec                     player2Lives
	                         mov                     currentXPlayer2,28
	                         mov                     currentYPlayer2,14
	                         add                     player1Score,20
	                         dec                     currentYPlayer1
	                         mov                     player2Respawn, 1
	                         jmp                     ContMoveDown1
	;--------------------------------------------------------------------------------------
	MovePlayer2Right:        
	                         cmp                     player2Moved,0
	                         jne                     MoveLoop
	                         mov                     player2Orientation, 'R'
	;check walls
	                         inc                     currentXPlayer2
	                         GridToCell              currentXPlayer2 ,currentYPlayer2
	                         dec                     currentXPlayer2
	                         cmp                     grid[bx],16
	                         jb                      MoveLoop
	;end check walls
	;check Ghosts
	                         inc                     currentXPlayer2
	                         GridToCell              currentXPlayer2 ,currentYPlayer2
	                         dec                     currentXPlayer2
	                         cmp                     grid[bx],128
	                         jae                     GhostRightPlayer2
	;end check ghosts
	;check player1
	                         inc                     currentXPlayer2
	                         GridToCell              currentXPlayer2 ,currentYPlayer2
	                         dec                     currentXPlayer2
	                         cmp                     grid[bx],player1Code
	                         je                      player1right
	;end check player1
	ContMoveRight2:          

	                         GridToCell              currentXPlayer2, currentYPlayer2
	                         mov                     grid[bx],127
	                         add                     currentXPlayer2,1
	                         jmp                     ChangePlayer2Pacman
	MovePlayer2Left:         
	                         cmp                     player2Moved,0
	                         jne                     MoveLoop
	                         mov                     player2Orientation, 'L'
	;check walls
	                         dec                     currentXPlayer2
	                         GridToCell              currentXPlayer2 ,currentYPlayer2
	                         inc                     currentXPlayer2
	                         cmp                     grid[bx],16
	                         jb                      MoveLoop
	;end check walls
	;check ghost
	                         dec                     currentXPlayer2
	                         GridToCell              currentXPlayer2 ,currentYPlayer2
	                         inc                     currentXPlayer2
	                         cmp                     grid[bx],128
	                         jae                     GhostLeftPlayer2
	;end check ghosts
	;check player1
	                         dec                     currentXPlayer2
	                         GridToCell              currentXPlayer2 ,currentYPlayer2
	                         inc                     currentXPlayer2
	                         cmp                     grid[bx],player1Code
	                         je                      player1left
	;end check player1
	ContMoveLeft2:           
	                         GridToCell              currentXPlayer2, currentYPlayer2
	                         mov                     grid[bx],127
	                         sub                     currentXPlayer2,1
	                         jmp                     ChangePlayer2Pacman
	MovePlayer2Up:           
	                         cmp                     player2Moved,0
	                         jne                     MoveLoop
	                         mov                     player2Orientation, 'U'
	;check walls
	                         dec                     currentYPlayer2
	                         GridToCell              currentXPlayer2 ,currentYPlayer2
	                         inc                     currentYPlayer2
	                         cmp                     grid[bx],16
	                         jb                      MoveLoop
	;end check walls
	;check ghost
	                         dec                     currentYPlayer2
	                         GridToCell              currentXPlayer2 ,currentYPlayer2
	                         inc                     currentYPlayer2
	                         cmp                     grid[bx],128
	                         jae                     GhostUpPlayer2
	;end check ghost
	;check player1
	                         dec                     currentYPlayer2
	                         GridToCell              currentXPlayer2 ,currentYPlayer2
	                         inc                     currentYPlayer2
	                         cmp                     grid[bx],player1Code
	                         je                      player1up
	;end check player1
	ContMoveUp2:             
	                         GridToCell              currentXPlayer2, currentYPlayer2
	                         mov                     grid[bx],127
	                         sub                     currentYPlayer2,1
	                         jmp                     ChangePlayer2Pacman
	MovePlayer2Down:         
	                         cmp                     player2Moved,0
	                         jne                     MoveLoop
	                         mov                     player2Orientation, 'D'
	;check walls
	                         inc                     currentYPlayer2
	                         GridToCell              currentXPlayer2 ,currentYPlayer2
	                         dec                     currentYPlayer2
	                         cmp                     grid[bx],16
	                         jb                      MoveLoop
	;end check walls
	;check Ghosts
	                         inc                     currentYPlayer2
	                         GridToCell              currentXPlayer2 ,currentYPlayer2
	                         dec                     currentYPlayer2
	                         cmp                     grid[bx],128
	                         jae                     GhostDownPlayer2
	;end check Ghosts
	;check player1
	                         inc                     currentYPlayer2
	                         GridToCell              currentXPlayer2 ,currentYPlayer2
	                         dec                     currentYPlayer2
	                         cmp                     grid[bx],player1Code
	                         je                      player1down
	;end check player1
	ContMoveDown2:           
	                         GridToCell              currentXPlayer2, currentYPlayer2
	                         mov                     grid[bx], 127
	                         add                     currentYPlayer2, 1
	                         jmp                     ChangePlayer2Pacman
	ChangePlayer2Pacman:     
	                         GridToCell              currentXPlayer2, currentYPlayer2
	                         jmp                     CheckPowerUpsPlayer2
	AfterPowerUp2:           
	                         cmp                     player2Lives, 0
	                         je                      Player2Deadd
	                         mov                     grid[bx], player2Code
	                         mov                     player2Moved, 1
	                         jmp                     MoveLoop
	Player2Deadd:            
	                         mov                     isPlayer2Dead, 1
	                         jmp                     MoveLoop
	;--------------------------------------------------------------------------------------

	CheckPowerUpsPlayer2:    
	                         push                    bx
	                         cmp                     grid[bx], dotCode
	                         je                      ApplyDot2
	                         cmp                     grid[bx], snowflakeCode
	                         je                      ApplyFreeze2
	                         cmp                     grid[bx], cherryCode
	                         je                      ApplyCherry2
	                         cmp                     grid[bx], bigDotCode
	                         je                      ApplyBigDot2
	                         cmp                     grid[bx], trapCode
	                         je                      ApplyGreenDot2
	                         cmp                     grid[bx], extraLifeCode
	                         je                      ApplyPacmanLife2
	                         cmp                     grid[bx], decLifeCode
	                         je                      ApplyPacmanUnLife2
	ReturningToMovePlayer2:  
	                         pop                     bx
	                         jmp                     AfterPowerUp2
	ApplyDot2:               
	                         add                     player2Score, 1
	                         jmp                     ReturningToMovePlayer2
	ApplyFreeze2:            
	                         mov                     player1FreezeDur, freezeDuration
	                         mov                     ghostFreezeDur, freezeDuration
	                         mov                     player1IsFrozen, 1
	                         mov                     ghostsIsFrozen, 1
	                         jmp                     ReturningToMovePlayer2
	ApplyCherry2:            
	                         add                     player2Score,10
	                         jmp                     ReturningToMovePlayer2
	ApplyBigDot2:            
	                         mov                     player2BigDotDur, bigDotDuartion
	                         mov                     player2IsBigDot, 1
	                         mov                     player2IsGreenDot, 0
	                         jmp                     ReturningToMovePlayer2
	ApplyGreenDot2:          
	                         mov                     player2GreenDotDur, greenDotDuration
	                         mov                     player2IsGreenDot, 1
	                         mov                     player2IsBigDot, 0
	                         jmp                     ReturningToMovePlayer2
	ApplyPacmanLife2:        
	                         add                     player2Lives, 1
	                         jmp                     ReturningToMovePlayer2
	ApplyPacmanUnLife2:      
	                         cmp                     player1Lives,0
	                         je                      SetPlayer1Dead
	                         sub                     player1Lives, 1
	                         je                      SetPlayer1Dead
	                         jmp                     ReturningToMovePlayer2
	SetPlayer1Dead:          
	                         mov                     isPlayer1Dead, 1
	                         jmp                     ReturningToMovePlayer2

	DecrementPlayer2Live:    
	                         GridToCell              currentXPlayer2,currentYPlayer2
	                         mov                     grid[bx],127
	                         dec                     player2Lives
	                         cmp                     player2Lives, 0
	                         je                      SetDead2
	                         mov                     currentXPlayer2, 28
	                         mov                     currentYPlayer2, 14                                                          	;we can add a delay later maybe integrate the freeze functionality
	                         mov                     player2Respawn, 1
	                         jmp                     MoveLoop
	SetDead2:                mov                     isPlayer2Dead,1
	                         jmp                     MoveLoop
	GhostRightPlayer2:       
	                         mov                     ax,player2IsBigDot
	                         cmp                     ax,1
	                         je                      eatghostrightplayer2
	                         GridToCell              currentXPlayer2,currentYPlayer2
	                         mov                     grid[bx],127
	                         dec                     player2Lives
	                         cmp                     player2Lives, 0
	                         je                      SetDead2
	                         mov                     currentXPlayer2,28
	                         mov                     currentYPlayer2,14
	                         mov                     player2Respawn, 1
	                         jmp                     MoveLoop
	eatghostRightplayer2:    
	                         GridToCell              currentXPlayer2, currentYPlayer2
	                         mov                     grid[bx],127
	                         add                     player2Score,10
	                         add                     currentXPlayer2,1
	                         jmp                     ChangePlayer2Pacman
	GhostUpPlayer2:          
	                         mov                     ax,player2IsBigDot
	                         cmp                     ax,1
	                         je                      eatghostUpplayer2
	                         GridToCell              currentXPlayer2,currentYPlayer2
	                         mov                     grid[bx],127
	                         dec                     player2Lives
	                         cmp                     player2Lives, 0
	                         je                      SetDead2
	                         mov                     currentXPlayer2,28
	                         mov                     currentYPlayer2,14
	                         mov                     player2Respawn, 1
	                         jmp                     MoveLoop
	eatghostUpplayer2:       
	                         GridToCell              currentXPlayer2, currentYPlayer2
	                         mov                     grid[bx],127
	                         add                     player2Score,10
	                         sub                     currentYPlayer2,1
	                         jmp                     ChangePlayer2Pacman

	GhostDownPlayer2:        
	                         mov                     ax,player2IsBigDot
	                         cmp                     ax,1
	                         je                      eatghostDownplayer2
	                         GridToCell              currentXPlayer2,currentYPlayer2
	                         mov                     grid[bx],127
	                         dec                     player2Lives
	                         cmp                     player2Lives, 0
	                         je                      SetDead2
	                         mov                     currentXPlayer2,28
	                         mov                     currentYPlayer2,14
	                         mov                     player2Respawn, 1
	                         jmp                     MoveLoop
	eatghostDownplayer2:     
	                         GridToCell              currentXPlayer2, currentYPlayer2
	                         mov                     grid[bx],127
	                         add                     player2Score,10
	                         add                     currentYPlayer2,1
	                         jmp                     ChangePlayer2Pacman

	GhostLeftPlayer2:        
	                         mov                     ax,player2IsBigDot
	                         cmp                     ax,1
	                         je                      eatghostLeftplayer2
	                         GridToCell              currentXPlayer2,currentYPlayer2
	                         mov                     grid[bx],127
	                         dec                     player2Lives
	                         cmp                     player2Lives, 0
	                         je                      SetDead2
	                         mov                     currentXPlayer2,28
	                         mov                     currentYPlayer2,14
	                         mov                     player2Respawn, 1
	                         jmp                     MoveLoop
	eatghostLeftplayer2:     
	                         GridToCell              currentXPlayer2, currentYPlayer2
	                         mov                     grid[bx],127
	                         add                     player2Score,10
	                         sub                     currentXPlayer2,1
	                         jmp                     ChangePlayer2Pacman

	player1right:            
	                         cmp                     player2IsGreenDot,1
	                         je                      eatplayer1Right
	                         jmp                     moveLoop
	eatplayer1Right:         mov                     grid[bx], 127
	                         dec                     player1Lives
	                         mov                     currentXPlayer1,1
	                         mov                     currentYPlayer1,1
	                         add                     player2Score,20
	                         inc                     currentXPlayer2
	                         mov                     player1Respawn, 1
	                         jmp                     ContMoveRight2

	player1left:             
	                         cmp                     player2IsGreenDot,1
	                         je                      eatplayer1left
	                         jmp                     moveLoop
	eatplayer1left:          mov                     grid[bx], 127
	                         dec                     player1Lives
	                         mov                     currentXPlayer1,1
	                         mov                     currentYPlayer1,1
	                         add                     player2Score,20
	                         dec                     currentXPlayer2
	                         mov                     player1Respawn, 1
	                         jmp                     ContMoveLeft2

	player1up:               
	                         cmp                     player2IsGreenDot,1
	                         je                      eatplayer1up
	                         jmp                     moveLoop
	eatplayer1up:            mov                     grid[bx], 127
	                         dec                     player1Lives
	                         mov                     currentXPlayer1,1
	                         mov                     currentYPlayer1,1
	                         add                     player2Score,20
	                         inc                     currentYPlayer2
	                         mov                     player1Respawn, 1
	                         jmp                     ContMoveUp2

	player1down:             
	                         cmp                     player2IsGreenDot,1
	                         je                      eatplayer1down
	                         jmp                     moveLoop
	eatplayer1down:          mov                     grid[bx], 127
	                         dec                     player1Lives
	                         mov                     currentXPlayer1,1
	                         mov                     currentYPlayer1,1
	                         add                     player2Score,20
	                         dec                     currentYPlayer2
	                         mov                     player1Respawn, 1
	                         jmp                     ContMoveDown2
	InGameChat:              
	                         Chat
	                         SetVideoMode
	                         jmp                     MoveLoop
	terminate:               
MovePacman endp

IsFrozen proc
	CheckPlayer1Freeze:      
	                         cmp                     player1IsFrozen,1
	                         je                      DecPlayer1FreezeEffect
	CheckPlayer2Freeze:      
	                         cmp                     player2IsFrozen, 1
	                         je                      DecPlayer2FreezeEffect
	CheckGhostFreeze:        
	                         cmp                     ghostsIsFrozen,1
	                         je                      DecGhoshtFreezeEffect
	ReturnFreeze:            
	                         ret
	DecPlayer1FreezeEffect:  
	                         sub                     player1FreezeDur,1
	                         jz                      SetFreeze1
	                         jmp                     CheckPlayer2Freeze
	SetFreeze1:              
	                         mov                     player1IsFrozen,0
	                         jmp                     CheckPlayer2Freeze
	DecPlayer2FreezeEffect:  
	                         sub                     player2FreezeDur,1
	                         jz                      SetFreeze2
	                         jmp                     CheckGhostFreeze
	SetFreeze2:              
	                         mov                     player2IsFrozen,0
	                         jmp                     CheckGhostFreeze
	DecGhoshtFreezeEffect:   
	                         sub                     ghostFreezeDur,1
	                         jz                      SetFreezeGhost
	                         jmp                     ReturnFreeze
	SetFreezeGhost:          
	                         mov                     ghostsIsFrozen,0
	                         jmp                     ReturnFreeze
	EndMovePacMan:           
	                         ret
IsFrozen endp

IsBigDot proc
	CheckPlayer1BigDot:      
	                         cmp                     player1IsBigDot,1
	                         je                      DecPlayer1BigDotEffect
	CheckPlayer2BigDot:      
	                         cmp                     player2IsBigDot, 1
	                         je                      DecPlayer2BigDotEffect
	ReturnBigDot:            
	                         ret
	DecPlayer1BigDotEffect:  
	                         sub                     player1BigDotDur,1
	                         jz                      SetBigDot1
	                         jmp                     CheckPlayer2BigDot
	SetBigDot1:              
	                         mov                     player1IsBigDot,0
	                         jmp                     CheckPlayer2BigDot
	DecPlayer2BigDotEffect:  
	                         sub                     player2BigDotDur,1
	                         jz                      SetBigDot2
	                         jmp                     ReturnBigDot
	SetBigDot2:              
	                         mov                     player2IsBigDot,0
	                         jmp                     ReturnBigDot
	EndMovePacMann:          
	                         ret
IsBigDot endp


IsGreenDot proc
	CheckPlayer1GreenDot:    
	                         cmp                     player1IsGreenDot,1
	                         je                      DecPlayer1GreenDotEffect
	CheckPlayer2GreenDot:    
	                         cmp                     player2IsGreenDot, 1
	                         je                      DecPlayer2GreenDotEffect
	ReturnGreenDot:          
	                         ret
	DecPlayer1GreenDotEffect:
	                         sub                     player1GreenDotDur,1
	                         jz                      SetGreenDot1
	                         jmp                     CheckPlayer2GreenDot
	SetGreenDot1:            
	                         mov                     player1IsGreenDot,0
	                         jmp                     CheckPlayer2GreenDot
	DecPlayer2GreenDotEffect:
	                         sub                     player2GreenDotDur,1
	                         jz                      SetGreenDot2
	                         jmp                     ReturnGreenDot
	SetGreenDot2:            
	                         mov                     player2IsGreenDot,0
	                         jmp                     ReturnGreenDot
	EndMovePacMannn:         
	                         ret
IsGreenDot endp

DrawGrid proc
	                         mov                     currentX, gridStartX
	                         mov                     currentY, gridStartY
	                         mov                     gridColor, 0
	                         mov                     si, 0
	                         mov                     ch, gridYCount
	DrawRow:                 
	                         mov                     currentX, gridStartX
	                         mov                     cl, gridXCount
	DrawCell:                
	                         push                    cx
	                         push                    si
	; DrawSquare             currentX, currentY, gridStep, gridColor, gridColor ; rainbow
	; inc                    gridColor
	; jmp                    ContinueDraw
	AfterRespawnCheck:       
	                         cmp                     player1Respawn, 1
	                         je                      Player1NeedRespawn
	                         cmp                     player2Respawn, 1
	                         je                      Player2NeedRespawn
	                         mov                     cl, grid[si]
	                         and                     cl, 128d
	                         jnz                     Ghost
	                         cmp                     grid[si], 127
	                         je                      Square
	                         cmp                     grid[si], player1Code
	                         je                      Player1
	                         cmp                     grid[si], player2Code
	                         je                      Player2
	                         cmp                     grid[si], snowflakeCode
	                         je                      Snowflake
	                         cmp                     grid[si], cherryCode
	                         je                      Cherry
	                         cmp                     grid[si], dotCode
	                         je                      Dot
	                         cmp                     grid[si], bigDotCode
	                         je                      BigDot
	                         cmp                     grid[si], trapCode
	                         je                      Trap
	                         cmp                     grid[si], extraLifeCode
	                         je                      Life
	                         cmp                     grid[si], decLifeCode
	                         je                      UnLife
	                         cmp                     grid[si], cornerLeftDownCode
	                         je                      CornerLeftDown
	                         cmp                     grid[si], cornerLeftUpCode
	                         je                      CornerLeftUp
	                         cmp                     grid[si], cornerRightDownCode
	                         je                      CornerRightDown
	                         cmp                     grid[si], cornerRightUpCode
	                         je                      CornerRightUp
	                         cmp                     grid[si], quadWallCode
	                         je                      QuadWall
	                         cmp                     grid[si], triWallLeftCode
	                         je                      TriWallLeft
	                         cmp                     grid[si], triWallRightCode
	                         je                      TriWallRight
	                         cmp                     grid[si], triWallUpCode
	                         je                      TriWallUp
	                         cmp                     grid[si], triWallDownCode
	                         je                      TriWallDown
	                         cmp                     grid[si], horizontalWallCode
	                         je                      HorizontalWall
	                         cmp                     grid[si], verticalWallCode
	                         je                      VerticalWall
	                         cmp                     grid[si], endWallLeftCode
	                         je                      EndWallLeft
	                         cmp                     grid[si], endWallRightCode
	                         je                      EndWallRight
	                         cmp                     grid[si], endWallUpCode
	                         je                      EndWallUp
	                         cmp                     grid[si], endWallDownCode
	                         je                      EndWallDown
	                         cmp                     grid[si], vacantCode
	                         je                      Vacant
	ContinueDraw:            
	                         pop                     si
	                         pop                     cx
	                         add                     currentX, gridStep
	                         inc                     si
	                         dec                     cl
	                         jnz                     DrawCell
	                         add                     currentY, gridStep
	                         dec                     ch
	                         jnz                     DrawRow
	                         jmp                     EndDraw
	Square:                  
	                         DrawSquare              currentX, currentY, gridStep, backGroundColor , backgroundColor              	;borderColor, backgroundColor
	                         jmp                     ContinueDraw
	Vacant:                  
	                         DrawSquare              currentX, currentY, gridStep, backgroundColor , backgroundColor
	                         jmp                     ContinueDraw
	Player1NeedRespawn:      
	                         mov                     player1Respawn, 0
	                         cmp                     player1Lives, 0
	                         je                      Player1DeadDrawGrid
	; Change the initial location according to the level here:
	                         mov                     bx, player1Initial
	                         mov                     grid[bx], player1Code
	                         mov                     player1Orientation, 'R'
	                         jmp                     AfterRespawnCheck
	Player1DeadDrawGrid:     
	                         mov                     grid[31], 127
	                         jmp                     AfterRespawnCheck
	Player1:                 
	                         cmp                     isPlayer1Dead, 1
	                         je                      Player1Dead
	                         cmp                     player1IsFrozen, 1
	                         je                      Player1Frozen
	                         cmp                     player1IsBigDot, 1
	                         je                      Player1BigDot
	                         cmp                     player1IsGreenDot, 1
	                         je                      Player1GreenDot
	                         mov                     player1Color,player1InitialColor
	DrawPlayer1:             
	                         DrawPlayer              currentX, currentY, player1Color, backgroundColor, isOpen, player1Orientation
	                         jmp                     ContinueDraw
	Player1Dead:             
	                         mov                     grid[si], 127
	                         jmp                     ContinueDraw
	Player1Frozen:           
	                         mov                     player1Color, lightBlue
	                         jmp                     DrawPlayer1
	Player1BigDot:           
	                         mov                     player1Color, white
	                         jmp                     DrawPlayer1
	Player1GreenDot:         
	                         mov                     player1Color, green
	                         jmp                     DrawPlayer1
	Player2NeedRespawn:      
	                         mov                     player2Respawn, 0
	                         cmp                     player2Lives, 0
	                         je                      Player2DeadDrawGrid
	                         mov                     bx, player2Initial
	                         mov                     grid[bx], player2Code
	                         mov                     player2Orientation, 'L'
	                         jmp                     AfterRespawnCheck
	Player2DeadDrawGrid:     
	                         mov                     grid[448], 127
	                         jmp                     AfterRespawnCheck
	Player2:                 
	                         cmp                     isPlayer2Dead, 1
	                         je                      Player2Dead
	                         cmp                     player2IsFrozen, 1
	                         je                      Player2Frozen
	                         cmp                     player2IsBigDot, 1
	                         je                      Player2BigDot
	                         cmp                     player2IsGreenDot, 1
	                         je                      Player2GreenDot
	                         mov                     player2Color, player2InitialColor
	DrawPlayer2:             
	                         DrawPlayer              currentX, currentY, player2Color, backgroundColor, isOpen, player2Orientation
	                         jmp                     ContinueDraw
	Player2Dead:             
	                         mov                     grid[si], 127
	                         jmp                     ContinueDraw
	Player2Frozen:           
	                         mov                     player2Color,lightBlue
	                         jmp                     DrawPlayer2
	Player2BigDot:           
	                         mov                     player2Color, white
	                         jmp                     DrawPlayer2
	Player2GreenDot:         
	                         mov                     player2Color, green
	                         jmp                     DrawPlayer2
	Ghost:                   
	                         cmp                     ghostsIsFrozen, 1
	                         je                      GhostFrozen
	                         mov                     ghostColor,ghostInitialColor
	DrawGhostt:              
	                         DrawGhost               currentX, currentY, ghostColor, backgroundColor
	                         jmp                     ContinueDraw
	GhostFrozen:             
	                         mov                     ghostColor, lightblue
	                         jmp                     DrawGhostt
	Snowflake:               
	                         DrawSnowflake           currentX, currentY, lightCyan, backgroundColor
	                         jmp                     ContinueDraw
	Cherry:                  
	                         DrawCherry              currentX, currentY, red, green, backgroundColor
	                         jmp                     ContinueDraw
	Dot:                     
	                         DrawDot                 currentX, currentY, white, backgroundColor
	                         add                     dotcount, 1
	                         jmp                     ContinueDraw
	BigDot:                  
	                         DrawBigDot              currentX, currentY, white, backgroundColor
	                         jmp                     ContinueDraw
	Trap:                    
	                         DrawTrap                currentX, currentY, backgroundColor, lightGreen, green
	                         jmp                     ContinueDraw
	Life:                    
	                         DrawPacManLife          currentX, currentY, green, white, backgroundColor
	                         jmp                     ContinueDraw
	UnLife:                  
	                         DrawPacManUnlife        currentX, currentY, red, white, backgroundColor
	                         jmp                     ContinueDraw
	CornerLeftUp:            
	                         DrawCornerWallLeftUp    currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	CornerLeftDown:          
	                         DrawCornerWallLeftDown  currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	CornerRightUp:           
	                         DrawCornerWallRightUp   currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	CornerRightDown:         
	                         DrawCornerWallRightDown currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	QuadWall:                
	                         DrawQuadWall            currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	TriWallLeft:             
	                         DrawTriWallLeft         currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	TriWallRight:            
	                         DrawTriWallRight        currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	TriWallUp:               
	                         DrawTriWallUp           currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	TriWallDown:             
	                         DrawTriWallDown         currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	HorizontalWall:          
	                         DrawWallHorizontal      currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	VerticalWall:            
	                         DrawWallVertical        currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	EndWallLeft:             
	                         DrawEndWallLeft         currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	EndWallRight:            
	                         DrawEndWallRight        currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	EndWallUp:               
	                         DrawEndWallUp           currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	EndWallDown:             
	                         DrawEndWallDown         currentX, currentY, borderColor, fillColor, backgroundColor
	                         jmp                     ContinueDraw
	EndDraw:                 
	                         ret
DrawGrid endp

DrawScoreAndLives proc
	                         mov                     si, @data
	                         DisplayTextVideoMode    10, 2, 1, scoreMessage1, 14                                                  	;Draw "Score#1"
	                         DisplayTextVideoMode    10, 24, 1, scoreMessage2, 14                                                 	;Draw "Score#2"
	                         DisplayTextVideoMode    10, 2, 23, livesMessage1, 14                                                 	;Draw "Lives#1"
	                         DisplayTextVideoMode    10, 24, 23, livesMessage2, 14                                                	;Draw "Lives#2"
	DrawScores:              
	                         mov                     si,@data
	                         DisplayNumberVideoMode  15, 1, player1Score
	                         DisplayNumberVideoMode  37, 1, player2Score
	                         DisplayNumberVideoMode  12, 23, player1Lives
	                         DisplayNumberVideoMode  34, 23, player2Lives
	                         ret
DrawScoreAndLives endp

InitializeSerialPort proc	near
	                         mov                     dx,3fbh                                                                      	; Line Control Register
	                         mov                     al,10000000b                                                                 	;Set Divisor Latch Access Bit
	                         out                     dx,al                                                                        	;Out it
	                         mov                     dx,3f8h                                                                      	;Set LSB byte of the Baud Rate Divisor Latch register.
	                         mov                     al,0ch
	                         out                     dx,al
	                         mov                     dx,3f9h                                                                      	;Set MSB byte of the Baud Rate Divisor Latch register.
	                         mov                     al,00h
	                         out                     dx,al
	                         mov                     dx,3fbh                                                                      	;Set port configuration
	                         mov                     al,00011011b
	                         out                     dx, al
	                         ret
InitializeSerialPort endp
	;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	;sends value in AH
SendValueThroughSerial proc	near
	                         push                    dx
	                         push                    ax
	;Check that Transmitter Holding Register is Empty
	                         mov                     dx , 3FDH                                                                    	; Line Status Register
	                         in                      al , dx                                                                      	;Read Line Status
	                         test                    al , 00100000b
	                         jnz                     EmptyLineRegister                                                            	;Not empty
	                         pop                     ax
	                         pop                     dx
	                         ret
	EmptyLineRegister:       
	;If empty put the VALUE in Transmit data register
	                         mov                     dx , 3F8H                                                                    	; Transmit data register
	                         mov                     al, ah
	                         out                     dx, al
	                         pop                     ax
	                         pop                     dx
	                         ret
SendValueThroughSerial endp

	; receives a byte from serial stored in AH, and the AL is used a flag (0 means there is a value, 1 means no value was sent)
ReceiveValueFromSerial proc	near
	;Check that Data is Ready
	                         push                    dx
	                         mov                     dx , 3FDH                                                                    	; Line Status Register
	                         in                      al , dx
	                         test                    al , 1
	                         JNZ                     SerialInput                                                                  	;Not Ready
	                         mov                     al, 1
	                         pop                     dx
	                         ret                                                                                                  	;if 1 return
	SerialInput:             
	;If Ready read the VALUE in Receive data register
	                         mov                     dx , 03F8H
	                         in                      al , dx
	                         mov                     ah, al
	                         mov                     al, 0
	                         pop                     dx
	                         ret
ReceiveValueFromSerial endp

main proc far

	                         mov                     ax, @data
	                         mov                     ds, ax
	                         mov                     es, ax
	                         mov                     di, offset grid
	                         

	;jmp                     SetLevel2
	;jmp                     setlevel1
	GetPlayer1Name:                                                                                                               	;Reading first player name and saving it to player1name
	                         SetTextMode
	                         mov                     dx, 0000
	                         MoveCursor
	                         Displaystring           welcomeMessage1
	                         mov                     dx, 0d0dh
	                         mov                     dl, 25d
	                         MoveCursor
	                         Displaystring           enterMessage
	                         mov                     dx, 0f0dh
	                         mov                     dl, 23d
	                         MoveCursor
	                         Displaystring           warningMessage
	                         mov                     dx, 0a0dh
	                         mov                     dl, 25d
	                         MoveCursor
	                         ReadString              nameMessage, player1Name
	                         ValidateName            player1Name
	                         cmp                     bl, 0
	                         je                      showWarning1
	                         mov                     word ptr warningMessage, byte ptr '$$'
	                         jmp                     GetPlayer2Name
	ShowWarning1:            
	                         mov                     word ptr warningMessage, word ptr 0
	                         jmp                     GetPlayer1Name
	GetPlayer2Name:                                                                                                               	;Reading second player name and saving it to player2name
	                         SetTextMode
	                         mov                     dx, 0000
	                         MoveCursor
	                         Displaystring           welcomeMessage2
	                         mov                     dx, 0d0dh
	                         mov                     dl, 25d
	                         MoveCursor
	                         displaystring           enterMessage
	                         mov                     dx, 0f0dh
	                         mov                     dl, 23d
	                         MoveCursor
	                         displaystring           warningMessage
	                         mov                     dx, 0A0dh
	                         mov                     dl, 25d
	                         MoveCursor
	                         ReadString              nameMessage, player2Name
	                         ValidateName            player2name
	                         cmp                     bl, 0
	                         je                      ShowWarning2
	                         jmp                     MainMenu
	ShowWarning2:            
	                         mov                     word ptr warningMessage, word ptr 0
	                         jmp                     GetPlayer2Name

	MainMenu:                                                                                                                     	;displaying main menu and provided functions and how to use them
	                         mov                     ax, @data
	                         mov                     ds, ax
	                         mov                     es, ax
	                         mov                     di, offset grid
	                         SetTextMode
	                         mov                     dx, 080dh
	                         mov                     dl, 25d
	                         MoveCursor
	                         DisplayString           chattingInfo
	                         mov                     dx, 0a0dh
	                         mov                     dl, 25d
	                         MoveCursor
	                         DisplayString           gameStartInfo
	                         mov                     dx, 0c0dh
	                         mov                     dl, 25d
	                         MoveCursor
	                         DisplayString           endgameInfo
	                         mov                     dl, 0
	                         mov                     dh, 22d
	                         MoveCursor
	                         Displaystring           notificationBar
	AgainTillKeyPressed:                                                                                                          	;checking if a key is pressed on the main menu
	                         mov                     ah, 08h                                                                      	;these two line are used to flush the keyboard buffer
	                         int                     21h
	                         mov                     ah, 1
	                         int                     16h
	                         cmp                     al, scanESC                                                                  	;comparing al with the esc ascci code if equal terminate the program esc pressed puts ah:01 and al:1b
	                         je                      Terminate1
	                         cmp                     al, scanF1
	                         je                      ChatModule
	                         cmp                     al, scanF2                                                                   	;comparing ah with the f2 scan code if equal go to game loading menu
	                         je                      LoadingMenu
	                         jmp                     AgainTillKeyPressed

	Terminate1:              jmp                     Terminate2
	ChatModule:              Chat
	                         jmp                     MainMenu

	LoadingMenu:             
	                         SetVideoMode

	;DrawLoadingScreen       black,yellow,cyan                                                            	;The next code snippet is ofr the delay
	                         MOV                     CX, 3fH
	                         MOV                     DX, 4240H
	                         MOV                     AH, 86H
	                         INT                     15H
	                         mov                     ah, 02h
	                         int                     1ah
	                         mov                     seed, dx
	ChooseLevel:             
	                         SetTextMode
	                         mov                     dx, 0000
	                         MoveCursor
	                         Displaystring           chooseLevelMsg
	                         mov                     dx, 0a0dh
	                         mov                     dl, 25d
	                         MoveCursor
	                         displaystring           level1Msg
	                         mov                     dx, 0c0dh
	                         mov                     dl, 25d
	                         MoveCursor
	                         DisplayString           level2Msg
	                         mov                     dl, 0
	                         mov                     dh, 22d
	                         MoveCursor
	                         Displaystring           notificationBar
	AgainTillKeyPressed2:                                                                                                         	;checking if a key is pressed on the main menu
	                         mov                     ah, 08h                                                                      	;these two line are used to flush the keyboard buffer
	                         int                     21h
	                         mov                     ah, 1
	                         int                     16h
	                         cmp                     al, scanF1                                                                   	;comparing al with the esc ascci code if equal terminate the program esc pressed puts ah:01 and al:1b
	                         je                      SetLevel1
	                         cmp                     al, scanF2                                                                   	;comparing ah with the f2 scan code if equal go to game loading menu
	                         je                      SetLevel2
	                         jmp                     AgainTillKeyPressed2

	SetLevel1:               
	; Setting the initial location for each player.
	                         mov                     player1Initial, player1Lvl1Initial
	                         mov                     player2Initial, player2lvl1Initial
	                         mov                     borderColor, borderlvl1
	                         mov                     fillColor, filllvl1
	StartLevel1:             
	                         SetVideoMode
	                         DrawLevel1              player1Initial, player2Initial
	                         jmp                     AfterLevelSelect
	SetLevel2:               
	                         mov                     player1Initial, player1Lvl1Initial
	                         mov                     player2Initial, player2Lvl1Initial
	                         mov                     borderColor, white
	                         mov                     fillColor, filllvl2
	StartLevel2:             
	                         SetVideoMode
	                         mov                     cx, 480
	                         mov                     si, offset grid2
	                         rep                     movsb
	                         mov                     bx, player1Initial
	                         mov                     grid[bx], player1Code
	                         mov                     bx, player2Initial
	                         mov                     grid[bx], player2Code

	AfterLevelSelect:        
	                         mov                     si, @data
	                         DisplayTextVideoMode    10, 2, 1, scoreMessage1, 14                                                  	;Draw "Score#1"
	                         DisplayTextVideoMode    10, 24, 1, scoreMessage2, 14                                                 	;Draw "Score#2"
	                         DisplayTextVideoMode    10, 2, 23, livesMessage1, 14                                                 	;Draw "Lives#1"
	                         DisplayTextVideoMode    10, 24, 23, livesMessage2, 14                                                	;Draw "Lives#2"
	gameLoop:                
	                         mov                     dotcount, 0
	                         call                    AddPowerUp
	                         call                    MoveGhosts
	                         call                    MovePacman
	                         call                    DrawGrid
	                         call                    DrawScoreAndLives
	                         call                    IsFrozen
	                         call                    IsBigDot
	                         call                    IsGreenDot
	                         MOV                     CX, 1H                                                                       	; delay
	                         MOV                     DX, 4240H
	                         MOV                     AH, 86H
	                         INT                     15H
	                         xor                     isOpen, 1
	                         cmp                     isPlayer1Dead, 1
	                         je                      CheckPlayer2Lives
	                         cmp                     dotcount,0
	                         je                      EndGame
	                         cmp                     IsF4Pressed, 1
	                         je                      ApplyF4
	                         jmp                     gameLoop
	EndLoop:                 
	                         jmp                     EndLoop
	Terminate2:              
	                         mov                     ah, 4ch
	                         int                     21h
	CheckPlayer2Lives:       
	                         cmp                     isPlayer2Dead, 1
	                         je                      EndGame
	                         jmp                     gameLoop
	EndGame:                 
	                         SetTextMode
	                         mov                     dx, 0c0dh
	                         MoveCursor
	                         push                    bx
	                         mov                     bx, player2Score
	                         cmp                     player1Score, bx
	                         pop                     bx
	                         jg                      Player1Wins
	                         jmp                     Player2Wins
	Player1Wins:             
	                         DisplayString           player1WinsMsg
	                         mov                     dx, 0d0dh
	                         MoveCursor
	                         DisplayString           player1Name+2
	AgainTillKeyPressed3:                                                                                                         	;checking if a key is pressed on the main menu
	                         mov                     ah, 08h                                                                      	;these two line are used to flush the keyboard buffer
	                         int                     21h
	                         mov                     ah, 1
	                         int                     16h
	                         cmp                     al, scanESC                                                                  	;comparing al with the esc ascci code if equal terminate the program esc pressed puts ah:01 and al:1b
	                         je                      Terminate2
	                         jmp                     AgainTillKeyPressed3
	Player2Wins:             
	                         DisplayString           player2WinsMsg
	                         mov                     dx, 0d0dh
	                         MoveCursor
	                         DisplayString           player2Name+2
	AgainTillKeyPressed4:                                                                                                         	;checking if a key is pressed on the main menu
	                         mov                     ah, 08h                                                                      	;these two line are used to flush the keyboard buffer
	                         int                     21h
	                         mov                     ah, 1
	                         int                     16h
	                         cmp                     al, scanESC                                                                  	;comparing al with the esc ascci code if equal terminate the program esc pressed puts ah:01 and al:1b
	                         je                      Terminate2
	                         jmp                     AgainTillKeyPressed4
	ApplyF4:                 
	                         mov                     IsF4Pressed, 0
	                         SetTextMode
	                         mov                     dx, 0a0dh
	; mov                     dl, 25d
	                         MoveCursor
	                         Displaystring           player1Name+2
	                         mov                     dx, 0b0dh
	;mov                     dl, 23d
	                         MoveCursor
	                         Displaystring           scoreMessage1
	                         DisplayNumber           player1Score
	                         mov                     dx, 0e0dh
	;mov                     dl, 25d
	                         MoveCursor
	                         Displaystring           player2Name+2
	                         mov                     dx, 0f0dh
	;mov                     dl, 23d
	                         MoveCursor
	                         Displaystring           scoreMessage2
	                         DisplayNumber           player2Score

	                         MOV                     CX, 55H                                                                      	; delay
	                         MOV                     DX, 4240H
	                         MOV                     AH, 86H
	                         INT                     15H

	                         mov                     player1Lives, 3
	                         mov                     player2Lives, 3
	                         mov                     player1Score, 0
	                         mov                     player2score, 0
	                         mov                     player1IsBigDot, 0
	                         mov                     player1IsFrozen, 0
	                         mov                     player1IsGreenDot, 0
	                         mov                     player2IsBigDot, 0
	                         mov                     player2IsFrozen, 0
	                         mov                     player2IsGreenDot, 0
	                         mov                     ghostsIsFrozen, 0
	                         mov                     isPlayer1Dead,0
	                         mov                     isPlayer2Dead,0
	                         mov                     player1Respawn,0
	                         mov                     player2Respawn,0
	                         mov                     currentXPlayer1, 1
	                         mov                     currentYPlayer1, 1
	                         mov                     currentXPlayer2, 28
	                         mov                     currentYPlayer2, 14
	; mov                     cx, 480
	                         
	;mov                     si, offset zerogrid
	; rep                     movsb
	
	                         mov                     si,0
	emptyGrid:               
	                         mov                     grid[si],dotCode
	                         inc                     si
	                         cmp                     si , 481
	                         jl                      emptyGrid
	                         SetTextMode
	                         jmp                     MainMenu

main endp
end main