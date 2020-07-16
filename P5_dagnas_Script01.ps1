# Script 01 du projet 5 d'OpenClassRooms - R�alis� par Hugo DAGNAS
# Script � vis�e �ducative !

# Version: 1.0

#Pr�sentation du script � l'utilisateur
Write-Host ''
Write-Host 'Script 01 - Hugo DAGNAS'
Write-Host 'Bienvenue sur la cr�ation d''un utlisateur Active Directory et d''un r�pertoire personnel.'
Write-Host ''

# Demande des param�tres pour la cr�ation du compte Active Directory
Write-Host 'Param�tres du compte de l''utilisateur � cr�er:'
$nom = Read-Host 'Nom de l''utilisateur'
$prenom = Read-Host 'Pr�nom de l''utilisateur'
$login = Read-Host 'Identifiant de connexion (en minuscule)'

# R�cup�ration des UO possible pour l'affectation du nouvel utilisateur - Code erreur possible: 1.01
# On r�cup�re toutes les UO en dehors de "Domain Controllers"
try
{
    [array]$UOname = Get-ADOrganizationalUnit -Filter {name -notlike "Domain Controllers"}
}
catch
{
    Write-Host "Erreur: Impossible de r�cup�rer la liste des Unit�s Organisationnelles (UO) disponible (code erreur: 1.01)"
    exit
}

#Affichage en liste (avec num�ro de s�lection) des UO disponibles - Code erreur possible: 1.02
try
{
    for($i=0;$i -lt $UOname.count; $i++){
        Write-Host $i ": " $UOname.Name[$i]
    }
}
catch
{
    Write-Host "Erreur: Impossible d'afficher la liste des groupes Active Directory disponible (Code erreur: 1.02)"
    exit
}

# Demande de l'UO d'affectation du nouvel utilisateur - Code erreur possible: 1.03
try
{
    [int]$userUO = Read-Host "Indiquer le num�ro de l'UO d'affectation de l'utilisateur"
}
catch
{
    Write-Host "Erreur: La donn�e fournie n'est pas un nombre entier ou n'est pas valide (Code erreur: 1.03)"
    exit
}

# Converti le choix d'affectation (num�ro) en path (lien d'affectation r�el) - Code erreur possible: 1.04
try
{
    $UOaffect = $UOname[$userUO]
}
catch
{
    Write-Host "Erreur: Impossible de trouver l'UO d'affectation (Code erreur: 1.04)"
    exit
}


# Fusion dans une seule variable du nom et pr�nom
$name = $prenom + " " + $nom


# Cr�ation de l'utilisateur et activation - Code erreur possible: 1.05
try
{
    New-ADUser -Name $name -GivenName $prenom -Surname $nom -SamAccountName $login -UserPrincipalName $login@ACME.local -AccountPassword(ConvertTo-SecureString -AsPlainText 'p4Cd4Er3' -Force) -Path $UOaffect -ChangePasswordAtLogon $true -Enabled $true
}
catch
{
    Write-Host "Erreur: La cr�ation de l'utilisateur a �chou� ! (Code erreur: 1.05)"
    exit 
}

# Ajout de l'utilisateur dans le groupe de s�curit� correspondant � son affectation - Code erreur possible: 1.07
try
{
    Add-ADGroupMember -Identity  $UOaffect.Name  -Members $login
    #New-ADGroup "G_$login" -Path $UOaffect.DistinguishedName -GroupScope DomainLocal
    #Add-ADGroupMember -Identity  "G_$login"  -Members $login
}
catch
{
    Write-Host "Erreur: Impossible d'ajouter l'utilisateur au groupe de s�curit� (Code erreur: 1.06)"
    exit
}


# Confirmation de la cr�ation de l'utilisateur
Write-Host 'L''utilisateur cr�� est' $name .
Write-Host "Son identifiant de connexion est" $login"@ACME.local et son mot de passe par d�faut est p4Cd4Er3 ."


# Cr�ation du dossier du partage "dossier personnel" - Code erreur possible: 1.07
try
{
   New-Item -Path "K:\Shares\Dossier personnel`$\$login" -ItemType Directory 
}
catch
{
   Write-Host "Erreur: La cr�ation du dossier de l'utilisateur a �chou� ! (Code erreur: 1.07)" 
   exit 
}
# Cr�ation du partage r�seau - Code erreur possible: 1.08
try
{
    New-SmbShare -Name "Dossier personnel ($login)$" -Path "K:\Shares\Dossier personnel`$\$login"
}
catch
{
    Write-Host "Erreur: Le partage du dossier de l'utilisateur a �chou� ! (Code erreur: 1.08)" 
    exit
}
# Modification des r�gles d'acc�s au dossier - Code erreur possible 1.09
try
{
    Grant-SmbShareAccess -Name "Dossier personnel ($login)$" -AccountName "ACME\$login" -AccessRight Full -Force
    Revoke-SmbShareAccess -Name "Dossier personnel ($login)$" -AccountName "Tout le monde" -Force
}
catch
{
    Write-Host "Erreur: La mise � jour des acc�s a �chou�. (Code erreur: 1.09)" 
    exit
}

Write-Host "Cr�ation du r�pertoire P en tant que dossier personnel de l'utilisateur $login r�ussi !"

# Annonce la fin de l'execution du script
Write-Host "Information: La cr�ation de l'utilisateur est termin� sans erreur !"










<# # Cr�ation du dossier de l'utilisateur dans K:\Shares\$login
try
{
    New-Item -Path "K:\Shares\$login" -ItemType Directory

}
catch
{
   Write-Host "Erreur: La cr�ation du dossier partag� de l'utilisateur a �chou� ! (Code erreur: 1.07)"
   exit  
}

# Partage du dossier sur le r�seau et mise en place des autorisations
try
{
    New-SmbShare -Name $login -Path "K:\Shares\$login" 
    $acl = Get-Acl "K:\Shares\$login"
    $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("ACME\$login","Modify","Allow")
    $acl.SetAccessRule($accessRule)
    $acl | Set-Acl "K:\Shares\$login"
}
catch
{
   Write-Host "Erreur: Le partage du dossier de l'utilisateur a �chou� ! (Code erreur: 1.08)"
   exit 
}
#>
