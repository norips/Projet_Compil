#include <stdio.h>
#include "utils/AST.h"
#include "imp.tab.h"
#include "utils/environ.h"
static int currentV=0,currentC=0,current=0,testPl=0,leftCurrent=0,test=0,testArith=0;;

void print(int etq,const char *op, const char *arg, const char *arg2, const char *des) {
    printf("ET%d\t:%s\t:%s\t:%s\t:%s\n",etq,op,arg ? arg : "",arg2 ? arg2 : "",des ? des : "");
}
static int lbJMP=0;

int ex(ENV *e,nodeType *p) {
    int lbJMP1,lbJMP2;
    char buf[20];
    char buf2[20];
    char buf3[20];
    char bufVar[20];
	if (!p) return 0;
	switch(p->type) {
	    case typeCon:   snprintf(buf,20,"%d",p->con.value);
	                    snprintf(buf2,20,"CT%d",++currentC);
                        print(current++,"Afc", buf, NULL, buf2);
                        test=0;
	                    break;
	    case typeId:	snprintf(buf,20,"CT%d",++currentC);
	                    print(current++,"Af", buf, p->id.id, NULL);
                        test=1;
	                    break;
	    case typeOpr:    
	    switch(p->opr.oper) {
	        case Wh:    snprintf(buf,20,"JMP%d",lbJMP1 = lbJMP++);
	                    printf("%s\t:%s\t:%s\t:%s\t:%s\n",buf,"Sk","","","");
	                    ex(e,p->opr.op[0]);
	                    snprintf(buf2,20,"CT%d",currentC);
                        snprintf(buf3,20,"JMP%d",lbJMP2 = lbJMP++);
                        print(current++,"Jz",buf2,NULL,buf3);
                        ex(e,p->opr.op[1]);
                        print(current++,"Jp",NULL,NULL,buf);
                        printf("%s\t:%s\t:%s\t:%s\t:%s\n",buf3,"Sk","","","");
                        
	                        
	                    return 0;  
            case If:    ex(e,p->opr.op[0]);
                        snprintf(buf,20,"CT%d",currentC);
                        snprintf(buf2,20,"JMP%d",lbJMP1 = lbJMP++);
                        print(current++,"Jz",buf,NULL,buf2);
                        ex(e,p->opr.op[1]);
                        snprintf(buf3,20,"JMP%d",lbJMP2 = lbJMP++);
                        print(current++,"Jp",NULL,NULL,buf3);
                        printf("%s\t:%s\t:%s\t:%s\t:%s\n",buf2,"Sk","","","");
                        ex(e,p->opr.op[2]);
                        printf("%s\t:%s\t:%s\t:%s\t:%s\n",buf3,"Sk","","","");
	                    return 0; 
	        case Af:    ex(e,p->opr.op[1]);
                        snprintf(buf,20,"CT%d",currentC);
                        print(current++,"Af", p->opr.op[0]->id.id, buf,NULL );
	                    break;
	                    
	        case Se:    ex(e,p->opr.op[0]); return ex(e,p->opr.op[1]);
	        
	        case Pl:    ex(e,p->opr.op[0]);
                        leftCurrent = currentC;
                        ex(e,p->opr.op[1]);
                        snprintf(buf,20,"CT%d",leftCurrent);
                        snprintf(buf2,20,"CT%d",currentC);
                        snprintf(bufVar,20,"CT%d",++currentC);
                        print(current++,"Pl",buf,buf2,bufVar);
                        break;
                
            case Mo:    ex(e,p->opr.op[0]);
                        leftCurrent = currentC;
                        ex(e,p->opr.op[1]);
                        snprintf(buf,20,"CT%d",leftCurrent);
                        snprintf(buf2,20,"CT%d",currentC);
                        snprintf(bufVar,20,"CT%d",++currentC);
                        print(current++,"Mo",buf,buf2,bufVar);
                        break;

            
            case Mu:    ex(e,p->opr.op[0]);
                        leftCurrent = currentC;
                        ex(e,p->opr.op[1]);
                        snprintf(buf,20,"CT%d",leftCurrent);
                        snprintf(buf2,20,"CT%d",currentC);
                        snprintf(bufVar,20,"CT%d",++currentC);
                        print(current++,"Mu",buf,buf2,bufVar);
                        break;
	    }
    }
    return 0;
}
