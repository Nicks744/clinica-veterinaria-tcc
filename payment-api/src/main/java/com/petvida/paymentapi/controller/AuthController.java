package com.petvida.paymentapi.controller;

import com.petvida.paymentapi.model.Usuario;
import com.petvida.paymentapi.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/registrar")
    public ResponseEntity<?> registrarUsuario(@RequestBody Usuario usuario) {
        try {
            System.out.println("Registrando usuário: " + usuario.getEmail());
            Usuario usuarioSalvo = authService.registrarUsuario(usuario);
            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "mensagem", "Usuário registrado com sucesso. Verifique seu email.", "usuarioId", usuarioSalvo.getId())
            );
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", e.getMessage())
            );
        }
    }

    @PostMapping("/verificar")
    public ResponseEntity<?> verificarEmail(@RequestBody Map<String, String> request) {
        try {
            String email = request.get("email");
            String codigo = request.get("codigo");

            authService.verificarEmail(email, codigo);
            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "mensagem", "Email verificado com sucesso")
            );
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", e.getMessage())
            );
        }
    }

    @PostMapping("/esqueci-senha")
    public ResponseEntity<?> solicitarRecuperacaoSenha(@RequestBody Map<String, String> request) {
        try {
            String email = request.get("email");
            System.out.println("Solicitando recuperação de senha para: " + email);

            authService.solicitarRecuperacaoSenha(email);
            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "mensagem", "Código de recuperação enviado para o email")
            );
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", e.getMessage())
            );
        }
    }

    @PostMapping("/redefinir-senha")
    public ResponseEntity<?> redefinirSenha(@RequestBody Map<String, String> request) {
        try {
            String email = request.get("email");
            String codigo = request.get("codigo");
            String novaSenha = request.get("novaSenha");

            authService.redefinirSenha(email, codigo, novaSenha);
            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "mensagem", "Senha redefinida com sucesso")
            );
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", e.getMessage())
            );
        }
    }

    // ✅ NOVO ENDPOINT: Reenviar código de verificação
    @PostMapping("/reenviar-codigo")
    public ResponseEntity<?> reenviarCodigoVerificacao(@RequestBody Map<String, String> request) {
        try {
            String email = request.get("email");

            if (email == null || email.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(
                        Map.of("sucesso", false, "mensagem", "Email é obrigatório")
                );
            }

            authService.reenviarCodigoVerificacao(email);

            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "mensagem", "Código de verificação reenviado com sucesso")
            );

        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", e.getMessage())
            );
        }
    }
}