# srv-sliver
Sliver C2 Server + GUI Client pre-configured for Qubes OS

![](https://github.com/cayc3/srv-sliver/blob/main/sliver_logo.png)

-------------

### Intro

- Self-Hosted, Sliver Adversary Emulation Framework + Sliver GUI Client
- Made for Qubes 4.1
- Sliver C2 Server pre-configured for rapid deployment & ease-of-use 
- TODO Populate Wiki with notes
- TODO AutoStart Shell Client (?)  
- TODO Update + Improve GUI

-------------

### Notes

- Do NOT use this
- Current configuration runs the server as a DispVM
- DispVM is likely NOT a good idea for C2
- If the above doesn't compute for you ...
- Do NOT use this

-------------

### Installation for Qubes 4.1

##### In dispXXX Qube:

```sh
git clone https://github.com/cayc3/srv-sliver
```

##### In dom0:

Install Script

```sh
qvm-run --pass-io dispXXX 'cat /home/user/srv-sliver/install.sh' | tee -a srv-sliver-install.sh >& /dev/null; chmod +x srv-sliver-install.sh; sudo ./srv-sliver-install.sh
```

Uninstall Script

```sh
qvm-run --pass-io dispXXX 'cat /home/user/srv-sliver/uninstall.sh' | tee -a srv-sliver-uninstall.sh >& /dev/null; chmod +x srv-sliver-uninstall.sh; sudo ./srv-sliver-uninstall.sh; rm srv-sliver-uninstall.sh
```

-------------

Project is free for personal use, donations are welcome.

Project is NOT free for use in commercial settings. Donation equivalent to 2
weeks of gross coffee costs is required in order to fulfill licensing terms. ; D

BTC: bc1q3ssxvtcve8pwf2ge7rn2a2flrxrpz5xjtg9lyp

-------------

Greetz & thanks to the following projects.

Tooling:  
https://github.com/BishopFox/sliver  
https://github.com/BishopFox/sliver-gui  
https://github.com/cloudflare/cloudflared  

