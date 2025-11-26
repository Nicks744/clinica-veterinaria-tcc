package com.petvida.paymentapi.dto;

public class RecuperacaoSenhaDTO {
    private String email;
    private String codigo;
    private String novaSenha;

    // Construtores
    public RecuperacaoSenhaDTO() {}

    public RecuperacaoSenhaDTO(String email, String codigo, String novaSenha) {
        this.email = email;
        this.codigo = codigo;
        this.novaSenha = novaSenha;
    }

    // Getters e Setters
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }

    public String getNovaSenha() { return novaSenha; }
    public void setNovaSenha(String novaSenha) { this.novaSenha = novaSenha; }
}