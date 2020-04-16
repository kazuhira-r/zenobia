# Zenobia

## What's Zenobia
Zenobia is a tool for local installation management of Apache Tomcat and Payara Micro.

```shellscript
## install
$ curl https://raw.githubusercontent.com/kazuhira-r/zenobia/master/install-zenobia.sh | bash


## init
$ source "${HOME}/.zenobia/bin/init-zenobia.sh"


## latest Payara Micro install
$ zenobia install payara-micro


## start Payara Micro
$ payara-micro --deploy [war-file path]


## latest Apache Tomcat (current 9) install
$ zenobia install tomcat


## start Apache Tomcat 9
$ tomcat9 --deploy [war-file path or deploy directory]

## start Apache Tomcat 8.5
$ tomcat85 --deploy [war-file path or deploy directory]
```

*Note: when running with Cygwin, it has a .bat extension (e.g. `tomcat9.bat`)

### Feature
- install jar
- uninstall jar
- switch version
- list version (local installed / Maven Central registered)
- create executable file

### Support Platform
Linux

### Support Application Server
- Tomcat
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
- list-remote
- selfupdate
- help

## Install
Installing Zenobia on UNIX-like platforms is as easy as ever. Zenobia installs smoothly on Linux. support Bash shell.
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
$ zenobia install [server-type]
```

example.
```shellscript
$ zenobia install tomcat

$ zenobia install payara-micro
```

install specified version.
```shellscript
$ zenobia install [server-type]
```

example.
```shellscript
$ zenobia install tomcat 9.0.34

$ zenobia install payara-micro 5.181
```

uninstall specified version.
```shellscript
$ zenobia uninstall [server-type]
```

example.
```shellscript
$ zenobia uninstall tomcat 9.0.34

$ zenobia uninstall payara-micro 5.181
```

set current version.
```shellscript
$ zenobia set [server-type] ([wildfly-swarm type]) [version]
```

example.
```shellscript
$ zenobia set tomcat 9.0.34

$ zenobia set payara-micro 5.181
```

show current version.
```shellscript
$ zenobia current [server-type]
```

example.
```shellscript
$ zenobia current tomcat
[2020-04-16 23:39:24] [INFO] [tomcat] current tomcat 9 version 9.0.34


$ zenobia current payara-micro
[2018-03-24 15:08:35] [INFO] [payara-micro] current version 5.181
```

list local installed versions.
```shellscript
$ zenobia list [server-type]
```

example.
```shellscript
$ zenobia list tomcat
[2020-04-16 23:40:52] [INFO] [tomcat] local installed tomcat 9 jars
  9.0.34 [current]
  9.0.30

$ zenobia list payara-micro
[2018-03-24 15:03:48] [INFO] [payara-micro] local installed payara-micro jars
  5.181 [current]
  4.1.2.181
```

list maven central registered versions.
```shellscript
$ zenobia list-remote [server-type]
```

example.
```shellscript
$ zenobia list-remote tomcat
[2020-04-16 23:41:25] [INFO] [tomcat] Maven Central registered tomcat 9 jars
  9.0.1
  9.0.10
  9.0.11
  9.0.12
  9.0.13
  9.0.14
  9.0.16
  9.0.17
  9.0.19
  9.0.2
  9.0.20
  9.0.21
  9.0.22
  9.0.24
  9.0.26
  9.0.27
  9.0.29
  9.0.30
  9.0.31
  9.0.33
  9.0.34 [current]
  9.0.4
  9.0.5
  9.0.6
  9.0.7
  9.0.8
[2020-04-16 23:41:25] [INFO] [tomcat] Maven Central registered tomcat 8.5 jars
  8.5.0
  8.5.11
  8.5.12
  8.5.13
  8.5.14
  8.5.15
  8.5.16
  8.5.19
  8.5.2
  8.5.20
  8.5.21
  8.5.23
  8.5.24
  8.5.27
  8.5.28
  8.5.29
  8.5.3
  8.5.30
  8.5.31
  8.5.32
  8.5.33
  8.5.34
  8.5.35
  8.5.37
  8.5.38
  8.5.39
  8.5.4
  8.5.40
  8.5.41
  8.5.42
  8.5.43
  8.5.45
  8.5.46
  8.5.47
  8.5.49
  8.5.5
  8.5.50
  8.5.51
  8.5.53
  8.5.54
  8.5.6
  8.5.8
  8.5.9


$ zenobia list-remote payara-micro
[2018-03-24 15:51:15] [INFO] [payara-micro] Maven Central registered payara-micro jars
  4.1.2.172
  4.1.2.173
  4.1.2.174
  4.1.2.181
  5.181 [current]
```

### Executable
Apache Tomcat 9.
```shellscript
$ tomcat9 --deploy [war-file path or deploy directory]
```

Apache Tomcat 8.5.
```shellscript
$ tomcat85 --deploy [war-file path or deploy directory]
```

Payara Micro.
```shellscript
$ payara-micro --deploy [war-file path]
```

## Update
```shellscript
$ zenobia selfupdate
```

## Uninstall
remove, `${HOME}/.zenobia` directory.
```shellscript
$ rm -rf ${HOME}/.zenobia
```

and, removing the initialisation snippet from your `.bashrc`, `.bash_profile` and/or `.profile` files.
```shellscript
[[ -s "${HOME}/.zenobia/bin/init-zenobia.sh" ]] && source "${HOME}/.zenobia/bin/init-zenobia.sh"
```

## Development Mode
To operate Zenobia as a development mode, set the environment variable `ZENOBIA_DEVELOPMENT=1`.
```shellscript
$ ZENOBIA_DEVELOPMENT=1 bin/zenobia install tomcat
```
