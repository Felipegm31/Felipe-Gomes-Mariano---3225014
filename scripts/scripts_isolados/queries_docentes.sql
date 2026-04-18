SELECT
    doc.nome_docente,
    dis.nome_disciplina
FROM academico.docente doc
LEFT JOIN academico.matricula m
    ON m.id_docente = doc.id_docente
LEFT JOIN academico.disciplina dis
    ON dis.cod_servico_academico = m.cod_servico_academico
ORDER BY doc.nome_docente;