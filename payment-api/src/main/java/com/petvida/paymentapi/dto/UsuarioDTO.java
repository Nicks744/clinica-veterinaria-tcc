package com.petvida.paymentapi.dto;

import com.petvida.paymentapi.model.TipoPlano;
import java.time.LocalDateTime;

public class UsuarioDTO {
    private Long id;
    private String nome;
    private String email;
    private TipoPlano plano;
    private LocalDateTime planoValidoAte;
    private LocalDateTime criadoEm;

    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public TipoPlano getPlano() { return plano; }
    public void setPlano(TipoPlano plano) { this.plano = plano; }
    public LocalDateTime getPlanoValidoAte() { return planoValidoAte; }
    public void setPlanoValidoAte(LocalDateTime planoValidoAte) { this.planoValidoAte = planoValidoAte; }
    public LocalDateTime getCriadoEm() { return criadoEm; }
    public void setCriadoEm(LocalDateTime criadoEm) { this.criadoEm = criadoEm; }
}