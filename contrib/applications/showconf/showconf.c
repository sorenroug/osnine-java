/*
 * Find the top of RAM, system drive etc. from the init module.
 */
#include <stdio.h>

#define T_SYSTM 0x0C
#define L_DATA 0x00

/* The mod_config structure in module.h is incorrect.
 * It is missing the system terminal. Recreated as mod_init.
 */
typedef struct {
        unsigned        m_sync,         /* sync bytes ($87cd) */
                        m_size,         /* module size */
                        m_name;         /* offset to module name */
        char            m_tylan,        /* type & language */
                        m_attrev,       /* attributes & revision */
                        m_parity;       /* header parity */

        char            m_ramtop[3];    /* top limit of free ram */
        char            m_irqno,        /* IRQ polling entries */
                        m_devno;        /* device entries */
        unsigned        m_startup,      /* offset to startup mod. name */
                        m_sysdrive,     /* offset to default drive name */
                        m_systerm,      /* offset to default terminal */
                        m_boot;         /* offset to bootstrap module name */
} mod_init;

/*
 * An os9 string is terminated with highorder bit set
 * This helpful function copies it into a C-convention string.
 */
static char *
strcpyh(s1, s2)
    char *s1;
    char *s2;
{
    char *p = s1;
    while(*s2 > 0)
        *p++ = *s2++;
    *p++ = *s2 & 127;
    *p = '\0';
    return s1;
}


main()
{
    mod_init *initmod;
    long ramtop;
    char buffer[40];

    pflinit();
    initmod = (mod_init*)modlink("init", T_SYSTM, L_DATA);
    if ((int)initmod == -1) {
        fprintf(stderr, "Init module not found\n");
        exit(1);
    }
    l3tol(&ramtop, initmod->m_ramtop, 1);
    printf("Top of RAM: %lx\n", ramtop);
    printf("IRQ polling entries: %d\n", initmod->m_irqno);
    printf("Device entries: %d\n", initmod->m_devno);
    strcpyh(buffer, (int)initmod + initmod->m_startup);
    printf("Startup module: %s\n", buffer);
    strcpyh(buffer, (int)initmod + initmod->m_sysdrive);
    printf("System drive: %s\n", buffer);
    strcpyh(buffer, (int)initmod + initmod->m_systerm);
    printf("Standard I/O terminal: %s\n", buffer);
    strcpyh(buffer, (int)initmod + initmod->m_boot);
    printf("Bootstrap module: %s\n", buffer);

    munlink(initmod);
    exit(0);
}
