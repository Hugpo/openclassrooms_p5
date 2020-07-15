# Script 02 du projet 5 d'OpenClassRooms - Réalisé par Hugo DAGNAS
# Script à visée éducative !
# Version 1.1

#Aide: https://github.com/Hugpo/openclassrooms_p5/wiki

#Présentation du script à l'utilisateur
Write-Host ''
Write-Host 'Script 02 - Hugo DAGNAS'
Write-Host 'Bienvenue sur le script permettant de connaître les membres d''un groupe Active Directory.'
Write-Host ''

[array]$GroupsAD = Get-ADGroup -Filter "*"
$GroupADNumber = $GroupsAD.count

try
{
    Write-Host "Liste des groupes Active Directory disponible:"
    for($i=0;$i -lt $GroupADNumber;$i++){
        Write-Host $i ": " $GroupsAD[$i] 
  }
}
catch
{
    Write-Host "Erreur: Impossible de récupérer la liste des groupes Active Directory disponible (Code erreur: 01)"
    exit
}

#Demande du groupe à rechercher
try
{
    [int]$GroupSend = Read-Host "Indiquer le numéro du groupe à rechercher"

}
catch
{
   Write-Host "Erreur: La donnée fournie n'est pas un nombre entier (Code erreur: 02)"
   exit 
}

try
{
    $GroupSearch = $GroupsAD[$GroupSend]
    $membersGroup = Get-ADGroupMember -Identity $GroupSearch
}
catch
{
  Write-Host "Erreur: Impossible de récupérer les membres du groupe demandé. (Code erreur: 03)"
  exit   
}

try
{
  Write-Host 'Les membres du groupe' $GroupSearch 'sont:'
  if ($membersGroup.count -eq 0)
   {
     Write-Host "Aucun membre"
   }
   else
   {
      $membersGroup.name 
   }  
}
catch
{
  Write-Host "Erreur: Impossible d'afficher les membres du groupe demandé. (Code erreur: 04)"
  exit    
}

#Fin de script
