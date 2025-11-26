package com.petvida.paymentapi.service;

import com.petvida.paymentapi.model.Agendamento;
import com.petvida.paymentapi.repository.AgendamentoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class AgendamentoService {

    @Autowired
    private AgendamentoRepository agendamentoRepository;

    public Agendamento agendar(Agendamento agendamento) {
        System.out.println("Agendando: " + agendamento.getTipo() + " para pet: " + agendamento.getNomePet());

        agendamento.setCriadoEm(LocalDateTime.now());
        agendamento.setStatus("AGENDADO");

        return agendamentoRepository.save(agendamento);
    }

    public List<Agendamento> listarPorUsuario(Long usuarioId) {
        return agendamentoRepository.findByUsuarioId(usuarioId);
    }

    public List<Agendamento> listarPorUsuarioETipo(Long usuarioId, String tipo) {
        return agendamentoRepository.findByUsuarioIdAndTipo(usuarioId, tipo);
    }

    public List<Agendamento> listarPorTipo(String tipo) {
        return agendamentoRepository.findByTipo(tipo);
    }

    public Optional<Agendamento> buscarPorId(Long id) {
        return agendamentoRepository.findById(id);
    }

    public void finalizarConsulta(Long agendamentoId, String diagnostico, String prescricao) {
        Optional<Agendamento> agendamentoOpt = agendamentoRepository.findById(agendamentoId);

        if (agendamentoOpt.isPresent()) {
            Agendamento agendamento = agendamentoOpt.get();
            agendamento.setDiagnostico(diagnostico);
            agendamento.setPrescricao(prescricao);
            agendamento.setDataRealizacao(LocalDateTime.now());
            agendamento.setStatus("REALIZADO");

            agendamentoRepository.save(agendamento);
            System.out.println("Consulta finalizada com sucesso: " + agendamentoId);
        } else {
            throw new RuntimeException("Agendamento não encontrado: " + agendamentoId);
        }
    }

    public List<Agendamento> listarHistoricoPorPet(Long usuarioId, String nomePet) {
        return agendamentoRepository.findByUsuarioIdAndNomePet(usuarioId, nomePet);
    }
}