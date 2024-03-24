# Retrocomputing: Genera Lisp Machine

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [Retrocomputing: Genera Lisp Machine](#retrocomputing-genera-lisp-machine)
    - [About](#about)
    - [Get Ready](#get-ready)
    - [Get Set](#get-set)
    - [Go!](#go)
    - [Caveats](#caveats)
- [Additional Reading](#additional-reading)

<!-- markdown-toc end -->

## About

Runs "opengenera2" on Ubuntu Cloud Image inside qmeu. The result is not especially stable, but sufficient for the casual explorer. 

This project depends on other existing resources:
* [Virtual Lisp Machine on Linux](http://www.jachemich.de/vlm/genera.html)
  provides a Lisp Machine World with NFSv3 support
* [Running Open Genera 2.0 on Linux](https://archives.loomcom.com/genera/genera-install.html)
  mainly reference
* [Provisions a Ubuntu 20.04 VM in QEMU on Mac OSX using Cloud-Init](https://gist.github.com/relyt0925/c761f5b5b3ce5363650ab6444bf7d159)
  reference for qemu usage

## Get Ready
To launch a qemu VM running genera:

* Ensure qemu in your system: `brew install qemu`
* Download resouces and build up `make qemu-install`
* For normal usage, just run `make run` might be okay

Here are some detailed infomation:
* This will download an ubuntu bionic server cloud image
  * change `CLOUD_IMG_LINK` for other cloud image should be avaliable
  * The `CLOUD_IMG_SIZE` is `20G`, change it or use `qemu-img resize`
* The configuration is automated by `user-data`. 
* The port forward is `SSH_PORT` (`2333`), `VNC_PORT` (`5902`)
* The installation needs network to download files

Building the image involves pulling files from the Internet, which introduces uncertainty. 

## Get Set
After the server is running, you can use Open Genera by opening:

```shell
vnc://localhost:5902 password "genera"
```

If failed to launch successfully you will only see a white screen with a black status bar at the bottom. If this happens it will probably restart successfully using:

```shell
restart-genera # currently should in vm
```

On a successful launch you will have a screen filled with pleasantly styled text. The resolution will be 1150x900, which was the native resolution of the Symbolics 3600. You should then configure the system as follows:

    "login Lisp-Machine"
    "define site <Something Fancy>"
    Left click value of "Namespace Server Name". Change to "genera"
    Left click value of "Unix Host Name". Change to "genera-host"
    Left click "<end> uses these values" (or type <End>)
    If prompted, type return to login anonymously
    ":reset network"
    
## Go!

See [TOUR](TOUR.md) for a quick guide on how to get started with the included user's guide.

## Caveats

```Save World``` will not succeed, and if it does it will not restore, and if it does then you are a lucky user! 

(Note: i am quite new to qemu, but you may use qemu snapshot to do the save world things. )

# Additional Reading

http://www.textfiles.com/bitsavers/pdf/symbolics/

![splash screen](https://github.com/ynniv/opengenera/raw/master/screenshots/splash%20screen.png)
![documentation viewer](https://github.com/ynniv/opengenera/raw/master/screenshots/document%20examiner.png) 
![graphical program output](https://github.com/ynniv/opengenera/raw/master/screenshots/sample%20program.png)
