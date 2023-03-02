# My Universal Manjaro Update Helper

###### _Named after my adopted rescue dog because, why not?_
###### _Her name is actually Lulu (pronounced Looloo) but before we adopted her, she had puppies. So with the little hanging tummy that reminds me of a cow's udder, from behind she looks like a miniature cow. So she became known to me as Mumu (pronounced Moomoo.)_

###### **_So she shall be my Moomoo and I shall call her my Moomoo._**

***

After spending quite some time on the [Manjaro forum](https://forum.manjaro.org/) I started noticing a pattern when updates happen. Usually after the update, when support is being asked, the people trying to help always have to request the same information. Hence me thinking that it can be scripted, seeing as it's so repetative. Also, if the information requested is present before the first person replies, it should cut the support time considerably, since then there is no need for back-and-forth for basic things.

Couple that with a desire to learn bash, and viola! I saw an opportunity to contribute, both to my favorite Linux distribution as well as myself.

So, I present **My Universal Manjaro Update Helper.**
_(Or, **`mumuh`** if you will.)_

## Usage:

After running the installation, the script executed as follows:
```
mumuh
```

### For example:

```
$ mumuh --help

######################################################################
################### Manjaro update helper script.#####################
######################################################################
# This script is just a wrapper for pamac, with the exception that   #
# if there were any errors, it allows you to copy them, neatly       #
# formatted for use as. or with a forum post, along with all the     #
# details required for requesting assistance.                        #
# It also allows you to set the required suddoers permissions in     #
# '/etc/sudoers.d'                                                   #
#                                                                    #
# Usage:                                                             #
#     * --addsudoers, or -a                                          #
#       Will add a file called /etc/sudoers.d/manjaro-update-helper  #
#       with entries to enable running this script as the current    #
#       user without a password.                                     #
#       CARE MUST BE TAKED WITH THE /etc/sudoers FILE, AS DOING IT   #
#       INNCORRECTLY CAN LEAD TO BEING LOCKED OUT OF THE SYSTEM.     #
#       PLEASE BE VERY CAREFUL.                                      #
#     * --skipbackup, or -s                                          #
#       This will cause the update process to skip the backup step   #
#       for the update.                                              #
#     * --custombackupcommand, or -c                                 #
#       This argument allows for specifying a custom backup command, #
#       for if you want to use something other than the default      #
#       timeshift one, or even is you use something other than       #
#       timeshift.                                                   #
#       NOTE:                                                        #
#       If --skipbackup, or -s is specified, then specifying this    #
#       will have no effect.                                         #
#     * --skipOrphansRemove                                          #
#       If this argument is specified, muumuh will skip the removal  #
#       of orphan packages after a successful upgrade.               #
#     * --help, or -h                                                #
#       Show this help and exit.                                     #
#     If no arguments are passed, the script performs its main       #
#     functionality.                                                 #
# Examples:                                                          #
#     * To add the current user to the sudoers list:                 #
#        mumu --addsudoers                                           #
#          OR                                                        #
#        mumu -a                                                     #
#     * If you wish to skip performing backups for this execution:   #
#        mumu --skipbackup                                           #
#          OR                                                        #
#        mumu -s                                                     #
#     * If you want to skip removing orphan pakackages:              #
#        mumu --skipOrphansRemove                                    #
#     * If you want to use a custom command:                         #
#        mumu --custombackupcommand=<custom command>                 #
#          OR                                                        #
#        mumu -c <custom command>                                    #
######################################################################
```

The script is **_not_** meant to be run as `root` or with `sudo`. It'll ask for the `sudo` password if it requires it.

***

### Current arguments:

| Argument | Explanation |
|---:|---|
| `--addsudoers`, `-a` | Add the specified user as able to run all the required `sudo` commands without a password, without human intervention. |
| `--skipbackup`, `-s` | If no backup is required, skip creating one. |
| `--custombackupcommand`, `-c` | If you use some other command for performing backups, specify it here. Will skip for anything that contains an `rm` command, as that has the potential be dangerous and cause havoc. |
| `--skipOrphansRemove` | Skip removal of orphan packages on successful upgrade process. | |

There is the possibility of there being added to these, but if so this list will be updated.

***

This my first attempt at a package that can be used by more than just me. With the result that there is quite the possibility the `pkgbuild` file is either incorrect, or missing something.

I've also run `mumuh` through [Shellcheck](https://www.shellcheck.net/) and implemented _nearly_ all suggestions.

So I'm asking to please respond gently, I'd much rather have guidance and advice to fix any issues than just unhelpful criticism.

So please be helpful in responses, I'll appreciate it much more. Smell even slightly like a troll, though, and you'll be ignored.