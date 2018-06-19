/*
 * os9raw.c Uncook and cook rbf devices for os9 kermit
 */

#include "os9inc.h"

/*
 * 06/30/85 ral Initial coding, partially adapted from 
 *              code by Bradley Bosch
 */

/* save current state in savesg and force path into raw mode */
raw(path, savesg)   
int             path;
struct sgbuf    *savesg;
{
    struct sgbuf    tempsg;

    getstat(0, path, savesg);
    getstat(0, path, &tempsg);
    if(tempsg.sg_class==0){  /* only change things for scf */ 
        /* Microware C generates better code with 0 only specified once */
        tempsg.sg_delete=
        tempsg.sg_backsp=
        tempsg.sg_echo  =
        tempsg.sg_alf   =
        tempsg.sg_pause =
        tempsg.sg_dlnch =
        tempsg.sg_eorch =
        tempsg.sg_eofch =
        tempsg.sg_rlnch =
        tempsg.sg_dulnch=
        tempsg.sg_psch  =
        tempsg.sg_kbich =
        tempsg.sg_kbach = 0;
#ifdef SGXONOFF
        tempsg.sg_xon   =
        tempsg.sg_xoff  = 0;
#endif
        setstat(0, path, &tempsg);
    }
}

cook(path, savesg) 
int             path;
struct sgbuf    *savesg;
{
        setstat(0, path, savesg);
}
