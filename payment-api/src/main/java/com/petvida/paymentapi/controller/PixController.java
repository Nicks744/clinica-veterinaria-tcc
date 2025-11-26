package com.petvida.paymentapi.controller;

import com.petvida.paymentapi.model.Pagamento;
import com.petvida.paymentapi.model.TipoPlano;
import com.petvida.paymentapi.model.StatusPagamento;
import com.petvida.paymentapi.service.PagamentoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.HashMap;
import java.util.List;

@RestController
@RequestMapping("/api/pagamentos")
@CrossOrigin(origins = "*")
public class PixController {

    @Autowired
    private PagamentoService pagamentoService;

    @PostMapping("/solicitar")
    public ResponseEntity<?> solicitarPagamento(@RequestBody Map<String, Object> solicitacao) {
        try {
            System.out.println("Solicitando pagamento: " + solicitacao);

            Long usuarioId = Long.valueOf(solicitacao.get("usuarioId").toString());
            TipoPlano plano = TipoPlano.valueOf(solicitacao.get("plano").toString());
            String metodoPagamento = solicitacao.get("metodoPagamento").toString();

            // ✅ CORREÇÃO: Chamar método correto
            Pagamento pagamento = pagamentoService.processarSolicitacaoPagamento(usuarioId, plano, metodoPagamento);

            Map<String, Object> resposta = new HashMap<>();
            resposta.put("sucesso", true);
            resposta.put("mensagem", "Pagamento solicitado com sucesso");
            resposta.put("dados", Map.of(
                    "idTransacao", pagamento.getIdTransacao(),
                    "valor", pagamento.getValor(),
                    "plano", pagamento.getPlano(),
                    "pixPayload", pagamento.getPixPayload(),
                    "qrCodeBase64", pagamento.getQrCodeBase64(),
                    "pixKey", pagamento.getPixKey(),
                    "tempoRestanteSegundos", 1800
            ));

            return ResponseEntity.ok().body(resposta);

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", "Erro ao solicitar pagamento: " + e.getMessage())
            );
        }
    }

    @GetMapping("/status/{idTransacao}")
    public ResponseEntity<?> consultarStatus(@PathVariable String idTransacao) {
        try {
            System.out.println("Consultando status: " + idTransacao);

            // ✅ CORREÇÃO: Usar método existente
            Pagamento pagamento = pagamentoService.buscarPorIdTransacao(idTransacao);

            Map<String, Object> status = new HashMap<>();
            status.put("sucesso", true);
            status.put("idTransacao", pagamento.getIdTransacao());
            status.put("status", pagamento.getStatus());
            status.put("valor", pagamento.getValor());
            status.put("dataCriacao", pagamento.getDataCriacao());
            status.put("dataPagamento", pagamento.getDataPagamento());

            return ResponseEntity.ok().body(status);

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", "Erro ao consultar status: " + e.getMessage())
            );
        }
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<?> listarPorUsuario(@PathVariable Long usuarioId) {
        try {
            // ✅ CORREÇÃO: Usar método existente
            List<Pagamento> pagamentos = pagamentoService.listarPorUsuario(usuarioId);

            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "pagamentos", pagamentos)
            );

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", "Erro ao listar pagamentos: " + e.getMessage())
            );
        }
    }

    @PostMapping("/webhook/pix")
    public ResponseEntity<?> webhookPix(@RequestBody Map<String, Object> webhookData) {
        try {
            System.out.println("Webhook PIX recebido: " + webhookData);

            String idTransacao = webhookData.get("idTransacao").toString();
            String status = webhookData.get("status").toString();
            Double valor = Double.valueOf(webhookData.get("valor").toString());

            // ✅ CORREÇÃO: Usar método existente
            StatusPagamento statusPagamento = StatusPagamento.valueOf(status);
            Pagamento pagamento = pagamentoService.atualizarStatusPagamento(idTransacao, statusPagamento);

            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "mensagem", "Webhook processado", "pagamento", pagamento)
            );

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", "Erro no webhook: " + e.getMessage())
            );
        }
    }

    @PostMapping("/simular-pagamento-pix")
    public ResponseEntity<?> simularPagamentoPix(@RequestBody Map<String, String> request) {
        try {
            String idTransacao = request.get("idTransacao");
            System.out.println("Simulando pagamento PIX: " + idTransacao);

            // ✅ CORREÇÃO: Usar método existente
            Pagamento pagamento = pagamentoService.simularPagamentoPix(idTransacao);

            return ResponseEntity.ok().body(
                    Map.of("sucesso", true, "mensagem", "Pagamento simulado com sucesso", "pagamento", pagamento)
            );

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(
                    Map.of("sucesso", false, "mensagem", "Erro ao simular pagamento: " + e.getMessage())
            );
        }
    }
}