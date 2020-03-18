# Varnish versions

# Overview
Varnish 4 had a syntax update (vcl_fetch is no longer), Fastly uses a heavily customized version 2.1 
(https://www.fastly.com/blog/benefits-using-varnish)./
In attempts to create a docker file for testing our fastly syntax, I found the following varnish 3.0.7 repo:

https://github.com/mobulum/docker-varnish/

That repo is now outdated as it uses an apt source - Varnish now host their own source files (either in github or from
http://varnish-cache.org/docs/trunk/installation/install_source.html) so this repo updates that file mostly.

I ~~should probably~~ will contribute the changes back to the original repo but right now, I can start trying to test 
v2.1 (or whatever version I choose - as long as I change the source)

## Config
In order to satisfy my use case (to connect to my host machine which runs my LNMP stack), I specified my docker bridge 
IP address in the docker-compose file rather than another container.

Because my host is setup as subdomains of localhost (i.e. NAME.localhost) I can visit http://NAME.localhost:8080 for the
varnish version of my sites.

I guess I can now play around with Fastly configs and ESI/SSI now? :) 


## What
This repo contains different docker definitions for Varnish - I'm sure I could probably create base but that would
 require a bit more work and I just want to save (commit) what I've got so far.
 
## Why
 The original Varnish v3 docker container I found relied upon a dated Varnish repository, their site specifically says 
 to build from source so I moved to that instead. 
 
 Each of these folders follows the exact same process, so if you wanted v4 (or whatever) you can pretty much use one of 
 these as a template (just go to varnish site and find install instructions).
 
 Plus I'm being a bit lazy because I didn't intend to spend ages on getting Varnish Docker - I intended to delve into
 Varnish itself :)

## How

 Simply navigate into a folder and run 
 `docker-compose up --build --force-recreate -d` 
 and get the version listed.

 Because they all run on port 8080, you can't run them at the same time.
 
 

