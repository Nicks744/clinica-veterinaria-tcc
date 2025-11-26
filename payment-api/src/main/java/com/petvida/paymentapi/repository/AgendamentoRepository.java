package com.petvida.paymentapi.repository;

import com.petvida.paymentapi.model.Agendamento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AgendamentoRepository extends JpaRepository<Agendamento, Long> {

    List<Agendamento> findByUsuarioId(Long usuarioId);

    List<Agendamento> findByUsuarioIdAndTipo(Long usuarioId, String tipo);

    List<Agendamento> findByUsuarioIdAndNomePet(Long usuarioId, String nomePet);

    // ✅ MÉTODO ADICIONADO: Buscar por tipo
    List<Agendamento> findByTipo(String tipo);

    // ✅ MÉTODO: Deletar agendamentos por usuário
    @Modifying
    @Query("DELETE FROM Agendamento a WHERE a.usuarioId = :usuarioId")
    void deleteByUsuarioId(@Param("usuarioId") Long usuarioId);
}