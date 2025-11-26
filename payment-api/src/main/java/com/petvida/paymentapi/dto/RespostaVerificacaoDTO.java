package com.petvida.paymentapi.dto;

public class RespostaVerificacaoDTO {
    private Boolean sucesso;
    private String mensagem;
    private Long usuarioId;
    private String email;

    public RespostaVerificacaoDTO() {}

    public RespostaVerificacaoDTO(Boolean sucesso, String mensagem, Long usuarioId, String email) {
        this.sucesso = sucesso;
        this.mensagem = mensagem;
        this.usuarioId = usuarioId;
        this.email = email;
    }

    // Getters e Setters
    public Boolean getSucesso() { return sucesso; }
    public void setSucesso(Boolean sucesso) { this.sucesso = sucesso; }

    public String getMensagem() { return mensagem; }
    public void setMensagem(String mensagem) { this.mensagem = mensagem; }

    public Long getUsuarioId() { return usuarioId; }
    public void setUsuarioId(Long usuarioId) { this.usuarioId = usuarioId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}