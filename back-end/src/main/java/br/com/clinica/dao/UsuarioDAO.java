package br.com.clinica.dao;

import br.com.clinica.model.Usuario;
import jakarta.persistence.EntityManager;     // <-- MUDANÇA CRÍTICA
import jakarta.persistence.NoResultException; // <-- MUDANÇA CRÍTICA
import jakarta.persistence.TypedQuery;      // <-- MUDANÇA CRÍTICA
import java.util.Optional;

public class UsuarioDAO {
    private EntityManager em;

    public UsuarioDAO(EntityManager em) {
        this.em = em;
    }

    public void salvar(Usuario usuario) {
        this.em.persist(usuario);
    }

    public void atualizar(Usuario usuario) {
        this.em.merge(usuario);
    }

    public Optional<Usuario> findByEmail(String email) {
        try {
            TypedQuery<Usuario> query = em.createQuery("SELECT u FROM Usuario u WHERE u.email = :email", Usuario.class);
            query.setParameter("email", email);
            return Optional.of(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }

    // ... os outros métodos (findByCpf, findByToken) são iguais, apenas a importação no topo muda ...
    public Optional<Usuario> findByCpf(String cpf) {
        // ...
        return Optional.empty();
    }
    public Optional<Usuario> findByTokenVerificacao(String token) {
        // ...
        return Optional.empty();
    }
}

