SELECT
    d.nome_disciplina,
    AVG(m.score_final) AS media_notas
FROM academico.matricula m
JOIN academico.disciplina d
    ON d.cod_servico_academico = m.cod_servico_academico
WHERE m.ativo = TRUE
GROUP BY d.nome_disciplina
HAVING AVG(m.score_final) < 6.0;