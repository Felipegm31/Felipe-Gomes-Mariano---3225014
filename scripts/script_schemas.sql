-- =========================================
-- 1. NAMESPACES (SCHEMAS)
-- =========================================
CREATE SCHEMA IF NOT EXISTS academico;
CREATE SCHEMA IF NOT EXISTS seguranca;

-- =========================================
-- 2. TABELAS (DDL)
-- =========================================

-- =====================
-- USUARIO
-- =====================
CREATE TABLE academico.usuario (
    id_matricula INT PRIMARY KEY,
    nome_usuario VARCHAR(150) NOT NULL,
    email_usuario VARCHAR(150) UNIQUE NOT NULL,
    endereco_usuario TEXT,
    ativo BOOLEAN DEFAULT TRUE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================
-- DISCIPLINA
-- =====================
CREATE TABLE academico.disciplina (
    cod_servico_academico INT PRIMARY KEY,
    nome_disciplina VARCHAR(150) NOT NULL,
    carga_h INT NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

-- =====================
-- DOCENTE
-- =====================
CREATE TABLE academico.docente (
    id_docente SERIAL PRIMARY KEY,
    nome_docente VARCHAR(150) NOT NULL,
    ativo BOOLEAN DEFAULT TRUE
);

-- =====================
-- OPERADOR PEDAGÓGICO
-- =====================
CREATE TABLE academico.operador (
    matricula_operador_pedagogico INT PRIMARY KEY,
    ativo BOOLEAN DEFAULT TRUE
);

-- =====================
-- MATRÍCULA (FATO)
-- =====================
CREATE TABLE academico.matricula (
    id_matricula INT,
    cod_servico_academico INT,
    id_docente INT,
    matricula_operador_pedagogico INT,
    data_ingresso DATE,
    score_final NUMERIC(4,2),
    ciclo_calendario VARCHAR(10),
    ativo BOOLEAN DEFAULT TRUE,

    PRIMARY KEY (id_matricula, cod_servico_academico, ciclo_calendario),

    CONSTRAINT fk_usuario
        FOREIGN KEY (id_matricula)
        REFERENCES academico.usuario(id_matricula),

    CONSTRAINT fk_disciplina
        FOREIGN KEY (cod_servico_academico)
        REFERENCES academico.disciplina(cod_servico_academico),

    CONSTRAINT fk_docente
        FOREIGN KEY (id_docente)
        REFERENCES academico.docente(id_docente),

    CONSTRAINT fk_operador
        FOREIGN KEY (matricula_operador_pedagogico)
        REFERENCES academico.operador(matricula_operador_pedagogico)
);

-- =========================================
-- 3. GOVERNANÇA (SOFT DELETE)
-- =========================================

-- Função genérica para bloquear DELETE físico
CREATE OR REPLACE FUNCTION seguranca.block_delete()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'DELETE físico não permitido. Use UPDATE (ativo = false).';
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger em todas as tabelas
CREATE TRIGGER trg_no_delete_usuario
BEFORE DELETE ON academico.usuario
FOR EACH ROW EXECUTE FUNCTION seguranca.block_delete();

CREATE TRIGGER trg_no_delete_disciplina
BEFORE DELETE ON academico.disciplina
FOR EACH ROW EXECUTE FUNCTION seguranca.block_delete();

CREATE TRIGGER trg_no_delete_docente
BEFORE DELETE ON academico.docente
FOR EACH ROW EXECUTE FUNCTION seguranca.block_delete();

CREATE TRIGGER trg_no_delete_operador
BEFORE DELETE ON academico.operador
FOR EACH ROW EXECUTE FUNCTION seguranca.block_delete();

CREATE TRIGGER trg_no_delete_matricula
BEFORE DELETE ON academico.matricula
FOR EACH ROW EXECUTE FUNCTION seguranca.block_delete();

-- =========================================
-- 4. SEGURANÇA (DCL)
-- =========================================

-- =====================
-- ROLES
-- =====================
CREATE ROLE professor_role;
CREATE ROLE coordenador_role;

-- =====================
-- PERMISSÕES - COORDENADOR (FULL ACCESS)
-- =====================
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA academico TO coordenador_role;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA academico TO coordenador_role;

-- =====================
-- PERMISSÕES - PROFESSOR
-- =====================

-- Permissão de leitura (exceto email - será tratado via VIEW)
GRANT SELECT ON academico.disciplina TO professor_role;
GRANT SELECT ON academico.docente TO professor_role;
GRANT SELECT ON academico.matricula TO professor_role;

-- UPDATE apenas na coluna score_final
GRANT UPDATE (score_final) ON academico.matricula TO professor_role;

-- =========================================
-- 5. PRIVACIDADE (ESCONDER EMAIL)
-- =========================================

-- Criar VIEW sem email
CREATE VIEW academico.usuario_publico AS
SELECT
    id_matricula,
    nome_usuario,
    endereco_usuario
FROM academico.usuario
WHERE ativo = TRUE;

-- Permitir acesso à view
GRANT SELECT ON academico.usuario_publico TO professor_role;

-- NÃO conceder acesso direto à tabela usuario
REVOKE ALL ON academico.usuario FROM professor_role;

-- =========================================
-- 6. BOAS PRÁTICAS (EXTRA)
-- =========================================

-- Garantir que novos objetos herdem permissões
ALTER DEFAULT PRIVILEGES IN SCHEMA academico
GRANT SELECT ON TABLES TO professor_role;

ALTER DEFAULT PRIVILEGES IN SCHEMA academico
GRANT ALL ON TABLES TO coordenador_role;