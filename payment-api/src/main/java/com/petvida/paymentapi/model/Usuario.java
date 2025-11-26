package com.petvida.paymentapi.model;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "usuario")
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nome;

    @Column(unique = true, nullable = false)
    private String email;

    @Column(nullable = false)
    private String senha;

    @Column(unique = true)
    private String cpf;

    private String celular;

    @Enumerated(EnumType.STRING)
    private StatusUsuario status;

    private String plano;

    @Column(name = "plano_valido_ate")
    private LocalDateTime planoValidoAte;

    @Column(name = "criado_em")
    private LocalDateTime criadoEm;

    // Recuperação de senha
    @Column(name = "codigo_recuperacao_senha")
    private String codigoRecuperacaoSenha;

    @Column(name = "codigo_recuperacao_expira_em")
    private LocalDateTime codigoRecuperacaoExpiraEm;

    @Column(name = "tentativas_recuperacao")
    private Integer tentativasRecuperacao;

    @Column(name = "ultima_tentativa_recuperacao")
    private LocalDateTime ultimaTentativaRecuperacao;

    // Verificação de email
    @Column(name = "codigo_verificacao")
    private String codigoVerificacao;

    @Column(name = "verificado_em")
    private LocalDateTime verificadoEm;

    // Campos adicionais
    private String endereco;

    @Column(name = "foto_perfil")
    private String fotoPerfil;

    // Construtores
    public Usuario() {
        this.status = StatusUsuario.AGUARDANDO_VERIFICACAO;
        this.tentativasRecuperacao = 0;
        this.criadoEm = LocalDateTime.now();
    }

    public Usuario(String nome, String email, String senha, String cpf, String celular) {
        this();
        this.nome = nome;
        this.email = email;
        this.senha = senha;
        this.cpf = cpf;
        this.celular = celular;
    }

    // Getters e Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    public String getCelular() {
        return celular;
    }

    public void setCelular(String celular) {
        this.celular = celular;
    }

    public StatusUsuario getStatus() {
        return status;
    }

    public void setStatus(StatusUsuario status) {
        this.status = status;
    }

    public String getPlano() {
        return plano;
    }

    public void setPlano(String plano) {
        this.plano = plano;
    }

    public LocalDateTime getPlanoValidoAte() {
        return planoValidoAte;
    }

    public void setPlanoValidoAte(LocalDateTime planoValidoAte) {
        this.planoValidoAte = planoValidoAte;
    }

    public LocalDateTime getCriadoEm() {
        return criadoEm;
    }

    public void setCriadoEm(LocalDateTime criadoEm) {
        this.criadoEm = criadoEm;
    }

    public String getCodigoRecuperacaoSenha() {
        return codigoRecuperacaoSenha;
    }

    public void setCodigoRecuperacaoSenha(String codigoRecuperacaoSenha) {
        this.codigoRecuperacaoSenha = codigoRecuperacaoSenha;
    }

    public LocalDateTime getCodigoRecuperacaoExpiraEm() {
        return codigoRecuperacaoExpiraEm;
    }

    public void setCodigoRecuperacaoExpiraEm(LocalDateTime codigoRecuperacaoExpiraEm) {
        this.codigoRecuperacaoExpiraEm = codigoRecuperacaoExpiraEm;
    }

    public Integer getTentativasRecuperacao() {
        return tentativasRecuperacao;
    }

    public void setTentativasRecuperacao(Integer tentativasRecuperacao) {
        this.tentativasRecuperacao = tentativasRecuperacao;
    }

    public LocalDateTime getUltimaTentativaRecuperacao() {
        return ultimaTentativaRecuperacao;
    }

    public void setUltimaTentativaRecuperacao(LocalDateTime ultimaTentativaRecuperacao) {
        this.ultimaTentativaRecuperacao = ultimaTentativaRecuperacao;
    }

    public String getCodigoVerificacao() {
        return codigoVerificacao;
    }

    public void setCodigoVerificacao(String codigoVerificacao) {
        this.codigoVerificacao = codigoVerificacao;
    }

    public LocalDateTime getVerificadoEm() {
        return verificadoEm;
    }

    public void setVerificadoEm(LocalDateTime verificadoEm) {
        this.verificadoEm = verificadoEm;
    }

    public String getEndereco() {
        return endereco;
    }

    public void setEndereco(String endereco) {
        this.endereco = endereco;
    }

    public String getFotoPerfil() {
        return fotoPerfil;
    }

    public void setFotoPerfil(String fotoPerfil) {
        this.fotoPerfil = fotoPerfil;
    }

    // Métodos auxiliares
    public boolean isVerificado() {
        return StatusUsuario.ATIVO.equals(this.status);
    }

    public boolean isCodigoRecuperacaoValido() {
        return this.codigoRecuperacaoExpiraEm != null &&
                this.codigoRecuperacaoExpiraEm.isAfter(LocalDateTime.now());
    }

    public boolean isCodigoRecuperacaoExpirado() {
        return this.codigoRecuperacaoExpiraEm != null &&
                this.codigoRecuperacaoExpiraEm.isBefore(LocalDateTime.now());
    }

    public void incrementarTentativasRecuperacao() {
        if (this.tentativasRecuperacao == null) {
            this.tentativasRecuperacao = 0;
        }
        this.tentativasRecuperacao++;
        this.ultimaTentativaRecuperacao = LocalDateTime.now();
    }

    public void resetarTentativasRecuperacao() {
        this.tentativasRecuperacao = 0;
        this.ultimaTentativaRecuperacao = null;
    }

    public void ativarUsuario() {
        this.status = StatusUsuario.ATIVO;
        this.verificadoEm = LocalDateTime.now();
        this.codigoVerificacao = null;
    }

    // toString para debug
    @Override
    public String toString() {
        return "Usuario{" +
                "id=" + id +
                ", nome='" + nome + '\'' +
                ", email='" + email + '\'' +
                ", status=" + status +
                ", criadoEm=" + criadoEm +
                ", verificadoEm=" + verificadoEm +
                '}';
    }

    // equals e hashCode baseados no ID
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Usuario usuario = (Usuario) o;
        return id != null && id.equals(usuario.id);
    }

    @Override
    public int hashCode() {
        return getClass().hashCode();
    }
}