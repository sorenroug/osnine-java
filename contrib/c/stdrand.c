/* C standard reference implementation */
static long int next = 1;

int rand() /* RAND_MAX assumed to be 32767 */
{
    long int r;
    next = next * 1103515245L + 12345L;
    r = next / 65536L;
    return (unsigned int)(r & 0x7FFF);
}

srand(seed)
    unsigned int seed;
{
    next = seed;
}
