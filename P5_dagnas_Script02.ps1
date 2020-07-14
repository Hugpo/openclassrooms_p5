# Script 02 du projet 5 d'OpenClassRooms - R�alis� par Hugo DAGNAS
# Script � vis�e �ducative !

#Pr�sentation du script � l'utilisateur
Write-Host ''
Write-Host 'Script 02 - Hugo DAGNAS'
Write-Host 'Bienvenue sur le script permettant de conna�tre les membres d''un groupe Active Directory.'
Write-Host ''

#Demande du param�tre (nom du groupe)
$nameGroup = Read-Host 'Nom du groupe � lister'

#R�cup�ration des membres du groupe demand�
$membersGroup = Get-ADGroupMember -Identity $nameGroup

#Affichage du r�sultat
Write-Host 'Les membres du groupe' $nameGroup 'sont:'
$membersGroup.name

#Fin du script - Version 1.0