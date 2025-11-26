package com.petvida.paymentapi.controller;

import com.petvida.paymentapi.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/status")
@CrossOrigin(origins = "*")
public class StatusController {

    @Autowired
    private AuthService authService;

    @GetMapping("/usuario")
    public ResponseEntity<?> verificarStatusUsuario(@RequestParam String email) {
        try {
            // Usar método existente do AuthService
            var usuarioOpt = authService.buscarPorEmail(email);

            if (usuarioOpt.isPresent()) {
                return ResponseEntity.ok().body(
                        Map.of("sucesso", true, "status", usuarioOpt.get().getStatus())
                );
            } else {
                return ResponseEntity.badRequest().body(
                        Map.of("sucesso", false, "mensagem", "Usuário não encontrado")
                );
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", "Erro ao verificar status: " + e.getMessage())
            );
        }
    }
}