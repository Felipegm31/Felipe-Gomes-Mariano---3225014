## Neste arquivo estão contidas somente as respostas teóricas solicitadas. ##

1. Modelagem e Arquitetura (Teoria)

Tarefa: No arquivo /docs/respostas.md, responda às seguintes questões:

    - SGBD: Justifique a escolha de um SGBD Relacional (ex: PostgreSQL) em vez de um modelo NoSQL para este cenário, focando em propriedades ACID e integridade de dados.
    Organização: Por que em um ambiente profissional de Engenharia de Dados é recomendado o uso de Schemas (ex: academico, seguranca) em vez de criar todas as tabelas no esquema padrão public.
    R: Utilizaremos o Portgresql (relacional) pois estamos tratando de dados estruturados, onde respeitam uma identificação clara, concisa e linear. 
    Exp: Todos os itens da coluna (campo) "Cod_Servico_Academico" são uma string de 6 dígitos. Todos os itens da coluna (campo) "Carga_H seguem um tipo de valor numérico. 

    - Organização: Por que em um ambiente profissional de Engenharia de Dados é recomendado o uso de Schemas (ex: academico, seguranca) em vez de criar todas as tabelas no esquema padrão public?
    R: Dessa forma a relação entre as diversas tabelas fica mais clara e estruturada. Permitindo uma visualização e navegação entre elas com uma lógica mais fluida.
;

2. Modelo Lógico Detalhado:

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


5. Tarefa: No arquivo /docs/respostas.md, analise o seguinte cenário: Dois operadores da secretaria tentam alterar a nota do mesmo ID_Matricula exatamente ao mesmo tempo.
    Explique como os conceitos de Isolamento (ACID) e o uso de Locks (bloqueios) pelo SGBD garantem que o dado final seja consistente e não corrompido.

        R: O isolamento garante que transações concorrentes não interfiram de forma inconsistente, enquanto os locks — especialmente row-level exclusive locks — impedem que duas transações modifiquem o mesmo registro simultaneamente. Isso força uma ordem de execução, evitando problemas como lost updates e garantindo consistência dos dados.
        Propriedade de "Isolamento" do ACID: Cada transação deve se comportar como se estivesse rodando sozinha no banco.