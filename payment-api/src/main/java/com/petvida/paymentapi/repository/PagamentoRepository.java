package com.petvida.paymentapi.repository;

import com.petvida.paymentapi.model.Pagamento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PagamentoRepository extends JpaRepository<Pagamento, Long> {

    List<Pagamento> findByUsuarioId(Long usuarioId);

    Optional<Pagamento> findByIdTransacao(String idTransacao);

    // ✅ NOVO MÉTODO: Deletar pagamentos por usuário
    @Modifying
    @Query("DELETE FROM Pagamento p WHERE p.usuarioId = :usuarioId")
    void deleteByUsuarioId(@Param("usuarioId") Long usuarioId);
}