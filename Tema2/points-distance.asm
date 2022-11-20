%include "../include/io.mac"

struc point
    .x: resw 1
    .y: resw 1
endstruc

section .text
    global points_distance
    extern printf

points_distance:
    ;; DO NOT MODIFY
    
    push ebp
    mov ebp, esp
    pusha

    mov ebx, [ebp + 8]      ; points
    mov eax, [ebp + 12]     ; distance
    ;; DO NOT MODIFY
   
    ;; Your code starts here

    xor ecx,ecx

    ; compar valorile x ale celor 2 puncte, daca sunt egale inseamna ca diferenta se face intre y-uri
    ; altfel, se trece la calculul distantei, in functie de care x e mai mare
    mov edx, [ebx]
    cmp dx, [ebx+4]
    jg max_x1
    jl max_x2
    je vertical

    ; se scade x2 din x1
max_x1:
    mov cx, [ebx]
    sub cx, [ebx+4]
    mov [eax], ecx
    jmp end

    ; se scade x1 din x2
max_x2:
    mov cx, [ebx+4]
    sub cx, [ebx]
    mov [eax], ecx
    jmp end

    ; se compara y-urile si se calculeaza distanta analog
vertical:
    mov edx, [ebx+2]
    cmp dx, [ebx+6]
    jg max_y1
    jle max_y2

    ; se scade y2 din y1
max_y1:
    mov cx, [ebx+2]
    sub cx, [ebx+6]
    mov [eax], ecx
    jmp end

    ; se scade y1 din y2
max_y2:
    mov cx, [ebx+6]
    sub cx, [ebx+2]
    mov [eax], ecx
    jmp end

end:
    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret

    ;; DO NOT MODIFY