    - Tema 2 PCLP2 -

    - Detalii de implementare -
    
    - Task 1 -

    Pentru valoarea step, calculez care e cea mai mare litera pentru care 
shiftarea ar aduce-o la o litera mai mica sau egala cu 'Z', fara a mai 
continua de la 'A'. Astfel, salvez in ebx 90 - step.
    Parcurg cu un loop fiecare litera din plain (de la coada la cap). Daca
litera este mai mica sau egala cu "litera maxima", atunci o voi updata ca
fiind ea insasi + step. In caz contrar, calculez cate caractere as mai
continua de la 'A' (litera + step - 26) si updatez litera cu rezultatul.
Odata cu actualizarea literei in sine se updateaza si caracterul cu acelasi
indice de la adresa end_string.

    - Task 2 -

        - Points distance -

    Extrag coordonatele x ale celor 2 puncte (fiind short, se gasesc la
adresele points si points + 2*2) si le compar. Dac sunt egale, inseamna ca
diferenta se face intre coordonatele y, pe care le extrag de la adresele
corespunzatoare si le compar.
    In urma oricarei comparatii, diferenta celor 2 coordonate se salveaza 
la adresa 'distance'.

        - Road -

    Un contor parcurge punctele din vector (creste cu 4 la fiecare iteratie,
pentru a sari peste 2 short-uri). Se adauga pe stiva adresa distances +
contor, respectiv points + contor, care vor fi primite ca parametri de
functia points_distance(). Functia completeaza astfel vectorul distances
de intregi (motiv pentru care parcurgerea tot din 4 in 4 octeti functioneaza).

        - Is square -

    Un contor parcurge fiecare intreg din vectorul distances (din 4 in 4).
    Pentru fiecare numar, plec de la 0 si calculez toate patratele perfecte
mai mici sau egale cu acesta. Daca am ajuns la un patrat egal sau mai mare
decat numarul, loop-ul se opreste. Egalitatea inseamna ca numarul este patrat
perfect, caz in care la adresa sq + contor se marcheaza cu 1. Cazul contrar
inseamna ca numarul nu e patrat perfect, iar adresa se marcheaza cu 0.

    - Task 3 -

    Un contor parcurge intreg sirul de caractere. Cum cheia se repeta de
oricate ori e nevoie, indexul corespunzator in cheie va fi contor % len_key.
    Din tabel se deduc 2 reguli: (notez P si K caracterele corespunzatoare din
    plain, respectiv cheie)
    -> daca P <= K, caracterul criptat este 'A' + K - P
    -> daca P > K, caracterul criptat este 'Z' + 1 - (P - K)

    Se calculeaza corespondentul corect pentru fiecare caracter si se
adauga la adresa enc + contor.

    - Task 4 -

    Am declarat 5 variabile locale, care memoreaza marginile submatricii si
valoarea lui n.
    Se initializeaza marginile matricii cu 0 si n pe orizontala si
verticala si se calculeaza numarul total de elemente (n*n).
    Exista 4 label-uri pentru parcurgeri si 4 pentru turn-uri, care
functioneaza analog.
    Label-urile de parcurgere orizontala/verticala in sens pozitiv/negativ
incrementeaza/decrementeaza indicele de linie/coloana (dupa caz). Cat timp
nu am iesit din marginile submatricii de la pasul curent, calculez adresa
in memorie a elementului (i,j) ca offsetul (i*n + j). Un contor creste la
fiecare element gasit, iar la adresa enc_string + contor se adauga rezultatul
sumei dintre elementului matricii si caracterul de la adresa plain + contor.
    Cand contorul care numara elementele ajunge la n*n, se iese din
parcurgere.
    Label-urile pentru turn maresc/micsoreaza indicii marginilor
submatricii si plaseaza coordonatele corecte de unde se continua parcurgerea matricii, dupa caz.

P.S. Tema este facuta integral fara mul/imul (painful, stiu), motiv pentru
care codul este putin overloaded cu label-uri pentru inmultiri prin adunari
repetate. 