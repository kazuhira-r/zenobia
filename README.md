# Zenobia

## What's Zenobia
Zenobia is a tool for local installation management of WildFly Swarm Hollow Uberjars and Payara Micro.

```shellscript
## install
$ curl https://raw.githubusercontent.com/kazuhira-r/zenobia/master/install-zenobia.sh | bash


## init
$ source "${HOME}/.zenobia/bin/init-zenobia.sh"


## Payara Micro install
$ zenobia install payara-micro


## start Payara Micro
$ payara-micro
```


### Feature
- install jar
- uninstall jar
- switch version
- create executable file

### Support Platform
*nix (e.g. Linux)

### Support Application Server
- WildFly Swarm
- Payara Micro

### Requirement
- bash
- Perl
- curl

### Command
- install
- uninstall
- set
- current
- list

## Install
Installing Zenobia on UNIX-like platforms is as easy as ever. Zenobia installs smoothly on Mac OSX, Linux, Cygwin, Solaris and FreeBSD. support Bash shell.
Simply open a new terminal and enter:
```shellscript
$ curl https://raw.githubusercontent.com/kazuhira-r/zenobia/master/install-zenobia.sh | bash
```

The last step involves editing and removing the initialisation snippet from your `.bashrc`, `.bash_profile` and/or `.profile` files.  The snippet of code to be removed looks something like this:
```shellscript
[[ -s "${HOME}/.zenobia/bin/init-zenobia.sh" ]] && source "${HOME}/.zenobia/bin/init-zenobia.sh"
```
Once removed, you have successfully uninstalled Zenobia from your machine.

## Usage
### Basic Command
install latest version.
```shellscript
$ zenobia install [server-type] ([wildfly-swarm type])
```

example.
```shellscript
$ zenobia install wildfly-swarm web

$ zenobia install payara-micro
```

install specified version.
```shellscript
$ zenobia install [server-type] ([wildfly-swarm type]) [version]
```

example.
```shellscript
$ zenobia install wildfly-swarm microprofile 2018.3.3

$ zenobia install payara-micro 5.181
```

uninstall specified version.
```shellscript
$ zenobia uninstall [server-type] ([wildfly-swarm type]) [version]
```

example.
```shellscript
$ zenobia uninstall wildfly-swarm microprofile 2018.3.3

$ zenobia uninstall payara-micro 5.181
```

set current version.
```shellscript
$ zenobia set [server-type] ([wildfly-swarm type]) [version]
```

example.
```shellscript
$ zenobia set wildfly-swarm web 2018.3.3

$ zenobia set payara-micro 5.181
```

show current version.
```shellscript
$ zenobia set [server-type] ([wildfly-swarm type])
```

example.
```shellscript
$ zenobia current wildfly-swarm web
[2018-03-24 15:08:42] [INFO] [wildfly-swarm] current web version 2018.3.3

$ zenobia current payara-micro
[2018-03-24 15:08:35] [INFO] [payara-micro] current version 5.181
```

list local install versions.
```shellscript
$ zenobia list [server-type] ([wildfly-swarm type])
```

example.
```shellscript
$ zenobia list wildfly-swarm
[2018-03-24 15:03:41] [INFO] [wildfly-swarm] local installed wildfly-swarm uberjars
  type: microprofile
    2018.3.3 [current]
    2018.3.2
  type: web
    2018.3.3 [current]
    2018.3.2

$ zenobia list wildfly-swarm web
[2018-03-24 15:03:44] [INFO] [wildfly-swarm] local installed wildfly-swarm web uberjars
  type: web
    2018.3.3 [current]
    2018.3.2

$ zenobia list payara-micro
[2018-03-24 15:03:48] [INFO] [payara-micro] local installed payara-micro jars
  5.181 [current]
  4.1.2.181
```

### Executable
WildFly Swarm Hollow Uberjar.
```shellscript
$ web-hollowswarm

$ microprofile-hollowswarm
```

Payara Micro.
```shellscript
$ payara-micro
```

## Development Mode
To operate Zenobia as a development mode, set the environment variable `ZENOBIA_DEVELOPMENT=1`.
```shellscript
$ ZENOBIA_DEVELOPMENT=1 bin/zenobia install wildfly-swarm microprofile
```
