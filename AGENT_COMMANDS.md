# Comandos do Agente

## Comando mestre: executar todas as stories

Use este comando quando quiser que o agente implemente o projeto seguindo o backlog completo, sem pedir aprovacao a cada story.

```text
Execute o projeto Operational Tracking do comeco ao fim seguindo exatamente estes arquivos:

1. AGENTS.md
2. PROJECT_CONTEXT.md
3. STORIES.md

Regras:

- Trabalhe como desenvolvedor pleno Flutter/Dart.
- Siga as stories na ordem definida em STORIES.md.
- Crie uma branch curta para cada segmento funcional.
- Use Conventional Commits com escopo.
- Faca commits pequenos e frequentes.
- Nao peca confirmacao para decisoes ja descritas em AGENTS.md, PROJECT_CONTEXT.md ou STORIES.md.
- Quando houver ambiguidade pequena, tome a decisao mais simples, documente no arquivo correto e continue.
- So pare para perguntar se a decisao alterar escopo de produto, exigir credencial, envolver pagamento, cloud, login, servidor externo ou risco de apagar trabalho existente.
- Antes de cada segmento, leia a story correspondente.
- Implemente codigo funcional, nao apenas placeholders.
- Escreva testes para regras de negocio relevantes.
- Rode analise estatica e testes sempre que a etapa permitir.
- Se uma ferramenta externa nao estiver instalada, registre o bloqueio e avance no que for possivel sem quebrar o projeto.
- Nunca adicione login, cloud, Firebase, IA, chat ou geolocalizacao no MVP.
- Mantenha o produto offline-first.
- Atualize PROJECT_CONTEXT.md quando uma decisao de regra de negocio for consolidada.

Comece pela primeira story pendente em STORIES.md e continue ate concluir todas as stories possiveis no ambiente atual.
```

## Comando curto

```text
Siga AGENTS.md, PROJECT_CONTEXT.md e STORIES.md. Execute as stories em ordem, criando branch por segmento e commits pequenos com Conventional Commits com escopo. Nao peca aprovacao para decisoes ja documentadas; implemente, teste e avance ate concluir tudo que for possivel no ambiente atual.
```

## Limites importantes

Este comando nao consegue remover aprovacoes de seguranca do ambiente.

O agente ainda pode precisar de aprovacao quando:

- O sandbox bloquear leitura ou escrita fora da area permitida.
- For necessario instalar dependencias.
- Um comando precisar de rede.
- Uma acao puder apagar ou sobrescrever trabalho existente.
- Houver necessidade de credenciais, contas externas ou servicos pagos.

Dentro desses limites, o agente deve seguir sozinho e tomar decisoes pragmáticas com base nos documentos do projeto.

## Ordem operacional recomendada

1. Ler `AGENTS.md`.
2. Ler `PROJECT_CONTEXT.md`.
3. Ler `STORIES.md`.
4. Verificar estado do Git.
5. Identificar a primeira story pendente.
6. Criar branch da story.
7. Implementar.
8. Testar.
9. Commitar.
10. Seguir para a proxima story.

## Checklist antes de cada commit

- Codigo compila ou o bloqueio esta documentado.
- Testes relevantes foram adicionados ou atualizados.
- Regra de negocio alterada foi documentada.
- Commit segue o formato:

```text
tipo(escopo): descricao curta
```

Exemplos:

```text
feat(obras): adiciona cadastro de obra
test(fiscalizacao): cobre vistoria unica por dia
docs(contexto): registra regra de fotos locais
```
