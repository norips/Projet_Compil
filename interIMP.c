#include <stdio.h>
#include "utils/AST.h"
#include "imp.tab.h"
#include "utils/environ.h"

int ex(ENV *e,nodeType *p) {
	if (!p) return 0;
	switch(p->type) {
	    case typeCon:   return p->con.value;
	    case typeId:    return valch(*e,p->id.id); 
	    case typeOpr:    
	    switch(p->opr.oper) {
	        case Wh:    while(ex(e,p->opr.op[0]))
	                        ex(e,p->opr.op[1]);
	                    return 0;  
            case If:    if(ex(e,p->opr.op[0])) {
                            ex(e,p->opr.op[1]);
                        } else {
	                        ex(e,p->opr.op[2]);
                        }
	                    return 0; 
	        case Af:    initenv(e,p->opr.op[0]->id.id); return affect(*e, p->opr.op[0]->id.id, ex(e,p->opr.op[1]));
	        case Se:    ex(e,p->opr.op[0]); return ex(e,p->opr.op[1]);
	        
	        case Pl:    return ex(e,p->opr.op[0]) + ex(e,p->opr.op[1]);
	        case Mo:    return ex(e,p->opr.op[0]) - ex(e,p->opr.op[1]);
	        case Mu:    return ex(e,p->opr.op[0]) * ex(e,p->opr.op[1]);
	    }
    }
    return 0;
}
