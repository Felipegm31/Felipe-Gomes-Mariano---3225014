-- =====================================================
-- RELATÓRIOS ACADÊMICOS
-- =====================================================
-- Este script contém consultas analíticas sobre o modelo
-- acadêmico normalizado.
-- =====================================================


-- =====================================================
-- 1. LISTAGEM DE MATRICULADOS (CICLO 2026/1)
-- =====================================================
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


-- =====================================================
-- 2. BAIXO DESEMPENHO (MÉDIA < 6.0)
-- =====================================================
SELECT
    d.nome_disciplina,
    AVG(m.score_final) AS media_notas
FROM academico.matricula m
JOIN academico.disciplina d
    ON d.cod_servico_academico = m.cod_servico_academico
WHERE m.ativo = TRUE
GROUP BY d.nome_disciplina
HAVING AVG(m.score_final) < 6.0;


-- =====================================================
-- 3. ALOCAÇÃO DE DOCENTES (INCLUINDO SEM TURMA)
-- =====================================================
SELECT
    doc.nome_docente,
    dis.nome_disciplina
FROM academico.docente doc
LEFT JOIN academico.matricula m
    ON m.id_docente = doc.id_docente
LEFT JOIN academico.disciplina dis
    ON dis.cod_servico_academico = m.cod_servico_academico
ORDER BY doc.nome_docente;


-- =====================================================
-- 4. DESTAQUE ACADÊMICO (MELHOR NOTA EM BANCO DE DADOS)
-- =====================================================
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