package io.decompile.testdata;

import java.io.Serializable;
import java.math.BigDecimal;

public class Assert implements Serializable {

    public static void test1(int i)
    {
        System.out.println("a");
        assert true : "true";
        assert false : "false";
        assert (i == 0) || (i == 1);
        assert (i == 2) && (i < 3);
        System.out.println("b");
    }

    public static void test2(int i)
    {
        System.out.println("a");
        assert i == 0 :
                "boom";
        System.out.println("b");
    }


    public static void test3(int i)
    {
        System.out.println("a");
        assert new BigDecimal(i) == BigDecimal.ONE;
        System.out.println("b");
    }

    public static void test4()
    {
        System.out.println("a");
        assert check() : "boom";
        System.out.println("b");
    }

    protected static boolean check()
    {
        return true;
    }

    void testBug341(int i) {
        assert i > 0;
    }
}
