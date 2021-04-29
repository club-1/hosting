CardDAV initialization protocol
===============================

Smartphone client
-----------------

### CardDAV synchro client

Install DAVx5 App: [DAVx5](https://f-droid.org/fr/packages/at.bitfire.davdroid/)

Few install steps:

- don't use task system as the app can't manage it
- 
- authorize regular synchronization

Add an account by clicking the + button

Use the URL + credential method

Indicate `club1.fr` as server URL and use your UNIX credentials as user and password

Keep the default behavior for Vcard group system

And select the address books you want to keep in sync with this device

### Contact management application

The idea is to replace Google Contact manager with a more open software.

Install [Simple Contacts](https://f-droid.org/en/packages/com.simplemobiletools.contacts.pro/)

If you want to transfert your phone contacts to a new WebDAV adress book, use the menu to export contacts. Then choose from which account you want to copy them. This will save a `.vcf` file on your phone. After that, you can use the import function in the same menu to import this file. You will have to select the WebDAV adress book as a destination target.

Now your contacts are being imported, this can take a few minutes if you have a lot of them.

With this application you can filter from which account you want to display the contacts, you may want to select only the WebDAV source to avoid duplicated items. If you already had your contacts loaded in the WebDAV server, this may be the only action needed.
