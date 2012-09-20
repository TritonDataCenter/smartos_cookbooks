SmartOS Knife Bootstrap Scripts
===============================

Here are two different bootstrap scripts which allow Chef's Knife utility to bootstrap a SmartOS Global Zone for use with Hosted Chef ("The Opscode Platform").  

* _smartos-gz-fat.erb_: Installs and configures Chef using a pre-compiled binary distribution of Chef known as the Joyent Ops "Fat Client".  If you want the fastest setup with minimal footprint, this is the way to go.
* _smartos-gz-pkgsrc.erb_: Installs a full PKG-SRC environment, then installs Ruby and dependancies, then installs Chef as a Gem.  If you want a full development environment and the latest version of Chef/Ohai, choose this option.

How to Use
----------

Create a ~/.chef/bootstrap directory if it doesn't already exist, and copy the script(s) into that directory.  

Each bootstrap script is known as a "distribution", so simply pass the name of the file (minus extension) to 'knife bootstrap <node> -d script'.  Example:

<pre>
# knife bootstrap 1.2.3.4 -d smartos-gz-pkgsrc -r "initial_run_list,..."
</pre>


Some Notes About the Installation
---------------------------------

The most important point to keep in mind is that these are intended specifically for the SmartOS *Global Zone*.  Because /etc is non-persistant in SmartOS GZ's, we use /var/chef instead, which is not neccisary in SmartOS NGZ's (aka: Zones).

When the node is bootstrapped, Chef will be run once with whatever cook books you specify in the first time run list (we recommend running the "smartos" cookbook first).  If that run is successful the chef-client SMF service will start the client in daemon mode.
