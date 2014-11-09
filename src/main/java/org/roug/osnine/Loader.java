package org.roug.osnine;

import java.io.FileInputStream;
import java.io.InputStream;
import java.io.IOException;

/**
 * Load data into memory from files.
*/
public final class Loader {

    private Loader() {
    }

    //----------------------------------------------------------------------------
    // Processor loading routines
    //----------------------------------------------------------------------------
    static int fread_byte(InputStream fp) throws IOException {
        byte str[] = new byte[2];
        int bytesRead;

        bytesRead = fp.read(str);
        String hexStr = new String(str);
        //System.out.println("HEX:" + hexStr);
        return Integer.valueOf(hexStr, 16).intValue();
    }

    static int fread_word(InputStream fp) throws IOException {
        int ret;

        ret = fread_byte(fp);
        ret <<= 8;
        ret |= fread_byte(fp);

        return ret;
    }

    private static int fgetc(InputStream fp) throws IOException {

        return fp.read();
    }

    private static boolean feof(InputStream fp) throws IOException {
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
    public static void load_srecord(final String filename, USim cpu) throws IOException {
        FileInputStream fp;
        fp = new FileInputStream(filename);
        load_srecord(fp, cpu);
        fp.close();
    }

    /**
     * Load file in Motorola S-record format into memory.
     */
    public static void load_srecord(InputStream fp, USim cpu) throws IOException {
        boolean done = false;

        while (!done) {
            int n, t;
            int addr;
            int b;

            while (fgetc(fp) != (int) 'S' && !feof(fp)) // Look for the S
                  ;
            if (feof(fp)) {
                return;
            }
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
                    cpu.write(addr, b);
                    addr++;
                }

            } else if (t == '9') {
                cpu.pc = addr;
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
    public static void load_intelhex(final String filename, USim cpu) throws IOException {
        FileInputStream fp;
        fp = new FileInputStream(filename);
        load_intelhex(fp, cpu);
        fp.close();
    }

    /**
     * Load file in Intel Hex format into memory.
     */
    public static void load_intelhex(InputStream fp, USim cpu) throws IOException {
        boolean done = false;

        while (!done) {
            int n, t;
            int addr;
            int b;

            fgetc(fp); // Skip the colon
            n = fread_byte(fp);
            addr = fread_word(fp);
            t = fread_byte(fp);
            if (t == 0x00) {
                while (n > 0) {
                    b = fread_byte(fp);
                    cpu.write(addr, b);
                    addr++;
                    n--;
                }
            } else if (t == 0x01) {
                cpu.pc = addr;
                done = true;
            }
            // Read and discard checksum byte
            fread_byte(fp);
            // Ignore newline.
            if (fgetc(fp) == (int) '\r') {
                fgetc(fp);
            }
        }
    }
}
