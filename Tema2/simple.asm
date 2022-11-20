%include "../include/io.mac"

section .text
    global simple
    extern printf

simple:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; plain
    mov     edi, [ebp + 16] ; enc_string
    mov     edx, [ebp + 20] ; step

    ;; DO NOT MODIFY
   
    ;; Your code starts here

    ;; calculez in ebx litera maxima pana la care shiftatul ajunge pana la Z sau mai putin
    mov ebx, 90
    sub ebx, edx
    dec ecx

    ;; verific daca am parcurs toate caracterele din sir
loop:
    cmp ecx, 0
    jge shift
    jmp end


shift:

    ;; salvez in al urmatorul caracter din sir
    xor eax, eax
    mov al, [esi + ecx]

    ;; daca caracterul este mai mic decat litera maxima shiftez inspre Z, altfel inspre A
    cmp eax, ebx
    jg shift_left
    jmp shift_right

shift_right:
    
    ;; adaug step la codul ascii a caracterului
    add [esi + ecx] , edx

    ;; adaug caracterul si la adresa sirului criptat
    xor eax,eax
    mov eax, [esi + ecx]
    mov [edi + ecx], eax

    ;; continui loop-ul
    dec ecx
    jmp loop

shift_left:

    ;; calculez cat as mai merge de la dreapta lui A dupa ce am trecut de Z
    add dword [esi + ecx], edx
    sub dword [esi + ecx], 26

    ;; adaug caracterul si la adresa sirului criptat
    xor eax,eax
    mov eax, [esi + ecx]
    mov [edi + ecx], eax

    ;; continui loop-ul
    dec ecx
    jmp loop

end:

    ;; Your code ends here
    
    ;; DO NOT MODIFY

    popa
    leave
    ret

    ;; DO NOT MODIFY
