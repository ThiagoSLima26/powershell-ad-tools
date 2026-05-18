# 1. Configurações de Senha
$NovaSenhaTexto = "Senha" 
$password = ConvertTo-SecureString $NovaSenhaTexto -AsPlainText -Force

# 2. Lista de usuários
$usuarios = @(
    "joao.silva", "alex.silva"
)

Write-Host "--- Iniciando Reset com Busca Global no Domínio ---" -ForegroundColor Cyan

foreach ($user in $usuarios) {
    try {
        # Busca o usuário em TODO o AD para não ter erro de OU
        $adUser = Get-ADUser -Filter "SamAccountName -eq '$user'" -ErrorAction Stop
        
        # Mostra onde o usuário foi encontrado (DistinguishedName)
        Write-Host "[LOCALIZADO] $user em: $($adUser.DistinguishedName)" -ForegroundColor Gray
        
        # Reseta a senha
        Set-ADAccountPassword -Identity $adUser -NewPassword $password -Reset -ErrorAction Stop
        Set-ADUser -Identity $adUser -ChangePasswordAtLogon $true -Enabled $true
        
        Write-Host "[OK] Senha atualizada para $user" -ForegroundColor Green
    }
    catch {
        Write-Host "[ERRO CRÍTICO] O login '$user' não existe no AD inteiro. Verifique a grafia." -ForegroundColor Red
    }
}

Write-Host "--- Processo Finalizado ---" -ForegroundColor Cyan
