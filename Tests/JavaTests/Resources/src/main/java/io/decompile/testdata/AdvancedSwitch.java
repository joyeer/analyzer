package io.decompile.testdata;

public class AdvancedSwitch {

    enum TestEnum {
        A, B, C;
    }

    public void switchEnum(TestEnum te) {
        System.out.println("start");

        switch (te) {
            case A:
                System.out.println("A");
            case B:
                System.out.println("B");
                break;
            case C:
                System.out.println("C");
                break;
            default:
                System.out.println("default");
        }

        System.out.println("end");
    }

    public void switchEnumBis(TestEnum te) {
        System.out.println("start");

        switch (te) {
            case A:
            case B:
                System.out.println("A or B");
                break;
            case C:
                System.out.println("C");
                break;
            default:
                System.out.println("default");
        }

        System.out.println("end");
    }

    public void switchString(String str) {
        System.out.println("start");

        switch (str) {
            case "One":
                System.out.println(1);
                break;
            case "POe":
                System.out.println("same hashcode than 'One'");
                break;
            case "Two":
                System.out.println(2);
                break;
            default:
                System.out.println("?");
                break;
        }

        System.out.println("end");
    }

    public void switchStringBis(String str) {
        System.out.println("start");

        switch (str) {
            case "One":
            case "POe":
                System.out.println("'One' or 'POe'");
                break;
            case "Two":
                System.out.println(2);
                break;
            default:
                System.out.println("?");
                break;
        }

        System.out.println("end");
    }
}
