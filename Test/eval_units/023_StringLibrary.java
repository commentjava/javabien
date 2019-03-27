//: true
//: true

//: true
//: true
//: true
//: true

//: true
//: true
//: true

//: true
//: true

//: true

//: true
//: true

//: true
//: false
//: false
//: true
//: false

//: true
//: true

//: true
//: false
//: true
//: true
//: true
//: false
//: true

//: true
//: true
//: false

class Main {
        static void main(String[] args) {
                String a = "coucou";
                Debug.debug(a.indexOf('u') == 2);
                Debug.debug(a.indexOf('r') == -1);

                Debug.debug("toi".length() == 3);
                Debug.debug("elle".length() == 4);
                Debug.debug("e".length() == 1);
                Debug.debug("".length() == 0);

                Debug.debug("moi".toCharArray()[0] == 'm');
                Debug.debug("moi".toCharArray()[1] == 'o');
                Debug.debug("moi".toCharArray()[2] == 'i');

                Debug.debug(String.concat("cou", "cou").length() == 6);
                Debug.debug(String.concat("cou", "cou").toCharArray()[3] == 'c');

                Debug.debug(String.fromInteger(5).toCharArray()[0] == '5');

                Debug.debug("them".charAt(0) == 't');
                Debug.debug("them".charAt(1) == 'h');

                Debug.debug("them".equals("them"));
                Debug.debug("them".equals("they"));
                Debug.debug("them".equals(""));
                Debug.debug("".equals(""));
                Debug.debug("".equals("his"));

                Debug.debug("".compareTo("") == 0);
                Debug.debug("lui".compareTo("elle") == 7);

                Debug.debug("lui".startsWith("l", 0));
                Debug.debug("lui".startsWith("r", 0));
                Debug.debug("lui".startsWith("", 0));
                Debug.debug("".startsWith("", 0));
                Debug.debug("chezmireille".startsWith("irei", 5));
                Debug.debug("chezmireille".startsWith("rei", 5));
                Debug.debug("chezmireille".startsWith("chezmireille", 0));

                Debug.debug("chezmireille".endsWith("lle"));
                Debug.debug("chezmireille".endsWith(""));
                Debug.debug("chezmirei".endsWith("lle"));

        }
}
