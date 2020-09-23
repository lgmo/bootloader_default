org 0x7e00
jmp 0x0000:start

data:
    mensagem db 'Informe o valor de X entre 1 e 1000',0
    string times 20 db 0
    X times 10 db 0
    valor times 10 db 0

init_sreen:
    push bp
    mov bp, sp
    pusha

    mov ah, 0x06      
    mov al, 0x00        
    mov bh, [bp+4]       
    mov cx, 0x00        
    mov dh, 0x18        
    mov dl, 0x4f        
    int 0x10    

    popa
    pop bp
    ret

start:

    xor ax, ax           ; limpando ax
    mov ds, ax           ; limpando ds
    mov es, ax           ; limpando es

    push 0x24
    jmp init_sreen
    add sp, 2
    jmp done

done:
    jmp $
