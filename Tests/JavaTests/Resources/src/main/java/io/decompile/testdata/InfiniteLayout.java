package io.decompile.testdata;

public class InfiniteLayout {

    public class InnerClass {
        protected int innerField1 = 0;

        public void innerMethod(int param1) {
            int localVariable1 = param1;
        }

        public class InnerInnerClass {}
    }

    public static class StaticInnerClass {
        protected int innerField1 = 0;
    }
}
