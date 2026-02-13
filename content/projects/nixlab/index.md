---
title: Nixlab
description: My homelab machine and its NixOS configuration
date: 2026-02-13
tags: ["hardware", "nix", "devops"]
---

## Hardware
My lab machine is a HP T630 Thin Client which I bought on [olx](https://olx.pl/) for 40 PLN (~10$).
Makes it perfect for a low consumption home server staying in my bedroom, as it requires only passive cooling.

{{< gallery images="hp_t630_standing.png, hp_t630_inside.png, hp_t630_ports.png" size="medium" align="center" >}}

Under the hood it has two M2 slots for drives, two slots for RAM (now there lies 2x4GB sticks), soundcard, a small cheap speaker which produces a horrible but authentic sound. There is also a place for Wi-Fi chip. All I had to buy additionally was one 128 GB SATA drive (30 PLN) and one 4 GB RAM stick (30 PLN), which was an overkill, but prices on RAM weren't that high back then. The total cost of hardware appears to be 100 PLN (~28$ on 2026-02-13).

Good thing about this mini-pc is that it has quite a few ports:
- Power Connector (DC-in)
- VGA IN/OUT
- Audio Jack
- 2xDisplayPort
- 2xUSB 2.0 on the back, 4x on the front
- PS/2 Mouse and Keyboard Ports
- Ethernet RJ-45

## OS
The question about what to install on this machine was a no-brainer. I had already been using [NixOS](https://nixos.org/) for around a year on my laptop when I bought this machine. So I created a new host in the same config, which made me modularize the NixOS configuration to be good at handling multiple hosts.
NixOS allowed me to build the system from my laptop, which is surely more performant than the old weak processor of ThinClient. And obviously having it as a code makes life easier and configuration manageable.

The network hostname was selected to be __`nixlab`__, which is the server for this website (as of 2026-02-13).
All my devices share VPN via [Tailscale](https://tailscale.com/), and tailscale allows to serve content from their public address via [funnel](https://tailscale.com/docs/features/tailscale-funnel) feature, so I used that, as I can't get a public IPv4 with my ISP unfortunately :(

## Services
Right now nixlab serves:
- [This website](/)
- [Forgejo](https://nixlab.worm-chameleon.ts.net:8443/)
- [SearXNG](https://nixlab.worm-chameleon.ts.net:10000/)

I use Forgejo mostly to mirror my GitHub repos for the day I'll be randomly banned there or something else happens ಠ_ಠ.
