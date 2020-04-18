package org.roug.terminal;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;

//          Class newClass = Class.forName(guiClassStr);
//          Constructor<Runnable> constructor = newClass.getConstructor(Acia.class);
//          Runnable threadInstance = constructor.newInstance(this);

public class AvailableEmulations {

    private static EmulationList[] emulations = {
        new EmulationList(DumbEmulation.class, "teletype", "Teletype printer (80x66)"),
        new EmulationList(GO51Emulation.class, "go51",     "Coco/Dragon GO51 (51x24)"),
        new EmulationList(GO80Emulation.class, "go80",     "DragonPlus Board (80x24)"),
        new EmulationList(H19Emulation.class,  "h19",      "Heath H-19/Zenith Z-19"),
        new EmulationList(VDGEmulation.class,  "vdg",      "Coco/Dragon VDG (32x16)"),
        new EmulationList(TVI912Emulation.class,"tvi912",  "Televideo TVI 912 (80x24)")
    };

    public String list() throws Exception {
        return emulations[1].name;
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
