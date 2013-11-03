================
Mesos formula
================

A saltstack formula that is empty. It has dummy content to help with a quick
start on a new formula.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``template``
------------

Installs the template package, and starts the associated template service.

Things to think about:
- Auto detect master node ip (Make sure master node is reachable from slaves), do this via hostsfile
- Support for mesosphere, apache mesos and possibly other vendors
- Make sure OpenJDK java package or oracle is installed, list dependency to sun-java
- Mesos frameworks integration, use subfolders for each framework or different git repo


Dependencies
============
- sun-java-formula
- hostsfile-formula


Setup
=====

- Download all dependencies
- Enable publish.publish/Peer communication on the master

