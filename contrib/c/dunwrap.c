/*
 * Dunwrap: split data module created with dwrap into its individual files.
 * The data file is read on standard in or given as argument.
 * The files will be created in the current working directory.
 */
#include <stdio.h>
#include <module.h>


typedef struct {
    unsigned   fl_start,   /* Start of data */
               fl_size     /* Size of data */
} fl_header;

int main(argc,argv)
    int argc;
    char *argv[];
{
    mod_data header;
    FILE *ifp;
    int i,c,dsize;
    char outname[40];
    char *p;
    fl_header file_head;

    if (argc == 1)
        ifp = stdin;
    else
        ifp = fopen(argv[1], "r");

    i = fread(&header, sizeof(header), 1, ifp);
    if (i == 0) {
        fprintf(stderr, "Unable to read file: %s\n", outname);
        exit(1);
    }
    if (header.m_sync != 0x87cd) {
        fprintf(stderr, "Sync bytes not found.\n");
        exit(1);
    }
    if (header.m_data == 0 || header.m_dsize == 0) {
        fprintf(stderr, "No data to unwrap.\n");
        exit(1);
    }

    dsize = header.m_dsize;
    for (i = sizeof(header); i < header.m_data; i++) getc(ifp);

    while (dsize > 0) {
        fread(&file_head, sizeof file_head, 1, ifp);
        i = file_head.fl_start - 2; /* Find end of name string */
        copyname(ifp, outname, i);
        fprintf(stderr, "Extracting: %s\n", outname);
        filecopy(ifp, outname, file_head.fl_size);
        dsize -= (file_head.fl_start + file_head.fl_size + 2);
    }
}

/* Copy the name to string buffer.
 * Side-effect: file-pointer is advanced to end of name string.
 */
copyname(fp, p, len)
    FILE *fp;
    char *p;
    int len;
{
    int c;
    while (len > 0) {
        c = getc(fp);
        len--;
        if ((c & 0x80) != 0) {
            *p++ = c & 0x7F;
            break;
        } else {
            *p++ = c;
        }
    }
    *p++ = '\0';
}

/* Copy file content to file.
 */
filecopy(ifp, oname, fsize)
    FILE *ifp;
    char *oname;
    int fsize;
{
    FILE *ofp;
    int c;

    if ((ofp = fopen(oname, "w")) == NULL) {
        fprintf(stderr, "Unable to open\n");
        return;
    }
    while(fsize > 0 && (c = getc(ifp)) != EOF) {
        putc(c, ofp);
        fsize--;
    }
    fflush(ofp);
    fclose(ofp);
}
