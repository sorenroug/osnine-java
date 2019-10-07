/* C standard reference implementation */
static long int next = 1;

int rand() /* RAND_MAX assumed to be 32767 */
{
    next = next * 1103515245 + 12345;
    return (unsigned int)(next / 65536) % 32768;
}

srand(seed)
    unsigned int seed;
{
    next = seed;
}
