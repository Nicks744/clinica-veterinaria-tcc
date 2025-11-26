package com.petvida.paymentapi.controller;

import com.petvida.paymentapi.model.Agendamento;
import com.petvida.paymentapi.service.AgendamentoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/api/agendamentos")
@CrossOrigin(origins = "*")
public class AgendamentoController {

    @Autowired
    private AgendamentoService agendamentoService;

    @PostMapping("/agendar")
    public ResponseEntity<?> agendar(@RequestBody Map<String, Object> request) {
        try {
            System.out.println("Recebendo agendamento do tipo: " + request.get("tipo"));

            Agendamento agendamento = new Agendamento();
            agendamento.setUsuarioId(Long.valueOf(request.get("usuarioId").toString()));
            agendamento.setNomePet(request.get("nomePet").toString());
            agendamento.setTipo(request.get("tipo").toString());
            agendamento.setObservacoes(request.get("observacoes") != null ? request.get("observacoes").toString() : "");

            System.out.println("Agendando: " + agendamento.getTipo() + " para pet: " + agendamento.getNomePet());

            Agendamento agendamentoSalvo = agendamentoService.agendar(agendamento);

            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "mensagem", "Agendamento realizado com sucesso", "agendamento", agendamentoSalvo)
            );
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", "Erro ao agendar: " + e.getMessage())
            );
        }
    }

    @PostMapping("/finalizar-consulta")
    public ResponseEntity<?> finalizarConsulta(@RequestBody Map<String, String> request) {
        try {
            Long agendamentoId = Long.valueOf(request.get("agendamentoId"));
            String diagnostico = request.get("diagnostico");
            String prescricao = request.get("prescricao");

            System.out.println("Finalizando consulta ID: " + agendamentoId);

            agendamentoService.finalizarConsulta(agendamentoId, diagnostico, prescricao);

            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "mensagem", "Consulta finalizada com sucesso")
            );
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", "Erro ao finalizar consulta: " + e.getMessage())
            );
        }
    }

    @PutMapping("/{id}/cancelar")
    public ResponseEntity<?> cancelarAgendamento(@PathVariable Long id) {
        try {
            // Buscar agendamento
            Agendamento agendamento = agendamentoService.buscarPorId(id)
                    .orElseThrow(() -> new RuntimeException("Agendamento não encontrado"));

            // Atualizar status
            agendamento.setStatus("CANCELADO");
            agendamentoService.agendar(agendamento); // Reutilizar método save

            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "mensagem", "Agendamento cancelado com sucesso")
            );
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", "Erro ao cancelar agendamento: " + e.getMessage())
            );
        }
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<?> listarPorUsuario(@PathVariable Long usuarioId) {
        try {
            List<Agendamento> agendamentos = agendamentoService.listarPorUsuario(usuarioId);
            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "agendamentos", agendamentos)
            );
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", "Erro ao listar agendamentos: " + e.getMessage())
            );
        }
    }

    @GetMapping("/usuario/{usuarioId}/tipo/{tipo}")
    public ResponseEntity<?> listarPorTipo(@PathVariable Long usuarioId, @PathVariable String tipo) {
        try {
            List<Agendamento> agendamentos = agendamentoService.listarPorUsuarioETipo(usuarioId, tipo);
            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "agendamentos", agendamentos)
            );
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", "Erro ao listar agendamentos: " + e.getMessage())
            );
        }
    }

    @GetMapping("/usuario/{usuarioId}/historico-medico")
    public ResponseEntity<?> historicoMedico(@PathVariable Long usuarioId) {
        try {
            List<Agendamento> historico = agendamentoService.listarPorUsuario(usuarioId);
            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "historico", historico)
            );
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", "Erro ao buscar histórico: " + e.getMessage())
            );
        }
    }

    @GetMapping("/usuario/{usuarioId}/pet/{nomePet}/historico")
    public ResponseEntity<?> historicoPorPet(@PathVariable Long usuarioId, @PathVariable String nomePet) {
        try {
            List<Agendamento> historico = agendamentoService.listarHistoricoPorPet(usuarioId, nomePet);
            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "historico", historico)
            );
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", "Erro ao buscar histórico do pet: " + e.getMessage())
            );
        }
    }

    @GetMapping("/usuario/{usuarioId}/pets")
    public ResponseEntity<?> listarPets(@PathVariable Long usuarioId) {
        try {
            List<Agendamento> agendamentos = agendamentoService.listarPorUsuario(usuarioId);

            // Extrair nomes únicos dos pets
            List<String> pets = agendamentos.stream()
                    .map(Agendamento::getNomePet)
                    .distinct()
                    .toList();

            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "pets", pets)
            );
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", "Erro ao listar pets: " + e.getMessage())
            );
        }
    }

    @GetMapping("/usuario/{usuarioId}/estatisticas")
    public ResponseEntity<?> estatisticas(@PathVariable Long usuarioId) {
        try {
            List<Agendamento> agendamentos = agendamentoService.listarPorUsuario(usuarioId);

            Map<String, Object> estatisticas = new HashMap<>();
            estatisticas.put("totalAgendamentos", agendamentos.size());
            estatisticas.put("consultas", agendamentos.stream().filter(a -> "CONSULTA".equals(a.getTipo())).count());
            estatisticas.put("vacinacoes", agendamentos.stream().filter(a -> "VACINACAO".equals(a.getTipo())).count());
            estatisticas.put("internacoes", agendamentos.stream().filter(a -> "INTERNACAO".equals(a.getTipo())).count());
            estatisticas.put("cirurgias", agendamentos.stream().filter(a -> "CIRURGIA".equals(a.getTipo())).count());
            estatisticas.put("exames", agendamentos.stream().filter(a -> "EXAME".equals(a.getTipo())).count());

            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "estatisticas", estatisticas)
            );
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", "Erro ao calcular estatísticas: " + e.getMessage())
            );
        }
    }
}