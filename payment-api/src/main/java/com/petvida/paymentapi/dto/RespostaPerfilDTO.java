package com.petvida.paymentapi.dto;

import com.petvida.paymentapi.model.StatusUsuario;
import com.petvida.paymentapi.model.TipoPlano;
import java.time.LocalDateTime;

public class RespostaPerfilDTO {
    private Long id;
    private String nome;
    private String email;
    private String cpf;
    private String celular;
    private String endereco;
    private String fotoPerfil;
    private TipoPlano plano;
    private StatusUsuario status;
    private LocalDateTime planoValidoAte;
    private LocalDateTime criadoEm;
    private LocalDateTime verificadoEm;
    private String mensagem;

    // Construtores
    public RespostaPerfilDTO() {}

    public RespostaPerfilDTO(Long id, String nome, String email, TipoPlano plano, StatusUsuario status) {
        this.id = id;
        this.nome = nome;
        this.email = email;
        this.plano = plano;
        this.status = status;
    }

    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getCpf() { return cpf; }
    public void setCpf(String cpf) { this.cpf = cpf; }
    public String getCelular() { return celular; }
    public void setCelular(String celular) { this.celular = celular; }
    public String getEndereco() { return endereco; }
    public void setEndereco(String endereco) { this.endereco = endereco; }
    public String getFotoPerfil() { return fotoPerfil; }
    public void setFotoPerfil(String fotoPerfil) { this.fotoPerfil = fotoPerfil; }
    public TipoPlano getPlano() { return plano; }
    public void setPlano(TipoPlano plano) { this.plano = plano; }
    public StatusUsuario getStatus() { return status; }
    public void setStatus(StatusUsuario status) { this.status = status; }
    public LocalDateTime getPlanoValidoAte() { return planoValidoAte; }
    public void setPlanoValidoAte(LocalDateTime planoValidoAte) { this.planoValidoAte = planoValidoAte; }
    public LocalDateTime getCriadoEm() { return criadoEm; }
    public void setCriadoEm(LocalDateTime criadoEm) { this.criadoEm = criadoEm; }
    public LocalDateTime getVerificadoEm() { return verificadoEm; }
    public void setVerificadoEm(LocalDateTime verificadoEm) { this.verificadoEm = verificadoEm; }
    public String getMensagem() { return mensagem; }
    public void setMensagem(String mensagem) { this.mensagem = mensagem; }
}