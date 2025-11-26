package com.petvida.paymentapi.model;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "pagamento")
public class Pagamento {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "usuario_id", nullable = false)
    private Long usuarioId;

    @Enumerated(EnumType.STRING)
    private TipoPlano plano;

    private Double valor;

    @Enumerated(EnumType.STRING)
    private StatusPagamento status;

    @Column(name = "id_transacao", unique = true)
    private String idTransacao;

    @Column(name = "pix_key")
    private String pixKey;

    @Column(name = "pix_payload", columnDefinition = "TEXT")
    private String pixPayload;

    @Column(name = "qr_code_base64", columnDefinition = "LONGTEXT")
    private String qrCodeBase64;

    @Column(name = "pix_expira_em")
    private LocalDateTime pixExpiraEm;

    @Column(name = "data_criacao")
    private LocalDateTime dataCriacao;

    @Column(name = "data_pagamento")
    private LocalDateTime dataPagamento;

    @Enumerated(EnumType.STRING)
    @Column(name = "metodo_pagamento")
    private MetodoPagamento metodoPagamento;

    private String mensagem;

    @Column(name = "merchant_name")
    private String merchantName;

    @Column(name = "merchant_city")
    private String merchantCity;

    // Construtores
    public Pagamento() {
        this.status = StatusPagamento.AGUARDANDO_PIX; // ✅ CORREÇÃO: Usar valor correto
        this.dataCriacao = LocalDateTime.now();
    }

    public Pagamento(Long usuarioId, TipoPlano plano, Double valor) {
        this();
        this.usuarioId = usuarioId;
        this.plano = plano;
        this.valor = valor;
    }

    // Getters e Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(Long usuarioId) {
        this.usuarioId = usuarioId;
    }

    public TipoPlano getPlano() {
        return plano;
    }

    public void setPlano(TipoPlano plano) {
        this.plano = plano;
    }

    public Double getValor() {
        return valor;
    }

    public void setValor(Double valor) {
        this.valor = valor;
    }

    public StatusPagamento getStatus() {
        return status;
    }

    public void setStatus(StatusPagamento status) {
        this.status = status;
    }

    public String getIdTransacao() {
        return idTransacao;
    }

    public void setIdTransacao(String idTransacao) {
        this.idTransacao = idTransacao;
    }

    public String getPixKey() {
        return pixKey;
    }

    public void setPixKey(String pixKey) {
        this.pixKey = pixKey;
    }

    public String getPixPayload() {
        return pixPayload;
    }

    public void setPixPayload(String pixPayload) {
        this.pixPayload = pixPayload;
    }

    public String getQrCodeBase64() {
        return qrCodeBase64;
    }

    public void setQrCodeBase64(String qrCodeBase64) {
        this.qrCodeBase64 = qrCodeBase64;
    }

    public LocalDateTime getPixExpiraEm() {
        return pixExpiraEm;
    }

    public void setPixExpiraEm(LocalDateTime pixExpiraEm) {
        this.pixExpiraEm = pixExpiraEm;
    }

    public LocalDateTime getDataCriacao() {
        return dataCriacao;
    }

    public void setDataCriacao(LocalDateTime dataCriacao) {
        this.dataCriacao = dataCriacao;
    }

    public LocalDateTime getDataPagamento() {
        return dataPagamento;
    }

    public void setDataPagamento(LocalDateTime dataPagamento) {
        this.dataPagamento = dataPagamento;
    }

    public MetodoPagamento getMetodoPagamento() {
        return metodoPagamento;
    }

    public void setMetodoPagamento(MetodoPagamento metodoPagamento) {
        this.metodoPagamento = metodoPagamento;
    }

    public String getMensagem() {
        return mensagem;
    }

    public void setMensagem(String mensagem) {
        this.mensagem = mensagem;
    }

    public String getMerchantName() {
        return merchantName;
    }

    public void setMerchantName(String merchantName) {
        this.merchantName = merchantName;
    }

    public String getMerchantCity() {
        return merchantCity;
    }

    public void setMerchantCity(String merchantCity) {
        this.merchantCity = merchantCity;
    }

    // Métodos auxiliares
    public boolean isPixExpirado() {
        return this.pixExpiraEm != null && this.pixExpiraEm.isBefore(LocalDateTime.now());
    }

    public boolean isConcluido() {
        return StatusPagamento.CONCLUIDO.equals(this.status);
    }

    @Override
    public String toString() {
        return "Pagamento{" +
                "id=" + id +
                ", usuarioId=" + usuarioId +
                ", plano=" + plano +
                ", valor=" + valor +
                ", status=" + status +
                ", idTransacao='" + idTransacao + '\'' +
                ", dataCriacao=" + dataCriacao +
                '}';
    }
}