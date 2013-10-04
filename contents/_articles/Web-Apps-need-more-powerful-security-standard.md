---
title: Web Apps need more powerful security standard
author: Matthew Sojourner Newton
date: 2012-06-07 12:53
template: article.jade
---

I've been developing a web app that needs access to all sites that a user visits. Somewhat similar to lastpass, it scans pages as the user browses and fills in information in forms when appropriate.

### Currently, the only decent way to make such a thing is to put it in a web browser plugin.

But what happens when you're on a work computer, kiosk, or mobile device? You lose the great functionality that you've been accustomed to on your computer. 

### You're worse off than before because now your workflow is dependent on this functionality you don't have access to.

What we need is a secure way to allow a true web app to *access other websites data on our behalf, directly from the browser*. CORS is not the answer (http://en.wikipedia.org/wiki/Cross-origin_resource_sharing) because it relies on each site giving special permission to the web app.

I'm not the only one who thinks so. Here is a quote from Tim Berners-Lee:
### "If I can’t give power to apps, then the web app platform cannot compete with native apps."
> The open web platform is a strong contender
for apps which you write once run anywhere
and end up being a better alternative, or quietly
moving out, native apps on all kids of device.

> These apps have got to be able to completely
act as agents trusted by the user, like for example

>   - a web browser
>   - a calendar client
>   - an IMAP client

> and so on, none of these can you currently write
as a web app, because of CORS. 

> As a user when I install an app, I want to be able to give
it access to a selection of:

> - Program storage, to a limit
> - Whether it is permanently available or downloaded or cached for a while
> - Access to RAM at runtime, to a limit
> - Access to the net, maybe to a bandwidth limit
> - CPU time when in background, to a limit
> - Ability to access anything on the web
> - Access to its own local storage up to a given limit
> - Access to shared local storage up to a given limit
> - Access to my location, as we currently allow an origin;
> - Access video and still camera, and sound
> - Access to other sensors such as temp, accelerometer, etc

> I want to be able to se where all my resources (including CPU, RAM, 'disk')  on my laptop or tablet or phone
are being used up, just like I do with music and movies.

> I want maybe a couple of default profiles for all the above.

> (I'll want to sync its local and shared data storage between  all my devices too)

> If I can't give power to apps, then the web app platform cannot compete with native apps.

> I don't want the value of these setting to be the origin domain name of the script of the app,
as that is too high a granularity.

> Note that when people talk about installation, they often immediately discuss
packaging and manifest formats, which will need to be defined, and for which
we might have more than one, but is not the crux of the issue -- the crux is
allowing it access to precious and/or sensitive resources.

> Tim

source: http://lists.w3.org/Archives/Public/public-webapps/2012JanMar/0464.html#start464
