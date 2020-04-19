package org.roug.terminal;

public class EmulationList {

    Class clazz;
    String name;
    String description;

    EmulationList(Class c, String n, String d) {
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
