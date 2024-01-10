let
    Fonte = #"Range Date",
    #"Função Personalizada Invocada" = Table.AddColumn(Fonte, "Agendamentos", each #"Busca - Agendamentos"([DtInicio], [DtFinal])),
    #"Agendamentos Expandido" = Table.ExpandRecordColumn(#"Função Personalizada Invocada", "Agendamentos", {"ListaHistoricoBox"}, {"ListaHistoricoBox"}),
    #"ListaHistoricoBox Expandido" = Table.ExpandListColumn(#"Agendamentos Expandido", "ListaHistoricoBox"),
    #"ListaHistoricoBox Expandido1" = Table.ExpandRecordColumn(#"ListaHistoricoBox Expandido", "ListaHistoricoBox", {"Vendedor", "Lead", "HrIni"}, {"Vendedor", "Lead", "HrIni"}),
    #"Lead Expandido" = Table.ExpandRecordColumn(#"ListaHistoricoBox Expandido1", "Lead", {"Id", "Nome"}, {"Id", "Nome"}),
    #"Tipo Alterado" = Table.TransformColumnTypes(#"Lead Expandido",{{"HrIni", type datetime}}),
    #"Tipo Alterado1" = Table.TransformColumnTypes(#"Tipo Alterado",{{"HrIni", type date}}),
    #"Expanded Vendedor" = Table.ExpandRecordColumn(#"Tipo Alterado1", "Vendedor", {"Email"}, {"Vendedor.Email"}),
    #"Linhas Agrupadas" = Table.Group(#"Expanded Vendedor", {"Id", "Nome", "Vendedor.Email"}, {{"Data da Reunião", each List.Max([HrIni]), type nullable date}}),
    #"Idade Inserida" = Table.AddColumn(#"Linhas Agrupadas", "Tempo Pendente", each Date.From(DateTime.LocalNow()) - [Data da Reunião], type duration),
    #"Tipo Alterado2" = Table.TransformColumnTypes(#"Idade Inserida",{{"Tempo Pendente", Int64.Type}, {"Vendedor.Email", type text}}),
    #"Filtered Rows" = Table.SelectRows(#"Tipo Alterado2", each [Tempo Pendente] > 0)
in
    #"Filtered Rows"