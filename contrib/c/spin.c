/*
 * Example of using tsleep() and signal() system calls.
 * This program will spin a hyphen until keyboard interrupt.
 */
#include <stdio.h>
#include <signal.h>

#define BACKSPACE 8

goodbye(sig)
    int sig;
{
    putchar(BACKSPACE);
    printf("Goodbye\n");
    exit(0);
}

int main() {
    static char *spinner = "-\\|/";
    int i;

    signal(SIGQUIT, goodbye);
    signal(SIGINT, goodbye);

    putchar(spinner[0]);
    i = 1;
    while (1) {
        putchar(BACKSPACE);
        putchar(spinner[i]);
        fflush(stdout);
        i = (i + 1) % 4;
        tsleep(25);
    }
}
