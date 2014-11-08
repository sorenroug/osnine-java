package org.roug.osnine;

import java.io.FileInputStream;
import java.io.InputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

/**
 * Generic processor run state routines.
*/
public abstract class USim {

    public boolean  halted;  //!< Flag: is the CPU halted?
    /** Memory space */
    private int memory[];

// Generic internal registers that we assume all CPUs have

    public int        ir; //!< Instruction Register.
    public int        pc; //!< Program Counter.

    /**
     * Constructor.
     */
    public USim() {
    }

    /**
     * Constructor.
     */
    public USim(int memorySize) {
        this();
        allocate_memory(memorySize);
    }

    public void allocate_memory(int size) {
        //TODO: Don't allow allocation of more than 65536 bytes
        memory = new int[size];
    }

    /**
     * Read 16-bit word.
     */
    public abstract int read_word(int offset);

    /**
     * Write 16-bit word.
     */
    public abstract void write_word(int offset, int val);

    /**
     * Reset the simulator.
     */
    public abstract void reset();

    /**
     * Output a status somehow.
     */
    public abstract void status();

    /**
     * Execute one instruction.
     */
    public abstract void execute();

    /**
     * Run until illegal instrution is encountered and then show status.
     */
    public void run() {
        halted = false;
        while (!halted) {
            execute();
        }
        status();
    }

    /**
     * Execute one instruction and then show status.
     */
    public void step() {
        execute();
        status();
    }

    /*
     * Set the halt flag.
     */
    public void halt() {
        halted = true;
    }

    /**
     * Fetch one memory byte from program counter and increment program counter.
     */
    public int fetch() {
        int val = read(pc);
        pc += 1;

        return val;
    }

    /**
     * Fetch two memory bytes from program counter.
     */
    public int fetch_word() {
        int val = read_word(pc);
        pc += 2;

        return val;
    }

    /**
     * Invalid operation encountered. Halt the processor.
     */
    void invalid(final String msg)
    {
        System.err.format("\ninvalid %s : pc = [%04x], ir = [%04x]\r\n",
                msg == null ? msg : "",
                pc, ir);
        halt();
    }

    //----------------------------------------------------------------------------
    // Primitive (byte) memory access routines
    //----------------------------------------------------------------------------

    /**
     * Single byte read from memory.
     */
    public int read(int offset) {
        return memory[offset];
    }

    /**
     * Single byte write to memory.
     */
    public void write(int offset, int val) {
        memory[offset] = val & 0xff;
    }

    //----------------------------------------------------------------------------
    // Processor loading routines
    //----------------------------------------------------------------------------
    static int fread_byte(InputStream fp) throws IOException {
        byte str[] = new byte[2];
        int bytesRead;

        bytesRead = fp.read(str);
        String hexStr = str.toString();
        return Integer.valueOf(hexStr, 16).intValue();
    }

    static int fread_word(InputStream fp) throws IOException {
        int ret;

        ret = fread_byte(fp);
        ret <<= 8;
        ret |= fread_byte(fp);

        return ret;
    }

    private int fgetc(InputStream fp) throws IOException {

        return fp.read();
        /*
        byte byteBuf[] = new byte[1];
        int bytesRead;

        bytesRead = fp.read(byteBuf);
        String s = new String(byteBuf);
        return s.charAt(0);
        */
    }

    private boolean feof(InputStream fp) throws IOException {
        if (fp.available() == 0) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * Load file in Motorola S-record format into memory. The address
     * to load into is stored in the file.
     * Motorola's S-record format for output modules was devised for the
     * purpose of encoding programs or data files in a printable (ASCII)
     * format.  This allows viewing of the object file with standard
     * tools and easy file transfer from one computer to another, or
     * between a host and target.  An individual S-record is a single
     * line in a file composed of many S-records.
     *
     * S-Records are character strings made of several fields which
     * specify the record type, record length, memory address, data, and
     * checksum.  Each byte of binary data is encoded as a 2-character
     * hexadecimal number: the first ASCII character representing the
     * high-order 4 bits, and the second the low-order 4 bits of the
     * byte.
     */
    public void load_srecord(final String filename) throws FileNotFoundException,  IOException {
        FileInputStream fp;
        fp = new FileInputStream(filename);
        load_srecord(fp);
        fp.close();
    }

    /**
     * Load file in Motorola S-record format into memory.
     */
    public void load_srecord(InputStream fp) throws IOException {
        boolean done = false;

        while (!done) {
            int n, t;
            int addr;
            int b;

            while(fgetc(fp) != (int)'S' && !feof(fp)) // Look for the S
                  ;
            if(feof(fp))
                return;
            t = fgetc(fp);          // Type
            n = fread_byte(fp);     // Length
            addr = fread_word(fp);      // Address
            n -= 2;
            if (t == '0') {
                System.out.print("Loading: ");
                while (--n > 0) {
                    b = fread_byte(fp);
                    System.out.format("%c", b);
                }
                System.out.println();
            } else if (t == '1') {
                while (--n > 0) {
                    b = fread_byte(fp);
                    memory[addr++] = b;
                }
            
            } else if (t == '9') {
                pc = addr;
                done = true;
            }
            // Read and discard checksum byte
            fread_byte(fp);
        }
    }

    /**
     * Load file in Intel Hex format into memory. The memory address
     * to load into is stored in the file.
     * There are several Intel hex formats available. The most common format used
     * is the 'Intel MCS-86 Hex Object'. This format uses the following
     * structure.
     * 
     * First char.     Start character
     * Next two char.  Byte count
     * next four char. Address
     * next two char.  Record type
     * last two char.  checksum
     */
    public void load_intelhex(final String filename) throws FileNotFoundException,  IOException {
        FileInputStream fp;
        fp = new FileInputStream(filename);
        load_intelhex(fp);
        fp.close();
    }

    /**
     * Load file in Intel Hex format into memory.
     */
    public void load_intelhex(InputStream fp) throws FileNotFoundException, IOException {
        boolean done = false;

        while (!done) {
            int n, t;
            int addr;
            int b;

            fgetc(fp);
            n = fread_byte(fp);
            addr = fread_word(fp);
            t = fread_byte(fp);
            if (t == 0x00) {
                while (n > 0) {
                    b = fread_byte(fp);
                    memory[addr++] = b;
                    n--;
                }
            } else if (t == 0x01) {
                pc = addr;
                done = true;
            }
            // Read and discard checksum byte
            fread_byte(fp);
            // Ignore newline.
            if (fgetc(fp) == (int)'\r') fgetc(fp);
        }
    }

}
