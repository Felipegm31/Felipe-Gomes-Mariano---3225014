>> Modelo Lógico (Detalhado) <<
# Usuario #

- ID_Matricula (PK)
- Nome_Usuario
- Email_Usuario
- Endereco_Usuario

# Disciplina #

- Cod_Servico_Academico (PK)
- Nome_Disciplina
- Carga_H

# Docente #
- ID_Docente (PK)
- Nome_Docente

# Operador #
- Matricula_Operador_Pedagogico (PK)

# Matricula (Fato / Relacionamento) #
- ID_Matricula (FK)
- Cod_Servico_Academico (FK)
- Nome_Docente (FK lógico)
- Matricula_Operador_Pedagogico (FK)
- Data_Ingresso
- Score_Final
- Ciclo_Calendario
