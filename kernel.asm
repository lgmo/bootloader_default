org 0x7e00
jmp 0x0000:start

data:
    ; p1 tem o valor da posição de memória onde está o primeiro elemento da string
    p1 db 'parametro 1', 0 
    p2 db 'parametro 2', 0
    p3 db 'parametro 3', 0
clear:
    push bp
    mov bp, sp
    pusha

    mov ah, 0x07
    mov bh, [bp+4]      
    mov al, 0x00               
    mov cx, 0x00        
    mov dh, 0x18        
    mov dl, 0x4f        
    int 0x10

    push word[bp+6]   
    call movecursor
    add sp, 2

    popa
    mov sp, bp
    pop bp
    ret

movecursor:
    push bp
    mov bp, sp
    pusha

    mov dx, [bp+4]      
    mov ah, 02h         
    mov bh, 0           
    int 10h

    popa
    mov sp, bp
    pop bp
    ret

putchar:
    mov ah, 0x0e
    mov bh, 0
    int 0x10
    ret

endl:
    mov al, 0x0a
    call putchar
    mov al, 0x0d
    call putchar
    ret

getchar:
    mov ah, 0x00
    int 16h
    ret

print:
    push bp
    mov bp, sp
    pusha

    mov si, [bp+4]
print_loop:
    lodsb 
    or al, 0
    je .end_print          
    call putchar           
    jmp print_loop       
.end_print:
    popa
    mov sp, bp
    pop bp
    ret

input:
    push bp
    mov bp, sp
    pusha

    mov cl, [bp+4]
    mov di, [bp+6]
input_loop:
    or cl, 0
    jz .end_input
    call getchar
    cmp al, 0x0d
    je .end_input
    mov byte[di], al
    call putchar
    inc di
    dec cl
    jmp input_loop
.end_input:
    popa
    mov sp, bp
    pop bp
    ret

proc:
    push bp         ; coloca o atual valor de bp(o endereço da base da pilha) na pilha
    mov bp, sp      ; coloca o endereço do último elemento da pilha(atual valor de bp) em bp
    pusha           ; salva todos o atual valor dos registradores

    ; word[bp] endereço original de bp
    ; word[bp+2] endereço de retorno
    ; word[bp+4] posiçao onde está armazenado o primeiro parametro
    push word[bp+4] 
    call print
    add sp, 2
    
    call endl

    ; word[bp+6] posiçao onde está armazenado o 2 parametro
    push word[bp+6]
    call print
    add sp, 2
   
    call endl

    ; word[bp+6] posiçao onde está armazenado o 3 parâmetro
    push word[bp+8]
    call print
    add sp, 2
   
    call endl

    popa
    mov sp, bp
    pop bp
    ret
start:
    push 0
    push 0x70        ; 0xbl, b = cor do background, l = cor da letra
    call clear
    add sp, 4
    
    push p3         ; parametro 3 na pilha
    push p2         ; parametro 2 na pilha
    push p1         ; parametro 1 na pilha
    call proc
    add sp, 6       ; remove os 3 parametros da pilha, cada um tem 2 bytes
done:
    jmp $
