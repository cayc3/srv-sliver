# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
# coder: b0b
# stamp: 1999-12-31

qvm-template-installed-sliver:
  qvm.template_installed:
    - name: debian-11-minimal

create-srv-sliver-template:
  qvm.clone:
    - name: srv-sliver-template
    - source: debian-11-minimal
    - label: black
