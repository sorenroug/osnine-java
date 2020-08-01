/*
 * Sortdir - tool to sort the entries in a directory.
 * WARNING: This program will modify the directory.
 */
#include <stdio.h>
#include <direct.h>
#include <modes.h>
#include <os9.h>

#define SKIPRECS 2

int compare(e1, e2)
    struct dirent *e1, *e2;
{
    if ((char)*e1 == '\0') return 1;
    if ((char)*e2 == '\0') return -1;

    return strcascmp(e1, e2, sizeof e1->dir_name);
}

/*
 * Compare two directory entries.
 */
int strcascmp(s, t, n)
    char *s, *t;
    int n;
{
    if (n <= 0) return 0;

    for ( ; tolower(*s & 0x7F) == tolower(*t & 0x7F); s++, t++, n--)
        if (n <= 0 || *s <= 0 || *t <= 0)
            return 0;
    return tolower(*s & 0x7F) - tolower(*t & 0x7F);
}

int sortdir(dir)
    char *dir;
{
    struct dirent *entries;
    int entsize, dirsize, i, total;
    char *p;

    int dirfd = open(dir, S_IFDIR + S_ISHARE + S_IWRITE + S_IREAD);
    if (dirfd == -1) return -1;

    dirsize = filesize(dirfd);

    entsize = sizeof(struct dirent);

    total = dirsize / entsize;
    entries = malloc(dirsize);

    read(dirfd, entries, dirsize);
    qsort(&entries[SKIPRECS], total-SKIPRECS, entsize, compare);
    /*
    for (i = SKIPRECS; i < total; i++) {
        p = entries[i].dir_name;
        if (*p == '\0') {
            continue;
        }
        prentry(&entries[i]);
    }
    */
    lseek(dirfd, 0L, 0); /* Rewind */

    write(dirfd, entries, dirsize);
    close(dirfd);
    return 0;
}

/*
 * Print a directory entry.
 */
int prentry(entryp)
    struct dirent *entryp;
{
    int i;
    char *p;

    p = entryp->dir_name;
    for (i = sizeof entryp->dir_name; i > 0; i--) {
        putchar(*p & 0x7F);
        if((*p & 0x80) != 0) break;
        p++;
    }
    putchar('\n');
}

/*
 * Get the size of the directory. Works up to 32 K.
 */
int filesize(dirfd)
    int dirfd;
{
    struct registers reg;
    int res;

    reg.rg_a = dirfd;
    reg.rg_b = SS_SIZE;
    res = _os9(I_GETSTT, &reg);
    if (res == 0) {
        return reg.rg_u;
    }
    return -1;
}

int main(argc, argv)
    int argc;
    char *argv[];
{
    int i;
    char answer[2];

    printf("Warning: this program will modify the directory.\n");
    printf("Do not run while other programs create/delete files.\n\n");
    printf("Want to continue (y/n)? ");
    fgets(answer, 2, stdin);
    if (*answer != 'y' && *answer != 'Y') {
        exit(0);
    }
    if (argc == 1) sortdir(".");
    else {
        for (i = 1; i < argc; i++) {
            if (sortdir(argv[i]) == -1) exit(errno);
        }
    }
    exit(0);
}
