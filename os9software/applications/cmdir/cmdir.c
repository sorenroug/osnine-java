/*
 * Print out the module directory.
 */

#include <stdio.h>
#include <module.h>
#include "page0.h"

typedef struct {
    mod_exec *md_addr;
    char md_links;
    char md_fill;
} md_entry;

/*
 * An os9 string is terminated with highorder bit set
 * This helpful function prints it out.
 */
static int
os9print(out, str)
    FILE *out;
    char *str;
{
    while(*str > 0)
        putc(*str++, out);
    putc(*str & 127,out);
}
    
main(argc,argv)
    int argc;
    char **argv;
{
    struct page0 *p0;
    mod_exec *m;
    int tylan, revision;
    md_entry *p;
    char *name;
    static char attrbits[5] = "....";

    p0 = (struct page0 *)0;

    printf("Addr Size typ rev attr use module name\n");
    printf("---- ---- --- --- ---- --- ------------\n");

    for (p = p0->D_MDirs; p < p0->D_MDire; p++) {
        if (p->md_addr == NULL) break;
        m = p->md_addr;
        tylan = m->m_tylan & 0xFF;
        revision = m->m_attrev & 0x0F;
        attrbits[0] = (m->m_attrev & 0x80) ? 'r' : '.';
        name = ((int)m) + m->m_name;
        printf("%04X %4X  %2X  %2X ", m, m->m_size, tylan, revision);
        printf("%s  %2X ", attrbits, p->md_links);
        os9print(stdout, name);
        printf("\n");
    }
    exit(0);
}

