/*
    (c) 2001 Soren Roug

    This file is part of Osnine.

    Osnine is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    Osnine is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Osnine; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

    $Id: v6809.cpp 56 2011-11-30 21:28:54Z roug $
*/
//	v6809.cc - Virtual 6809
// The idea behind this program is to have virtual devices that are
// easy to support from OS9
//

#include <cstdlib>
#include <cstdio>
using namespace std;
#include <signal.h>
#include <unistd.h>
#include "mc6809_X.h"
#include "mc6850.h"


class V6809 : virtual public mc6809_X {

protected:

	virtual Byte			 read(Word);
	virtual void			 write(Word, Byte);

protected:

		mc6850			 uart;

} sys;

Byte V6809::read(Word addr)
{
	Byte		ret = 0;

	if ((addr & 0xfffe) == 0xff40) {
		ret = uart.read(addr);
	} else {
		ret = mc6809_X::read(addr);
	}

	return ret;
}

void V6809::write(Word addr, Byte x)
{
	if ((addr & 0xfffe) == 0xff40) {
		uart.write(addr, x);
	} else {
		mc6809_X::write(addr, x);
	}
}

#ifdef SIGALRM
void update(int)
{
	sys.status();
	(void)signal(SIGALRM, update);
	alarm(1);
}
#endif // SIGALRM

int main(int argc, char *argv[])
{
	if (argc != 2) {
		fprintf(stderr, "usage: %s <hexfile>\n",argv[0]);
		return EXIT_FAILURE;
	}

/*
	(void)signal(SIGINT, SIG_IGN);
*/
#ifdef SIGALRM
	(void)signal(SIGALRM, update);
	alarm(1);
#endif

	sys.load_srecord(argv[1]);
	sys.run();

	return EXIT_SUCCESS;
}
