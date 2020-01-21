# VPN Policy based routing

This project includes some config files and instructions (in this README) to allow for a policy based routing to forward based on port on a linux system.

## So what is policy based routing anyway?

Well if you're asking this question then I wonder how you found this page in the first place, but here it goes.
Policy based routing is simply making routing decisions based on some other criterion than destination address.
In this case I built the system to make routing decisions based on destination port, but this setup could be easily extended to work for other purposes as well.

## Getting started

## Prerequisites

This project was tested on Ubuntu LTS 18.04 but should work on any linux distro that uses the following network tools:
1. `iptables` (firewall)
1. `iproute2` (routing)
1. `netplan` (network interface config)
This *should* be the majority of linux systems today since `net-tools` was deprecated by debian, which basically ended development on the tool.

## Installation

The only dependency that really needs to be installed is `iptables-persistent` which can be installed on debian systems with:
```
sudo apt install iptables-persistent
```
Other distros should be similar just changing the package manager around.

Then just run:
```
sudo ./install.sh
```
I don't blame you if you're suspect of running a shell script you found online as root, but feel free to open it up it's really just a copy paste to make your life easier.
The only other thing is turning off the `rp_filter` on the system.
After installation you will need to reboot the machine for the changes to take effect.

### A note on `rp_filter`

The `rp_filter` is the "reverse path filter" and basically what it does is make sure that the source of the packet can be reached on the same interface where the packet was received from.
That seems logical, the only problem is that since we're making policy based routing choices the new `icmp` packet will be routed through the default route instead of our custom routing decisions.
Since it can't reach the source the packet will be dropped and all our fancy routing will just be an overcomplicated way of dropping packets.
There's probably a way to configure the `rp_filter` to work with what we're doing, and if you can figure it out I'd love to hear it!
But as of now I just disabled it to make life simpler.

## Configuration

The only config that needs to happen is deciding what ports you want routed.
I'd like to script this in the future but for now you'll need to edit the `rules.v4` file with your ports. These lines are where the magic happens:
```
-A PREROUTING -p tcp -m tcp --dport 22 -j MARK --set-xmark 0x1/0xffffffff
-A OUTPUT -p tcp -m tcp --dport 22 -j MARK --set-xmark 0x1/0xffffffff
```
These two lines open up port 22 (ssh) through our untunneled route.
What this means for configuration is you can add a pair of lines like these for every port you want to not use your VPN and you'll be good to go.
Do note however you'll need to do this before you run the install script (or just rerun the install script after you've edited).
