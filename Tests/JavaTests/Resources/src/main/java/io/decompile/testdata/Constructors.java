package io.decompile.testdata;

public class Constructors {

    public static class SuperType {
        protected short short56;
        protected int int78;

        public SuperType() {
            this.short56 = 1;
            this.int78 = 78;
        }

        public SuperType(short short56) {
            this.short56 = short56;
            this.int78 = 78;
        }
    }

    public static class Type extends SuperType {
        protected short short123;

        public Type() {
            this.short123 = 1;
        }

        public Type(short short56) {
            super(short56);
            this.short123 = 2;
        }

        public Type(short short56, int int78) {
            this(short56);
            this.int78 = int78;
            this.short123 = 3;
        }
    }
}
