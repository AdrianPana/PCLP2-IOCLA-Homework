%include "../include/io.mac"

section .data
    x1 dd 0
    x2 dd 0
    y1 dd 0
    y2 dd 0
    n dd 0

section .text
    global spiral
    extern printf

; void spiral(int N, char *plain, int key[N][N], char *enc_string);
spiral:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; N (size of key line)
    mov ebx, [ebp + 12] ; plain (address of first element in string)
    mov ecx, [ebp + 16] ; key (address of first element in matrix)
    mov edx, [ebp + 20] ; enc_string (address of first element in string)
    ;; DO NOT MODIFY
    ;; TODO: Implement spiral encryption
    ;; FREESTYLE STARTS HERE

    ; daca matricea este de 1x1, nu are rost sa o parcurg
    ; adaug prima litera din cheie ca sa criptez elementul matricii si ies din program

    cmp eax, 1
    jg len_not_1
    mov eax, [ebx]
    add eax, [ecx]
    mov [edx], eax
    jmp end

len_not_1:

    ; salvez in n valoarea lungimii cheii
    mov [n], eax

    ; setez marginile initiale ale matricii
    mov dword[x1], 0
    mov dword[y1], 0
    mov [x2], eax
    mov [y2], eax

    ; calculez n*n prin adunari repetate si il stochez in edi
    mov edi, 0
    mov esi, [n]

get_square:
    add edi, [n]
    dec esi
    jnz get_square

    ; esi va numara elementele parcurse ca sa stiu cand ma opresc
    mov esi,0

    ; "eliberez" registrele
    push edx
    push ebx
    push ecx
    
    ; eax si ebx retin marginile matricii pentru fiecare parcurgere pe linie/coloana
    mov eax, 0
    mov ebx, [n]

    ; plec de la elementul (0,0), ecx si edx sunt indicii pentru linie/coloana
    mov ecx, 0
    mov edx, 0

horizontal_pos:

    ; daca am ajuns la margine, continui in jos
    cmp edx, ebx
    jge top_right_turn

    ; "eliberez" eax si ebx ca sa calculez n*ecx
    push eax
    push ebx

    ; adaug ecx in ebx de n ori (n*indicele liniei)

    mov eax, [n]
    mov ebx, 0
loop_hp:
    add ebx, ecx
    dec eax
    jnz loop_hp

    ; adaug indicele coloanei la ebx
    add ebx, edx

    ; mut in edi pe stiva si salvez in el adresa cheii
    mov eax, [esp + 8]
    push edi
    push eax
    pop edi

    ; scot in eax valoarea din matrice la care am ajuns
    mov eax, [edi + 4*ebx]

    ; salvez adresa sirului plain in edi
    mov edi, [esp + 16]

    ; adaug la elementul din matrice caracterul din plain
    add al, [edi + esi]

    ; salvez adresa sirului criptat in edi si adaug la adresa
    ; corespunzatoare rezultatul criptarii caracterului
    mov edi, [esp + 20]
    mov [edi + esi], al

    ; scot registrele de pe stiva si incrementez numarul de elemente parcurse
    pop edi
    inc esi
    pop ebx
    pop eax

    ; daca am parcurs toate elementele matricii ma opresc 
    cmp esi, edi
    je clean

    ; cresc indexul coloanei si reiau parcurgerea
    inc edx
    jmp horizontal_pos

    ; algoritmul este identic cu cel de horizontal_pos
    ; singura diferenta e ca decrementez indicele coloanei si parcurg
    ; pana la marginea inferioara a coloanelor  
horizontal_neg:

    cmp edx, ebx
    jl bot_left_turn

    push eax
    push ebx

    mov eax, [n]
    mov ebx, 0
loop_hn:
    add ebx, ecx
    dec eax
    jnz loop_hn

    add ebx, edx
    mov eax, [esp + 8]
    push edi

    push eax
    pop edi

    mov eax, [edi + 4*ebx]

    mov edi, [esp + 16]
    add al, [edi + esi]
    
    mov edi, [esp + 20]
    mov [edi + esi], al
    
    pop edi
    inc esi
    pop ebx
    pop eax

    cmp esi, edi
    je clean

    dec edx
    jmp horizontal_neg

    ; algoritmul este identic cu cel de horizontal_pos
    ; singura diferenta e ca incrementez indicele liniei si parcurg
    ; pana la marginea superiara a liniilor
vertical_pos:
    cmp ecx, eax
    jge bot_right_turn

    push eax
    push ebx

    mov eax, [n]
    mov ebx, 0
loop_vp:
    add ebx, ecx
    dec eax
    jnz loop_vp

    add ebx, edx
    mov eax, [esp + 8]
    push edi

    push eax
    pop edi

    mov eax, [edi + 4*ebx]
    mov edi, [esp + 16]
    add al, [edi + esi]
    mov edi, [esp + 20]
    mov [edi + esi], al
    
    pop edi

    inc esi
    pop ebx
    pop eax

    cmp esi, edi
    je clean

    inc ecx
    jmp vertical_pos

    ; algoritmul este identic cu cel de horizontal_pos
    ; singura diferenta e ca decrementez indicele liniei si parcurg
    ; pana la marginea inferioara a liniilor
vertical_neg:
    cmp ecx, eax
    jl top_left_turn

    push eax
    push ebx

    mov eax, [n]
    mov ebx, 0
loop_vn:
    add ebx, ecx
    dec eax
    jnz loop_vn

    add ebx, edx
    mov eax, [esp + 8]
    push edi

    push eax
    pop edi

    mov eax, [edi + 4*ebx]
    mov edi, [esp + 16]
    add al, [edi + esi]
    mov edi, [esp + 20]
    mov [edi + esi], al
    
    pop edi

    inc esi
    pop ebx
    pop eax

    cmp esi, edi
    je clean

    dec ecx
    jmp vertical_neg

    ;pregatesc registrele pentru parcurgerea pe verticala in sens pozitiv
top_right_turn:

    ; plasez indicele coloanei inainte de marginea superioara
    mov edx, [y2]
    dec edx

    ; cresc marginea inferioara a liniilor si plasez indicele acolo
    inc dword[x1]
    mov ecx, [x1]

    ; updatez marginile pana la care pot parcurge
    mov eax, [x2]
    mov ebx, [y2]

    ; continui cu parcurgerea pe verticala in sens pozitiv
    jmp vertical_pos

    ; analog cu top_right_turn, doar ca scade maximul coloanei
bot_right_turn:
    dec dword[y2]
    mov edx, [y2]
    dec edx
    mov ecx, [x2]
    dec ecx
    
    mov eax, [x2]
    mov ebx, [y1]

    jmp horizontal_neg  

    ; analog cu top_right_turn, doar ca scade maximul liniei
bot_left_turn:
    dec dword[x2]
    mov ecx, [x2]
    dec ecx
    mov edx, [y1]

    mov eax, [x1]
    mov ebx, [y1]

    jmp vertical_neg

    ; analog cu top_right_turn, doar ca cresc minimul coloanei
top_left_turn:
    inc dword[y1]
    mov edx, [y1]
    mov ecx, [x1]

    mov eax, [x2]
    mov ebx, [y2]

    jmp horizontal_pos

    ; eliberez stiva
clean:
    pop ecx
    pop ebx
    pop edx

end:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
