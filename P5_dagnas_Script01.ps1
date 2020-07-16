# Script 01 du projet 5 d'OpenClassRooms - Réalisé par Hugo DAGNAS
# Script à visée éducative !

# Version: 1.1
# Documentation: https://github.com/hugodagnas/openclassrooms_p5/wiki

#Présentation du script à l'utilisateur
Write-Host ''
Write-Host 'Script 01 - Hugo DAGNAS'
Write-Host 'Bienvenue sur la création d''un utlisateur Active Directory et d''un répertoire personnel.'
Write-Host ''


# Demande des paramètres pour la création du compte Active Directory
Write-Host 'Paramètres du compte de l''utilisateur à créer:'
$nom = Read-Host 'Nom de l''utilisateur'
$prenom = Read-Host 'Prénom de l''utilisateur'
$login = Read-Host 'Identifiant de connexion (en minuscule)'


# Récupération des UO possible pour l'affectation du nouvel utilisateur - Code erreur possible: 1.01
# On récupère toutes les UO en dehors de "Domain Controllers"
try
{
    [array]$UOname = Get-ADOrganizationalUnit -Filter {name -notlike "Domain Controllers"}
}
catch
{
    Write-Host "Erreur: Impossible de récupérer la liste des Unités Organisationnelles (UO) disponible (code erreur: 1.01)"
    exit
}


#Affichage en liste (avec numéro de sélection) des UO disponibles - Code erreur possible: 1.02
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
    [int]$userUO = Read-Host "Indiquer le numéro de l'UO d'affectation de l'utilisateur"
}
catch
{
    Write-Host "Erreur: La donnée fournie n'est pas un nombre entier ou n'est pas valide (Code erreur: 1.03)"
    exit
}


# Converti le choix d'affectation (numéro) en path (lien d'affectation réel) - Code erreur possible: 1.04
try
{
    $UOaffect = $UOname[$userUO]
}
catch
{
    Write-Host "Erreur: Impossible de trouver l'UO d'affectation (Code erreur: 1.04)"
    exit
}


# Fusion dans une seule variable du nom et prénom
$name = $prenom + " " + $nom


# Création de l'utilisateur et activation - Code erreur possible: 1.05
try
{
    New-ADUser -Name $name -GivenName $prenom -Surname $nom -SamAccountName $login -UserPrincipalName $login@ACME.local -AccountPassword(ConvertTo-SecureString -AsPlainText 'p4Cd4Er3' -Force) -Path $UOaffect -ChangePasswordAtLogon $true -Enabled $true
}
catch
{
    Write-Host "Erreur: La création de l'utilisateur a échoué ! (Code erreur: 1.05)"
    exit 
}


# Ajout de l'utilisateur dans le groupe de sécurité correspondant à son affectation - Code erreur possible: 1.07
try
{
    Add-ADGroupMember -Identity  $UOaffect.Name  -Members $login
}
catch
{
    Write-Host "Erreur: Impossible d'ajouter l'utilisateur au groupe de sécurité (Code erreur: 1.06)"
    exit
}


# Confirmation de la création de l'utilisateur
Write-Host 'L''utilisateur créé est' $name .
Write-Host "Son identifiant de connexion est" $login"@ACME.local et son mot de passe par défaut est p4Cd4Er3 ."


# Création du dossier du partage "dossier personnel" - Code erreur possible: 1.07
try
{
   New-Item -Path "K:\Shares\Dossier personnel`$\$login" -ItemType Directory 
}
catch
{
   Write-Host "Erreur: La création du dossier de l'utilisateur a échoué ! (Code erreur: 1.07)" 
   exit 
}


# Création du partage réseau - Code erreur possible: 1.08
try
{
    New-SmbShare -Name "Dossier personnel ($login)$" -Path "K:\Shares\Dossier personnel`$\$login"
}
catch
{
    Write-Host "Erreur: Le partage du dossier de l'utilisateur a échoué ! (Code erreur: 1.08)" 
    exit
}


# Modification des règles d'accès au dossier - Code erreur possible 1.09
try
{
    Grant-SmbShareAccess -Name "Dossier personnel ($login)$" -AccountName "ACME\$login" -AccessRight Full -Force
    Revoke-SmbShareAccess -Name "Dossier personnel ($login)$" -AccountName "Tout le monde" -Force
}
catch
{
    Write-Host "Erreur: La mise à jour des accès a échoué. (Code erreur: 1.09)" 
    exit
}

Write-Host "Création du répertoire P en tant que dossier personnel de l'utilisateur $login réussi !"


# Annonce la fin de l'execution du script
Write-Host "Information: La création de l'utilisateur est terminé sans erreur !"

# Fin du script
