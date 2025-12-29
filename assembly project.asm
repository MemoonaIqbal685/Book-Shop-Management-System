org 100h
.model small
.stack 100h

.data
; ===== Messages =====
welcome     db 10,13,'* ONLINE BOOK SHOP *$'
startMsg    db 10,13,'Enter 1 to Display Books List: $'
choiceMsg   db 10,13,'Enter Your Choice: $'
pickBook    db 10,13,'Pick Your Book: $'
qtyMsg      db 10,13,'Enter Quantity (1-9): $'
totalMsg    db 10,13,'Total Price: $'
invalidMsg  db 10,13,10,13,'Invalid Input! Program Ended.$'

menu1 db 10,13,'1. English Novels (50/-)$'
menu2 db 10,13,'2. Urdu Novels (100/-)$'
menu3 db 10,13,'3. Islamic Books (200/-)$'

after1 db 10,13,10,13,'1. Back to Book List$'
after2 db 10,13,'2. Exit$'

; ===== Book Lists =====
engList db 10,13,'1. Wuthering Heights'
        db 10,13,'2. Middle March'
        db 10,13,'3. 1984'
        db 10,13,'4. Lord of Rings'
        db 10,13,'5. Diary of Nobody'
        db 10,13,'6. Dark Materials$'

urduList db 10,13,'1. Jannat Kay Pattay'
         db 10,13,'2. Bismil'
         db 10,13,'3. Mala'
         db 10,13,'4. Peer-e-Kamil'
         db 10,13,'5. Bakht'
         db 10,13,'6. Namal$'

islList db 10,13,'1. Minhaj-ul-Muslim'
        db 10,13,'2. Namaz-e-Nabvi'
        db 10,13,'3. Tib-e-Nabvi'
        db 10,13,'4. Hisnul-Muslim'
        db 10,13,'5. Tafseer'
        db 10,13,'6. Riyad-us-Saliheen$'

.code
main proc
    mov ax,@data
    mov ds,ax

    ; ===== Welcome =====
    mov dx,offset welcome
    call Print

    mov dx,offset startMsg
    call Print
    call GetNum
    cmp al,1
    jne Invalid

; ===== Main Menu =====
BookMenu:
    mov dx,offset menu1
    call Print
    mov dx,offset menu2
    call Print
    mov dx,offset menu3
    call Print

    mov dx,offset choiceMsg
    call Print
    call GetNum

    cmp al,1
    je English
    cmp al,2
    je Urdu
    cmp al,3
    je Islamic
    jmp Invalid

; ===== English =====
English:
    mov dx,offset engList
    call Print
    mov bx,50
    jmp SelectBook

; ===== Urdu =====
Urdu:
    mov dx,offset urduList
    call Print
    mov bx,100
    jmp SelectBook

; ===== Islamic =====
Islamic:
    mov dx,offset islList
    call Print
    mov bx,200

; ===== Book Selection & Calculation =====
SelectBook:
    mov dx,offset pickBook
    call Print
    
    ; 1. Get Book Number (and ignore it)
    mov ah,1
    int 21h            

    mov dx,offset qtyMsg
    call Print
    
    ; 2. Get Quantity
    mov ah,1
    int 21h            ; Read character into AL
    sub al,48          ; Convert ASCII to digit
    
    ; 3. CLEAN CALCULATION
    mov ah,0           
    mul bx             ; AX = AX * BX (Price)

    ; 4. Display Result
    push ax            
    mov dx,offset totalMsg
    call Print
    pop ax             
    
    call PrintNumber

; ===== NEW: Continue or Exit Logic =====
AfterPurchase:
    mov dx,offset after1
    call Print
    mov dx,offset after2
    call Print
    
    mov dx,offset choiceMsg
    call Print
    call GetNum
    
    cmp al,1
    je BookMenu        ; If 1, loop back to the main menu
    cmp al,2
    je Exit            ; If 2, go to exit
    jmp Invalid        ; Any other key ends with invalid message

; ===== Invalid =====
Invalid:
    mov dx,offset invalidMsg
    call Print

; ===== Exit =====
Exit:
    mov ah,4Ch
    int 21h
main endp

; ===== Procedures =====

Print proc
    mov ah,9
    int 21h
    ret
Print endp

GetNum proc
    mov ah,1
    int 21h
    sub al,48
    ret
GetNum endp

PrintNumber proc
    mov cx,0
    mov si,10

Convert:
    xor dx,dx
    div si
    push dx
    inc cx
    cmp ax,0
    jne Convert

PrintLoop:
    pop dx
    add dl,48
    mov ah,2
    int 21h
    loop PrintLoop

    mov dl,'/'
    int 21h
    mov dl,'-'
    int 21h
    ret
PrintNumber endp

end main