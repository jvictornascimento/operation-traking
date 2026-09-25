# belis-oversight

Aplicativo Flutter offline-first para fiscalizacao e acompanhamento de obras.
O foco do projeto e registrar o que acontece em campo sem depender de internet,
mantendo dados locais, historico e relatorios PDF gerados no aparelho.

## Estado atual do produto

- Cadastro de empresas, contratantes e funcionarios.
- Cadastro de obras com etapas vinculadas.
- Fiscalizacao diaria vinculada a etapa.
- Periodos da fiscalizacao por manha, tarde e noite.
- Registro de mao de obra por fiscalizacao.
- Fotos da fiscalizacao com armazenamento local.
- Legenda opcional nas fotos.
- Relatorios PDF locais com cabecalho profissional.
- Assinatura do funcionario responsavel do contratante no relatorio.
- Rodape com nome do app e versao.
- Tela de configuracoes com base para backup local.

## Stack

- Flutter
- Dart
- Riverpod
- Drift + SQLite
- GoRouter
- `pdf`
- `printing`
- `image_picker`
- `photo_manager`
- Storage local do app para fotos e arquivos gerados

## Regras do produto

- Funciona offline.
- Nao depende de login, cloud ou Firebase no MVP.
- Dados importantes usam auto-save.
- Fotos nao sao salvas em binario no banco.
- O banco local e a fonte primaria de verdade.
- Relatorios sao gerados localmente no dispositivo.
- Historico deve ser preservado para alteracoes relevantes.
- Funcionarios inativos nao devem desaparecer do historico.

## Modelo principal

- `empresa`
- `contratante`
- `funcionario`
- `endereco`
- `contato`
- `obra`
- `etapa`
- `vistoria_servico`
- `vistoria_periodo`
- `vistoria_mao_de_obra`
- `vistoria_foto`
- `historico_alteracao`

## Fluxo atual

1. Cadastrar empresa e contratante.
2. Cadastrar funcionarios e enderecos.
3. Criar obra.
4. Criar etapas dentro da obra.
5. Criar fiscalizacao dentro da etapa.
6. Registrar atividade, periodos, mao de obra, fotos e ocorrencias.
7. Gerar relatorio PDF local ao final.

## Relatorios PDF

O relatorio atual prioriza leitura rapida em campo:

- Cabecalho visual com resumo da fiscalizacao.
- Status humanizados no PDF.
- Nome do funcionario na mao de obra.
- Fotos em miniaturas com legenda opcional.
- Assinatura com nome e imagem do funcionario do contratante.
- Rodape com nome do app e versao.
- Sem exibicao do caminho local da imagem.
- Sem progresso da obra no relatorio.

## Backup e configuracoes

Existe base para centralizar configuracoes do app em uma tela propria.
O plano de backup local inclui frequencia e quantidade de copias mantidas.

## Desenvolvimento

Instalar dependencias:

```bash
flutter pub get
```

Executar em modo debug:

```bash
flutter run
```

Gerar APK de release:

```bash
flutter build apk --release
```

Gerar App Bundle de release:

```bash
flutter build appbundle --release
```

## Artefatos de release

- APK: `build/app/outputs/flutter-apk/app-release.apk`
- App Bundle: `build/app/outputs/bundle/release/app-release.aab`

## Versao atual

`0.1.1`
