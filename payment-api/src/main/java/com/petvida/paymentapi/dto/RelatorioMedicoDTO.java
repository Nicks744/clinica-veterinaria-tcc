package com.petvida.paymentapi.dto;

import java.time.LocalDateTime;

public class RelatorioMedicoDTO {
    private Long agendamentoId;
    private String diagnostico;
    private String prescricao;
    private String examesSolicitados;
    private String observacoesMedicas;
    private String nomeVeterinario;

    // Getters e Setters
    public Long getAgendamentoId() { return agendamentoId; }
    public void setAgendamentoId(Long agendamentoId) { this.agendamentoId = agendamentoId; }

    public String getDiagnostico() { return diagnostico; }
    public void setDiagnostico(String diagnostico) { this.diagnostico = diagnostico; }

    public String getPrescricao() { return prescricao; }
    public void setPrescricao(String prescricao) { this.prescricao = prescricao; }

    public String getExamesSolicitados() { return examesSolicitados; }
    public void setExamesSolicitados(String examesSolicitados) { this.examesSolicitados = examesSolicitados; }

    public String getObservacoesMedicas() { return observacoesMedicas; }
    public void setObservacoesMedicas(String observacoesMedicas) { this.observacoesMedicas = observacoesMedicas; }

    public String getNomeVeterinario() { return nomeVeterinario; }
    public void setNomeVeterinario(String nomeVeterinario) { this.nomeVeterinario = nomeVeterinario; }
}