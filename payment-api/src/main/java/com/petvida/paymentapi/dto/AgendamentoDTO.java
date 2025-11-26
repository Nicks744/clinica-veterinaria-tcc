package com.petvida.paymentapi.dto;

import java.time.LocalDateTime;

public class AgendamentoDTO {
    private String tipo; // CONSULTA, VACINACAO, CASTRACAO, INTERNACAO, CIRURGIA
    private String nomePet;
    private String nomeDono;
    private String cpf;
    private String contato;
    private LocalDateTime dataAgendamento;
    private String horario; // Para vacinação
    private String genero;
    private String raca;
    private String sintomas;
    private String peso;
    private String observacoes;
    private String especie; // Para castração
    private String idadePet;
    private String pesoPet;
    private String historicoSaude;
    private String descricao; // Para internação
    private Long usuarioId;

    // Getters e Setters
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public String getNomePet() { return nomePet; }
    public void setNomePet(String nomePet) { this.nomePet = nomePet; }

    public String getNomeDono() { return nomeDono; }
    public void setNomeDono(String nomeDono) { this.nomeDono = nomeDono; }

    public String getCpf() { return cpf; }
    public void setCpf(String cpf) { this.cpf = cpf; }

    public String getContato() { return contato; }
    public void setContato(String contato) { this.contato = contato; }

    public LocalDateTime getDataAgendamento() { return dataAgendamento; }
    public void setDataAgendamento(LocalDateTime dataAgendamento) { this.dataAgendamento = dataAgendamento; }

    public String getHorario() { return horario; }
    public void setHorario(String horario) { this.horario = horario; }

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

    public String getEspecie() { return especie; }
    public void setEspecie(String especie) { this.especie = especie; }

    public String getIdadePet() { return idadePet; }
    public void setIdadePet(String idadePet) { this.idadePet = idadePet; }

    public String getPesoPet() { return pesoPet; }
    public void setPesoPet(String pesoPet) { this.pesoPet = pesoPet; }

    public String getHistoricoSaude() { return historicoSaude; }
    public void setHistoricoSaude(String historicoSaude) { this.historicoSaude = historicoSaude; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public Long getUsuarioId() { return usuarioId; }
    public void setUsuarioId(Long usuarioId) { this.usuarioId = usuarioId; }
}