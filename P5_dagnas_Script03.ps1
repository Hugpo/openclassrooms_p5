# Script 03 du projet 5 d'OpenClassRooms - Réalisé par Hugo DAGNAS
# Script à visée éducative !

#Présentation du script à l'utilisateur
Write-Host ''
Write-Host 'Script 03 - Hugo DAGNAS'
Write-Host 'Bienvenue sur le script permettant de connaître les groupes d''un utilisateur Active Directory.'
Write-Host ''

#Demande du paramètre (nom de l'utilisateur)
$nameUser = Read-Host 'Nom de l''utilisateur à lister'

#Récupération des membres du groupe demandé
$groupsMember = Get-ADUser $nameUser -Properties MemberOf

#Affichage du résultat
Write-Host 'Les groupes de l''utilisateur' $nameUser 'sont:'
$groupsMember.MemberOf

#Fin du script - Version 1.0
#Aide: https://github.com/Hugpo/openclassrooms_p5/wiki
