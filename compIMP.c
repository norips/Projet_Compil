#include <stdio.h>
#include "AST.h"
#include "imp.tab.h"
#include "environ.h"
static int currentV=0,currentC=0,current=0;

void print(int etq,const char *op, const char *arg, const char *arg2, const char *des) {
    printf("ET%d\t:%s\t:%s\t:%s\t:%s\n",etq,op,arg ? arg : "",arg2 ? arg2 : "",des ? des : "");
}
static int lbJMP=0;

int ex(ENV *e,nodeType *p) {
    int lbJMP1,lbJMP2;
	if (!p) return 0;
	switch(p->type) {
	    case typeCon:   ;;char buf[20];  snprintf(buf,20,"%d",p->con.value);
	                    ;;char buf2[20]; snprintf(buf2,20,"CT%d",++currentC);
	                    print(current++,"Afc", buf, NULL, buf2);
	                    break;
	    case typeId:	;;char buf5[20]; snprintf(buf5,20,"CT%d",++currentC);
	                    print(current++,"Af", buf5, p->id.id, NULL);
	                    break;
	    case typeOpr:    
	    switch(p->opr.oper) {
	        case Wh:    while(ex(e,p->opr.op[0]))
	                        ex(e,p->opr.op[1]);
	                    return 0;  
            case If:    ex(e,p->opr.op[0]);
                        ;;char buf8[20]; snprintf(buf8,20,"CT%d",currentC);
                        ;;char buf9[20]; snprintf(buf9,20,"JMP%d",lbJMP1 = lbJMP++);
                        print(current++,"Jz",buf8,NULL,buf9);
                        ex(e,p->opr.op[1]);
                        ;;char buf10[20]; snprintf(buf10,20,"JMP%d",lbJMP2 = lbJMP++);
                        print(current++,"Je",NULL,NULL,buf10);
                        printf("%s\t:%s\t:%s\t:%s\t:%s\n",buf9,"Sk","","","");
                        ex(e,p->opr.op[2]);
                        printf("%s\t:%s\t:%s\t:%s\t:%s\n",buf10,"Sk","","","");
	                    return 0; 
	        case Af:    ex(e,p->opr.op[1]);
	                    ;;char buf4[20]; snprintf(buf4,20,"CT%d",currentC);
	                    print(current++,"Af", p->opr.op[0]->id.id, buf4,NULL );
	                    break;
	                    
	        case Se:    ex(e,p->opr.op[0]); return ex(e,p->opr.op[1]);
	        
	        case Pl:    ex(e,p->opr.op[0]);
                        int leftCurrent = currentC;
                        ex(e,p->opr.op[1]);
                        char buf6[20]; snprintf(buf6,20,"CT%d",leftCurrent);
                        char buf7[20]; snprintf(buf7,20,"CT%d",currentC);
                        print(current++,"Pl",buf6,buf7,buf7);
                        break;
	        case Mo:    return ex(e,p->opr.op[0]) - ex(e,p->opr.op[1]);
	        case Mu:    return ex(e,p->opr.op[0]) * ex(e,p->opr.op[1]);
	    }
    }
    return 0;
}
