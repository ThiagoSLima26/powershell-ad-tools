Import-Module ActiveDirectory

# =========================
# SENHA
# =========================

$NovaSenhaTexto = "Senha"
$Password = ConvertTo-SecureString $NovaSenhaTexto -AsPlainText -Force

# =========================
# USUÁRIOS
# =========================

$Usuarios = @(
    "alberto.moura",
    "alex.lima1",
    "alexcione.silva"
)

Write-Host "`n--- INICIANDO RESET DE SENHAS ---`n" -ForegroundColor Cyan

foreach ($User in $Usuarios) {

    try {

        # Busca usuário no domínio
        $ADUser = Get-ADUser -Identity $User -Properties Enabled -ErrorAction Stop

        Write-Host "[LOCALIZADO] $($ADUser.SamAccountName)" -ForegroundColor Gray
        Write-Host "OU: $($ADUser.DistinguishedName)" -ForegroundColor DarkGray

        # Reset senha
        Set-ADAccountPassword `
            -Identity $ADUser `
            -NewPassword $Password `
            -Reset `
            -ErrorAction Stop

        # Habilita conta + força troca
        Enable-ADAccount -Identity $ADUser

        Set-ADUser `
            -Identity $ADUser `
            -ChangePasswordAtLogon $true

        Write-Host "[OK] Senha redefinida com sucesso`n" -ForegroundColor Green
    }

    catch {

        Write-Host "[ERRO] Usuário '$User' não encontrado ou erro no reset." -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor DarkRed
        Write-Host ""
    }
}

Write-Host "--- PROCESSO FINALIZADO ---" -ForegroundColor Cyan
