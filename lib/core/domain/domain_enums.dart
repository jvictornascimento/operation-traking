enum StatusExecucao {
  naoComecou,
  emAndamento,
  parada,
  embargada,
  atrasada,
  concluida,
}

enum StatusFiscalizacao {
  emAndamento,
  aprovada,
  negada,
}

enum TipoEntidadeEndereco {
  empresa,
  contratante,
  funcionario,
  obra,
}

enum TipoEntidadeContato {
  empresa,
  contratante,
  funcionario,
}

enum TipoContato {
  email,
  telefone,
  whatsapp,
  outro,
}

enum PeriodoDia {
  manha,
  tarde,
  noite,
}

enum TempoPeriodo {
  claro,
  nublado,
  chuvoso,
}

enum CondicaoPeriodo {
  praticavel,
  impraticavel,
}
