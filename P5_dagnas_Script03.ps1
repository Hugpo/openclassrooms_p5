# Script 03 du projet 5 d'OpenClassRooms - R�alis� par Hugo DAGNAS
# Script � vis�e �ducative !

#Pr�sentation du script � l'utilisateur
Write-Host ''
Write-Host 'Script 03 - Hugo DAGNAS'
Write-Host 'Bienvenue sur le script permettant de conna�tre les groupes d''un utilisateur Active Directory.'
Write-Host ''

#Demande du param�tre (nom de l'utilisateur)
$nameUser = Read-Host 'Nom de l''utilisateur � lister'

#R�cup�ration des membres du groupe demand�
$groupsMember = Get-ADUser $nameUser -Properties MemberOf

#Affichage du r�sultat
Write-Host 'Les groupes de l''utilisateur' $nameUser 'sont:'
$groupsMember.MemberOf

#Fin du script - Version 1.0