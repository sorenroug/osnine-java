#include <stdio.h>
#include <direct.h>
#include <modes.h>

int lsdir(dir)
    char *dir;
{
    struct dirent entry;
    int entsize;
    char *p;
    int i;

    int dirfd = open(dir, S_IFDIR + S_IREAD);
    if (dirfd == -1) return -1;

    entsize = sizeof(entry);

    while(read(dirfd, &entry, entsize) == entsize) {
        p = entry.dir_name;
        if (*p == '\0' || *p == '.') continue;

        for (i = sizeof entry.dir_name; i > 0; i--) {
            putchar(*p & 0x7F);
            if((*p & 0x80) != 0) break;
            p++;
        }
        putchar('\n');
    }
    close(dirfd);
    return 0;
}

int main(argc, argv)
    int argc;
    char *argv[];
{
    int i;

    if (argc == 1) lsdir(".");
    else {
        for (i = 1; i < argc; i++) {
            if (lsdir(argv[i]) == -1) exit(errno);
        }
    }
    exit(0);
}
