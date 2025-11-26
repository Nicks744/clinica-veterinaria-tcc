package com.petvida.paymentapi.dto;

import com.petvida.paymentapi.model.StatusVacinacao;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class VacinacaoResponseDTO {

    private Long id;
    private String nomePet;
    private String cpfDono;
    private LocalDate dataVacinacao;
    private LocalTime horario;
    private String observacoes;
    private StatusVacinacao status;
    private LocalDateTime criadoEm;
    private String mensagem;

    // Construtores
    public VacinacaoResponseDTO() {}

    public VacinacaoResponseDTO(Long id, String nomePet, String cpfDono, LocalDate dataVacinacao,
                                LocalTime horario, String observacoes, StatusVacinacao status, LocalDateTime criadoEm) {
        this.id = id;
        this.nomePet = nomePet;
        this.cpfDono = cpfDono;
        this.dataVacinacao = dataVacinacao;
        this.horario = horario;
        this.observacoes = observacoes;
        this.status = status;
        this.criadoEm = criadoEm;
    }

    public VacinacaoResponseDTO(String mensagem) {
        this.mensagem = mensagem;
    }

    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNomePet() { return nomePet; }
    public void setNomePet(String nomePet) { this.nomePet = nomePet; }
    public String getCpfDono() { return cpfDono; }
    public void setCpfDono(String cpfDono) { this.cpfDono = cpfDono; }
    public LocalDate getDataVacinacao() { return dataVacinacao; }
    public void setDataVacinacao(LocalDate dataVacinacao) { this.dataVacinacao = dataVacinacao; }
    public LocalTime getHorario() { return horario; }
    public void setHorario(LocalTime horario) { this.horario = horario; }
    public String getObservacoes() { return observacoes; }
    public void setObservacoes(String observacoes) { this.observacoes = observacoes; }
    public StatusVacinacao getStatus() { return status; }
    public void setStatus(StatusVacinacao status) { this.status = status; }
    public LocalDateTime getCriadoEm() { return criadoEm; }
    public void setCriadoEm(LocalDateTime criadoEm) { this.criadoEm = criadoEm; }
    public String getMensagem() { return mensagem; }
    public void setMensagem(String mensagem) { this.mensagem = mensagem; }
}