#include <stdio.h>

int         opterr = 1,         /* if error message should be printed */
            optind = 1,         /* index into parent argv vector */
            optopt;             /* character checked for validity */
char       *optarg;             /* argument associated with option */

#define BADCH   (int)'?'
#define BADARG  (int)':'
#define EMSG    ""

/*
 * getopt
 *  Parse argc/argv argument vector.
 *
 * This implementation does not use optreset.  Instead, we guarantee that
 * it can be restarted on a new argv array after a previous call returned -1,
 * if the caller resets optind to 1 before the first call of the new series.
 * (Internally, this means we must be sure to reset "place" to EMSG before
 * returning -1.)
 */
int
getopt(nargc, nargv, ostr)
    int nargc;
    char **nargv;
    char *ostr;
{
    static char *place = EMSG;  /* option letter processing */
    char       *oli;            /* option letter list index */

    if (!*place)
    {                           /* update scanning pointer */
        if (optind >= nargc || *(place = nargv[optind]) != '-')
        {
            place = EMSG;
            return -1;
        }
        if (place[1] && *++place == '-' && place[1] == '\0')
        {                       /* found "--" */
            ++optind;
            place = EMSG;
            return -1;
        }
    }                           /* option letter okay? */
    if ((optopt = (int) *place++) == (int) ':' ||
        !(oli = index(ostr, optopt)))
    {
        /*
         * if the user didn't specify '-' as an option, assume it means -1.
         */
        if (optopt == (int) '-')
        {
            place = EMSG;
            return -1;
        }
        if (!*place)
            ++optind;
        if (opterr && *ostr != ':')
            fprintf(stderr,"illegal option -- %c\n", optopt);
        return BADCH;
    }
    if (*++oli != ':')
    {                           /* don't need argument */
        optarg = NULL;
        if (!*place)
            ++optind;
    }
    else
    {                           /* need an argument */
        if (*place)             /* no white space */
            optarg = place;
        else if (nargc <= ++optind)
        {                       /* no arg */
            place = EMSG;
            if (*ostr == ':')
                return BADARG;
            if (opterr)
                fprintf(stderr, "option requires an argument -- %c\n", optopt);
            return BADCH;
        }
        else
            /* white space */
            optarg = nargv[optind];
        place = EMSG;
        ++optind;
    }
    return optopt;              /* dump back option letter */
}
