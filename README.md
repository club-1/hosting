Ce dépot git a été crée dans le but de **documenter** les possibilités d'hébergement sur le serveur CLUB1 et d'en **gérer les demandes et incidents**.

# Espace Personnel

L'hébergement est basé sur un **espace de stockage personnel** sur le serveur, ainsi disponible à tout moment via internet. Différents services peuvent y être adjoints :

-   un simple compte [FTP](#ftp) (c'est le minimum)
-   des sites [Web](#web)
-   un accès [SSH](#ssh) au serveur

## FTP

Le compte FTP permet d'accéder à votre espace de stockage personnel grâce à des logiciels comme [FileZilla](https://filezilla-project.org/download.php?type=client) (attention l'installeur windows comprend des bundlewares).

## Web

Il est possible d'ajouter à la demande des sous domaines de `club1.fr` pointant vers l'un des dossiers présent dans votre espace de stockage pour ansi créer un site web.

## SSH

L'acces SSH peut s'avérer très utile pour les utilisateurs expérimentés. Il est également créé sur demande et le mot de passe sera le même que celui du compte FTP.

Il peut être utilisé pour établir des connection cryptés en SFTP, pour cela il est fortement recommandé de créer une paire de clés RSA à l'aide d'[OpenSSH](https://fr.wikipedia.org/wiki/OpenSSH). Cette suite logicielle s'utilise en ligne de commande, il faut pour celà ouvrir une fenêtre de console. Pour créer une paire de clé RSA on utilise la commande suivante.

```$
ssh-keygen
```

La commande ci-dessous permet ensuite d'envoyer la partie publique de la clé au serveur pour pouvoir l'utiliser comme moyen d'authentification.

```$
ssh-copy-id -i ~/.ssh/mykey user@club1.fr
```

# Demandes et Incidents

Pour toute demande ou incident, veuillez [créer une _issue_](https://github.com/club-1/hosting/issues) sur github, en préfixant son titre par `[demande]` ou `[incident]` en fonction de la nature du ticket.
