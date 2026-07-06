# Operational Tracking

App mobile offline-first para fiscalizacao e acompanhamento de obras.

## Stack prevista

- Flutter
- Dart
- Riverpod
- Drift + SQLite
- GoRouter
- pdf package

## Observacao

Este esqueleto foi criado manualmente porque o Flutter SDK nao esta instalado neste ambiente.

Quando o Flutter estiver instalado, o caminho recomendado e:

```bash
flutter create --platforms=ios,android --project-name operational_tracking .
flutter pub get
```

Depois disso, manter a organizacao de `lib/` criada aqui.

## Organizacao

```text
lib/
  app/
  core/
    database/
    router/
    theme/
  features/
    obras/
    etapas/
    fiscalizacoes/
    relatorios/
```

## Regra de produto

O app deve funcionar offline, sem login, sem cloud e com auto-save.
