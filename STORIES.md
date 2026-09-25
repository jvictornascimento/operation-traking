# Stories - belis-oversight

Este arquivo organiza o desenvolvimento do app do começo ao fim, com base em `PROJECT_CONTEXT.md`.

Formato recomendado de branch:

```text
feature/<segmento>
fix/<segmento>
test/<segmento>
docs/<segmento>
```

Formato recomendado de commit:

```text
tipo(escopo): descricao curta
```

Exemplo:

```text
feat(obras): adiciona cadastro de obra
test(progresso): cobre calculo de dias atrasados
```

## Epic 0 - Fundacao do projeto

### Story 0.1 - Inicializar projeto Flutter real

Como desenvolvedor, quero transformar o esqueleto atual em um projeto Flutter executavel para que o app possa compilar em iOS e Android.

Critérios de aceite:

- Projeto criado com `flutter create`.
- Estrutura `lib/` existente preservada.
- App abre uma tela inicial simples.
- `flutter analyze` executa sem erro bloqueante.
- `flutter test` executa.

Branch sugerida:

```text
chore/flutter-create
```

Commits sugeridos:

```text
chore(project): inicializa projeto flutter
chore(project): preserva estrutura por features
```

### Story 0.2 - Configurar dependencias base

Como desenvolvedor, quero configurar as dependencias principais para que a arquitetura do app fique pronta para evoluir.

Critérios de aceite:

- `flutter_riverpod` instalado.
- `go_router` instalado.
- `drift`, `drift_dev`, `sqlite3_flutter_libs`, `path_provider` e `path` instalados.
- `pdf`, `printing` e `share_plus` instalados.
- `image_picker` instalado.
- Projeto roda `flutter pub get` sem conflitos.

Branch sugerida:

```text
chore/dependencias-base
```

Commits sugeridos:

```text
chore(deps): adiciona dependencias base
build(deps): configura geradores do drift
```

### Story 0.3 - Configurar tema e rotas iniciais

Como usuario, quero navegar por uma estrutura inicial do app para acessar as areas principais.

Critérios de aceite:

- `MaterialApp.router` configurado.
- `GoRouter` configurado.
- Rotas iniciais para dashboard, obras, empresas, contratantes e configuracoes.
- Tema Material 3 configurado.
- Tela inicial mostra entrada para obras e fiscalizacoes.

Branch sugerida:

```text
feature/rotas-iniciais
```

Commits sugeridos:

```text
feat(router): configura rotas iniciais
feat(theme): adiciona tema base do app
```

## Epic 1 - Banco local e modelos de dominio

### Story 1.1 - Criar entidades de dominio

Como desenvolvedor, quero representar as entidades principais em Dart para que as regras de negocio sejam testaveis sem depender da UI.

Critérios de aceite:

- Entidades criadas para `Obra`, `Empresa`, `Contratante`, `Funcionario`, `Endereco`, `Contato`, `Etapa`, `Servico`, `VistoriaServico`, `VistoriaPeriodo`, `VistoriaMaoDeObra`, `Medicao`, `Foto` e `HistoricoAlteracao`.
- Enums criados para status, periodo, tempo e condicao.
- Entidades ficam em `domain/`.
- Testes unitarios cobrem criacao e validacoes simples.

Branch sugerida:

```text
feature/modelos-dominio
```

Commits sugeridos:

```text
feat(domain): cria entidades principais
feat(domain): adiciona enums do dominio
test(domain): cobre validacoes basicas
```

### Story 1.2 - Configurar Drift e SQLite

Como desenvolvedor, quero um banco local relacional para persistir todos os dados offline.

Critérios de aceite:

- `AppDatabase` configurado com Drift.
- Banco abre localmente usando SQLite.
- Migrations iniciais preparadas.
- Tabelas criadas para todas as entidades do MVP.
- IDs e relacionamentos definidos.
- Indices criados para consultas frequentes.

Branch sugerida:

```text
feature/database-drift
```

Commits sugeridos:

```text
feat(database): configura drift sqlite
feat(database): adiciona tabelas iniciais
```

### Story 1.3 - Garantir unicidade de fiscalizacao por servico e data

Como fiscal, quero que cada servico tenha apenas uma fiscalizacao por dia para evitar duplicidade de registro.

Critérios de aceite:

- Banco impede duplicidade por `servico_id` e `data`.
- Repositorio retorna erro controlado ao tentar duplicar.
- Teste cobre tentativa de criar duas fiscalizacoes no mesmo dia para o mesmo servico.
- Permite fiscalizacoes em dias diferentes.

Branch sugerida:

```text
feature/regra-vistoria-unica
```

Commits sugeridos:

```text
feat(fiscalizacao): impede vistoria duplicada por dia
test(fiscalizacao): cobre unicidade por servico e data
```

## Epic 2 - Cadastros base

### Story 2.1 - Cadastro de empresas

Como usuario, quero cadastrar empresas contratadas para vincular obras, funcionarios e mao de obra.

Critérios de aceite:

- Criar empresa com nome, CNPJ e IE.
- Editar empresa.
- Listar empresas.
- Validar nome obrigatorio.
- Persistir offline.
- Auto-save ou salvamento automatico ao sair do campo, conforme padrao definido.

Branch sugerida:

```text
feature/cadastro-empresas
```

Commits sugeridos:

```text
feat(empresas): adiciona cadastro de empresas
test(empresas): cobre validacao de empresa
```

### Story 2.2 - Cadastro de contratantes

Como usuario, quero cadastrar contratantes para associar quem solicitou ou contratou a obra.

Critérios de aceite:

- Criar contratante com nome, CNPJ e IE.
- Editar contratante.
- Listar contratantes.
- Validar nome obrigatorio.
- Persistir offline.

Branch sugerida:

```text
feature/cadastro-contratantes
```

Commits sugeridos:

```text
feat(contratantes): adiciona cadastro de contratantes
test(contratantes): cobre validacao de contratante
```

### Story 2.3 - Cadastro de enderecos

Como usuario, quero cadastrar enderecos para empresas, contratantes, funcionarios e obras.

Critérios de aceite:

- Criar endereco com tipo, CEP, logradouro, numero, complemento, bairro, cidade, estado e pais.
- Vincular endereco a `empresa`, `contratante`, `funcionario` ou `obra`.
- Listar enderecos por entidade.
- Editar endereco.
- Persistir offline.

Branch sugerida:

```text
feature/cadastro-enderecos
```

Commits sugeridos:

```text
feat(enderecos): adiciona cadastro generico
test(enderecos): cobre vinculo por entidade
```

### Story 2.4 - Cadastro de contatos

Como usuario, quero cadastrar contatos para empresas, contratantes e funcionarios.

Critérios de aceite:

- Criar contato com tipo, valor e observacao.
- Tipos suportados: email, telefone, WhatsApp e outro.
- Vincular contato a `empresa`, `contratante` ou `funcionario`.
- Listar contatos por entidade.
- Editar contato.
- Persistir offline.

Branch sugerida:

```text
feature/cadastro-contatos
```

Commits sugeridos:

```text
feat(contatos): adiciona cadastro generico
test(contatos): cobre tipos de contato
```

### Story 2.5 - Cadastro de funcionarios

Como usuario, quero cadastrar funcionarios de empresas e contratantes para usar em responsaveis e mao de obra.

Critérios de aceite:

- Criar funcionario com nome, CPF e cargo.
- Funcionario pode pertencer a uma empresa ou a um contratante.
- Sistema impede funcionario com empresa e contratante preenchidos ao mesmo tempo.
- Sistema impede funcionario sem empresa e sem contratante.
- Editar funcionario.
- Listar funcionarios por empresa ou contratante.
- Persistir offline.

Branch sugerida:

```text
feature/cadastro-funcionarios
```

Commits sugeridos:

```text
feat(funcionarios): adiciona cadastro de funcionarios
test(funcionarios): valida origem do funcionario
```

## Epic 3 - Obras, etapas e servicos

### Story 3.1 - Cadastro de obras

Como usuario, quero cadastrar obras para acompanhar fiscalizacao, progresso e prazo.

Critérios de aceite:

- Criar obra com empresa, endereco, nome, data de inicio, data de fim e status.
- Editar obra.
- Listar obras.
- Visualizar detalhe da obra.
- Status inicial pode ser `Nao comecou`.
- Persistir offline.

Branch sugerida:

```text
feature/cadastro-obras
```

Commits sugeridos:

```text
feat(obras): adiciona cadastro de obras
test(obras): cobre status inicial
```

### Story 3.2 - Calculo de prazo da obra

Como usuario, quero ver quantos dias faltam ou quantos dias a obra esta atrasada.

Critérios de aceite:

- Calcular `progresso_prazo_dias` com base em `data_fim`.
- Valor positivo indica dias restantes.
- Valor zero indica vencimento hoje.
- Valor negativo indica dias em atraso.
- Status muda para `Atrasada` quando prazo for negativo e obra nao estiver concluida.
- Testes cobrem dias restantes, vencimento hoje e atraso.

Branch sugerida:

```text
feature/prazo-obras
```

Commits sugeridos:

```text
feat(obras): calcula prazo em dias
test(obras): cobre prazo restante e atraso
```

### Story 3.3 - Cadastro de etapas

Como usuario, quero cadastrar etapas dentro de uma obra para organizar a execucao.

Critérios de aceite:

- Criar etapa com obra, nome, data de inicio, data de fim e status.
- Editar etapa.
- Listar etapas por obra.
- Visualizar detalhe da etapa.
- Persistir offline.

Branch sugerida:

```text
feature/cadastro-etapas
```

Commits sugeridos:

```text
feat(etapas): adiciona cadastro de etapas
test(etapas): cobre vinculo com obra
```

### Story 3.4 - Cadastro de servicos

Como usuario, quero cadastrar servicos dentro de uma etapa para controlar execucao, valor e fiscalizacoes.

Critérios de aceite:

- Criar servico com etapa, nome, preco total, unidade, quantidade, data de inicio, data de fim e status.
- Editar servico.
- Listar servicos por etapa.
- Visualizar detalhe do servico.
- Persistir offline.

Branch sugerida:

```text
feature/cadastro-servicos
```

Commits sugeridos:

```text
feat(servicos): adiciona cadastro de servicos
test(servicos): cobre vinculo com etapa
```

### Story 3.5 - Progresso fisico por medicoes

Como usuario, quero que o progresso fisico seja calculado a partir das medicoes para evitar divergencia manual.

Critérios de aceite:

- Progresso fisico do servico vem das medicoes.
- Progresso fisico da etapa vem dos servicos.
- Progresso fisico da obra vem das etapas.
- Testes cobrem calculos nos tres niveis.

Branch sugerida:

```text
feature/progresso-fisico
```

Commits sugeridos:

```text
feat(progresso): calcula progresso fisico
test(progresso): cobre calculo por hierarquia
```

## Epic 4 - Fiscalizacao diaria

### Story 4.1 - Criar fiscalizacao diaria de servico

Como fiscal, quero criar uma fiscalizacao diaria para um servico para registrar o que aconteceu naquele dia.

Critérios de aceite:

- Criar fiscalizacao vinculada a servico, obra, contratante e responsavel.
- Gerar ou informar numero unico.
- Preencher data e dia da semana.
- Status inicial pode ser `Em andamento`.
- Campo de ocorrencia disponivel.
- Campo de comentario disponivel.
- Persistir offline.
- Permitir edicao posterior.

Branch sugerida:

```text
feature/fiscalizacao-servico
```

Commits sugeridos:

```text
feat(fiscalizacao): adiciona vistoria diaria
test(fiscalizacao): cobre criacao de vistoria
```

### Story 4.2 - Status da fiscalizacao

Como fiscal, quero controlar se a fiscalizacao esta em andamento, aprovada ou negada.

Critérios de aceite:

- Status possiveis: `Em andamento`, `Aprovada`, `Negada`.
- Usuario pode alterar status.
- Alteracao de status gera historico.
- Status aparece na lista e detalhe da fiscalizacao.

Branch sugerida:

```text
feature/status-fiscalizacao
```

Commits sugeridos:

```text
feat(fiscalizacao): adiciona controle de status
test(fiscalizacao): cobre alteracao de status
```

### Story 4.3 - Periodos da fiscalizacao

Como fiscal, quero marcar manha, tarde e noite e informar tempo e condicao de cada periodo.

Critérios de aceite:

- UI exibe checkboxes para manha, tarde e noite.
- Para cada periodo marcado, exibe radio group de tempo.
- Tempo permite apenas uma opcao: claro, nublado ou chuvoso.
- Para cada periodo marcado, exibe radio group de condicao.
- Condicao permite apenas uma opcao: praticavel ou impraticavel.
- Persistir periodos offline.
- Impedir periodo duplicado na mesma fiscalizacao.
- Testes cobrem validacao de periodo, tempo e condicao.

Branch sugerida:

```text
feature/periodos-fiscalizacao
```

Commits sugeridos:

```text
feat(fiscalizacao): adiciona periodos da vistoria
test(fiscalizacao): valida tempo e condicao por periodo
```

### Story 4.4 - Mao de obra da fiscalizacao

Como fiscal, quero adicionar funcionarios da empresa contratada na fiscalizacao para registrar a mao de obra do dia.

Critérios de aceite:

- Listar funcionarios da empresa contratada.
- Selecionar varios funcionarios para a fiscalizacao.
- Informar funcao no dia e observacao opcional.
- Remover funcionario da lista.
- Persistir offline.
- Impedir funcionario de contratante como mao de obra da empresa contratada.

Branch sugerida:

```text
feature/mao-de-obra-fiscalizacao
```

Commits sugeridos:

```text
feat(fiscalizacao): adiciona mao de obra
test(fiscalizacao): valida origem da mao de obra
```

### Story 4.5 - Ocorrencias e comentarios com auto-save

Como fiscal, quero escrever ocorrencias e comentarios sem depender de botao salvar para nao perder informacoes.

Critérios de aceite:

- Campo ocorrencia salva automaticamente.
- Campo comentario salva automaticamente.
- Fechar e abrir app mantem os dados.
- Alteracoes relevantes geram historico.
- UI deixa claro o estado salvo sem exigir acao manual.

Branch sugerida:

```text
feature/autosave-fiscalizacao
```

Commits sugeridos:

```text
feat(fiscalizacao): adiciona autosave de textos
test(fiscalizacao): cobre persistencia de ocorrencias
```

## Epic 5 - Medicoes

### Story 5.1 - Registrar medicao de servico

Como fiscal, quero registrar percentual executado de um servico para medir o progresso fisico.

Critérios de aceite:

- Criar medicao com servico, percentual executado, observacao e data.
- Percentual deve aceitar valores validos entre 0 e 100.
- Listar medicoes por servico.
- Editar medicao.
- Persistir offline.

Branch sugerida:

```text
feature/medicoes-servico
```

Commits sugeridos:

```text
feat(medicoes): adiciona registro de medicao
test(medicoes): valida percentual executado
```

### Story 5.2 - Historico de medicoes

Como usuario, quero manter historico de alteracoes de medicoes para auditar mudancas.

Critérios de aceite:

- Alteracao de percentual gera historico.
- Historico guarda valor anterior, valor novo, data, entidade e campo.
- Historico pode ser consultado no detalhe do servico ou medicao.

Branch sugerida:

```text
feature/historico-medicoes
```

Commits sugeridos:

```text
feat(historico): registra alteracoes de medicao
test(historico): cobre valores anterior e novo
```

## Epic 6 - Fotos

### Story 6.1 - Capturar e armazenar fotos localmente

Como fiscal, quero anexar fotos para documentar a execucao e as ocorrencias.

Critérios de aceite:

- Capturar foto com camera ou selecionar da galeria.
- Salvar arquivo no storage local do app.
- Salvar no banco apenas o caminho do arquivo.
- Listar fotos vinculadas.
- Remover foto quando necessario.
- Nao salvar binario da imagem no banco.

Branch sugerida:

```text
feature/fotos-locais
```

Commits sugeridos:

```text
feat(fotos): salva imagens no storage local
test(fotos): garante caminho salvo no banco
```

### Story 6.2 - Vincular fotos a medicoes

Como fiscal, quero vincular fotos a medicoes para comprovar o percentual executado.

Critérios de aceite:

- Foto pode ser vinculada a uma medicao.
- Detalhe da medicao exibe fotos vinculadas.
- Relatorio consegue consumir essas fotos.

Branch sugerida:

```text
feature/fotos-medicoes
```

Commits sugeridos:

```text
feat(fotos): vincula fotos a medicoes
```

### Story 6.3 - Avaliar fotos em fiscalizacoes

Como fiscal, quero decidir se fotos tambem devem ser vinculadas diretamente a fiscalizacao para registrar ocorrencias do dia.

Critérios de aceite:

- Decisao documentada em `PROJECT_CONTEXT.md`.
- Se aprovado, modelo suporta foto vinculada a fiscalizacao.
- Se nao aprovado, manter fotos apenas em medicoes.

Branch sugerida:

```text
docs/fotos-fiscalizacao
```

Commits sugeridos:

```text
docs(fotos): define vinculo com fiscalizacao
```

## Epic 7 - Dashboard e consultas

### Story 7.1 - Dashboard local de obras

Como usuario, quero ver um resumo das obras para identificar status e progresso rapidamente.

Critérios de aceite:

- Exibir lista/resumo de obras.
- Mostrar status da obra.
- Mostrar progresso fisico.
- Mostrar prazo em dias restantes ou atrasados.
- Funcionar offline.

Branch sugerida:

```text
feature/dashboard-obras
```

Commits sugeridos:

```text
feat(dashboard): adiciona resumo de obras
```

### Story 7.2 - Dashboard de detalhe da obra

Como usuario, quero ver etapas, servicos, progresso e fiscalizacoes dentro da obra.

Critérios de aceite:

- Exibir dados principais da obra.
- Exibir etapas da obra.
- Exibir servicos por etapa.
- Exibir progresso fisico e prazo.
- Exibir fiscalizacoes recentes.

Branch sugerida:

```text
feature/detalhe-obra
```

Commits sugeridos:

```text
feat(obras): adiciona detalhe com etapas e servicos
```

### Story 7.3 - Filtros e busca local

Como usuario, quero buscar e filtrar obras, servicos e fiscalizacoes para encontrar informacoes rapidamente.

Critérios de aceite:

- Buscar obra por nome.
- Filtrar obra por status.
- Buscar fiscalizacao por numero.
- Filtrar fiscalizacao por status e data.
- Busca funciona offline.

Branch sugerida:

```text
feature/busca-local
```

Commits sugeridos:

```text
feat(busca): adiciona filtros locais
```

## Epic 8 - Relatorios PDF

### Story 8.1 - Gerar PDF de fiscalizacao

Como fiscal, quero gerar um PDF da fiscalizacao diaria para compartilhar com interessados.

Critérios de aceite:

- PDF gerado localmente.
- Inclui obra, servico, contratante e responsavel.
- Inclui numero, data, dia da semana e status.
- Inclui periodos, tempo e condicao.
- Inclui ocorrencia e comentario.
- Inclui mao de obra.
- Arquivo pode ser salvo localmente.

Branch sugerida:

```text
feature/pdf-fiscalizacao
```

Commits sugeridos:

```text
feat(relatorios): gera pdf de fiscalizacao
test(relatorios): cobre dados do pdf
```

### Story 8.2 - Gerar PDF de obra

Como usuario, quero gerar um PDF da obra para acompanhar progresso, custos e historico.

Critérios de aceite:

- PDF inclui dados da obra.
- Inclui empresa, contratante quando aplicavel e endereco.
- Inclui etapas e servicos.
- Inclui progresso fisico.
- Inclui prazo restante ou atraso.
- Inclui custos executados quando houver dados suficientes.

Branch sugerida:

```text
feature/pdf-obra
```

Commits sugeridos:

```text
feat(relatorios): gera pdf de obra
```

### Story 8.3 - Compartilhar relatorio

Como usuario, quero compartilhar o PDF por WhatsApp, email, AirDrop ou arquivos locais.

Critérios de aceite:

- App abre compartilhamento nativo.
- PDF gerado e compartilhavel.
- Compartilhamento nao depende de servidor.
- Usuario consegue salvar arquivo localmente.

Branch sugerida:

```text
feature/compartilhar-pdf
```

Commits sugeridos:

```text
feat(relatorios): compartilha pdf local
```

## Epic 9 - Historico e auditoria

### Story 9.1 - Historico generico de alteracoes

Como usuario, quero manter historico de mudancas relevantes para saber o que foi alterado.

Critérios de aceite:

- Historico registra entidade, entidade_id, campo, valor anterior, valor novo, data e usuario.
- Mudancas de status geram historico.
- Mudancas de progresso geram historico.
- Mudancas de fiscalizacao relevantes geram historico.

Branch sugerida:

```text
feature/historico-alteracoes
```

Commits sugeridos:

```text
feat(historico): adiciona auditoria generica
test(historico): cobre registro de alteracoes
```

### Story 9.2 - Visualizar historico

Como usuario, quero consultar o historico de uma obra, servico ou fiscalizacao.

Critérios de aceite:

- Tela exibe historico filtrado por entidade.
- Lista mostra campo, valor anterior, valor novo e data.
- Funciona offline.

Branch sugerida:

```text
feature/visualizar-historico
```

Commits sugeridos:

```text
feat(historico): adiciona tela de auditoria
```

## Epic 10 - Qualidade, testes e acabamento

### Story 10.1 - Testes de regras centrais

Como desenvolvedor, quero cobrir as principais regras de negocio para evoluir o app sem quebrar comportamento.

Critérios de aceite:

- Testes para progresso fisico.
- Testes para progresso de prazo.
- Testes para status automatico de atraso.
- Testes para fiscalizacao unica por servico e dia.
- Testes para periodo da fiscalizacao.
- Testes para origem de funcionario.

Branch sugerida:

```text
test/regras-centrais
```

Commits sugeridos:

```text
test(regras): cobre regras centrais do dominio
```

### Story 10.2 - Testes de widget dos fluxos principais

Como desenvolvedor, quero testar as telas principais para garantir que os fluxos basicos funcionem.

Critérios de aceite:

- Teste de tela de cadastro de obra.
- Teste de tela de cadastro de servico.
- Teste de tela de fiscalizacao.
- Teste de periodos com checkboxes e radio groups.
- Teste de geracao ou acao de relatorio.

Branch sugerida:

```text
test/widgets-principais
```

Commits sugeridos:

```text
test(widgets): cobre fluxos principais
```

### Story 10.3 - Analise estatica e lint

Como desenvolvedor, quero manter o codigo limpo para reduzir bugs e inconsistencias.

Critérios de aceite:

- `flutter analyze` sem erros.
- Lints relevantes aplicados.
- Imports organizados.
- Sem codigo morto relevante.

Branch sugerida:

```text
chore/analise-estatica
```

Commits sugeridos:

```text
chore(lint): ajusta analise estatica
```

### Story 10.4 - Teste de fluxo offline completo

Como Regis, quero usar o app sem internet do cadastro ao relatorio para garantir que ele funciona em campo.

Critérios de aceite:

- Criar empresa offline.
- Criar contratante offline.
- Criar funcionario offline.
- Criar obra offline.
- Criar etapa offline.
- Criar servico offline.
- Criar fiscalizacao offline.
- Adicionar periodo, mao de obra, ocorrencia e comentario offline.
- Criar medicao offline.
- Adicionar foto offline.
- Gerar PDF offline.

Branch sugerida:

```text
test/fluxo-offline
```

Commits sugeridos:

```text
test(offline): cobre fluxo principal sem internet
```

## Ordem recomendada de execucao

1. Epic 0 - Fundacao do projeto.
2. Epic 1 - Banco local e modelos de dominio.
3. Epic 2 - Cadastros base.
4. Epic 3 - Obras, etapas e servicos.
5. Epic 4 - Fiscalizacao diaria.
6. Epic 5 - Medicoes.
7. Epic 6 - Fotos.
8. Epic 7 - Dashboard e consultas.
9. Epic 8 - Relatorios PDF.
10. Epic 9 - Historico e auditoria.
11. Epic 10 - Qualidade, testes e acabamento.

## Primeira branch recomendada

```text
chore/flutter-create
```

Primeiros commits esperados:

```text
chore(project): inicializa projeto flutter
chore(project): preserva estrutura por features
chore(deps): adiciona dependencias base
```
