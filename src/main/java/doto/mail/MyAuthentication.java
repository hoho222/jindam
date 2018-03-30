package doto.mail;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class MyAuthentication extends Authenticator {
    PasswordAuthentication pa;
    public MyAuthentication(){
        pa = new PasswordAuthentication("master@doit2gether.tk", "rudghdnjs1220");
    }

    public PasswordAuthentication getPasswordAuthentication() {
        return pa;
    }
}
