#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "structs.h"
#include <inttypes.h>

data_structure * build_element(char *s)
{
    char type = s[0]-'0';

    char *aux;

    //creez elementul
    data_structure * elem;
    elem = malloc(sizeof(data_structure));
    elem->header = malloc(sizeof(head));

    elem->header->type = type;

    aux = malloc(strlen(s)-1);
    strcpy(aux,s+2);
    strcpy(s,aux);
    free(aux);

    char *p;
    int stage = 0, elem_len=0;

    int8_t nr11=0,nr12=0;
    int16_t nr21=0;
    int32_t nr22=0,nr31=0,nr32=0;

    p = strtok(s," ");
    while(p)
    {
        stage++;

        if(stage==1)
        {   
            switch (type)
            {
            case 1:
                elem->data = malloc(strlen(p) + 1 + 2 * sizeof(int8_t));
                break;
            
            case 2:
                elem->data = malloc(strlen(p) + 1 + sizeof(int16_t) + sizeof(int32_t));
                break;

            case 3:
                elem->data = malloc(strlen(p) + 1 + sizeof(int32_t) + sizeof(int32_t));
                break;
            }

            
            memcpy(elem->data,p,strlen(p)+1);
            elem_len+=strlen(p)+1;
        }

        if(stage==2) {

            switch (type)
            {
            case 1:;
                nr11 = (int8_t) atoi(p);
                memcpy(elem->data + elem_len, &nr11, 1);
                elem_len++;
                break;
            
            case 2:;
                nr21 = (uint16_t) atoi(p);
                memcpy(elem->data + elem_len, &nr21, 2);
                elem_len += 2;
                break;

            case 3:;
                nr31 = (int32_t) atoi(p);
                memcpy(elem->data + elem_len, &nr31, 4);
                elem_len += 4;
                break;
            }
            
        }

        if(stage==3)
        {
            switch (type)
            {
            case 1:;
                nr12 = (int8_t) atoi(p);
                memcpy(elem->data + elem_len, &nr12, 1);
                elem_len++;
                break;
            
            case 2:;
                nr22 = (int32_t) atoi(p);
                memcpy(elem->data + elem_len, &nr22, 4);
                elem_len += 4;
                break;

            case 3:;
                nr32 = (int32_t) atoi(p);
                memcpy(elem->data + elem_len, &nr32, 4);
                elem_len += 4;
                break;
            }
        }

        if(stage == 4) {
            elem->data = realloc (elem->data,elem_len + strlen(p)+1);
            memcpy(elem->data + elem_len, p, strlen(p) + 1);
            elem_len += strlen(p) + 1;

            nr11=nr21=nr31=nr12=nr22=nr32=0;
        }

        p=strtok(NULL," ");
    }

    elem->header->len = elem_len + sizeof(char) + sizeof(int);

    return elem;
}