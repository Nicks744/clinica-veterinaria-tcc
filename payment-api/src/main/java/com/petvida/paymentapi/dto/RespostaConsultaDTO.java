package com.petvida.paymentapi.dto;

import com.petvida.paymentapi.model.StatusConsulta;
import java.time.LocalDateTime;

public class RespostaConsultaDTO {
    private Long id;
    private String nomePet;
    private String nomeDono;
    private String cpf;
    private String contato;
    private LocalDateTime dataConsulta;
    private String genero;
    private String raca;
    private String sintomas;
    private String peso;
    private String observacoes;
    private StatusConsulta status;
    private Long usuarioId;
    private LocalDateTime criadoEm;
    private String mensagem;

    // Construtores
    public RespostaConsultaDTO() {}

    public RespostaConsultaDTO(Long id, String nomePet, String nomeDono, LocalDateTime dataConsulta,
                               StatusConsulta status, String mensagem) {
        this.id = id;
        this.nomePet = nomePet;
        this.nomeDono = nomeDono;
        this.dataConsulta = dataConsulta;
        this.status = status;
        this.mensagem = mensagem;
    }

    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNomePet() { return nomePet; }
    public void setNomePet(String nomePet) { this.nomePet = nomePet; }
    public String getNomeDono() { return nomeDono; }
    public void setNomeDono(String nomeDono) { this.nomeDono = nomeDono; }
    public String getCpf() { return cpf; }
    public void setCpf(String cpf) { this.cpf = cpf; }
    public String getContato() { return contato; }
    public void setContato(String contato) { this.contato = contato; }
    public LocalDateTime getDataConsulta() { return dataConsulta; }
    public void setDataConsulta(LocalDateTime dataConsulta) { this.dataConsulta = dataConsulta; }
    public String getGenero() { return genero; }
    public void setGenero(String genero) { this.genero = genero; }
    public String getRaca() { return raca; }
    public void setRaca(String raca) { this.raca = raca; }
    public String getSintomas() { return sintomas; }
    public void setSintomas(String sintomas) { this.sintomas = sintomas; }
    public String getPeso() { return peso; }
    public void setPeso(String peso) { this.peso = peso; }
    public String getObservacoes() { return observacoes; }
    public void setObservacoes(String observacoes) { this.observacoes = observacoes; }
    public StatusConsulta getStatus() { return status; }
    public void setStatus(StatusConsulta status) { this.status = status; }
    public Long getUsuarioId() { return usuarioId; }
    public void setUsuarioId(Long usuarioId) { this.usuarioId = usuarioId; }
    public LocalDateTime getCriadoEm() { return criadoEm; }
    public void setCriadoEm(LocalDateTime criadoEm) { this.criadoEm = criadoEm; }
    public String getMensagem() { return mensagem; }
    public void setMensagem(String mensagem) { this.mensagem = mensagem; }
}