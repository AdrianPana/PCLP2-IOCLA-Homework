%include "../include/io.mac"

section .text
    global is_square
    extern printf

is_square:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov ebx, [ebp + 8]      ; dist
    mov eax, [ebp + 12]     ; nr
    mov ecx, [ebp + 16]     ; sq
    ;; DO NOT MODIFY
   
    ;; Your code starts here

    ; initializare contor
    mov esi, 0

    ; ma opresc daca am ajuns la finalul vectorului de distante

check_number:
    cmp esi, eax
    jge end

    ; incep sa formez radacini in edx si sa caut patrate
    mov edx, 0
    mov edi, 0

    ; radacina se va afla in varful stivei
    push edx

    ; adun radacina in edi de 'radacina' ori (ridic radacina la patrat)

square:
    cmp edx, 0
    je verify
    add edi, [esp]
    dec edx
    jnz square

    ; verific daca am ajuns la numarul cautat
    ; compar numarul cu patratul calculat

verify:
    pop edx
    cmp edi, [ebx + 4*esi]
    jl next_root
    je is_perf_square
    jg is_not_square

    ; daca patratul e mai mic decat numarul, incrementez radacina
    ; si calculez in nou patrat

next_root:
    add edx, 1
    mov edi, 0
    push edx
    jmp square

    ; daca numarul e egal cu patratul calculat, il marchez ca fiind 1
    ; si trec la urmatoarea distanta

is_perf_square:
    mov dword[ecx + 4*esi], 1
    inc esi
    jmp check_number

    ; daca am ajuns la un patrat mai mare ca numarul, inseamna ca acesta
    ; nu e patrat perfect. Il marchez cu 0 si trec la urmatoarea distanta

is_not_square:
    ;;marchez ca nefiind patrat
    mov dword[ecx + 4*esi], 0
    inc esi
    jmp check_number

end:
    ;; Your code ends here
    
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY