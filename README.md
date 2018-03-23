# Zenobia

## Install
Installing Zenobia on UNIX-like platforms is as easy as ever. Zenobia installs smoothly on Mac OSX, Linux, Cygwin, Solaris and FreeBSD. support Bash shell.
Simply open a new terminal and enter:
```shellscript
$ curl https://raw.githubusercontent.com/kazuhira-r/zenobia/master/install-zenobia.sh | bash
```

The last step involves editing and removing the initialisation snippet from your `.bashrc`, `.bash_profile` and/or `.profile` files.  The snippet of code to be removed looks something like this:
```shellscript
[[ -s "/home/kazuhira/.zenobia/bin/init-zenobia.sh" ]] && source "/home/kazuhira/.zenobia/bin/init-zenobia.sh"
```
Once removed, you have successfully uninstalled Zenobia from your machine.

## Development Mode
To operate Zenobia as a development mode, set the environment variable `ZENOBIA_DEVELOPMENT=1`.
```shellscript
$ ZENOBIA_DEVELOPMENT=1 bin/zenobia install wildfly-swarm microprofile
```

