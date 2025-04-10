
package io.decompile.testdata.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.FIELD, ElementType.METHOD, ElementType.PARAMETER})
public @interface Value {
    boolean z()     default true;
    byte    b()     default 1;
    short   s()     default 1;
    int     i()     default 1;
    long    l()     default 1L;
    float   f()     default 1.0F;
    double  d()     default 1.0D;
    String  str()   default "str";
    Class   clazz() default Object.class;
}
