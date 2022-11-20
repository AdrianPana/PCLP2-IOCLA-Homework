%include "../include/io.mac"

section .text
    global beaufort
    extern printf

; void beaufort(int len_plain, char *plain, int len_key, char *key, char tabula_recta[26][26], char *enc) ;
beaufort:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; len_plain
    mov ebx, [ebp + 12] ; plain (address of first element in string)
    mov ecx, [ebp + 16] ; len_key
    mov edx, [ebp + 20] ; key (address of first element in matrix)
    mov edi, [ebp + 24] ; tabula_recta
    mov esi, [ebp + 28] ; enc
    ;; DO NOT MODIFY
    ;; TODO: Implement spiral encryption
    ;; FREESTYLE STARTS HERE

    push edi
    push esi

    ; esi este index-ul caracterului din sirul plain
    mov esi, 0
    
encrypt:
    ; daca am ajuns la finalul sirului plain, programul se incheie
    cmp esi, eax
    jge end

    ; edi va fi index-ul din cheie, daca este mai mare ca lungimea cheii,
    ; inseamna ca cheia se repeta, trebuie calculat un nou index
    mov edi, esi
    cmp edi, ecx
    jl search

    ; index-ul din cheie este restul impartirii index-ului plain la lungimea cheii
get_index:
    sub edi, ecx
    cmp edi, ecx
    jge get_index

    ; gasesc corespondentul in tabula recta

search:
    ; adaug pe stiva lungimea sirurilor, pentru a elibera eax si ecx
    push eax
    push ecx
    xor eax, eax
    xor ecx, ecx

    ; salvez caracterele din plain si cheie si le compar
    ; caracterul criptat este rezultatul uneia dintre 2 formule

    mov al, byte[ebx + esi]
    mov cl, byte[edx + edi]
    cmp al, cl
    jle l1
    jmp l2

    ; daca caracterul plain e mai mare decat caracterul cheie,
    ; caracterul criptat este A + offset-ul dintre ele
l1:
    add cl, 65
    sub cl, al
    mov eax, ecx
    pop ecx
    jmp assign

    ; daca caracterul plain e mai mic decat caracterul cheie,
    ; caracterul criptat este Z + 1 - offset-ul dintre ele
l2:
    add cl, 91
    sub cl, al
    mov eax, ecx
    pop ecx
    jmp assign

assign:
    ; adresa rezultatului este in varful stivei, sub lungimea sirului salvat anterior

    mov edi, [esp + 4]
    mov byte[edi + esi], al

    ; iau lungimea sirului din varful stivei si o adaug inapoi in eax
    pop eax

    ; cresc contorul si continui criptarea la urmatorul caracter
    inc esi
    jmp encrypt

end:
    pop esi
    pop edi

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
