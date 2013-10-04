---
title: proxy-toggle.sh
author: Matthew Sojourner Newton
date: 2012-09-13 13:29
template: article.jade
---

![](http://media.tumblr.com/tumblr_mab1zvlEEm1qz4cdo.png)

##Reason for Being

I need to change my proxy settings regularly depending on which network I'm connected to. I initially tried [Proxy Switchy](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&ved=0CCIQFjAA&url=https%3A%2F%2Fchrome.google.com%2Fwebstore%2Fdetail%2Fcaehdcpeofiiigpdhbabniblemipncjj&ei=pDxSUMa4M4zQigLh-IGgAQ&usg=AFQjCNG68edvuAF1w8GAa1G_BM5cAgmeww) but found that it took up too much CPU time. There is no excuse for that in such a simple utility, so I decided to trash it and do things the old fashioned way.

##Method

It turns out that it's quite trivial to change proxy settings on OS X:

    sudo networksetup -setsocksfirewallproxy <network service> <proxy_host> <port_number>

example:

    sudo networksetup -setsocksfirewallproxy "Wi-Fi" localhost 1080

Then you turn if off with:

    sudo networksetup -setsocksfirewallproxystate off

##Script
However, I can't be trusted to remember the full commands and arguments so I wrote a tiny script to do it:

    #!/bin/sh

    PROXY_INTERFACE="USB Ethernet"
    PROXY_HOST=localhost
    PROXY_PORT=1080

    if [[ $1 == "on" ]]; then
        sudo networksetup -setsocksfirewallproxy "$PROXY_INTERFACE" $PROXY_HOST $PROXY_PORT
        echo "SOCKS proxy enabled"

    elif [[ $1 == "off" ]]; then
        sudo networksetup -setsocksfirewallproxystate "$PROXY_INTERFACE" off
        echo "SOCKS proxy disabled"

    elif [[ $1 == "status" ]]; then
        echo "======================================================"
        echo "Network Services:"
        echo "======================================================"
        networksetup -listallnetworkservices
        echo
        echo "======================================================"
        echo "Current SOCKS Proxy Settings:"
        echo "======================================================"
        networksetup -getsocksfirewallproxy "$PROXY_INTERFACE"
        echo

    else
        echo "`basename $0` toggles SOCKS proxy settings on OS X"
        echo
        echo "Usage: "
        echo "  $ proxy on           # turns SOCKS proxy on"
        echo "  $ proxy off          # turns SOCKS proxy off"
        echo "  $ proxy status       # prints status of proxy settings"
        echo
        echo "proxy interface:      " $PROXY_INTERFACE
        echo "proxy host:           " $PROXY_HOST
        echo "proxy port:           " $PROXY_PORT
        echo
        exit 65 # end process with error to indicate incorrect arguments
    fi

Cheers.
