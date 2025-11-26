package com.petvida.paymentapi.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    public void enviarEmailVerificacao(String para, String codigo) {
        try {
            SimpleMailMessage mensagem = new SimpleMailMessage();
            mensagem.setTo(para);
            mensagem.setSubject("PetVida - Verificação de Email");
            mensagem.setText(
                    "Olá!\n\n" +
                            "Seu código de verificação é: " + codigo + "\n\n" +
                            "Use este código para ativar sua conta no PetVida.\n\n" +
                            "Atenciosamente,\nEquipe PetVida"
            );

            mailSender.send(mensagem);
            System.out.println("✅ Email de verificação enviado para: " + para);
        } catch (Exception e) {
            System.err.println("❌ Erro ao enviar email de verificação para " + para + ": " + e.getMessage());
            throw new RuntimeException("Falha ao enviar email de verificação: " + e.getMessage());
        }
    }

    public void enviarEmailRecuperacaoSenha(String para, String codigo) {
        try {
            SimpleMailMessage mensagem = new SimpleMailMessage();
            mensagem.setTo(para);
            mensagem.setSubject("PetVida - Recuperação de Senha");
            mensagem.setText(
                    "Olá!\n\n" +
                            "Seu código de recuperação de senha é: " + codigo + "\n\n" +
                            "Este código expira em 15 minutos.\n\n" +
                            "Se você não solicitou esta recuperação, ignore este email.\n\n" +
                            "Atenciosamente,\nEquipe PetVida"
            );

            mailSender.send(mensagem);
            System.out.println("✅ Email de recuperação enviado para: " + para);
        } catch (Exception e) {
            System.err.println("❌ Erro ao enviar email de recuperação para " + para + ": " + e.getMessage());
            throw new RuntimeException("Falha ao enviar email de recuperação: " + e.getMessage());
        }
    }

    public void enviarEmailBoasVindas(String para, String nome) {
        try {
            SimpleMailMessage mensagem = new SimpleMailMessage();
            mensagem.setTo(para);
            mensagem.setSubject("PetVida - Bem-vindo!");
            mensagem.setText(
                    "Olá " + nome + "!\n\n" +
                            "Sua conta foi ativada com sucesso. Bem-vindo ao PetVida!\n\n" +
                            "Agora você pode:\n" +
                            "• Agendar consultas para seu pet\n" +
                            "• Gerenciar vacinações\n" +
                            "• Acompanhar o histórico médico\n" +
                            "• E muito mais!\n\n" +
                            "Atenciosamente,\nEquipe PetVida"
            );

            mailSender.send(mensagem);
            System.out.println("✅ Email de boas-vindas enviado para: " + para);
        } catch (Exception e) {
            System.err.println("❌ Erro ao enviar email de boas-vindas para " + para + ": " + e.getMessage());
            throw new RuntimeException("Falha ao enviar email de boas-vindas: " + e.getMessage());
        }
    }

    public void enviarEmailConfirmacaoSenha(String para) {
        try {
            SimpleMailMessage mensagem = new SimpleMailMessage();
            mensagem.setTo(para);
            mensagem.setSubject("PetVida - Senha Alterada");
            mensagem.setText(
                    "Olá!\n\n" +
                            "Sua senha foi alterada com sucesso.\n\n" +
                            "Se você não realizou esta alteração, entre em contato conosco imediatamente.\n\n" +
                            "Atenciosamente,\nEquipe PetVida"
            );

            mailSender.send(mensagem);
            System.out.println("✅ Email de confirmação de senha enviado para: " + para);
        } catch (Exception e) {
            System.err.println("❌ Erro ao enviar email de confirmação para " + para + ": " + e.getMessage());
            throw new RuntimeException("Falha ao enviar email de confirmação: " + e.getMessage());
        }
    }

    // ✅ MÉTODO ADICIONAL: Email de reenvio de código
    public void enviarEmailReenvioCodigo(String para, String codigo) {
        try {
            SimpleMailMessage mensagem = new SimpleMailMessage();
            mensagem.setTo(para);
            mensagem.setSubject("PetVida - Novo Código de Verificação");
            mensagem.setText(
                    "Olá!\n\n" +
                            "Seu novo código de verificação é: " + codigo + "\n\n" +
                            "Use este código para ativar sua conta no PetVida.\n\n" +
                            "Atenciosamente,\nEquipe PetVida"
            );

            mailSender.send(mensagem);
            System.out.println("✅ Email de reenvio de código enviado para: " + para);
        } catch (Exception e) {
            System.err.println("❌ Erro ao enviar email de reenvio para " + para + ": " + e.getMessage());
            throw new RuntimeException("Falha ao enviar email de reenvio: " + e.getMessage());
        }
    }

    // ✅ MÉTODO ADICIONAL: Email genérico para notificações
    public void enviarEmailNotificacao(String para, String assunto, String mensagemTexto) {
        try {
            SimpleMailMessage mensagem = new SimpleMailMessage();
            mensagem.setTo(para);
            mensagem.setSubject("PetVida - " + assunto);
            mensagem.setText(mensagemTexto + "\n\nAtenciosamente,\nEquipe PetVida");

            mailSender.send(mensagem);
            System.out.println("✅ Email de notificação enviado para: " + para);
        } catch (Exception e) {
            System.err.println("❌ Erro ao enviar email de notificação para " + para + ": " + e.getMessage());
            throw new RuntimeException("Falha ao enviar email de notificação: " + e.getMessage());
        }
    }
}