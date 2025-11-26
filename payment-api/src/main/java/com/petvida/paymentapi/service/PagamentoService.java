package com.petvida.paymentapi.service;

import com.petvida.paymentapi.model.Pagamento;
import com.petvida.paymentapi.model.Usuario;
import com.petvida.paymentapi.model.TipoPlano;
import com.petvida.paymentapi.model.StatusPagamento;
import com.petvida.paymentapi.model.MetodoPagamento;
import com.petvida.paymentapi.repository.PagamentoRepository;
import com.petvida.paymentapi.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;
import java.util.List;

@Service
public class PagamentoService {

    @Autowired
    private PagamentoRepository pagamentoRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    public Pagamento processarSolicitacaoPagamento(Long usuarioId, TipoPlano plano, String metodoPagamentoStr) {
        try {
            System.out.println("Processando pagamento: {usuarioId=" + usuarioId + ", plano=" + plano + ", metodoPagamento=" + metodoPagamentoStr + "}");

            // Buscar usuário
            Usuario usuario = usuarioRepository.findById(usuarioId)
                    .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

            // Calcular valor baseado no plano
            double valor = calcularValorPlano(plano);

            // Criar pagamento
            Pagamento pagamento = new Pagamento();
            pagamento.setUsuarioId(usuarioId);
            pagamento.setPlano(plano);
            pagamento.setValor(valor);
            pagamento.setStatus(StatusPagamento.AGUARDANDO_PIX);

            // ✅ CORREÇÃO: Converter String para ENUM ou usar String
            pagamento.setMetodoPagamento(MetodoPagamento.PIX); // Se o campo for String
            // Ou: pagamento.setMetodoPagamento(MetodoPagamento.valueOf(metodoPagamentoStr)); // Se for ENUM

            pagamento.setIdTransacao(UUID.randomUUID().toString());
            pagamento.setDataCriacao(LocalDateTime.now());
            pagamento.setPixExpiraEm(LocalDateTime.now().plusMinutes(30));

            // Configurar PIX
            configurarPix(pagamento);

            // Salvar pagamento
            Pagamento pagamentoSalvo = pagamentoRepository.save(pagamento);
            System.out.println("Pagamento criado com sucesso: " + pagamentoSalvo.getIdTransacao());

            return pagamentoSalvo;

        } catch (Exception e) {
            System.err.println("❌ Erro ao processar pagamento: " + e.getMessage());
            throw new RuntimeException("Falha ao processar pagamento: " + e.getMessage(), e);
        }
    }

    private double calcularValorPlano(TipoPlano plano) {
        // ✅ CORREÇÃO: Usar switch correto com ENUM
        switch (plano) {
            case BASICO:
                return 29.90;
            case PREMIUM:
                return 59.90;
            case VIP:
                return 99.90;
            default:
                return 59.90;
        }
    }

    private void configurarPix(Pagamento pagamento) {
        // Configurar dados do PIX
        pagamento.setPixKey("kaualuiz1512@gmail.com");
        pagamento.setMerchantName("PetVida Saude Animal");
        pagamento.setMerchantCity("Sao Paulo");

        // Gerar payload PIX (simplificado)
        String payload = gerarPayloadPix(pagamento);
        pagamento.setPixPayload(payload);

        // Gerar QR Code (simplificado)
        String qrCode = gerarQRCodeSimulado(pagamento.getIdTransacao());
        pagamento.setQrCodeBase64(qrCode);

        pagamento.setMensagem("Aguardando pagamento via PIX");
    }

    private String gerarPayloadPix(Pagamento pagamento) {
        // Payload PIX simplificado para testes
        return String.format("00020101021126440014BR.GOV.BCB.PIX0122%s5204000053039865405%.2f5802BR5920%s6009%s6304E273",
                pagamento.getPixKey(),
                pagamento.getValor(),
                pagamento.getMerchantName(),
                pagamento.getMerchantCity());
    }

    private String gerarQRCodeSimulado(String idTransacao) {
        // QR Code simulado em Base64 (SVG simples)
        String svg = String.format("<svg width='200' height='200' xmlns='http://www.w3.org/2000/svg'><rect width='100%%' height='100%%' fill='white'/><text x='100' y='100' text-anchor='middle' font-family='Arial' font-size='10'>QR CODE PIX</text><text x='100' y='120' text-anchor='middle' font-family='Arial' font-size='8'>%s</text></svg>", idTransacao);
        return "data:image/svg+xml;base64," + java.util.Base64.getEncoder().encodeToString(svg.getBytes());
    }

    public Pagamento buscarPorIdTransacao(String idTransacao) {
        return pagamentoRepository.findByIdTransacao(idTransacao)
                .orElseThrow(() -> new RuntimeException("Pagamento não encontrado"));
    }

    public Pagamento atualizarStatusPagamento(String idTransacao, StatusPagamento novoStatus) {
        Pagamento pagamento = buscarPorIdTransacao(idTransacao);
        pagamento.setStatus(novoStatus);

        if (novoStatus == StatusPagamento.CONCLUIDO) {
            pagamento.setDataPagamento(LocalDateTime.now());
            ativarPlanoUsuario(pagamento);
        }

        return pagamentoRepository.save(pagamento);
    }

    private void ativarPlanoUsuario(Pagamento pagamento) {
        try {
            Usuario usuario = usuarioRepository.findById(pagamento.getUsuarioId())
                    .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

            // Converter TipoPlano para String
            usuario.setPlano(pagamento.getPlano().name());

            // Calcular validade do plano (ex: 30 dias)
            usuario.setPlanoValidoAte(LocalDateTime.now().plusDays(30));

            usuarioRepository.save(usuario);

            System.out.println("Plano ativado para usuário: " + usuario.getEmail() + " - Plano: " + pagamento.getPlano());

        } catch (Exception e) {
            System.err.println("❌ Erro ao ativar plano do usuário: " + e.getMessage());
            throw new RuntimeException("Erro ao ativar plano: " + e.getMessage());
        }
    }

    public Pagamento simularPagamentoPix(String idTransacao) {
        System.out.println("Simulando pagamento PIX para: " + idTransacao);

        Pagamento pagamento = buscarPorIdTransacao(idTransacao);

        if (pagamento.getStatus() != StatusPagamento.AGUARDANDO_PIX) {
            throw new RuntimeException("Pagamento não está aguardando PIX");
        }

        // Simular processamento
        pagamento.setStatus(StatusPagamento.CONCLUIDO);
        pagamento.setDataPagamento(LocalDateTime.now());
        pagamento.setMensagem("Pagamento simulado com sucesso");

        Pagamento pagamentoAtualizado = pagamentoRepository.save(pagamento);

        // Ativar plano do usuário
        ativarPlanoUsuario(pagamentoAtualizado);

        System.out.println("Pagamento simulado com sucesso: " + idTransacao);

        return pagamentoAtualizado;
    }

    public Optional<Pagamento> buscarPorId(Long id) {
        return pagamentoRepository.findById(id);
    }

    public List<Pagamento> listarPorUsuario(Long usuarioId) {
        return pagamentoRepository.findByUsuarioId(usuarioId);
    }
}