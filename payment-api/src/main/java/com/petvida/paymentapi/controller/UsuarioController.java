package com.petvida.paymentapi.controller;

import com.petvida.paymentapi.model.Usuario;
import com.petvida.paymentapi.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/usuarios")
@CrossOrigin(origins = "*")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;

    @GetMapping("/perfil/{id}")
    public ResponseEntity<?> buscarPerfil(@PathVariable Long id) {
        try {
            Optional<Usuario> usuario = usuarioService.buscarPorId(id);
            if (usuario.isPresent()) {
                return ResponseEntity.ok().body(
                        Map.of("sucesso", true, "usuario", usuario.get())
                );
            } else {
                return ResponseEntity.badRequest().body(
                        Map.of("sucesso", false, "mensagem", "Usuário não encontrado")
                );
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", "Erro ao buscar usuário: " + e.getMessage())
            );
        }
    }

    // ✅ NOVO ENDPOINT: Deletar usuário
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deletarUsuario(@PathVariable Long id) {
        try {
            usuarioService.deletarUsuario(id);
            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "mensagem", "Usuário deletado com sucesso")
            );
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", e.getMessage())
            );
        }
    }

    // ✅ NOVO ENDPOINT: Listar todos usuários (para debug)
    @GetMapping("/todos")
    public ResponseEntity<?> listarTodosUsuarios() {
        try {
            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "usuarios", usuarioService.listarTodos())
            );
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", "Erro ao listar usuários: " + e.getMessage())
            );
        }
    }
}