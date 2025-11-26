package com.petvida.paymentapi.dto;

import com.petvida.paymentapi.model.StatusPagamento;
import com.petvida.paymentapi.model.TipoPlano;
import java.time.LocalDateTime;

public class RespostaPagamentoDTO {
    private Long id;
    private Long usuarioId;
    private TipoPlano plano;
    private Double valor;
    private StatusPagamento status;
    private String idTransacao;
    private String mensagem;
    private String pixPayload;
    private LocalDateTime pixExpiraEm;
    private Integer tempoRestanteSegundos;

    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUsuarioId() { return usuarioId; }
    public void setUsuarioId(Long usuarioId) { this.usuarioId = usuarioId; }

    public TipoPlano getPlano() { return plano; }
    public void setPlano(TipoPlano plano) { this.plano = plano; }

    public Double getValor() { return valor; }
    public void setValor(Double valor) { this.valor = valor; }

    public StatusPagamento getStatus() { return status; }
    public void setStatus(StatusPagamento status) { this.status = status; }

    public String getIdTransacao() { return idTransacao; }
    public void setIdTransacao(String idTransacao) { this.idTransacao = idTransacao; }

    public String getMensagem() { return mensagem; }
    public void setMensagem(String mensagem) { this.mensagem = mensagem; }

    public String getPixPayload() { return pixPayload; }
    public void setPixPayload(String pixPayload) { this.pixPayload = pixPayload; }

    public LocalDateTime getPixExpiraEm() { return pixExpiraEm; }
    public void setPixExpiraEm(LocalDateTime pixExpiraEm) { this.pixExpiraEm = pixExpiraEm; }

    public Integer getTempoRestanteSegundos() { return tempoRestanteSegundos; }
    public void setTempoRestanteSegundos(Integer tempoRestanteSegundos) { this.tempoRestanteSegundos = tempoRestanteSegundos; }
}