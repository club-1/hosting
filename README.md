This git repository has been created in order to **document** the hosting
possibilities on the CLUB1 server and to **manage the requests and issues**.


# Personal Space

The hosting is based on a user account composed of a `login` and a `password`,
giving access to a **personal storage space** on the server, which is accessible
at any time through internet. Several services can be added to it:

-   a simple [FTP](#ftp) account (the minimal option)
-   some [websites](#web)
-   [MySql](#mysql) databases
-   [SSH](#ssh) access to the server

All of this services are linked to your account so they all use the same `login`
and `password`.

## FTP

The FTP account provides access to your **personal storage space** thanks to
softwares like [FileZilla](https://filezilla-project.org/download.php?type=client)
(beware the windows installer includes bundlewares).

### Security

The FTP server is configured to only accept TLS connections. This is to avoid
passwords beeing sent in cleartext. This feature is referred to as
[FTPES](https://en.wikipedia.org/wiki/FTPS#Explicit).

A certificate is also used to prove the authenticity of the server key.
If prompted for a certificate approval, it is important to check that it is
issued by `Let's Encrypt`.

### Connection informations

| field            | value      |
| ---------------- | ---------- |
| host             | `club1.fr` |
| port             | `2121`     |
| authentication   | `Normal`   |

## Web

It is possible to add, on demand, `club1.fr` **sub-domains** pointing to one of
the **directories** of your **personal space** in order to create a website. The
sub-domains names are to be chosen together according to their availability and
viability.

## MySql

An access to MariaDb could be added, from which it is possible to create
**personal MySql databases**. A phpMyAdmin instance is accessible at the
following address: <http://club1.fr/phpmyadmin>

### Connection informations

| field            | value       |
| ---------------- | ----------- |
| host             | `localhost` |
| port             | `3306`      |

## SSH

The SSH acces can be very useful for **advanced users**, it can be created on
demand.

In this section [OpenSSH](https://en.wikipedia.org/wiki/OpenSSH) will be
used. As this software suite is in command-line, it is necessary to open a
console window.

### First connection

The first connection is critical because the key exchange takes place at this
moment. To avoid a
[man-in-the-middle attack](https://en.wikipedia.org/wiki/Man-in-the-middle_attack)
we have to make sure that we received the correct key during the exchange.
To solve this problem OpenSSH shows this warning with the fingerprint of the
received key:

>     The authenticity of host 'club1.fr (128.78.51.131)' can't be established.
>     ECDSA key fingerprint is SHA256:EKqAMn8X9z3IQDzffbHAwyU8CDG4fAStlzNQznHfyEY.
>     Are you sure you want to continue connecting (yes/no/[fingerprint])?

This is not ideal as the user must manually compare the fingerprint of the
warning with the one provided by the admin. So instead it is preferable to add
the key before the first connection using the following command:

    echo club1.fr,128.78.51.131 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBC64tjZ1WjxMMoGeWiipApfCAaQe1sP/YFoNWYtckXV7XfFFKsBf70SHUw/oPjVZ1sdwcIL8wsH8Q00oYMIv7M= >> .ssh/known_hosts

If for some reason the manual comparison is preferred, the fingerprint in the above example is indeed the fingerprint of club1.fr.


### Create a pair of RSA keys

To create a RSA kay pair we use the following command

    ssh-keygen

The command thereafter then effortlessly sends the public part of the key to the
server to be able to use it as an authentication method.
(Replace `<login>` with your `login`)

    ssh-copy-id -i ~/.ssh/id_rsa <login>@club1.fr

### Connection informations

| field            | value      |
| ---------------- | ---------- |
| host             | `club1.fr` |
| port             | `22`       |


# Requests and Problems

For any request or incident,
please [create an _issue_](https://github.com/club-1/hosting/issues) on GitHub
(you will need to create an account), choosing between `request` or `problem`
depending on the nature of the ticket. If this is an impersonal request, please
**check** that there is not already a similar request using the search bar.


# Server infos

## Hardware and infrastructure

The server is located in Pantin, France. It is connected to the internet by
optical fiber with an
[average upload rate of 200Mb/s](https://www.nperf.com/r/338260996-nDOmVdkc).

## Operationg system

The server runs the latest **LTS version of _ubuntu server_ (18.04)** and is
updated regularly.

## Installed software and libraries

A significant number of softwares and libraries are already installed. Here is a
_non-exhaustive list_ :
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

If you want additional software installed, please **check first** that it is not
already present, then, if not, **create a ticket** as
[explained above](#requests-and-issues).

## Availability

In order to guarantee a certain availability, the server as well as the network
equipment are powered by an _UPS_. However, since redundancy is not present at
all levels, the server may be inaccessible for short periods of time, for
example during a kernel update. That said, an effective availability
**above 99%** should be ensured.

All of the services are monitored using [UptimeRobot](https://uptimerobot.com/)
and the status page can be consulted at the following address:
[status.club1.fr](https://status.club1.fr)

# Politics and privacy

None of the data you store in your personal space will be divulged or used for
profit, even under threat. However, I do not guarantee that I will not take a
look at it occasionally.
