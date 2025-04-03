
package io.decompile.testdata.annotation;

public @interface Quality {
    enum Level { LOW, MIDDLE, HIGH }

    Level value();
}
