================
Mesos formula
================

Installs mesos on ubuntu from the mesosphere repo

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``mesos``
========
Installs nodes as mesos-master and mesos-slave based on pillar config masters_target and slaves_target.
The default targeting is to install mesos-master to all nodes with the role mesos_master and to
install mesos-slave to all nodes with the role mesos_slave. This is configurable through pillar.



Dependencies
============
You have to first install and apply the following dependencies:

- sun-java-formula
- hostsfile-formula


Setup
=====

- Download all dependencies listed above
- Enable publish.publish/Peer communication on the master /etc/salt/master.d/peer.conf:
::
    peer:
      .*:
        - network.interfaces
