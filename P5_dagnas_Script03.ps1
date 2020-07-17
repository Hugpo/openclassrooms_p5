# Script 03 du projet 5 d'OpenClassRooms - Réalisé par Hugo DAGNAS
# Script à visée éducative !
# Version 1.2

# Aide: https://github.com/Hugpo/openclassrooms_p5/wiki

# Indiquer le chemin de sauvegarde du fichier de résultat du script
Param($PathResultFolder = "C:\Users\Administrateur\Documents")

# Présentation du script à l'utilisateur
Write-Host ""
Write-Host "Script 03 - Hugo DAGNAS"
Write-Host "Bienvenue sur le script permettant de connaître les groupes d''un utilisateur Active Directory."
Write-Host ""

# Récupération de tous les membres de l'Active Directory
[array]$MembersAD = Get-ADUser -Filter "*"

# Affichage de tous les membres de l'Active Directory
# Soit réussite de l'opération, soit erreur (code: 3.01)
try
{
    Write-Host "Liste des membres Active Directory disponible:"
    for($i=0;$i -lt $MembersAD.count;$i++){
        Write-Host $i ": " $MembersAD.Name[$i] 
    }
}
catch
{
    Write-Host "Erreur: Impossible de récupérer la liste des membres Active Directory disponible (Code erreur: 3.01)"
    exit
}

# Demande du membre à rechercher
# Soit réussite de l'opération, soit erreur (code: 3.02)
try
{
    [int]$MemberSend = Read-Host "Indiquer le numéro du membre à rechercher"
}
catch
{
    Write-Host "Erreur: La donnée fournie n'est pas un nombre entier (Code erreur: 3.02)"
    exit 
}

# Récupération des groupes du membre demandé
# Soit réussite de l'opération, soit erreur (code: 03)
try
{
    $groupsMember = Get-ADUser $MembersAD[$MemberSend] -Properties MemberOf
}
catch
{
    Write-Host "Erreur: Impossible de récupérer les groupes du membre demandé. (Code erreur: 3.03)"
    exit   
}

# Affichage des groupes de l'utilisateur demandé
# Si le membre n'a aucun groupe, le script affiche "Aucun groupe"
# Soit réussite de l'opération, soit erreur (code: 04)
try
{
    Write-Host "Les groupe de l'utilisateur" $MembersAD[$MemberSend].Name "sont:"
    if ($groupsMember.count -eq 0)
    {
        Write-Host "Aucun groupe"
    }
    else
    {
        $groupSplit = $groupsMember.MemberOf
        $groupSplit = $groupSplit.split(",")
        $groupSplit
    }  
}
catch
{
  Write-Host "Erreur: Impossible d'afficher les groupes du membre demandé. (Code erreur: 3.04)"
  exit    
}


# Création du fichier de sortie du script
# Le lieu de l'enregistrement du fichier est défini en paramètre du script

try
{
    $UserFile = $groupsMember.Name
    Out-File -FilePath "$PathResultFolder\AD_GroupeDe_$UserFile.txt" -InputObject "Les groupe du membre $UserFile sont:"
    Add-Content -Path "$PathResultFolder\AD_GroupeDe_$UserFile.txt" -Value $groupSplit
}
catch
{
    Write-Host "Erreur: La création du fichier txt de sortie a échoué (Code erreur: 3.05)"
    exit 
}

# Confirmation de la création du fichier texte 
Write-Host "Un fichier texte avec le résultat a été généré: $PathResultFolder\AD_GroupeDe_$UserFile.txt"

#Fin du script
