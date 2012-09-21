smartos_cookbooks
=================

Chef Cookbooks and tools for use with SmartOS.  

This is intended for management of the Global Zone, not SmartMachines (Non-Global Zones).  For cookbooks and tools to be used with SmartMachines/NGZ's, please see the [joyent/smartmachine_cookbooks](https://github.com/joyent/smartmachine_cookbooks) repository instead.

For details about how to use this repository, please refer to http://wiki.smartos.org/display/DOC/Using+Chef


REPOSITORY LAYOUT
-----------------

* **cookbooks**: Indivial SmartOS cookbooks.  The "smartos" cookbook itself is considered the primary cookbooks applied to all nodes and should be the first one included in the run_list.
* **knife_bootstrap**: Bootstrap templates for Knife.
* **nodes**: Chef node attribute files.
* **smf**: SmartOS SMF XML manifests for Chef Solo & Chef Client
* **scripts**: Chef Solo bootstrap scripts to simplify deployment.

For Chef Solo users, a *Makefile* is included to transfer the contents of the repsitory to a web server for distribution.


DISLAIMER
---------

These tools and cookbooks are unofficial and not supported by Joyent or its partners.  Please use at your own risk.


TODO
----

* Make fat client bootstrap more verbose (add echos), make pkgsrc bootstrap less verbose.
* Sanitize and include LDAP Client cookbook
* LWRP for managing images (_imgadm_)
* LWRP improvements for user management
* LWRP improvements for SMF management
