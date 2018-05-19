/*
 * Split the OS9Boot file into its individual modules.
 * The boot file is read on standard in
 * The modules will be created as files in the current working directory.
 */
#include <stdio.h>
#include <module.h>


main(argc,argv)
    int argc;
    char *argv[];
{
    mod_exec header;
    FILE *tmpfp, *ifp;
    char *tmpname;
    int i,c;
    char outname[40];
    char *p;

    if (argc == 1)
        ifp = stdin;
    else
        ifp = fopen(argv[1], "r");

    tmpname = mktemp("split.XXXXX");
    while(fread(&header, sizeof(header), 1, ifp) > 0) {
        if (header.m_sync != 0x87cd) {
            fprintf(stderr, "Sync not found.\n");
            exit(1);
        }
        tmpfp = fopen(tmpname, "w");
        fwrite(&header, sizeof(header), 1, tmpfp);
        p = outname;

        i = sizeof(header);
        /* Copy up to module name */
        for ( ; i < header.m_name; i++) {
            c = getc(ifp);
            putc(c, tmpfp);
        }
        /* Copy the name to string buffer */
        while (i < header.m_size) {
            c = getc(ifp);
            putc(c, tmpfp);
            i++;
            if ((c & 0x80) != 0) {
                *p++ = c & 0x7F;
                break;
            } else {
                *p++ = c;
            }
        }
        *p++ = '\0';
        /* Copy the remainder */
        for ( ; i < header.m_size; i++) {
            c = getc(ifp);
            putc(c, tmpfp);
        }
        fclose(tmpfp);
        fprintf(stderr, "Extracting: %s\n", outname);
        filecopy(tmpname, outname);
    }
    unlink(tmpname);
}

filecopy(iname,oname)
    char *iname, *oname;
{
    FILE *ifp, *ofp;
    int l;
    char buf[BUFSIZ];

    ofp = fopen(oname, "w");
    ifp = fopen(iname, "r");
    while((l = fread(buf, 1, BUFSIZ, ifp)) > 0)
        fwrite(buf, 1, l, ofp);
    fflush(ofp);
    fclose(ofp);
    fclose(ifp);
}

