package org.roug.osnine;

/**
 * Condiction codes register.
 */
public class CC {
   
    int all;    // Condition code register
    /*
    union {
        struct {
            Byte        e : 1;  //!< Entire
            Byte        f : 1;  //!< FIRQ disable
            Byte        h : 1;  //!< Half carry
            Byte        i : 1;  //!< IRQ disable
            Byte        n : 1;  //!< Negative
            Byte        z : 1;  //!< Zero
            Byte        v : 1;  //!< Overflow
            Byte        c : 1;  //!< Carry

        } bit;
    } cc;
    */

    int getAll() {
        return all;
    }

    void setAll(int newValue) {
        all = newValue;
    }

    void clearAll() {
        all = 0;
    }

    //!< Entire
    int get_bit_e() {
        return all & 1;
    }

    void set_bit_e(int newValue) {
        all |= newValue;
    }

    int get_bit_f() {
        return all & (1 << 1);
    }

    void set_bit_f(int newValue) {
        all |= (newValue << 1);
    }
}

