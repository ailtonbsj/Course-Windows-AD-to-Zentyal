#------------------------------------------------------
# CitraIT - Excelencia em TI
# Script para importar estrutura de AD pre-configurada.
# O dominio deve ser mylab.lan
# use apenas para teste.
# Obs.: Dados de usuarios foram gerados de forma aleatoria.
# Uso: powershell -ep bypass -file <caminho-deste-script>
# Exemplo: powershell -ep bypass -file .\importa.ps1
#------------------------------------------------------

# Obtendo a pasta pela qual este script está sendo chamado
$ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Importando o Módulo do Active Directory
Import-Module ActiveDirectory

# Lendo as unidades organizacionais
$ous = Get-Content -Path "$ScriptPath\ou.txt" -Encoding UTF8
ForEach($ou in $ous)
{
    #Write-Host "Processing $ou"
    $array_path = $ou.Split(",")
    $ouname = $array_path[0].replace("OU=","")
    $oupath = [String]::Join(",", $array_path[1..$array_path.Length])
    Write-Host "Creating OU $ouname on path $oupath"
    try{
        New-ADOrganizationalUnit -Name $ouname -Path $oupath -EA Continue
        Write-Host "[+] OU $ouname,$oupath criada com sucesso!" -Fore Green
    }Catch{
        Write-Host "[-] Erro criando a OU $ouname,$oupath" -Fore Red
    }
}

# Lendo os grupos
$groups = Get-Content -Path "$ScriptPath\group.txt" -Encoding UTF8
ForEach($group in $groups)
{
    Write-Host "Processing group $group"
    $array_path = $group.Split(",")
    $group_name = $array_path[0].replace("CN=","")
    $group_path = [String]::Join(",", $array_path[1..$array_path.Length])
    Write-Host "Creating GROUP $group_name on path $group_path"
    try{
        New-ADGroup -Name $group_name -Path $group_path -GroupCategory Security -GroupScope Global -EA Stop
        Write-Host "[+] Group $group_name,$group_path criado com sucesso!" -Fore Green
    }Catch{
        Write-Host "[-] Erro criando o grupo $group_name,$group_path" -Fore Red
        #$Error[0]
    }
}

# Lendo os usuarios
$users = Import-CliXML -Path "$ScriptPath\user.xml"
ForEach($user in $users)
{
    Write-Host "Processing user " $user.Name
    $dn_array = $user.DistinguishedName.Split(",")
    $rel_dn = [String]::Join(",", $dn_array[1..$dn_array.Length])
    try {
        $ADUser = New-ADUser -EA Stop -Name $user.Name `
            -SamAccountName $user.SamAccountName  `
            -Enabled $user.Enabled `
            -GivenName $user.GivenName `
            -AccountPassword (ConvertTo-SecureString -AsPlainText -Force "P4ssword") `
            -UserPrincipalName $user.UserPrincipalName `
            -Path $rel_dn -PassThru 
        ForEach($grp in $user.MemberOf) {
            Add-ADPrincipalGroupMemberShip -Identity $ADUser -MemberOf $grp -EA Continue
        }
    }Catch{
        Write-Host "Erro criando o usuario " $user.Name -Fore Red
    }

}

Write-Host "################################################"
Write-Host "                 FINALIZADO                     " -Fore Yellow
Write-Host "################################################"

