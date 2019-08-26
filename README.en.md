This git repository has been created in order to **document** the hosting possibilities on the CLUB1 server and to **manage the requests and issues**.


# Personnal Space

The hosting is based on a user account composed of a `login`and a `password`, giving access to a **personnal storage space** on the server, which is accessible at any time through internet. Several services can be added to it:

-   a simple [FTP](#ftp) account (the minimal option)
-   some [websites](#web)
-   [MySql](#mysql) databases
-   [SSH](#ssh) access to the server

All of this services are linked to your account so they all use the same `login`and `password`.

## FTP

The FTP account provides access to your **personnal storage space** thanks to softwares like [FileZilla](https://filezilla-project.org/download.php?type=client) (beware the windows installer includes bundlewares).

### Connection informations

| field            | value      |
| ---------------- | ---------- |
| host             | `club1.fr` |
| port             | `21`       |
| authentication   | `Normal`   |

## Web

It is possible to add, on demand, `club1.fr` **sub-domains** pointing to one of the **directories** of your **personnal space** in order to create a website. The sub-domains names are to be chosen together according to their availability and viability.

## MySql

An access to MariaDb could be added, from which it is possible to create **personnal MySql databases**. A phpMyAdmin instance is accessible at the following address: <http://club1.fr/phpmyadmin>

### Connection informations

| field            | value       |
| ---------------- | ----------- |
| host             | `localhost` |
| port             | `3306`      |

## SSH

An SSH acces can be very useful for **advenced users**. It is created on demand too.

It can be used to establish encrypted SFTP connections, for that it is strongly recommended to create a **RSA key pair** using [OpenSSH](https://fr.wikipedia.org/wiki/OpenSSH). This software suite is used in command line, it is necessary to open a console window. To create a RSA kay pair we use the following command

```$
ssh-keygen
```

The command thereafter then makes it possible to send the public part of the key to the server to be able to use it as an authentication method. (Replace `<USER>` with your login)

```$
ssh-copy-id -i ~/.ssh/id_rsa <USER>@club1.fr
```

### Connection informations

| field            | value      |
| ---------------- | ---------- |
| host             | `club1.fr` |
| port             | `22`       |


# Requests and Issues

For any request or incident, please [create an _issue_](https://github.com/club-1/hosting/issues) on GitHub (you will need to create an account), **prefixing** its title by `[request]` or `[issue]` depending on the nature of the ticket. If this is an impersonal request, please **check** that there is not already a similar request using the search bar.


# Server infos

## Hardware and infrastructure

The server is located in Pantin, France. It is connected to the internet by optical fiber with an [average upload rate of 200Mb/s](https://www.nperf.com/r/338260996-nDOmVdkc).

## Operationg system

The server runs the latest **LTS version of _ubuntu server_ (18.04)** and is updated regularly.

## Installed software and libraries

A significant number of softwares and libraries are already installed. Here is a _non-exhaustive list_ :
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
-   ffmpeg (2019-08-26)
-   beets (2019-08-26)

If you want additional software installed, please **check first** that it is not already present, then, if not, **create a ticket** as [explained above](#requests-and-issues).

## Availability

In order to guarantee a certain availability, the server as well as the network equipment are powered by an _UPS_. However, since redundancy is not present at all levels, the server may be inaccessible for short periods of time, for example during a kernel update. That said, an effective availability **above 90%** should be ensured.

# Politics and privacy

None of the data you store in your personal space will be divulged or used for profit, even under threat. However, I do not guarantee that I will not take a look at it occasionally.
