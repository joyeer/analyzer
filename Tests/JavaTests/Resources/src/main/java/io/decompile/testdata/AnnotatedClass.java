package io.decompile.testdata;


import io.decompile.testdata.annotation.Author;
import io.decompile.testdata.annotation.Name;
import io.decompile.testdata.annotation.Quality;
import io.decompile.testdata.annotation.Value;

import java.io.Serializable;
import java.io.Writer;
import java.net.UnknownHostException;
import java.util.ArrayList;

@Quality(Quality.Level.HIGH)
@Author(value=@Name(salutation="Mr", value="Donald", last="Duck"), contributors={@Name("Huey"), @Name("Dewey"), @Name("Louie")})
public class AnnotatedClass extends ArrayList implements Serializable, Cloneable {
    @Value(z = true)
    protected boolean z1;

    @Value(b = -15)
    protected byte b1;

    @Value(s = -15)
    protected short s1;

    @Value(i = 1)
    protected int i1 = 1;

    @Value(l = 1234567890123456789L)
    protected long l1;

    @Value(f = 123.456F)
    protected float f1;

    @Value(d = 789.101112D)
    protected double d1;

    @Value(str = "str")
    protected String str1;

    @Value(str = "str \u0083 \u0909 \u1109") // "str � ? ?"
    protected String str2;

    @Value(clazz = String.class)
    protected Class clazz;

    public int add(int i1, int i2) {
        return i1 + i2;
    }

    public void ping(@Deprecated Writer writer, @Deprecated @Value(str="localhost") @SuppressWarnings("all") String host, long timeout) throws UnknownHostException, UnsatisfiedLinkError {
        // ...
    }

    public static class SimpleInnerClass {
        protected int i;
    }
}
