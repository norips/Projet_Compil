%{
#include "utils/bilquad.h"
#include "utils/environ.h"
BILQUAD list;
char *etiq=NULL,*arg1=NULL,*arg2=NULL,*res=NULL;
int op = 0;
int first = 1;
char *cpa(char *src){
    int len = strlen(src);
    char *dst = malloc(sizeof(int)*(len+1));
    return strcpy(dst,src);
} 
%}

%s OPE ARG_1 ARG_2 DEST
%%

(ET|JMP)[0-9]+                {
                            BEGIN OPE; free(etiq); etiq=cpa(yytext); 
                        }
<OPE>:[A-Za-z]+         {
                            BEGIN ARG_1;
                            if(strncmp("Pl",yytext+1,2)==0) {
                                op = Pl;
                            } else if (strncmp("Mo",yytext+1,2)==0) { 
                                op = Mo;   
                            } else if (strncmp("Mu",yytext+1,2)==0) { 
                                op = Mu;   
                            } else if (strncmp("Afc",yytext+1,3)==0) { 
                                op = Afc;   
                            } else if (strncmp("Af",yytext+1,2)==0) { 
                                op = Af;   
                            } else if (strncmp("Sk",yytext+1,2)==0) { 
                                op = Sk;   
                            } else if (strncmp("Jp",yytext+1,2)==0) { 
                                op = Jp;   
                            } else if (strncmp("Jz",yytext+1,2)==0) { 
                                op = Jz;   
                            } else if (strncmp("St",yytext+1,2)==0) { 
                                op = St;   
                            }              
                        }
<ARG_1>:[A-Za-z0-9]*      {
                            BEGIN ARG_2;
                            free(arg1); 
                            arg1=cpa(yytext+1);
                        }
<ARG_2>:[A-Za-z0-9]*        {
                            BEGIN DEST;
                            free(arg2); 
                            arg2=cpa(yytext+1);
                        }
<DEST>:[A-Za-z0-9]*        {
                            BEGIN INITIAL;
                            char *dst=NULL;
                            dst = cpa(yytext+1);
                            if(first) {
                                first = 0;
                                list = creer_bilquad(creer_quad(etiq,op,arg1,arg2,dst));
                            } else {
                                BILQUAD tmp = creer_bilquad(creer_quad(etiq,op,arg1,arg2,dst));
                                list = concatq(list,tmp);
                                
                            }
                            free(dst);
                        }

%%
int yywrap() {
    return -1;
}
char *strdupn(char *s,unsigned int n) {
    char *d = malloc (strlen (s) + 1 + n);   // Space for length plus nul
    if (d == NULL) return NULL;          // No memory
    strcpy (d,s);                        // Copy the characters
    return d;                            // Return the new string
}
void print(int n,char *_ETQ, char *cmd, char *arg1, char *arg2) {
    char *ETQ = NULL;
    if(_ETQ == NULL) {
        ETQ = malloc(1);
        ETQ[0] = '\0';
    } else {
        ETQ = strdupn(_ETQ,1);
        strcat(ETQ,":");
    }
    if(n==1) {
        printf("%s\t%s\t%s\n", ETQ ,cmd ? cmd : "",arg1 ? arg1 : "");
    } else {
        printf("%s\t%s\t%s,\t\t%s\n", ETQ ,cmd ? cmd : "",arg1 ? arg1 : "",arg2 ? arg2 : "");
    }
}
int main(int argc,char *argv[]) {
    char buf[128];
    int current = 0, head = 0;;
	yylex();
	ecrire_bilquad(list);
	ENV env = Envalloc();
	QUAD elem = list.debut;
	//Init all variables with a memory case associated with it name
	while(elem != NULL) {
	    if(elem->OP == Afc) {
	        if(initenv(&env,elem->RES) == EXIT_SUCCESS) {
	            affect(env,elem->RES,++current);
	        }
	    } else if(elem->OP == Af) {
	        if(initenv(&env,elem->ARG1) == EXIT_SUCCESS) {
	            affect(env,elem->ARG1,++current);
	        }
	        if(initenv(&env,elem->ARG2) == EXIT_SUCCESS) {
	            affect(env,elem->ARG2,++current);
	        }
	    }
	    if(elem->OP == Sk) {
	        if(initenv(&env,elem->RES) == EXIT_SUCCESS) {
	            affect(env,elem->RES,++current);
	        }
	    }   
	    elem = elem->SUIV;
	}
	//Real compilation
	printf("\t\t.pos\t0\n");
	print(2,"INIT","irmovl","Data","%edx");
	print(2,NULL,"irmovl","256","%eax");
	print(2,NULL,"addl","%edx","%eax");
	print(2,NULL,"rrmovl","%eax","%esp");
	print(2,NULL,"rrmovl","%eax","%ebp");
	elem = list.debut;
	while(elem != NULL) {
	    if(elem->OP == Afc) {
            print(2,elem->ETIQ,"irmovl",elem->ARG1,"%eax");
            snprintf(buf,128,"%d(%%edx)",4*valch(env,elem->RES));
            print(2,NULL,"rmmovl","%eax", buf);
	    }
	    else if(elem->OP == Af) {
	        snprintf(buf,128,"%d(%%edx)",4*valch(env,elem->ARG2));
            print(2,elem->ETIQ,"mrmovl",buf,"%eax");
            snprintf(buf,128,"%d(%%edx)",4*valch(env,elem->ARG1));
            print(2,NULL,"rmmovl","%eax", buf);
	    }
	    else if(elem->OP == Pl ) {
            snprintf(buf,128,"%d(%%edx)",4*valch(env,elem->ARG1));
            print(2,elem->ETIQ,"mrmovl",buf,"%eax");
            snprintf(buf,128,"%d(%%edx)",4*valch(env,elem->ARG2));
            print(2,NULL,"mrmovl", buf,"%ebx");
            print(2,NULL,"addl", "%eax","%ebx");
            snprintf(buf,128,"%d(%%edx)",4*valch(env,elem->RES));
            print(2,NULL,"rmmovl", "%ebx",buf);
	    }
	    else if(elem->OP == Jp) {
	        print(1,elem->ETIQ,"jmp",elem->RES,NULL);
	    } 
	    else if(elem->OP == Jz) {
	        snprintf(buf,128,"%d(%%edx)",4*valch(env,elem->ARG1));
	        print(2,elem->ETIQ,"mrmovl",buf,"%eax");
	        print(2,NULL,"andl","%eax","%eax");
	        print(1,NULL,"je",elem->RES,NULL);
	    } 
	    else if(elem->OP == Sk) {
	        print(1,elem->ETIQ,"nop",NULL,NULL);
	    }
	    elem = elem->SUIV;
	}
	print(1,"END","halt","","");
	printf("\t\t.align\t8\n");
	printf("Data\t:\n");
    ecrire_env(env);
	
	
}
