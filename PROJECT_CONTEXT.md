# Operational Tracking - Contexto do Projeto

## Objetivo

Criar um aplicativo mobile offline-first para fiscalizacao e acompanhamento de obras.

O app deve funcionar totalmente offline no iPhone, sem login, sem internet, sem cloud e sem servidor no MVP.

## Usuario principal

Fiscal de obra que acompanha uma ou mais obras em campo e precisa registrar
andamento, fotos, ocorrencias, comentarios, mao de obra, status e gerar
relatorios confiaveis.

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
- Fiscalizacoes.
- Periodos da fiscalizacao.
- Mao de obra.
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
- Vincular a foto diretamente a uma fiscalizacao.

Decisao do MVP:

- Fotos permanecem vinculadas diretamente a fiscalizacao.
- A tela de fiscalizacao deve permitir tirar foto pela camera ou anexar imagem
  da galeria.
- Ao salvar uma foto, o usuario pode informar uma legenda opcional; legenda em
  branco nao deve aparecer no relatorio.
- O relatorio da fiscalizacao deve renderizar as fotos vinculadas a propria
  fiscalizacao como evidencias fotograficas.
- Medicao saiu do fluxo principal do MVP.

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
- Uma etapa possui varias fiscalizacoes.

Status possiveis:

- Nao comecou.
- Em andamento.
- Parada.
- Embargada.
- Atrasada.
- Concluida.

### Servico legado

Servico saiu do fluxo principal do MVP.

O codigo ainda pode manter tabelas e classes legadas para migracao e
compatibilidade de dados antigos, mas novas fiscalizacoes devem ser criadas a
partir da etapa.

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
- Relacionamentos de fiscalizacao e medicao por servico sao legados.

Status possiveis:

- Nao comecou.
- Em andamento.
- Parada.
- Embargada.
- Atrasada.
- Concluida.

### Fiscalizacao da etapa

Nome tecnico sugerido: `vistoria_servico`.

Representa a fiscalizacao diaria de uma etapa. Uma etapa pode ter varias
fiscalizacoes ao longo do tempo, mas apenas uma fiscalizacao por dia.

```text
vistoria_servico
- id
- etapa_id
- obra_id
- contratante_id
- responsavel_id
- numero
- data
- dia_semana
- status
- atividade
- ocorrencia
- comentario
```

Relacionamentos:

- Uma fiscalizacao pertence a uma etapa.
- Uma fiscalizacao aponta para a obra para facilitar consultas e relatorios.
- Uma fiscalizacao possui um contratante.
- Uma fiscalizacao possui um responsavel, que e funcionario do contratante.
- Uma fiscalizacao pode ter uma lista de mao de obra.
- Uma fiscalizacao pode ter periodos cadastrados para manha, tarde e noite.
- Uma fiscalizacao pode ter varias fotos.

Regra de unicidade:

- Deve existir no maximo uma `vistoria_servico` por `etapa_id` e `data`.

Status possiveis:

- Em andamento.
- Aprovada.
- Negada.

Observacoes:

- `numero` deve ser unico.
- `data` representa a data da fiscalizacao.
- `dia_semana` pode ser calculado a partir da `data`, mas pode ser armazenado para facilitar relatorio.
- `atividade` descreve o que esta acontecendo na etapa durante o dia.
- `ocorrencia` descreve qualquer coisa relevante que aconteceu durante o dia.
- `comentario` guarda observacoes gerais da fiscalizacao.
- O widget de resumo de fiscalizacoes no dashboard deve abrir uma tela com as
  fiscalizacoes em andamento.
- A tela de fiscalizacoes em aberto deve permitir editar a fiscalizacao e
  visualizar o PDF ja gerado quando existir arquivo local vinculado a ela.
- Relatorios PDF de fiscalizacao devem ter o id da fiscalizacao no nome do
  arquivo para permitir localizacao offline posterior.

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
- `tempo` nao deve usar radio button.
- `condicao` nao deve usar radio button.

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
- O funcionario deve pertencer a empresa contratada vinculada a obra da etapa.

### Medicao legado

Medicao saiu do fluxo principal do MVP.

```text
medicao
- id
- servico_id
- percentual_executado
- observacao
- data
```

Relacionamentos:

- Relacionamentos por servico sao legados.

### Foto da fiscalizacao

```text
vistoria_foto
- id
- vistoria_servico_id
- caminho_arquivo
- legenda
```

Relacionamentos:

- Uma fiscalizacao pode ter varias fotos.
- Uma foto pertence a uma fiscalizacao.
- Uma foto pode ter uma legenda opcional.

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

Regra sugerida:

- O progresso fisico da etapa e informado ou ajustado no acompanhamento da obra.
- O progresso fisico da obra e calculado a partir das etapas.

### Progresso de prazo

Obra e etapa possuem `progresso_prazo_dias`.

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
- Registrar fiscalizacoes diarias por etapa.
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
- Custos.
- Fiscalizacoes.
- Ocorrencias.
- Mao de obra.

Regras de apresentacao:

- Status devem aparecer com nomes humanizados no relatorio, mesmo que os enums
  internos continuem tecnicos.
- Mao de obra deve exibir o nome do funcionario quando existir cadastro
  vinculado.
- Fotos devem aparecer em miniaturas, organizadas em ate tres imagens por
  linha, sem exibir o caminho local do arquivo.
- A assinatura deve exibir o PNG cadastrado no funcionario responsavel do
  contratante, com o nome desse funcionario abaixo da linha.
- Todas as paginas do PDF devem ter rodape com o nome do app de um lado e a
  versao do outro.
- O inicio do relatorio deve usar um cabecalho visual profissional com resumo,
  status e metadados, evitando tabela simples para as informacoes principais.
- O cabecalho do relatorio nao deve exibir progresso fisico da obra ou da etapa.

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
5. Fiscalizacao diaria por etapa.
6. Periodos da fiscalizacao.
7. Mao de obra da fiscalizacao.
8. Fotos.
9. Dashboard local.
10. Exportacao PDF.

## Criterio de sucesso do MVP

Regis consegue sair para uma fiscalizacao sem internet, registrar o andamento
de uma etapa com atividade, status, periodo do dia, tempo, condicao,
ocorrencias, comentarios, mao de obra e fotos, fechar o app sem perder dados e
gerar um PDF local ao final da visita.

## Issues registradas

### Issue 27 - Melhorias de apresentacao do relatorio PDF

- Humanizar labels de status no PDF.
- Exibir nome do funcionario na mao de obra em vez do ID.
- Renderizar fotos em miniaturas, com tres imagens por linha.
- Remover caminho local da imagem no PDF.
- Remover progresso da obra do relatorio.

### Issue 28 - Assinatura e rodape nos relatorios PDF

- Exibir nome do funcionario representante do contratante na assinatura.
- Renderizar o PNG de assinatura cadastrado no funcionario quando existir.
- Colocar o nome do app e a versao no rodape de todas as paginas.
- Garantir que o relatorio nao volte a exibir progresso da obra.

### Issue 29 - Legenda opcional em fotos da fiscalizacao

- Ao tirar ou anexar uma foto, permitir informar uma legenda opcional.
- Salvar a legenda junto da foto da fiscalizacao.
- Exibir a legenda no relatorio abaixo da foto quando preenchida.
- Nao renderizar legenda vazia no relatorio.

### Issue 30 - Cabecalho profissional no inicio dos relatorios

- Substituir a tabela inicial de informacoes por um cabecalho visual.
- Destacar titulo, subtitulo e status no inicio do PDF.
- Organizar metadados principais em blocos compactos e legiveis.
- Remover progresso fisico do cabecalho.
