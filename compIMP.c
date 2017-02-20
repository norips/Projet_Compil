#include <stdio.h>
#include "AST.h"
#include "imp.tab.h"
#include "environ.h"
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
	    case typeId:	snprintf(buf2,20,"CT%d",++currentC);
	                    print(current++,"Sk", NULL, NULL, p->id.id);
                        test=1;
	                    break;
	    case typeOpr:    
	    switch(p->opr.oper) {
	        case Wh:    snprintf(buf,20,"JMP%d",lbJMP1 = lbJMP++);
	                    printf("%s\t:%s\t:%s\t:%s\t:%s\n",buf,"Sk","","","");
	                    ex(e,p->opr.op[0]);
	                    snprintf(buf2,20,"CT%d",currentC);
                        snprintf(buf3,20,"JMP%d",lbJMP2 = lbJMP++);
                        if(test==0){
                            print(current++,"Jz",buf2,NULL,buf3);
                        }else{
                            print(current++,"Jz",p->opr.op[0]->id.id,NULL,buf3);
                            test=0;
                        }
                        ex(e,p->opr.op[1]);
                        print(current++,"Je",NULL,NULL,buf);
                        printf("%s\t:%s\t:%s\t:%s\t:%s\n",buf3,"Sk","","","");
                        
	                        
	                    return 0;  
            case If:    ex(e,p->opr.op[0]);
                        snprintf(buf,20,"CT%d",currentC);
                        snprintf(buf2,20,"JMP%d",lbJMP1 = lbJMP++);
                        if(test==0){
                            print(current++,"Jz",buf,NULL,buf2);
                        }else{
                            print(current++,"Jz",p->opr.op[0]->id.id,NULL,buf2);
                            test=0;
                        }
                        ex(e,p->opr.op[1]);
                        snprintf(buf3,20,"JMP%d",lbJMP2 = lbJMP++);
                        print(current++,"Jp",NULL,NULL,buf3);
                        printf("%s\t:%s\t:%s\t:%s\t:%s\n",buf2,"Sk","","","");
                        ex(e,p->opr.op[2]);
                        printf("%s\t:%s\t:%s\t:%s\t:%s\n",buf3,"Sk","","","");
	                    return 0; 
	        case Af:    ex(e,p->opr.op[1]);
                        if (testPl == 0){
                            if (test==0){
                                snprintf(buf,20,"CT%d",currentC);
                                print(current++,"Af", p->opr.op[0]->id.id, buf,NULL );
                            }else{
                                snprintf(buf,20,"CT%d",currentC);
                                print(current++,"Af", p->opr.op[0]->id.id, p->opr.op[1]->id.id,NULL );
                                test=1;
                            }
                        }else{
                            if (test==0){
                                snprintf(bufVar,20,"VA%d",currentC);
                                print(current++,"Af", p->opr.op[0]->id.id, bufVar,NULL );
                                testPl=0;
                            }else{
                                snprintf(bufVar,20,"VA%d",currentC);
                                print(current++,"Af", p->opr.op[0]->id.id, bufVar,NULL );
                                testPl=0;
                                test=0;
                            }
                        }
	                    break;
	                    
	        case Se:    ex(e,p->opr.op[0]); return ex(e,p->opr.op[1]);
	        
	        case Pl:    ex(e,p->opr.op[0]);
                        leftCurrent = currentC;
                        ex(e,p->opr.op[1]);
                        snprintf(buf,20,"CT%d",leftCurrent);
                        snprintf(buf2,20,"CT%d",currentC);
                        snprintf(bufVar,20,"VA%d",++currentC);
                        if (test==0){
                            print(current++,"Pl",p->opr.op[0]->id.id,buf2,bufVar);
                        }else{
                            print(current++,"Pl",p->opr.op[0]->id.id,p->opr.op[1]->id.id,bufVar);

                        }
                        testPl=1;
                        break;
                
            case Mo:    ex(e,p->opr.op[0]);
                        leftCurrent = currentC;
                        ex(e,p->opr.op[1]);
                        snprintf(buf,20,"CT%d",leftCurrent);
                        snprintf(buf2,20,"CT%d",currentC);
                        snprintf(bufVar,20,"VA%d",++currentC);
                        if (test==0){
                            print(current++,"Mo",p->opr.op[0]->id.id,buf2,bufVar);
                        }else{
                            print(current++,"Mo",p->opr.op[0]->id.id,p->opr.op[1]->id.id,bufVar);
                    
                        }
                        testPl=1;
                        break;

            
            case Mu:    ex(e,p->opr.op[0]);
                        leftCurrent = currentC;
                        ex(e,p->opr.op[1]);
                        snprintf(buf,20,"CT%d",leftCurrent);
                        snprintf(buf2,20,"CT%d",currentC);
                        snprintf(bufVar,20,"VA%d",++currentC);
                        if (test==0){
                            print(current++,"Mu",p->opr.op[0]->id.id,buf2,bufVar);
                        }else{
                            print(current++,"Mu",p->opr.op[0]->id.id,p->opr.op[1]->id.id,bufVar);
                    
                        }
                        testPl=1;
                        break;
	    }
    }
    return 0;
}
