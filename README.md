# Zenobia

## Install
install zenobia
```shellscript
$ curl https://raw.githubusercontent.com/kazuhira-r/zenobia/master/install-zenobia.sh | bash
```

The last step involves editing and removing the initialisation snippet from your `.bashrc`, `.bash_profile` and/or `.profile` files.  The snippet of code to be removed looks something like this:
```shellscript
[[ -s "/home/kazuhira/.zenobia/bin/init-zenobia.sh" ]] && source "/home/kazuhira/.zenobia/bin/init-zenobia.sh"
```
