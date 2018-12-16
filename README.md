Ce dépot git a été créé dans le but de **documenter** les possibilités d'hébergement sur le serveur CLUB1 et d'en **gérer les demandes et incidents**.


# Espace Personnel

L'hébergement est basé sur un compte d'utilisateur composé d'un identifiant (`login`) et d'un mot de passe (`password`), donnant accès à un **espace de stockage personnel** sur le serveur, ainsi disponible à tout moment via internet. Différents services peuvent y être adjoints :

-   un simple compte [FTP](#ftp) (c'est le minimum)
-   des sites [Web](#web)
-   des bases de données [MySql](#mysql)
-   un accès [SSH](#ssh) au serveur

Tous ces services sont reliés à votre compte, ils utilisent donc tous le même `login` et `password`.

## FTP

Le compte FTP permet d'accéder à votre **espace de stockage personnel** grâce à des logiciels comme [FileZilla](https://filezilla-project.org/download.php?type=client) (attention l'installeur windows comprend des bundlewares).

### Informations de connexion

| champ            | valeur     |
| ---------------- | ---------- |
| hôte             | `club1.fr` |
| port             | `21`       |
| authentification | `Normale`  |

## Web

Il est possible d'ajouter à la demande des **sous-domaines** de `club1.fr` pointant vers **l'un des dossiers** présent dans votre **espace personnel** pour ainsi créer un site web. Les noms des sous-domaines seront à définir ensemble en fonction de leur disponibilité et leur viabilité.

## MySql

Un accès à MariaDb pourra être ajouté, à partir duquel il est possible de créer des **bases de données MySql personnelles**. Une instance de phpMyAdmin est disponnible à l'adresse suivante : <http://club1.fr/phpmyadmin>

### Informations de connexion

| champ            | valeur      |
| ---------------- | ----------- |
| hôte             | `localhost` |
| port             | `3306`      |

## SSH

L'acces SSH peut s'avérer très utile pour les **utilisateurs expérimentés**. Il est également créé sur demande.

Il peut être utilisé pour établir des connections cryptés en SFTP, pour cela il est fortement recommandé de créer une paire de **clés RSA** à l'aide d'[OpenSSH](https://fr.wikipedia.org/wiki/OpenSSH). Cette suite logicielle s'utilise en ligne de commande, il faut pour celà ouvrir une fenêtre de console. Pour créer une paire de clé RSA on utilise la commande suivante.

```$
ssh-keygen
```

La commande ci-dessous permet ensuite d'envoyer la partie publique de la clé au serveur pour pouvoir l'utiliser comme moyen d'authentification. (Remplacer `<USER>` par votre identifiant)

```$
ssh-copy-id -i ~/.ssh/id_rsa <USER>@club1.fr
```

### Informations de connexion

| champ            | valeur     |
| ---------------- | ---------- |
| hôte             | `club1.fr` |
| port             | `22`       |


# Demandes et Incidents

Pour toute demande ou incident, veuillez [créer une _issue_](https://github.com/club-1/hosting/issues) sur GitHub (vous devrez pour celà créer un compte), en **préfixant** son titre par `[demande]` ou `[incident]` en fonction de la nature du ticket. Si il s'agit d'une demande impersonnelle, merci de **vérifier** qu'il n'éxiste pas déjà une demande similaire à l'aide de la barre de recherche.


# Infos sur le serveur

## Matériel et infrastructure

Le serveur est localisé en France à Pantin. Il est relié à internet par fibre optique avec un [débit montant de 200Mb/s en moyenne](https://www.nperf.com/r/338260996-nDOmVdkc).

## Système d'exploitation

Le serveur tourne sur la dernière version **LTS d'_ubuntu server_ (18.04)** et est mis à jour régulièrement.

## Logiciels et bibliothèques installés

Un certain nombre de logiciels et de bibliothèques sont déjà installés. En voici une liste _non-exhaustive_ :
-   Apache 2.4
-   MariaDb 10.3
-   PHP 7.2
-   Python 2.7 & 3.6
-   NodeJs 8.11
-   Composer 1.6
-   pip 10.0
-   npm 6.4
-   phpMyAdmin 4.6
-   Git 2.18
-   ...

Si vous souhaitez qu'un logiciel supplémentaire soit installé, merci de **vérifier** dans un premier temps qu'il n'est pas déjà présent, puis, dans le cas contraire, de **créer un ticket** comme expliqué [ci-dessus](#demandes-et-incidents).

## Disponibilité

Afin de garantir un certaine disponibilité, le serveur ainsi que les équipements réseaux sont alimentés par une _UPS_. Cependant, la redondance n'étant pas présente à tous les niveaux, le serveur pourrait être inaccessible pendant de courts laps de temps, par exemple lors d'une mise à jour du noyau. Cela dit, une disponibilité effective **supérieure à 90%** devrait pouvoir être assurée.

# Politique et vie privée

Aucune des données que vous stockez dans votre espace personnel de sera divulguée ni utilisée à des fins lucratives et ce même sous la menace. Cependant Je ne garantis pas que je n'y jetterai pas un coup d'oeil à l'occasion.