package com.petvida.paymentapi.model;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "agendamento")
public class Agendamento {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String tipo;

    @Column(nullable = false)
    private String nomePet;

    private String nomeDono;
    private String cpf;
    private String contato;
    private LocalDateTime dataAgendamento;
    private String horario;
    private String genero;
    private String raca;
    private String sintomas;
    private String peso;

    @Column(columnDefinition = "TEXT")
    private String observacoes;

    private String especie;
    private String idadePet;
    private String pesoPet;

    @Column(columnDefinition = "TEXT")
    private String historicoSaude;

    @Column(columnDefinition = "TEXT")
    private String descricao;

    private String status;
    private Long usuarioId;
    private LocalDateTime criadoEm;

    // Campos relatório médico
    @Column(columnDefinition = "TEXT")
    private String diagnostico;

    @Column(columnDefinition = "TEXT")
    private String prescricao;

    private String examesSolicitados;

    @Column(columnDefinition = "TEXT")
    private String observacoesMedicas;

    private LocalDateTime dataRealizacao;
    private String nomeVeterinario;

    // Construtor
    public Agendamento() {
        this.criadoEm = LocalDateTime.now();
        this.status = "AGENDADO";
    }

    // Getters e Setters (mantenha todos os existentes)...
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
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
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Long getUsuarioId() { return usuarioId; }
    public void setUsuarioId(Long usuarioId) { this.usuarioId = usuarioId; }
    public LocalDateTime getCriadoEm() { return criadoEm; }
    public void setCriadoEm(LocalDateTime criadoEm) { this.criadoEm = criadoEm; }
    public String getDiagnostico() { return diagnostico; }
    public void setDiagnostico(String diagnostico) { this.diagnostico = diagnostico; }
    public String getPrescricao() { return prescricao; }
    public void setPrescricao(String prescricao) { this.prescricao = prescricao; }
    public String getExamesSolicitados() { return examesSolicitados; }
    public void setExamesSolicitados(String examesSolicitados) { this.examesSolicitados = examesSolicitados; }
    public String getObservacoesMedicas() { return observacoesMedicas; }
    public void setObservacoesMedicas(String observacoesMedicas) { this.observacoesMedicas = observacoesMedicas; }
    public LocalDateTime getDataRealizacao() { return dataRealizacao; }
    public void setDataRealizacao(LocalDateTime dataRealizacao) { this.dataRealizacao = dataRealizacao; }
    public String getNomeVeterinario() { return nomeVeterinario; }
    public void setNomeVeterinario(String nomeVeterinario) { this.nomeVeterinario = nomeVeterinario; }
}