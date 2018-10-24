package org.roug.osnine.rbf;

public class DirEntry {

    private String name;
    private int lsn;

    final static int NAMELEN = 29;

    public String toString() {
        return name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getLSN() {
        return lsn;
    }

    public void setLSN(int lsn) {
        this.lsn = lsn;
    }

    public boolean isDeleted() {
        return name.length() == 0;
    }
}

