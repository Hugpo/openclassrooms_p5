# Script 02 du projet 5 d'OpenClassRooms - Réalisé par Hugo DAGNAS
# Script à visée éducative !
# Version 1.2

# Aide: https://github.com/hugodagnas/openclassrooms_p5/wiki

# Indiquer le chemin de sauvegarde du fichier de résultat du script
Param($PathResultFolder = "C:\Users\Administrateur\Documents")

#Présentation du script à l'utilisateur
Write-Host ""
Write-Host "Script 02 - Hugo DAGNAS"
Write-Host "Bienvenue sur le script permettant de connaître les membres d'un groupe Active Directory."
Write-Host ""

[array]$GroupsAD = Get-ADGroup -Filter "*"

try
{
    Write-Host "Liste des groupes Active Directory disponible:"
    for($i=0;$i -lt $GroupsAD.count;$i++){
        Write-Host $i ": " $GroupsAD.Name[$i]
    }
}
catch
{
    Write-Host "Erreur: Impossible de récupérer la liste des groupes Active Directory disponible (Code erreur: 2.01)"
    exit
}

# Demande du groupe à rechercher
try
{
    [int]$GroupSend = Read-Host "Indiquer le numéro du groupe à rechercher"

}
catch
{
    Write-Host "Erreur: La donnée fournie n'est pas un nombre entier (Code erreur: 2.02)"
    exit 
}

# Récupération des membres du groupe demandé
try
{
    $GroupSearch = $GroupsAD[$GroupSend]
    $membersGroup = Get-ADGroupMember -Identity $GroupSearch
}
catch
{
    Write-Host "Erreur: Impossible de récupérer les membres du groupe demandé. (Code erreur: 2.03)"
    exit   
}

# Affichage du résultat de la recherche
try
{
    Write-Host "Les membres du groupe" $GroupSearch.Name "sont:"

    # Si aucun membre dans la groupe, affichage de la réponse "Aucun membre"
    if ($membersGroup.count -eq 0)
    {
        $members = "Aucun membre"  
        Write-Host "Aucun membre"
    }
    else
    {
        $membersGroup.name 
        $members = $membersGroup.name
    }  
}
catch
{
    Write-Host "Erreur: Impossible d'afficher les membres du groupe demandé. (Code erreur: 2.04)"
    exit    
}

# Création du fichier de sortie du script
# Le lieu de l'enregistrement du fichier est défini en paramètre du script

try
{
    $groupFile = $GroupSearch.Name
    Out-File -FilePath "$PathResultFolder\AD_membreDuGroupe_$groupFile.txt" -InputObject "Les membres du groupe $groupFile sont:"
    Add-Content -Path "$PathResultFolder\AD_membreDuGroupe_$groupFile.txt" -Value $members
}
catch
{
    Write-Host "Erreur: La création du fichier txt de sortie a échoué (Code erreur: 2.05)"
    exit 
}

# Confirmation de la création du fichier texte 
Write-Host "Un fichier texte avec le résultat a été généré: $PathResultFolder\AD_membreDuGroupe_$groupFile.txt"

# Fin de script
