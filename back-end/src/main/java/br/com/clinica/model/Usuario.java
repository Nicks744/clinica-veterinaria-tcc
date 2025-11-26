package br.com.clinica.model;

import jakarta.persistence.*; // <-- MUDANÇA CRÍTICA
import java.time.LocalDateTime;

@Entity
@Table(name = "usuarios")
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nome;

    @Column(unique = true)
    private String email;

    @Column(unique = true)
    private String cpf;

    private String senhaHash;

    @Column(name = "token_verificacao")
    private String tokenVerificacao;

    @Column(name = "data_expiracao_token")
    private LocalDateTime dataExpiracaoToken;

    private boolean ativo = false;

    // Construtor, Getters e Setters (sem alterações)
    public Usuario() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getCpf() { return cpf; }
    public void setCpf(String cpf) { this.cpf = cpf; }
    public String getSenhaHash() { return senhaHash; }
    public void setSenhaHash(String senhaHash) { this.senhaHash = senhaHash; }
    public String getTokenVerificacao() { return tokenVerificacao; }
    public void setTokenVerificacao(String tokenVerificacao) { this.tokenVerificacao = tokenVerificacao; }
    public LocalDateTime getDataExpiracaoToken() { return dataExpiracaoToken; }
    public void setDataExpiracaoToken(LocalDateTime dataExpiracaoToken) { this.dataExpiracaoToken = dataExpiracaoToken; }
    public boolean isAtivo() { return ativo; }
    public void setAtivo(boolean ativo) { this.ativo = ativo; }
}

