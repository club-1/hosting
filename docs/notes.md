Create or update cert using dns auth
------------------------------------

    sudo certbot certonly --manual --manual-auth-hook dns-auth --manual-cleanup-hook dns-cleanup --manual-public-ip-logging-ok --preferred-challenges dns-01 --key-type ecdsa -d '*.alixturcq.club1.fr' -d '*.club1.fr' -d club1.fr
