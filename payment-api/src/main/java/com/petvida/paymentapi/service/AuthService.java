package com.petvida.paymentapi.service;

import com.petvida.paymentapi.model.Usuario;
import com.petvida.paymentapi.model.StatusUsuario;
import com.petvida.paymentapi.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;

@Service
public class AuthService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private EmailService emailService;

    private BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    private Random random = new Random();

    public Usuario registrarUsuario(Usuario usuario) {
        // Verificar se email já existe
        if (usuarioRepository.findByEmail(usuario.getEmail()).isPresent()) {
            throw new RuntimeException("Email já está em uso");
        }

        // Verificar se CPF já existe
        if (usuarioRepository.findByCpf(usuario.getCpf()).isPresent()) {
            throw new RuntimeException("CPF já está em uso");
        }

        // Criptografar senha
        usuario.setSenha(passwordEncoder.encode(usuario.getSenha()));

        // Gerar código de verificação
        String codigoVerificacao = String.format("%06d", random.nextInt(999999));
        usuario.setCodigoVerificacao(codigoVerificacao);
        usuario.setStatus(StatusUsuario.AGUARDANDO_VERIFICACAO);
        usuario.setCriadoEm(LocalDateTime.now());

        Usuario usuarioSalvo = usuarioRepository.save(usuario);

        // Enviar email de verificação
        try {
            emailService.enviarEmailVerificacao(usuario.getEmail(), codigoVerificacao);
        } catch (Exception e) {
            System.err.println("❌ Erro ao enviar email. Código para " + usuario.getEmail() + ": " + codigoVerificacao);
            System.err.println("Erro: " + e.getMessage());
        }

        return usuarioSalvo;
    }

    public void verificarEmail(String email, String codigo) {
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        if (!codigo.equals(usuario.getCodigoVerificacao())) {
            throw new RuntimeException("Código de verificação inválido");
        }

        usuario.setStatus(StatusUsuario.ATIVO);
        usuario.setVerificadoEm(LocalDateTime.now());
        usuario.setCodigoVerificacao(null);

        usuarioRepository.save(usuario);

        // Enviar email de boas-vindas
        try {
            emailService.enviarEmailBoasVindas(usuario.getEmail(), usuario.getNome());
        } catch (Exception e) {
            System.err.println("❌ Erro ao enviar email de boas-vindas: " + e.getMessage());
        }
    }

    public void reenviarCodigoVerificacao(String email) {
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        // Verificar se o usuário já está verificado
        if (StatusUsuario.ATIVO.equals(usuario.getStatus())) {
            throw new RuntimeException("Usuário já está verificado");
        }

        // Gerar novo código
        String novoCodigo = String.format("%06d", random.nextInt(999999));
        usuario.setCodigoVerificacao(novoCodigo);
        usuarioRepository.save(usuario);

        // Enviar email com novo código
        try {
            emailService.enviarEmailReenvioCodigo(email, novoCodigo);
        } catch (Exception e) {
            System.err.println("❌ Erro ao reenviar email. Novo código para " + email + ": " + novoCodigo);
            System.err.println("Erro: " + e.getMessage());
            throw new RuntimeException("Erro ao enviar email: " + e.getMessage());
        }
    }

    public void solicitarRecuperacaoSenha(String email) {
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        // Gerar código de recuperação
        String codigoRecuperacao = String.format("%06d", random.nextInt(999999));
        usuario.setCodigoRecuperacaoSenha(codigoRecuperacao);
        usuario.setCodigoRecuperacaoExpiraEm(LocalDateTime.now().plusMinutes(15));
        usuario.setUltimaTentativaRecuperacao(LocalDateTime.now());

        usuarioRepository.save(usuario);

        // Enviar email com código de recuperação
        try {
            emailService.enviarEmailRecuperacaoSenha(email, codigoRecuperacao);
        } catch (Exception e) {
            System.err.println("❌ Erro ao enviar email de recuperação. Código para " + email + ": " + codigoRecuperacao);
            System.err.println("Erro: " + e.getMessage());
        }
    }

    public void redefinirSenha(String email, String codigo, String novaSenha) {
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        // Verificar código e expiração
        if (!codigo.equals(usuario.getCodigoRecuperacaoSenha())) {
            throw new RuntimeException("Código de recuperação inválido");
        }

        if (usuario.getCodigoRecuperacaoExpiraEm().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("Código de recuperação expirado");
        }

        // Atualizar senha
        usuario.setSenha(passwordEncoder.encode(novaSenha));
        usuario.setCodigoRecuperacaoSenha(null);
        usuario.setCodigoRecuperacaoExpiraEm(null);

        usuarioRepository.save(usuario);

        // Enviar email de confirmação
        try {
            emailService.enviarEmailConfirmacaoSenha(email);
        } catch (Exception e) {
            System.err.println("❌ Erro ao enviar email de confirmação: " + e.getMessage());
        }
    }

    public Optional<Usuario> buscarPorEmail(String email) {
        return usuarioRepository.findByEmail(email);
    }
}