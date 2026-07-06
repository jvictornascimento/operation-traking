# Operational Tracking - Contexto do Projeto

## Objetivo

Criar um aplicativo mobile offline-first para fiscalizacao e acompanhamento de obras.

O app deve funcionar totalmente offline no iPhone, sem login, sem internet, sem cloud e sem servidor no MVP.

## Usuario principal

Fiscal de obra que acompanha uma ou mais obras em campo e precisa registrar andamento, medicoes, fotos, ocorrencias, comentarios, mao de obra, status e gerar relatorios confiaveis.

## Problema

Regis precisa acompanhar obras em campo com mais controle, visibilidade e padronizacao.

A rotina de obra pode envolver:

- Falta de internet.
- Bateria acabando.
- App sendo fechado sem querer.
- Interrupcoes por ligacoes.
- Fotos e observacoes soltas.
- Pendencias registradas em WhatsApp ou planilhas.

Por isso, o app precisa salvar automaticamente e manter historico de alteracoes.

## Conceito

Offline Operational Tracking.

Uma plataforma local para registrar operacoes de campo com evidencias, progresso, fiscalizacoes diarias e historico.

## Stack recomendada

- Flutter.
- Dart.
- Riverpod para estado.
- Drift + SQLite para banco local.
- GoRouter para rotas.
- Package `pdf` para relatorios locais.
- Storage local do app para fotos.

## Principios de arquitetura

### Offline-first

O banco local e a fonte primaria de verdade no MVP.

O sistema deve funcionar:

- Sem internet.
- Sem login.
- Sem cloud.
- Sem servidor.

### Splash e loading

O app possui uma tela de carregamento centralizada para abertura e estados de
loading entre telas/consultas locais.

Decisao para o asset visual:

- O GIF/animacao principal deve usar area de 160x160 px.
- A splash de abertura deve ter tempo maximo de 2,5 segundos.
- Enquanto o GIF final nao for fornecido, usar fallback visual nativo do app.

### Auto-save

Nenhuma informacao importante deve depender de botao "Salvar".

O app deve persistir automaticamente:

- Obras.
- Empresas.
- Contratantes.
- Funcionarios.
- Etapas.
- Servicos.
- Fiscalizacoes.
- Periodos da fiscalizacao.
- Mao de obra.
- Medicoes.
- Fotos.
- Observacoes.
- Progresso.
- Status.

### Historico de alteracoes

Nunca sobrescrever progresso ou status sem historico.

Toda alteracao relevante deve guardar:

- Entidade alterada.
- Campo alterado.
- Valor anterior.
- Novo valor.
- Data.
- Usuario local ou identificador do aparelho.

### Fotos

Nao salvar imagens diretamente no banco.

Estrategia:

- Salvar a imagem no storage local do app.
- Guardar no banco apenas o caminho do arquivo.
- Vincular a foto a uma medicao.

Decisao do MVP:

- Fotos permanecem vinculadas a medicoes.
- A tela de fiscalizacao deve permitir tirar ou anexar fotos nas medicoes
  daquela fiscalizacao.
- A fiscalizacao consome fotos pelas medicoes registradas nela.
- O relatorio da fiscalizacao deve renderizar as fotos vinculadas as medicoes
  como evidencias fotograficas.
- Essa decisao evita duplicidade de origem da evidencia e preserva o fluxo
  fiscalizacao > medicao > fotos.

## Modelo de dados

### Obra

```text
obra
- id
- empresa_id
- contratante_id
- endereco_id
- nome
- numero_contrato
- valor_contrato
- responsavel_nome
- responsavel_contato
- data_inicio
- data_fim
- status
- progresso_fisico
- progresso_prazo_dias
```

Campos derivados para visualizacao, sem persistencia:

- dias_totais_contrato
- dias_decorridos
- dias_restantes

Relacionamentos:

- Uma obra pertence a uma empresa.
- Uma obra pode indicar o contratante solicitante.
- Uma obra possui um endereco.
- Uma empresa pode ter varias obras.
- Um contratante pode ter varias obras.
- Uma obra possui varias etapas.
- Uma obra pode aparecer em varias fiscalizacoes.

Status possiveis:

- Nao comecou.
- Em andamento.
- Parada.
- Embargada.
- Atrasada.
- Concluida.

### Empresa

Empresa contratada ou executora.

```text
empresa
- id
- nome
- cnpj
- ie
```

Relacionamentos:

- Uma empresa pode ter varios enderecos.
- Uma empresa pode ter varios contatos.
- Uma empresa pode ter varios funcionarios.
- Uma empresa pode ter varias obras.

### Contratante

Entidade equivalente a empresa, usada para representar quem contratou ou solicitou a obra.

```text
contratante
- id
- nome
- cnpj
- ie
```

Relacionamentos:

- Um contratante pode ter varios enderecos.
- Um contratante pode ter varios contatos.
- Um contratante pode ter varios funcionarios.
- Um contratante pode aparecer em varias fiscalizacoes.

Observacao:

- A estrutura inicial e igual a `empresa`.
- Futuramente, `empresa` e `contratante` podem virar uma tabela unica com campo `tipo`.

### Funcionario

```text
funcionario
- id
- empresa_id
- contratante_id
- nome
- cpf
- telefone
- cargo
- tipo
- assinatura_path
```

Relacionamentos:

- Um funcionario pertence a uma empresa ou a um contratante.
- Um funcionario pode ter varios enderecos.
- Um funcionario pode ter varios contatos.
- Um funcionario de contratante pode ser responsavel por uma fiscalizacao.
- Um funcionario de empresa pode entrar na lista de mao de obra de uma fiscalizacao.

Regra:

- Para funcionario de empresa contratada, usar `empresa_id`.
- Para funcionario de contratante, usar `contratante_id`.
- Apenas um dos dois campos deve ser preenchido por registro.
- `tipo` deve ser `func_empresa` para funcionario de empresa contratada.
- `tipo` deve ser `func_contratante` para funcionario de contratante.
- Funcionarios de contratante podem ter assinatura em PNG salva no storage local
  do app, mantendo no banco apenas `assinatura_path`.

### Endereco

```text
endereco
- id
- entidade
- entidade_id
- tipo
- cep
- logradouro
- numero
- complemento
- bairro
- cidade
- estado
- pais
```

Uso:

- Endereco de empresa.
- Endereco de contratante.
- Endereco de funcionario.
- Endereco de obra.

Regra:

- `entidade` indica a origem: `empresa`, `contratante`, `funcionario` ou `obra`.
- `entidade_id` guarda o ID da entidade relacionada.

### Contato

```text
contato
- id
- entidade
- entidade_id
- tipo
- valor
- observacao
```

Tipos possiveis:

- Email.
- Telefone.
- WhatsApp.
- Outro.

Uso:

- Contato de empresa.
- Contato de contratante.
- Contato de funcionario.

Regra:

- `entidade` indica a origem: `empresa`, `contratante` ou `funcionario`.
- `entidade_id` guarda o ID da entidade relacionada.

### Etapa

```text
etapa
- id
- obra_id
- nome
- data_inicio
- data_fim
- status
- progresso_fisico
- progresso_prazo_dias
```

Relacionamentos:

- Uma obra possui varias etapas.
- Uma etapa pertence a uma obra.
- Uma etapa possui varios servicos.

Status possiveis:

- Nao comecou.
- Em andamento.
- Parada.
- Embargada.
- Atrasada.
- Concluida.

### Servico

```text
servico
- id
- etapa_id
- nome
- preco_total
- unidade
- quantidade
- data_inicio
- data_fim
- status
- progresso_fisico
- progresso_prazo_dias
```

Relacionamentos:

- Uma etapa possui varios servicos.
- Um servico pertence a uma etapa.
- Um servico pode ter varias fiscalizacoes.
- Um servico so pode ter uma fiscalizacao por dia.
- Um servico possui varias medicoes.

Status possiveis:

- Nao comecou.
- Em andamento.
- Parada.
- Embargada.
- Atrasada.
- Concluida.

### Fiscalizacao do servico

Nome tecnico sugerido: `vistoria_servico`.

Representa a fiscalizacao diaria de um servico. Um servico pode ter varias fiscalizacoes ao longo do tempo, mas apenas uma fiscalizacao por dia.

```text
vistoria_servico
- id
- servico_id
- obra_id
- contratante_id
- responsavel_id
- numero
- data
- dia_semana
- status
- ocorrencia
- comentario
```

Relacionamentos:

- Uma fiscalizacao pertence a um servico.
- Uma fiscalizacao aponta para a obra para facilitar consultas e relatorios.
- Uma fiscalizacao possui um contratante.
- Uma fiscalizacao possui um responsavel, que e funcionario do contratante.
- Uma fiscalizacao pode ter uma lista de mao de obra.
- Uma fiscalizacao pode ter periodos cadastrados para manha, tarde e noite.

Regra de unicidade:

- Deve existir no maximo uma `vistoria_servico` por `servico_id` e `data`.

Status possiveis:

- Em andamento.
- Aprovada.
- Negada.

Observacoes:

- `numero` deve ser unico.
- `data` representa a data da fiscalizacao.
- `dia_semana` pode ser calculado a partir da `data`, mas pode ser armazenado para facilitar relatorio.
- `ocorrencia` descreve qualquer coisa relevante que aconteceu durante o dia.
- `comentario` guarda observacoes gerais da fiscalizacao.

### Periodo da fiscalizacao

Tabela filha da fiscalizacao para registrar condicoes por periodo do dia.

```text
vistoria_periodo
- id
- vistoria_servico_id
- periodo
- tempo
- condicao
```

Relacionamentos:

- Uma fiscalizacao pode ter ate tres periodos.
- Cada periodo pertence a uma fiscalizacao.

Regra de unicidade:

- Deve existir no maximo um `vistoria_periodo` por `vistoria_servico_id` e `periodo`.

Periodos possiveis:

- Manha.
- Tarde.
- Noite.

Tempo possivel:

- Claro.
- Nublado.
- Chuvoso.

Condicao possivel:

- Praticavel.
- Impraticavel.

Regra de interface:

- `periodo` pode ser representado por checkboxes: manha, tarde e noite.
- Para cada periodo marcado, o usuario escolhe apenas uma opcao de `tempo`.
- Para cada periodo marcado, o usuario escolhe apenas uma opcao de `condicao`.
- `tempo` deve funcionar como radio group.
- `condicao` deve funcionar como radio group.

### Mao de obra da fiscalizacao

Tabela de relacionamento entre fiscalizacao e funcionarios da empresa contratada.

```text
vistoria_mao_de_obra
- id
- vistoria_servico_id
- funcionario_id
- funcao_no_dia
- observacao
```

Relacionamentos:

- Uma fiscalizacao pode ter varios funcionarios como mao de obra.
- Um funcionario pode aparecer em varias fiscalizacoes.
- O funcionario deve pertencer a empresa contratada vinculada a obra ou ao servico.

### Medicao

```text
medicao
- id
- servico_id
- percentual_executado
- observacao
- data
```

Relacionamentos:

- Um servico possui varias medicoes.
- Uma medicao pertence a um servico.

### Foto

```text
foto
- id
- medicao_id
- caminho_arquivo
```

Relacionamentos:

- Uma medicao pode ter varias fotos.
- Uma foto pertence a uma medicao.

### Historico de alteracoes

```text
historico_alteracao
- id
- entidade
- entidade_id
- campo
- valor_anterior
- valor_novo
- data
- usuario
```

Uso inicial:

- Registrar mudancas de progresso.
- Registrar alteracoes de medicao.
- Registrar mudancas de status.
- Registrar alteracoes relevantes em fiscalizacoes.

## Regras de progresso

### Progresso fisico

O progresso fisico existe em tres niveis:

- Obra.
- Etapa.
- Servico.

Regra sugerida:

- O progresso fisico do servico e informado por medicoes.
- O progresso fisico da etapa e calculado a partir dos servicos.
- O progresso fisico da obra e calculado a partir das etapas.

### Progresso de prazo

Obra, etapa e servico possuem `progresso_prazo_dias`.

Esse campo representa a contagem de prazo em dias:

- Valor positivo: dias restantes.
- Valor zero: vence hoje.
- Valor negativo: dias em atraso.

Exemplo:

```text
data_inicio: 10/05
data_fim: 20/05
data_atual: 18/05
progresso_prazo_dias: 2

data_atual: 21/05
progresso_prazo_dias: -1
```

Regra:

- O status `Atrasada` pode ser aplicado automaticamente quando `progresso_prazo_dias` for negativo e a entidade ainda nao estiver concluida.

## MVP

### Funcionalidades

- Criar e editar obras.
- Definir status da obra.
- Criar empresas.
- Criar contratantes.
- Criar funcionarios.
- Cadastrar enderecos e contatos.
- Criar etapas.
- Criar servicos.
- Registrar medicoes.
- Registrar fiscalizacoes diarias por servico.
- Registrar periodos da fiscalizacao.
- Registrar mao de obra da fiscalizacao.
- Registrar fotos.
- Visualizar dashboard local.
- Gerar relatorio PDF local.

### Relatorios

O PDF local deve permitir:

- Tabelas.
- Fotos.
- Assinatura.
- Progresso da obra.
- Custos.
- Fiscalizacoes.
- Ocorrencias.
- Mao de obra.

Compartilhamento esperado:

- WhatsApp.
- Email.
- AirDrop.
- Arquivos locais do iPhone.

### Fora do escopo agora

- Login.
- Cloud.
- Firebase.
- Multiusuario.
- IA.
- Chat.
- Geolocalizacao.
- Dashboard web.
- Cobranca por assinatura.

## Prioridade de construcao

1. Estrutura do banco local.
2. Cadastro de empresas, contratantes e funcionarios.
3. Cadastro de obras.
4. Cadastro de etapas.
5. Cadastro de servicos.
6. Fiscalizacao diaria por servico.
7. Periodos da fiscalizacao.
8. Mao de obra da fiscalizacao.
9. Medicoes.
10. Fotos.
11. Dashboard local.
12. Exportacao PDF.

## Criterio de sucesso do MVP

Regis consegue sair para uma fiscalizacao sem internet, registrar o andamento de um servico com status, periodo do dia, tempo, condicao, ocorrencias, comentarios, mao de obra, medicoes e fotos, fechar o app sem perder dados e gerar um PDF local ao final da visita.
