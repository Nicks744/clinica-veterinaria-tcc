package com.petvida.paymentapi.service;

import com.petvida.paymentapi.model.Usuario;
import com.petvida.paymentapi.repository.UsuarioRepository;
import com.petvida.paymentapi.repository.AgendamentoRepository;
import com.petvida.paymentapi.repository.PagamentoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private AgendamentoRepository agendamentoRepository;

    @Autowired
    private PagamentoRepository pagamentoRepository;

    // ✅ MÉTODO: Deletar usuário
    @Transactional
    public void deletarUsuario(Long id) {
        // Verificar se o usuário existe
        Usuario usuario = usuarioRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado com ID: " + id));

        System.out.println("Deletando usuário: " + usuario.getEmail() + " (ID: " + id + ")");

        // Primeiro deletar agendamentos relacionados
        try {
            agendamentoRepository.deleteByUsuarioId(id);
            System.out.println("Agendamentos deletados para usuário ID: " + id);
        } catch (Exception e) {
            System.out.println("Nenhum agendamento para deletar ou erro: " + e.getMessage());
        }

        // Depois deletar pagamentos relacionados
        try {
            pagamentoRepository.deleteByUsuarioId(id);
            System.out.println("Pagamentos deletados para usuário ID: " + id);
        } catch (Exception e) {
            System.out.println("Nenhum pagamento para deletar ou erro: " + e.getMessage());
        }

        // Finalmente deletar o usuário
        usuarioRepository.delete(usuario);
        System.out.println("Usuário deletado com sucesso: " + id);
    }

    // Métodos auxiliares
    public Optional<Usuario> buscarPorId(Long id) {
        return usuarioRepository.findById(id);
    }

    public List<Usuario> listarTodos() {
        return usuarioRepository.findAll();
    }

    public Optional<Usuario> buscarPorEmail(String email) {
        return usuarioRepository.findByEmail(email);
    }
}