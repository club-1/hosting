This tutorial is dedicated to users that are part of the `aliases` group. It describes actions that can be done by those users.

# Updating email aliases

## Edit the file that describes aliases

Open it with your favorite CLI text editor (`nano`, `vim`, etc.)

```
/etc/aliases
```

The file should approximatively look like this:

```conf
# See man 5 aliases for format
postmaster:     root
root:           nicolas
contact:        nicolas,vincent,guilhem,audrey
alert:          nicolas,vincent,guilhem,audrey
matrix-synapse: /dev/null
jellyfin:       /dev/null
```

### Add or remove users from an alias

Simply write or erase the name of the user you want to add after the alias name.

### Create or delete an alias

You can create as many aliases as you want by creating a new line using the [aliases db syntax][1]:

```
<ALIAS>:      <USER1>[,<USER2>...]
```

Simply remove or comment out (using `#`) a line to delete the corresponding alias.

## Submitting changes

After you've saved your edits, you have to regenerate the database (`/etc/aliases.db`) using the following command:

```
sudo newaliases
```

[1]: http://www.postfix.org/aliases.5.html