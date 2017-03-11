import java.io.FileInputStream;
import java.util.Arrays;

public class OS9Tool {

    private static void usage(String msg) {
        System.err.println("Error: " + msg);
        System.err.println("Usage: OS9Tool ident ...");
        System.exit(2);
    }

    public static void main(String[] args) throws Exception {
        if (args.length == 0) {
            usage("No subcommand argument");
        }
        String subCommand = args[0];
        String[] extraArgs = Arrays.copyOfRange(args, 1, args.length);

        if ("ident".equals(subCommand)) {
            Ident.main(extraArgs);
        } else if ("diskinfo".equals(subCommand)) {
            DiskInfo.main(extraArgs);
        } else {
            usage("Unknown subcommand: " + subCommand);
        }

    }
}
