package com.petvida.paymentapi.dto;

import com.petvida.paymentapi.model.StatusCirurgiaOrtopedica;
import java.time.LocalDateTime;

public class RespostaCirurgiaOrtopedicaDTO {
    private Long id;
    private String nomeDono;
    private String cpfDono;
    private String contato;
    private LocalDateTime dataCirurgia;
    private String animal;
    private String parteAfetada;
    private String sintomas;
    private String tipoLesao;
    private String tempoLesao;
    private String tratamentosAnteriores;
    private String examesRealizados;
    private String observacoes;
    private StatusCirurgiaOrtopedica status;
    private String urgencia;
    private Long usuarioId;
    private LocalDateTime criadoEm;
    private String mensagem;

    // Construtores
    public RespostaCirurgiaOrtopedicaDTO() {}

    public RespostaCirurgiaOrtopedicaDTO(Long id, String nomeDono, String animal,
                                         LocalDateTime dataCirurgia, StatusCirurgiaOrtopedica status,
                                         String mensagem) {
        this.id = id;
        this.nomeDono = nomeDono;
        this.animal = animal;
        this.dataCirurgia = dataCirurgia;
        this.status = status;
        this.mensagem = mensagem;
    }

    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNomeDono() { return nomeDono; }
    public void setNomeDono(String nomeDono) { this.nomeDono = nomeDono; }
    public String getCpfDono() { return cpfDono; }
    public void setCpfDono(String cpfDono) { this.cpfDono = cpfDono; }
    public String getContato() { return contato; }
    public void setContato(String contato) { this.contato = contato; }
    public LocalDateTime getDataCirurgia() { return dataCirurgia; }
    public void setDataCirurgia(LocalDateTime dataCirurgia) { this.dataCirurgia = dataCirurgia; }
    public String getAnimal() { return animal; }
    public void setAnimal(String animal) { this.animal = animal; }
    public String getParteAfetada() { return parteAfetada; }
    public void setParteAfetada(String parteAfetada) { this.parteAfetada = parteAfetada; }
    public String getSintomas() { return sintomas; }
    public void setSintomas(String sintomas) { this.sintomas = sintomas; }
    public String getTipoLesao() { return tipoLesao; }
    public void setTipoLesao(String tipoLesao) { this.tipoLesao = tipoLesao; }
    public String getTempoLesao() { return tempoLesao; }
    public void setTempoLesao(String tempoLesao) { this.tempoLesao = tempoLesao; }
    public String getTratamentosAnteriores() { return tratamentosAnteriores; }
    public void setTratamentosAnteriores(String tratamentosAnteriores) { this.tratamentosAnteriores = tratamentosAnteriores; }
    public String getExamesRealizados() { return examesRealizados; }
    public void setExamesRealizados(String examesRealizados) { this.examesRealizados = examesRealizados; }
    public String getObservacoes() { return observacoes; }
    public void setObservacoes(String observacoes) { this.observacoes = observacoes; }
    public StatusCirurgiaOrtopedica getStatus() { return status; }
    public void setStatus(StatusCirurgiaOrtopedica status) { this.status = status; }
    public String getUrgencia() { return urgencia; }
    public void setUrgencia(String urgencia) { this.urgencia = urgencia; }
    public Long getUsuarioId() { return usuarioId; }
    public void setUsuarioId(Long usuarioId) { this.usuarioId = usuarioId; }
    public LocalDateTime getCriadoEm() { return criadoEm; }
    public void setCriadoEm(LocalDateTime criadoEm) { this.criadoEm = criadoEm; }
    public String getMensagem() { return mensagem; }
    public void setMensagem(String mensagem) { this.mensagem = mensagem; }
}