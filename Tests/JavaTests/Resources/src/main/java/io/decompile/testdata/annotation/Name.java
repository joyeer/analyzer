
package io.decompile.testdata.annotation;

public @interface Name {
    String salutation() default ""; // Salutation
    String value();                 // First name
    String last() default "";       // Last name
}
