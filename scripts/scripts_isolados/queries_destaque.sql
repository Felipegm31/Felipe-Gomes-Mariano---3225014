SELECT
    u.nome_usuario,
    m.score_final
FROM academico.matricula m
JOIN academico.usuario u
    ON u.id_matricula = m.id_matricula
JOIN academico.disciplina d
    ON d.cod_servico_academico = m.cod_servico_academico
WHERE d.nome_disciplina = 'Banco de Dados'
  AND m.score_final = (
        SELECT MAX(m2.score_final)
        FROM academico.matricula m2
        JOIN academico.disciplina d2
            ON d2.cod_servico_academico = m2.cod_servico_academico
        WHERE d2.nome_disciplina = 'Banco de Dados'
  );