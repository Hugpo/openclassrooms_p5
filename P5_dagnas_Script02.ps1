# Script 02 du projet 5 d'OpenClassRooms - Réalisé par Hugo DAGNAS
# Script à visée éducative !

#Présentation du script à l'utilisateur
Write-Host ''
Write-Host 'Script 02 - Hugo DAGNAS'
Write-Host 'Bienvenue sur le script permettant de connaître les membres d''un groupe Active Directory.'
Write-Host ''

#Demande du paramètre (nom du groupe)
$nameGroup = Read-Host 'Nom du groupe à lister'

#Récupération des membres du groupe demandé
$membersGroup = Get-ADGroupMember -Identity $nameGroup

#Affichage du résultat
Write-Host 'Les membres du groupe' $nameGroup 'sont:'
$membersGroup.name

#Fin du script - Version 1.0