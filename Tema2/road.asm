%include "../include/io.mac"

struc point
    .x: resw 1
    .y: resw 1
endstruc

section .text
    global road
    extern printf
    extern points_distance

road:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]      ; points
    mov ecx, [ebp + 12]     ; len
    mov ebx, [ebp + 16]     ; distances
    ;; DO NOT MODIFY
   
    ;; Your code starts here

    mov esi, 0
    dec ecx
    mov edi, eax
    mov edx, ebx

    ; parcurg pe rand fiecare pereche de puncte
loop:
    cmp esi, ecx
    jge end

    ; adaug pe stiva parametrii folositi de functie si o apelez
    ; la final dau pop la parametri    
    push edx
    push edi
    call points_distance
    pop edi
    pop edx

    ; trec la urmatoarea pereche de puncte din vector si
    ; la urmatoarea adresa unde se stocheaza distanta dintre ele
    add edi, 4
    add edx, 4

    inc esi
    jmp loop

end:
    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY