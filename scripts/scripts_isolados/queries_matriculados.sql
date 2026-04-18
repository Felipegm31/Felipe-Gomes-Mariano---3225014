SELECT
    u.nome_usuario,
    d.nome_disciplina,
    m.ciclo_calendario
FROM academico.matricula m
JOIN academico.usuario u 
    ON u.id_matricula = m.id_matricula
JOIN academico.disciplina d 
    ON d.cod_servico_academico = m.cod_servico_academico
WHERE m.ciclo_calendario = '2026/1'
  AND m.ativo = TRUE;