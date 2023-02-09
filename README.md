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

_(For now, you'll still have to run it directly. This might (probably will) change in the future.)_

```
./system_update_script.sh
```

The script is **_not_** meant to be run as `root` or with `sudo`. It'll ask for the `sudo` password if it requires it.

### Current arguments:

| Argument | Explanation |
|---:|---|
| `--addsudoers`, `-a` | Add the specified user as able to run all the required `sudo` commands without a password, without human intervention. |
| `--checkdeps`, `-d` | Check to ensure all dependencies are installed. |
| `--skipbackup`, `-s` | If no backup is required, skip creating one. |
| `--custombackupcommand`, `-c` | If you use some other command for performing backups, specify it here. Will skip for anything that contains an `rm` command, as that can be dangerous and cause havoc. |

There is the possibility of there being added to these, but if so this list will be updated.

***

This my firest attempt at a package that can be used by more than just me. With the result that there is quite the possibility the `pkgbuild` file is either incorrect, or missing something.

I've also run `system_update_script.sh` through [Shellcheck](https://www.shellcheck.net/) and implemented _nearly_ all suggestions.

So I'm asking to please respond gently, I'd much rather have guidance and advice to fix aany issues than just unhelpful criticism.

So please be helpful in responses, I'll appreciate it much more. Smell even slightly like a troll, though, and you'll be ignored.