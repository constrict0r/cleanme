Description
--------------------------------------------------------------

Bash script to clean environments.

When executed this script performs the following actions:

- Ansible cleanup:

 - Remove installed ansible roles from current user home directory.
 - If the -u parameter is present, uninstall Ansible.

- General cleanup:

 - Remove all soft links found on tests folder.
 - Remove the folders docs/build or doc/build if exists.
 - Remove all files under /tmp folder.

- Python cleanup:

 - Remove python compilated and cache files.

Using the -t parameter is possible to select to cleanup only Ansible or Python resources.