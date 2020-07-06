package org.roug.ui.terminal;

public class EmulationRec {

    Class clazz;
    String name;
    String description;

    EmulationRec(Class c, String n, String d) {
        clazz = c;
        name = n;
        description = d;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }
}
