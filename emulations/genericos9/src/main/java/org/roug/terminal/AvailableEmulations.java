package org.roug.terminal;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;

//          Class newClass = Class.forName(guiClassStr);
//          Constructor<Runnable> constructor = newClass.getConstructor(Acia.class);
//          Runnable threadInstance = constructor.newInstance(this);

public class AvailableEmulations {

    private static EmulationRec[] emulations = {
        new EmulationRec(DumbEmulation.class, "teletype", "Teletype printer (80x66)"),
        new EmulationRec(GO51Emulation.class, "go51",     "Coco/Dragon GO51 (51x24)"),
        new EmulationRec(GO80Emulation.class, "go80",     "DragonPlus Board (80x24)"),
        new EmulationRec(H19Emulation.class,  "h19",      "Heath H-19/Zenith Z-19"),
        new EmulationRec(VDGEmulation.class,  "vdg",      "Coco/Dragon VDG (32x16)"),
        new EmulationRec(TVI912Emulation.class,"tvi912",  "Televideo TVI 912 (80x24)")
    };

    public static EmulationRec[] getAvailable() {
        return emulations;
    }

    public static EmulationCore createEmulation(String token)
            throws Exception {
        EmulationCore te = null;
        for (int i = 0; i < emulations.length; i++) {
            String n = emulations[i].name;
            if (token.equals(n)) {
                Constructor<EmulationCore> constructor = emulations[i].clazz.getConstructor();
                te = constructor.newInstance();
            }
        }
        return te;
    }
}
