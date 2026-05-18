Import-Module ActiveDirectory

$Grupo = "SET_Tecnologia_Lojas"

$Usuarios = @(
    "joao.silva",
    "maria.souza",
    "pedro.lima"
)

foreach ($Usuario in $Usuarios) {

    try {

        Add-ADGroupMember -Identity $Grupo -Members $Usuario -ErrorAction Stop

        Write-Host "Adicionado: $Usuario" -ForegroundColor Green
    }

    catch {

        Write-Host "Erro: $Usuario" -ForegroundColor Red
    }
}
