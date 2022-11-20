#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "structs.h"
#include <inttypes.h>
#include "parsing.h"

int string_to_int(char *s)
{
    int nr=0;
    int i;

    for (i=0;i<strlen(s);i++)
        nr = nr*10+s[i]-'0';

    return nr;
}

void print(void *arr, int len);

int add_last(void **arr, int *len, data_structure *data) 
{
    // daca lungimea este 0 trebuie alocata memoria pentru prima data

    if (*len == 0)
    {
        *arr = malloc(data->header->len);

        if (*arr == NULL)
            return 1;

        char type = data->header->type;
        memcpy(*arr,&type,sizeof(char));

        int data_len = data->header->len;
        memcpy(*arr + 1, &data_len, sizeof(int));

        memcpy(*arr + 5, data->data, data->header->len - 5);
        *len = data->header->len;
    }

    else
    {
        *arr = realloc(*arr,*len+data->header->len);

        if (*arr == NULL)
            return 1;

        char type = data->header->type;
        memcpy(*arr + *len ,&type,sizeof(char));

        int data_len = data->header->len;
        memcpy( *arr + *len + 1, &data_len, sizeof(int));

        memcpy(*arr + *len + 5, data->data, data->header->len - 5);
        *len += data->header->len;
    }

    return 0;
}
    
void add_at(void **arr, int *len, data_structure *data, int index)
{

    if (index < 0)
    {
        printf("Index ILEGAL\n");
        return;
    }

    int nr_elem = 0, i = 0;

    
    while (nr_elem < index && i < *len)
    {
        //sar peste 'type' din header
        i++;

        int elem_len = *(int*)(*arr + i);

        i += (elem_len - sizeof(char));

        nr_elem++;
    }

    *arr = realloc (*arr,*len + data->header->len);

    memcpy(*arr+i+data->header->len,*arr+i,*len-i);

    char type = data->header->type;
    memcpy(*arr + i,&type,sizeof(char));

    int data_len = data->header->len;
    memcpy( *arr + i + 1, &data_len, sizeof(int));

    memcpy(*arr + i + 5, data->data, data->header->len - 5);
    *len += data->header->len;

}

void find(void *data_block, int len, int index)
{
    if (index < 0)
    {
        printf("Index ILEGAL\n");
        return;
    }

    int nr_elem = 0, i = 0;

    
    while (nr_elem < index && i < len)
    {
        //sar peste 'type' din header
        i++;

        int elem_len = *(int*)(data_block + i);

        i += (elem_len - sizeof(char));

        nr_elem++;
    }

    if (nr_elem < index)
    {
        printf("Index ILEGAL\n");
        return;
    }

    i++;
    int elem_len = *(int*)(data_block + i);
    i--;

    print((data_block+i),elem_len);

}

void delete_at(void **arr, int *len, int index)
{
    if (index < 0)
    {
        printf("Index ILEGAL\n");
        return;
    }

    int nr_elem = 0, i = 0;
    
    while (nr_elem < index && i < *len)
    {
        //sar peste 'type' din header
        i++;

        int elem_len = *(int*)(*arr + i);

        i += (elem_len - sizeof(char));

        nr_elem++;
    }

    i++;
    int elem_len = *(int*)(*arr + i);
    i--;

    memcpy(*arr+i,*arr+ i + elem_len,*len-i-elem_len);

    *arr = realloc (*arr,*len - elem_len);
    *len -= elem_len;
}

void print(void *arr, int len)
{
    char * aux = (char*) arr;
    int j, type;
    int stage = 0;

    int8_t b11=0,b12=0;
    int16_t b21=0;
    int32_t b22=0,b31=0,b32=0;


    for (j=0;j<len;j++)
    {
        if(stage==0)
        {
            type = aux[j];
            printf("Tipul %d\n",type);
            j++;

            j+=4;
            stage++;
        }

        if(stage==1)
        {
            if(aux[j] == 0)
            {
                stage++;
                printf(" pentru ");
                continue;
            }
            printf("%c",aux[j]);
        }

        else if(stage == 2)
        {
            switch (type)
            {
            case 1:
                b11 = *(int8_t*)(aux+j);
                break;
            
            case 2:
                b21 = *(int16_t*)(aux+j);
                j++;
                break;
            
            case 3:
                b31 = *(int32_t*)(aux+j);
                j+=3;
                break;
            }

            stage++;
        }
        else if(stage == 3)
        {
            switch (type)
            {
            case 1:
                b12 = *(int8_t*)(aux+j);
                break;
            
            case 2:
                b22 = *(int32_t*)(aux+j);
                j+=3;
                break;
            
            case 3:
                b32 = *(int32_t*)(aux+j);
                j+=3;
                break;
            }

            stage++;
        }

        else if(stage == 4)
        {
            if (aux[j] == 0)
            {
                stage = 0;
                
                switch (type)
                {
                case 1:;
                    printf("\n%d\n%d\n\n",b11,b12);
                    break;
                
                case 2:;
                    printf("\n%"PRId16"\n%"PRId32"\n\n",b21,b22);
                    break;
                
                case 3:;
                    printf("\n%"PRId32"\n%"PRId32"\n\n",b31,b32);
                    break;
                }

                b11=b12=b21=b22=b31=b32=0;

                continue;
            }
            printf("%c",aux[j]);
        }
    }
}

int main()
{
    void *arr = NULL;
    int len = 0;

    //ia fiecare comanda, o prelucreaza
    char s[256];
    while(fgets(s,256,stdin))
    {
        if (strstr(s,"insert "))
        {
            if (s[strlen(s)-1] == '\n')
                s[strlen(s)-1]='\0';

            char *aux;
            aux = malloc(strlen(s)-6);
            strcpy(aux,s+7);
            strcpy(s,aux);
            free(aux);

            data_structure * elem = build_element(s);
            
            add_last(&arr,&len,elem);

            free(elem->header);
            free(elem->data);
            free(elem);
        }

        else if (strstr(s,"insert_at"))
        {
            if (s[strlen(s)-1] == '\n')
                s[strlen(s)-1]='\0';

            char *aux;
            aux = malloc(strlen(s)-9);
            strcpy(aux,s+10);
            strcpy(s,aux);
            free(aux);

            int index = 0;
            int k=0;
            while(s[k]!=' ')
            {
                index = index * 10 + s[k]-'0';
                k++;
            }

            data_structure * elem = build_element(s+k+1);
            
            add_at(&arr,&len,elem,index);

            free(elem->header);
            free(elem->data);
            free(elem);
        }

        else if (strstr(s,"delete_at"))
        {
            if (s[strlen(s)-1] == '\n')
                s[strlen(s)-1]='\0';

            char *aux;
            aux = malloc(strlen(s)-9);
            strcpy(aux,s+10);
            strcpy(s,aux);
            free(aux);

            int index = 0;
            int k=0;
            while(s[k]>='0' && s[k]<='9')
            {
                index = index * 10 + s[k]-'0';
                k++;
            }
            delete_at(&arr,&len,index);
        }

        else if (strstr(s,"find"))
        {
            if (s[strlen(s)-1] == '\n')
                s[strlen(s)-1]='\0';

            char *aux;
            aux = malloc(strlen(s)-4);
            strcpy(aux,s+5);
            strcpy(s,aux);
            free(aux);

            int index = 0;
            int k=0;
            while(s[k]>='0' && s[k]<='9')
            {
                index = index * 10 + s[k]-'0';
                k++;
            }
            find(arr,len,index);
        }

        else if (strstr(s,"print"))
        {
            print(arr,len);
        }
    }

    free(arr);
    return 0;
}