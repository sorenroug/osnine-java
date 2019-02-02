package org.roug.osnine;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.assertFalse;
import org.junit.Test;

public class OptionParserTest {

    @Test
    public void plainArguments() throws IllegalArgumentException {
        String[] args = {"-f", "argument1", "-o", "argumentO"};
        OptionParser op = new OptionParser(args, "o:f:");
        String optionO = op.getOptionArgument("o");
        assertEquals("argumentO", optionO);
        assertNull(op.getOptionArgument("x"));
    }

    @Test
    public void plainArgumentWithSpace() throws IllegalArgumentException {
        String[] args = {"-f", "Hello  World", "-o", "argumentO"};
        OptionParser op = new OptionParser(args, "o:f:");
        String optionF = op.getOptionArgument("f");
        assertEquals("Hello  World", optionF);
    }

    @Test
    public void unusedArguments1() throws IllegalArgumentException {
        String[] args = {"-x", "file1", "file2"};
        OptionParser op = new OptionParser(args, "xyz");
        assertEquals("", op.getOptionArgument("x"));
        assertNull(op.getOptionArgument("y"));
        assertNull(op.getOptionArgument("z"));

        String[] unused = op.getUnusedArguments();
        assertEquals("file1", unused[0]);
        assertEquals("file2", unused[1]);
        assertEquals(2, unused.length);
    }

    @Test
    public void unusedArguments2() throws IllegalArgumentException {
        String[] args = {"-x", "--", "file1", "-y", "file2"};
        OptionParser op = new OptionParser(args, "xyz");
        assertEquals("", op.getOptionArgument("x"));
        assertNull(op.getOptionArgument("y"));
        assertNull(op.getOptionArgument("z"));

        String[] unused = op.getUnusedArguments();
        assertEquals("file1", unused[0]);
        assertEquals("-y", unused[1]);
        assertEquals("file2", unused[2]);
        assertEquals(3, unused.length);
    }

    @Test
    public void unsetPlainOption() throws IllegalArgumentException {
        String[] args = {"-f", "-o", "argumentO"};
        OptionParser op = new OptionParser(args, "o:fu");
        assertFalse(op.getOptionFlag("u"));
    }

    @Test(expected = IllegalArgumentException.class)
    public void unknownPlainOption() throws IllegalArgumentException {
        // "u" is not on the list of options.
        String[] args = {"-f", "-u", "-o", "argumentO"};
        OptionParser op = new OptionParser(args, "o:f");
    }

    @Test
    public void clusteredFlags() throws IllegalArgumentException {
        String[] args = {"-xa", "-f", "F"};
        OptionParser op = new OptionParser(args, "f:ax");
        assertTrue(op.getOptionFlag("a"));
        assertEquals("", op.getOptionArgument("x"));
        assertEquals("F", op.getOptionArgument("f"));
    }

    @Test(expected = IllegalArgumentException.class)
    public void clusteredOptionWithArgument() throws IllegalArgumentException {
        // "f" requires an argument so it is not allowed in the cluster
        String[] args = {"-xaf", "F", "Unused argument"};
        OptionParser op = new OptionParser(args, "f:ax");
    }

    @Test
    public void noArgumentsGiven() throws IllegalArgumentException {
        String[] args = {};
        OptionParser op = new OptionParser(args, "f:ax");
        String[] unused = op.getUnusedArguments();
        assertEquals("No unused arguments", 0, unused.length);
    }

    /**
     * The OptionParser only looks at the first letter in the getOptionArgument value.
     * I.e. if you query "file", then option "f" is looked up.
     * The user should not do this on production systems.
     */
    @Test
    public void getLongOption() throws IllegalArgumentException {
        String[] args = {"-f", "argument1", "-o", "argumentO"};
        OptionParser op = new OptionParser(args, "o:f:");
        String optionO = op.getOptionArgument("file");
        assertEquals("argument1", optionO);
    }

    @Test
    public void getOptionByChar() throws IllegalArgumentException {
        String[] args = {"-f", "-o", "argumentO"};
        OptionParser op = new OptionParser(args, "o:f");
        String optionO = op.getOptionArgument('o');
        assertEquals("argumentO", optionO);
        assertTrue(op.getOptionFlag('f'));
    }
}
