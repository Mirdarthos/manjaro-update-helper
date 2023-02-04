# My Universal Manjaro Update Helper

***

###### _Named after my adopted rescue dog because, why not?_
###### _Her name is actually Lulu (pronounced Looloo) but before we adopted her, she had puppies. So with the little hanging tummy that reminds me of a cow's udder, from behind she looks like a miniature cow. So she became known to me as Mumu (pronounced Moomoo.)_

###### **_So she shall be my Moomoo and I shall call her my Moomoo._**

***

After spending quite some time on the [Manjaro forum](https://forum.manjaro.org/) I started noticing a pattern when updates happen. Usually after the update, when support is being asked, the people trying to help always have to request the same information. Hence me thinking that it can be scripted, seeing as it's so repetative. Also, if the information reqqueested is present before the first person replies, it should cut the support time considerably, since then there is no need for back-and-forth for basic things.

Couple that with a desire to learn bash, and viola! I saw an opportunity to contribute, both to my favorite Linux distribution as well as myself.

So, I present **My Universal Manjaro Update Helper.**
_(Or, **`MuMuh`** if you will.)_

## Usage:

_(For now, you'll still have to run it directly. This might (probably will) change in the future.)_

```
./system_update_script.sh
```

The script is **_not_** meant to be run as `root` or with `sudo`. It'll ask for the `sudo` password if it requires it.

### Currentt arguments:

| Argument | Explanation |
|---:|---|
| `--addsudoers`, `-a` | Add the specified user as able to run all the required `sudo` commands without a password, without human intervention. |
| `--checkdeps`, `-d` | Check to ensure all dependencies are installed. |
| `--skipbackup`, `-s` | If no backup is required, skip creating one. |
| `--custombackupcommand`, `-c` | If you use some other command for performing backups, specify it here. Wioll skip for anything that contains an `rm` command, as that can be dangerous and cause havoc. |

There is the possibility of there being added to these, but if so this list will be updated.

Any feedback is welcome. Smell even slightly like a troll and you will be ignored.