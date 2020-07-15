# Script 03 du projet 5 d'OpenClassRooms - Réalisé par Hugo DAGNAS
# Script à visée éducative !
# Version 1.1

# Aide: https://github.com/Hugpo/openclassrooms_p5/wiki

# Présentation du script à l'utilisateur
Write-Host ''
Write-Host 'Script 03 - Hugo DAGNAS'
Write-Host 'Bienvenue sur le script permettant de connaître les groupes d''un utilisateur Active Directory.'
Write-Host ''

# Récupération de tous les membres de l'Active Directory
[array]$MembersAD = Get-ADUser -Filter "*"
$MembersADNumber = $MembersAD.count

# Affichage de tous les membres de l'Active Directory
# Soit réussite de l'opération, soit erreur (code: 01)
try
{
    Write-Host "Liste des membres Active Directory disponible:"
    for($i=0;$i -lt $MembersADNumber;$i++){
        Write-Host $i ": " $MembersAD[$i] 
    }
}
catch
{
    Write-Host "Erreur: Impossible de récupérer la liste des membres Active Directory disponible (Code erreur: 01)"
    exit
}

# Demande du membre à rechercher
# Soit réussite de l'opération, soit erreur (code: 02)
try
{
    [int]$MemberSend = Read-Host "Indiquer le numéro du membre à rechercher"

}
catch
{
    Write-Host "Erreur: La donnée fournie n'est pas un nombre entier (Code erreur: 02)"
    exit 
}

# Récupération des groupes du membre demandé
# Soit réussite de l'opération, soit erreur (code: 03)
try
{
    $MemberSearch = $MembersAD[$MemberSend]
    $groupsMember = Get-ADUser $MemberSearch -Properties MemberOf
}
catch
{
    Write-Host "Erreur: Impossible de récupérer les groupes du membre demandé. (Code erreur: 03)"
    exit   
}

# Affichage des groupes de l'utilisateur demandé
# Si le membre n'a aucun groupe, le script affiche "Aucun groupe"
# Soit réussite de l'opération, soit erreur (code: 04)
try
{
  Write-Host 'Les groupe de l''utilisateur' $MemberSearch 'sont:'
  if ($groupsMember.count -eq 0)
   {
     Write-Host "Aucun groupe"
   }
   else
   {
      $groupsMember.MemberOf 
   }  
}
catch
{
  Write-Host "Erreur: Impossible d'afficher les groupes du membre demandé. (Code erreur: 04)"
  exit    
}

#Fin du script
