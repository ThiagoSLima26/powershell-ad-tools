Import-Module ActiveDirectory

# =========================
# DADOS DO USUÁRIO
# =========================

$PrimeiroNome = "Joao"
$Sobrenome    = "Silva"

$NomeCompleto = "$PrimeiroNome $Sobrenome"

$Usuario = "joao.silva"
$Senha   = "Senha@123"

$Dominio = "empresa.local"

$Email = "$Usuario@empresa.com"

# =========================
# CAMINHO DA OU
# =========================

$OU = "OU=Usuarios,OU=Matriz,DC=empresa,DC=local"

# =========================
# GRUPOS
# =========================

$Grupos = @(
    "GRP_Office365"
    "GRP_VPN"
    "GRP_ERP"
)

# =========================
# OUTRAS INFORMAÇÕES
# =========================

$Cargo = "Analista de TI"
$Departamento = "Tecnologia"

# =========================
# CRIAÇÃO
# =========================

# Verifica se usuário já existe
if (Get-ADUser -Filter "SamAccountName -eq '$Usuario'" -ErrorAction SilentlyContinue) {

    Write-Host "Usuário já existe!" -ForegroundColor Red

} else {

    New-ADUser `
        -Name $NomeCompleto `
        -GivenName $PrimeiroNome `
        -Surname $Sobrenome `
        -SamAccountName $Usuario `
        -UserPrincipalName "$Usuario@$Dominio" `
        -EmailAddress $Email `
        -Title $Cargo `
        -Department $Departamento `
        -Description $Cargo `
        -Path $OU `
        -AccountPassword (ConvertTo-SecureString $Senha -AsPlainText -Force) `
        -Enabled $true `
        -ChangePasswordAtLogon $false `
        -PasswordNeverExpires $true `
        -CannotChangePassword $true

    Write-Host "Usuário criado com sucesso!" -ForegroundColor Green

    # =========================
    # ADICIONAR AOS GRUPOS
    # =========================

    foreach ($Grupo in $Grupos) {

        try {

            Add-ADGroupMember -Identity $Grupo -Members $Usuario

            Write-Host "Adicionado ao grupo: $Grupo" -ForegroundColor Cyan

        } catch {

            Write-Host "Erro ao adicionar no grupo: $Grupo" -ForegroundColor Yellow

        }
    }
}
