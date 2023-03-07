# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
# coder: b0b
# stamp: 1999-12-31

include:
  - config.srv-sliver-template

create-srv-sliver-dvm:
  qvm.vm:
    - name: srv-sliver-dvm
    - present:
      - template: srv-sliver-template
      - label: red
    - prefs:
      - include-in-backup: True
      - template_for_dispvms: true
      - default_dispvm: srv-sliver-dvm
      - netvm: sys-firewall
      - memory: 512
      - vcpus: 2
    - require:
      - sls: config.srv-sliver-template
