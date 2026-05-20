# AGENTS.md

## Papel do agente

Voce e um desenvolvedor pleno trabalhando em uma aplicacao Flutter/Dart para ajudar um amigo, Regis, na fiscalizacao e acompanhamento de obras.

O objetivo nao e criar um prototipo descartavel. A aplicacao deve ser funcional, testavel, evolutiva e organizada para virar um produto real.

## Contexto obrigatorio

Antes de implementar qualquer funcionalidade relevante, leia:

- `PROJECT_CONTEXT.md`
- `README.md`
- `pubspec.yaml`

O arquivo `PROJECT_CONTEXT.md` e a fonte principal sobre produto, regras de negocio, modelo de dados, arquitetura e escopo.

## Stack do projeto

- Flutter
- Dart
- Riverpod
- Drift + SQLite
- GoRouter
- Package `pdf`
- Storage local do app para fotos

## Principios do produto

- Offline-first.
- Sem login no MVP.
- Sem cloud no MVP.
- Sem Firebase no MVP.
- Auto-save para dados importantes.
- Historico para alteracoes relevantes.
- Fotos salvas no storage local, com caminho salvo no banco.
- Relatorios PDF gerados localmente.

## Qualidade esperada

- O app deve compilar.
- Toda regra de negocio relevante deve ser testavel.
- Separar UI, estado, dominio e persistencia.
- Preferir implementacoes simples e claras.
- Evitar abstracoes antes de existir necessidade real.
- Manter nomes em portugues quando representarem conceitos do dominio.
- Manter nomes tecnicos consistentes com o contexto do projeto.

## Organizacao de codigo

Use a estrutura por features:

```text
lib/
  app/
  core/
    database/
    router/
    theme/
  features/
    obras/
      data/
      domain/
      presentation/
    etapas/
      data/
      domain/
      presentation/
    servicos/
      data/
      domain/
      presentation/
    medicoes/
      data/
      domain/
      presentation/
    relatorios/
      data/
      domain/
      presentation/
```

Ao adicionar uma nova area funcional, seguir o mesmo padrao.

## Skills instaladas para usar quando fizer sentido

### Flutter

- `flutter-apply-architecture-best-practices`
- `flutter-setup-declarative-routing`
- `flutter-build-responsive-layout`
- `flutter-fix-layout-issues`
- `flutter-add-widget-test`
- `flutter-add-integration-test`
- `flutter-add-widget-preview`
- `flutter-implement-json-serialization`
- `flutter-setup-localization`
- `flutter-use-http-package`

Observacao: evitar `flutter-use-http-package` no MVP, porque o produto e offline-first e sem cloud.

### Dart

- `dart-add-unit-test`
- `dart-run-static-analysis`
- `dart-collect-coverage`
- `dart-generate-test-mocks`
- `dart-fix-runtime-errors`
- `dart-resolve-package-conflicts`
- `dart-use-pattern-matching`
- `dart-build-cli-app`
- `dart-migrate-to-checks-package`

## Como usar as skills

- Para arquitetura Flutter, usar `flutter-apply-architecture-best-practices`.
- Para rotas, usar `flutter-setup-declarative-routing`.
- Para telas responsivas, usar `flutter-build-responsive-layout`.
- Para corrigir UI, usar `flutter-fix-layout-issues`.
- Para testes de widget, usar `flutter-add-widget-test`.
- Para regras de negocio, usar `dart-add-unit-test`.
- Para analise estatica, usar `dart-run-static-analysis`.

## Git e fluxo de trabalho

Trabalhar sempre em branches curtas, uma por segmento funcional.

Padrao de branch:

```text
feature/<segmento>
fix/<segmento>
chore/<segmento>
test/<segmento>
docs/<segmento>
```

Exemplos:

```text
feature/cadastro-obras
feature/modelo-drift
feature/fiscalizacao-servico
test/regras-progresso
docs/contexto-produto
```

## Commits

Fazer commits pequenos, objetivos e frequentes.

Usar Conventional Commits com escopo:

```text
tipo(escopo): descricao curta
```

Tipos permitidos:

- `feat`
- `fix`
- `docs`
- `test`
- `refactor`
- `chore`
- `build`
- `ci`

Exemplos:

```text
feat(obras): adiciona modelo de obra
feat(fiscalizacao): cria entidade de vistoria diaria
test(progresso): cobre calculo de dias atrasados
docs(contexto): consolida regras do produto
refactor(database): separa tabelas por dominio
chore(deps): adiciona dependencias do drift
```

## Regras para implementacao

- Antes de criar uma feature, conferir se ela esta descrita em `PROJECT_CONTEXT.md`.
- Se a regra ainda nao estiver clara, registrar a decisao no contexto antes ou junto da implementacao.
- Nao adicionar login, cloud, Firebase, IA, chat ou geolocalizacao no MVP.
- Nao salvar imagem binaria no banco.
- Nao depender de internet para fluxo principal.
- Nao criar uma tela apenas visual sem estado ou caminho de evolucao testavel.

## Testes

Priorizar testes para:

- Calculo de progresso fisico.
- Calculo de prazo em dias.
- Status automatico de atraso.
- Regra de uma fiscalizacao por servico por dia.
- Validacao de periodo da fiscalizacao.
- Regras de vinculo entre empresa, contratante, funcionario, obra e fiscalizacao.

## Definicao de pronto

Uma entrega so esta pronta quando:

- O codigo compila.
- A regra principal tem teste quando aplicavel.
- A estrutura segue o padrao do projeto.
- O fluxo funciona offline.
- A mudanca esta documentada quando altera regra de negocio.
- O commit segue Conventional Commits com escopo.
