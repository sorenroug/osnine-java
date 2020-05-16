/*
 * Display hex code for entered key.
 * This is an example of how to change the terminal.
 */
#include <sgstat.h>
#include <stdio.h>
#include <signal.h>

struct sgbuf org, alt;

goodbye(sig)
    int sig;
{
    setstat(0, 0, &org);
    exit(0);
}

int main() {

    char buf[2];

    getstat(0, 0, &org);
    signal(SIGQUIT, goodbye);
    signal(SIGINT, goodbye);

    _strass(&alt, &org, sizeof org);
    alt.sg_echo = '\0';
    alt.sg_eofch = '\0';
    setstat(0, 0, &alt);

    buf[0] = '\0';
    while(1) {
        read(0, buf, 1);
        printf("%02X\n", *buf);
    }
}

