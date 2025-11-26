package br.com.clinica.util;

import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailService {

    public static void enviarEmailVerificacao(String destinatario, String token, String urlBase) throws Exception {
        System.out.println("Iniciando o envio de e-mail de verificação para: " + destinatario);
        final String remetente = "assistenciaclinicaananda@gmail.com";
        final String senhaApp = "arklmqlhiwwsnikm";
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        Authenticator auth = new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(remetente, senhaApp);
            }
        };
        Session session = Session.getInstance(props, auth);
        MimeMessage mensagem = new MimeMessage(session);
        mensagem.setFrom(new InternetAddress(remetente));
        mensagem.addRecipient(Message.RecipientType.TO, new InternetAddress(destinatario));
        mensagem.setSubject("Clínica Veterinária - Ative a sua Conta");
        String linkVerificacao = urlBase + "/verificar?token=" + token;
        String corpoEmail = "<h1>Bem-vindo à Clínica Veterinária!</h1>"
                + "<p>Obrigado por se cadastrar. Por favor, clique no link abaixo para ativar a sua conta:</p>"
                + "<a href='" + linkVerificacao + "' style='padding: 10px 20px; background-color: #002F4B; color: white; text-decoration: none; border-radius: 5px;'>Ativar Minha Conta</a>";
        mensagem.setContent(corpoEmail, "text/html; charset=utf-8");
        Transport.send(mensagem);
        System.out.println("E-mail de verificação enviado com sucesso!");
    }

    public static void enviarEmailRecuperacao(String destinatario, String token, String urlBase) throws Exception {
        System.out.println("Iniciando o envio de e-mail de recuperação para: " + destinatario);
        final String remetente = "assistenciaclinicaananda@gmail.com";
        final String senhaApp = "arklmqlhiwwsnikm";
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        Authenticator auth = new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(remetente, senhaApp);
            }
        };
        Session session = Session.getInstance(props, auth);
        MimeMessage mensagem = new MimeMessage(session);
        mensagem.setFrom(new InternetAddress(remetente));
        mensagem.addRecipient(Message.RecipientType.TO, new InternetAddress(destinatario));
        mensagem.setSubject("Clínica Veterinária - Redefinição de Senha");
        String linkRedefinicao = urlBase + "/redefinirSenha.jsp?token=" + token;
        String corpoEmail = "<h1>Redefinição de Senha</h1>"
                + "<p>Recebemos um pedido para redefinir a sua senha. Por favor, clique no link abaixo para criar uma nova senha:</p>"
                + "<a href='" + linkRedefinicao + "' style='padding: 10px 20px; background-color: #002F4B; color: white; text-decoration: none; border-radius: 5px;'>Redefinir Minha Senha</a>"
                + "<p>Este link irá expirar em 1 hora.</p>";
        mensagem.setContent(corpoEmail, "text/html; charset=utf-8");
        Transport.send(mensagem);
        System.out.println("E-mail de recuperação enviado com sucesso!");
    }
}

