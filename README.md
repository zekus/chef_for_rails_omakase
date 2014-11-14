# Chef recipes

## IMPORTANT: before you start

Along the code in this repo you'll se references to "your_app". Please, customise it with a proper name everywhere.

## What it does

Basically, they setup the server completely, from the most basic packages to the configuration of iptables.

## How can I do it?

Chef is based on the idea of idempotence, so you *should* safely run this recipes over and over in the server without causing any damage. Let'se see:

If you want to bootstrap a new server, installing the chef-solo client first et al. you should run this command:

```
knife solo bootstrap root@host
```

If you just made a change in one of the recipes and you want to update the changes in the server, just do:

```
knife solo cook root@host
```

**To do that, you'd need, of course, to properly fill in the node config file with the proper settings for your environment.**

## Gemfile and Berksfile

To install the basic dependencies you need to run all this stuff, just do a `bundle install` inside the `chef/` directory.

This setup is using [Berkshelf](http://berkshelf.com/) to manage dependencies, so that you don't need to manually copy cookbooks from the internet. It works basically as Bundler, but for recipes instead of gems. You don't need to run the `berks install` command manually after changing something in `Berksfile`. `knife-solo` will take care when firing any command :wink:

## The runlist

You'll find our own recipes in the folder `site-coobooks/your_app/recipes`. Here's a brief summary of the runlist:

- **apt::default**: takes care that the `apt` cache is always up to date to install updated packages.
- **build-essential::default**: installs the basic libraries to be able to compile stuff. We'll need them later.
- **your_app::basics**: installs some basic packages we need, like: Node.js, Git, Imagemagick, etc. It creates swap file of 1GB.
- **nginx**: installs Nginx from a native package and configures it as a service.
- **postgresql::server**: installs Postgres server.
– **postgresql::server_dev**: installs Postgres development dependencies (to be able to install the gem later).
- **your_app::ruby**: includes a couple of recipes to install rbenv and ruby-build and installs all the rubies specified in the node configuration.
- **your_app::user**: users and groups boring stuff. Heads up! The password is being shadowed, so that's not the real one. Ask Miguel.
- **your_app::security**: disables SSH password authentication and sets up some basic iptables rules.
- **your_app::rails_app**: nginx's virtual hosts configuration for each app.
