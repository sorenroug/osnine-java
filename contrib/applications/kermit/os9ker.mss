@begin(comment)
@Part(OS9KERMIT,root="USER")
@Chapter<OS9 KERMIT>
@end(comment)
@Begin<Description,Leftmargin +12,Indent -12,spread 0>
@i(Authors:)@\Bill Catchings, Bob Cattani, Chris Maio, Columbia University@*
Modified from UNIX Kermit to Os9 Kermit By Glean Seaton and Robert A. Larson@*
with fixes and contributions from many others.

@i(Documentation:)@\Walter Underwood, Ford Aerospace (Palo Alto, CA)@*
Changed for Os9 Kermit by Robert A. Larson

@i(Version:)@\1.5

@i(Date: )@\July 1985
@end<Description>

@label<-kc>
A sample, working implementation of the Kermit "kernel" was written in the
C language, and widely distributed in the @i<Kermit Protocol Manual>.  This
kernel was intended merely to
illustrate the protocol, and did not include a "user interface", nor some of
the fancy features like server support, 8-bit quoting, file warning, timeouts,
etc.  Several sites have added the necessary trappings to make this a
production version of Kermit, usually under the UNIX operating system.
Limited server functions have also been added to the Os9 version.

The keyword style of user/program interaction favored by Kermit (program types
prompt, user types command followed by operands, program types another prompt,
etc) is contrary to the UNIX style, so UNIX implementations have a style more
familiar to UNIX users.  The Os9 version has retained this style of command
interface.  C versions of Kermit are running successfully on
VAX and PDP-11 UNIX systems, IBM 370-@|compatible mainframes under Amdahl UTS,
and the SUN Microsystems MC68000-@|based and other workstations.

There is a new version of Kermit written in C called C-Kermit.  (The current
version as of July 1985 is 4c.)  It is recommended for Unix and adapting to
other operating systems if memory is adiquate.  (It is being adapted to
Os9/68000, but is probably to large for Os9/6809.)

Os9 filespecs are of the form
@example<dir1/dir2/dir3/ ... /filename>
where the tokens delimited by slashes form a @i<path name>, and 
are each limited to 29 characters in length.  The final token in a path is the
actual file name.  By convention, it is of the form name.type, but there is
nothing special about the dot separating name and type;
to Os9 it's just another character, and there may be many dots in a filename.

In the tradition of UNIX, here's the Os9 KERMIT "man page".

@begin<description>
NAME@\kermit - file transfer, virtual terminal over tty link

SYNOPSIS@\kermit cl[e] line [esc]

@\kermit r[ddifl] [line] 

@\kermit s[ddifl] [line] file ...

@\kermit gl[ddif] line file ...

@\kermit ql[ddif] line

@\kermit h[ddifl] [line]

DESCRIPTION@\@begin<multiple>Kermit provides reliable file transfer and
primitive virtual terminal communication between machines.  It has been
implemented on many different computers, including microprocessors (see below).
The files transferred may be arbitrary ASCII data (7-bit characters) and may be
of any length.  The file transfer protocol uses small (96 character)
check summed packets, with ACK/NACK responses and timeouts.  
Os9 Kermit by defaults (changeable by compilation options)
uses a fifteen "second" timeout and ten retries.

The arguments to kermit are a set of flags (no spaces
between the flags), three optional args (which, if included,
must be in the same order as the flags which indicate their
presence), and, if this is a Send or Get operation a list of one or
more files. 

Kermit has six modes, Connect, Send, Receive, Get, Quit, and Host.  Connect
is for a virtual terminal connection, Send and Receive may be used to
transfer files in a non-server mode, Send, Get, and Quit are used with
a remote kermit server, and Host is used to make the Os9 system a server
itself.  These modes are specified by the first
flag, which should be c, s, r, g, q, or h respectively.  Exactly one
mode must be specified.

The d flag (debug) makes kermit a bit more verbose.  The
states kermit goes through are printed along with other
traces of its operation.  A second, third, and even fourth 
d flag will cause kermit
to give an even more detailed trace.

The i flag (image) allows slightly more efficient file
transfer between Os9 machines.  Normally (on Kermits
defined to run on Os9 systems) return is mapped to CRLF on
output, LF's are discarded on input, and bytes are masked to
7 bits.  If this is set, no mapping is done on returns, and
all eight bits of each byte are sent or received.  

The l flag (line) specifies the tty line that kermit should use to communicate
with the other machine.  This is specified as a regular filename, like
"/t2".  If no l option is specified, standard input is used and kermit
assumes it is running on the remote host (i.e.. NOT the machine to which your
terminal is attached).

The e flag (escape) allows the user to set the first character of the two
character escape sequence for Connect mode.  When the escape character is
typed, kermit will hold it and wait for the next character.  If the next
character is c or C, kermit will close the connection with the remote host.  If
the second character is the same as the escape character, the escape character
itself is passed.  An exclamation mark ('!') as the second character will
cause shell to be forked.  (Use your EOF character to return to the kermit
connect mode.)
Any character other than these two results in a bell being
sent to the user's terminal and no characters passed to the remote host.  All
other typed characters are passed through unchanged.  The default escape
character is tilde ('~').  (Control-3 on the standard Coco keyboard.)

The file arguments are only meaningful to a Send or Get kermit.
The Receiving kermit will attempt to store the file with the
same name that was used to send it.  Os9 kermits normally
convert outgoing file names to uppercase and incoming ones
to lower case (see the f flag).  If a filename contains a
slash (/) all outgoing kermits will strip off the leading
part of the name through the last slash.  In the Get command, filenames
will be sent to the remote host as is and the filenames sent back will
be converted as usual for a receiving kermit.  (Wildcard characters
may be expanded on the remote end.)

The Quit command will send a "Generic Finish" packet to the remote
kermit server.

The Host command has not been fully implemented and tested as of this
writing.
@end<multiple>

EXAMPLE@\@begin<multiple>For this example we will assume two Os9 machines.  We
are logged onto "Os9a" (the local machine), and want to communicate with
"Os9b" (the remote machine).  There is a modem on "/t2".

We want to connect to "Os9b", then transfer "file1" to that
machine.

We type:
@example<kermit cl /t2>

Kermit answers:
@example<Kermit: connected...>

Now we dial the remote machine and connect the modem.  Anything typed on the
terminal will be sent to the remote machine and any output from that machine
will be displayed on our terminal.  We hit RETURN, get a "login:" prompt and
login.

Now we need to start a kermit on the remote machine so that
we can send the file over.  First we start up the remote,
(in this case receiving) kermit, then the local, (sending)
one.  Remember that we are talking to Os9b right now.

We type:
@example(kermit r)
(there is now a Receive kermit on Os9b)

We type ~ (the escape character) and then the letter c to kill the
local (Connecting) kermit:
~c

Kermit answers:
@example<Kermit: disconnected.>

We type:
@example<kermit sl /t2 file1>

Kermit answers:
@example<Sending file1 as FILE1>

When the transmission is finished, kermit will type either
"Send complete", or "Send failed.", depending on the success
of the transfer.  If we now wanted to transfer a file from
os9b (remote) to os9a (local), we would use these commands:

@begin<example>
kermit cl /t2
  @i<(connected to Os9b)>
kermit s file9
  ~c @i<(talking to Os9a again)>
kermit rl /t2 
@end<example>
After all the transfers were done, we should connect again,
log off of Os9b, kill the Connect kermit and hang up the
phone.
@end<multiple>

FEATURES@\Kermit can interact strangely with the tty driver.

@\The KERMIT Protocol uses only printing ASCII characters, Ctrl-A, and CRLF.
Ctrl-S/Ctrl-Q flow control can be used "underneath" the Kermit protocol,
but is not currently implemented in Os9 Kermit.

@\Since BREAK is not an ASCII character, kermit cannot send a BREAK to the
remote machine.  On some systems, a BREAK will be read as a NUL.

@\This kermit does have timeouts when run under Os9, so the protocol is stable
when communicating with "dumb" kermits (that don't have timeouts).

DIAGNOSTICS@\@begin<multiple>@i<cannot open device>@*
          The file named in the line argument did not exist or
          had the wrong permissions.

     @i<Could not create file>@*
          A Receive kermit could not create the file being sent
          to it.

     @i<nothing to connect to>@*
          A Connect kermit was started without a line argument.
@end<multiple>
@end<description>

