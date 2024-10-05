# Toaster's Debian Setup Guide

After installing Debian for use as a server a third time, I decided to create this guide which documents and standardizes the common tasks that I perform every time I want to setup a new machine (e.g. passwordless sudo, git, SSH, etc.). The contents of this guide are intentionally biased towards my preferences for using linux.

This guide is for a headless Debian install, meaning no desktop or graphical interfaces are used.

## Sections

This guide is split into 3 sections:

1. [Debian Installation](./1-install.md)

2. [Scripted Configuration](./2-configure.md)

## Frequently Asked Questions

### Why Debian and not Ubuntu?

Debian is often favored over Ubuntu for headless server environments, especially when stability, control, and minimalism are paramount. While Ubuntu, developed by Canonical, offers a more user-friendly experience with up-to-date software, Debian's appeal lies in its conservative and community-driven approach.

Unlike Ubuntu, Debian prioritizes stability and long-term reliability, making it ideal for embedded developers (me) who do not require cutting-edge software. Debian's slower release cycle ensures that packages are well-tested before inclusion, reducing the risk of instability. In contrast, Ubuntu tends to push newer software, which may introduce more frequent updates and potential disruptions.

Moreover, Debian offers a lightweight, minimal installation by default, giving developers complete control over which packages and services are included. Ubuntu, even in server configurations, often comes with additional software and services pre-installed, which can add unnecessary overhead for developers looking for streamlined systems.

Canonical's influence on Ubuntu introduces certain factors that might not align with all developers' needs. For instance, Ubuntu promotes the use of Snap packages and is designed with cloud services and Canonical's own tools in mind. Debian, on the other hand, is entirely community-driven, focusing purely on free software principles without any corporate-specific goals. For developers looking for an open, vendor-neutral operating system with a long support cycle and minimal updates, Debian is the preferred choice.

### What hardware do you reccommend?



### What BIOS settings do you reccommend?

Most machines have a BIOS option that defines the behavior after power cycle while the machine is active. For example:

```
> Chipset
    > PCH-IO Configuration
        > State After G3
            > S0 State
```

This will make it so that if the machine inadvertently looses power, it will boot back into the OS on as soon as power is restored.
