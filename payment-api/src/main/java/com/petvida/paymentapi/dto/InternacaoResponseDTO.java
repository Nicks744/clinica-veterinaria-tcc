package com.petvida.paymentapi.dto;

import com.petvida.paymentapi.model.StatusInternacao;
import java.time.LocalDateTime;

public class InternacaoResponseDTO {

    private Long id;
    private String nomeTutor;
    private String cpfTutor;
    private String telefoneTutor;
    private String descricao;
    private StatusInternacao status;
    private LocalDateTime criadoEm;
    private String mensagem;

    // Construtores
    public InternacaoResponseDTO() {}

    public InternacaoResponseDTO(Long id, String nomeTutor, String cpfTutor, String telefoneTutor,
                                 String descricao, StatusInternacao status, LocalDateTime criadoEm) {
        this.id = id;
        this.nomeTutor = nomeTutor;
        this.cpfTutor = cpfTutor;
        this.telefoneTutor = telefoneTutor;
        this.descricao = descricao;
        this.status = status;
        this.criadoEm = criadoEm;
    }

    public InternacaoResponseDTO(String mensagem) {
        this.mensagem = mensagem;
    }

    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNomeTutor() { return nomeTutor; }
    public void setNomeTutor(String nomeTutor) { this.nomeTutor = nomeTutor; }
    public String getCpfTutor() { return cpfTutor; }
    public void setCpfTutor(String cpfTutor) { this.cpfTutor = cpfTutor; }
    public String getTelefoneTutor() { return telefoneTutor; }
    public void setTelefoneTutor(String telefoneTutor) { this.telefoneTutor = telefoneTutor; }
    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }
    public StatusInternacao getStatus() { return status; }
    public void setStatus(StatusInternacao status) { this.status = status; }
    public LocalDateTime getCriadoEm() { return criadoEm; }
    public void setCriadoEm(LocalDateTime criadoEm) { this.criadoEm = criadoEm; }
    public String getMensagem() { return mensagem; }
    public void setMensagem(String mensagem) { this.mensagem = mensagem; }
}