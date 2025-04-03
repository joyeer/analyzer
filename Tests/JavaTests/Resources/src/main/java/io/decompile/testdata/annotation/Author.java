

package io.decompile.testdata.annotation;

public @interface Author {
    Name value();
    Name[] contributors() default {};
}
