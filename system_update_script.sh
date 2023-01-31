#!/bin/env bash

# Define an array with text formatting options, to get rid of the single value per format thing.
declare -A TEXTFORMATTING=(
    [RED]=$(tput setaf 1)
    [GREEN]=$(tput setaf 2)
    [YELLOW]=$(tput setaf 3)
    [BRIGHT]=$(tput bold)
    [NORMAL]=$(tput sgr0)
)

# If arguments are given, prepare some of the functionality
if [[ $# -gt 0 ]];
then
    usage() {
        echo
        printf '%s\n' "######################################################################"
        printf '%s\n' "################### Manjaro update helper script.#####################"
        printf '%s\n' "######################################################################"
        printf '%s\n' "# This script is just a wrapper for pamac, with the exception that   #"
        printf '%s\n' "# if there were any errors, it allows you to copy them, neatly       #"
        printf '%s\n' "# formatted for use as. or with a forum post, along with all the     #"
        printf '%s\n' "# details required for requesting assistance.                        #"
        printf '%s\n' "# It also allows you to set the required suddoers permissions in     #"
        printf '%s\n' "# '/etc/sudoers.d'                                                   #"
        printf '%s\n' "#                                                                    #"
        printf '%s\n' "# Usage:                                                             #"
        printf '%s\n' "#     * ${TEXTFORMATTING[BRIGHT]}--addsudoers${TEXTFORMATTING[NORMAL]}, or ${TEXTFORMATTING[BRIGHT]}-a${TEXTFORMATTING[NORMAL]}                                          #"
        printf '%s\n' "#       Will add a file called ${TEXTFORMATTING[BRIGHT]}/etc/sudoers.d/manjaro-update-helper${TEXTFORMATTING[NORMAL]}  #"
        printf '%s\n' "#       with entries to enable running this script as normal user,   #"
        printf '%s\n' "#       without sudo. This functionality requires root access,       #"
        printf '%s\n' "#       however, or to be run with sudo.                             #"
        printf '%s\n' "#       Optionally a valid username can be passed to enable the      #"
        printf '%s\n' "#       sudoers entries to be for the specified user.                #"
        printf '%s\n' "#     * ${TEXTFORMATTING[BRIGHT]}--checkdeps${TEXTFORMATTING[NORMAL]}, or ${TEXTFORMATTING[BRIGHT]}-d${TEXTFORMATTING[NORMAL]}                                           #"
        printf '%s\n' "#       Will check for and install any missing dependencies.         #"
        printf '%s\n' "#       ${TEXTFORMATTING[BRIGHT]}CARE MUST BE TAKED WITH THE ${TEXTFORMATTING[GREEN]}/etc/sudoers${TEXTFORMATTING[NORMAL]} FILE, AS DOING IT   #"
        printf '%s\n' "#       INNCORRECTLY CAN LEAD TO BEING LOCKED OUT OF THE SYSTEM.     #"
        printf '%s\n' "#       ${TEXTFORMATTING[RED]}PLEASE BE ${TEXTFORMATTING[BRIGHT]}VERY${TEXTFORMATTING[NORMAL]}${TEXTFORMATTING[RED]} CAREFUL.${TEXTFORMATTING[NORMAL]}                                      #"
        printf '%s\n' "#     * If no arguments are passed, the script performs its main     #"
        printf '%s\n' "#       functionality.                                               #"
        printf '%s\n' "#     * ${TEXTFORMATTING[BRIGHT]}--skipbackup${TEXTFORMATTING[NORMAL]}, or ${TEXTFORMATTING[BRIGHT]}-s${TEXTFORMATTING[NORMAL]}                                          #"
        printf '%s\n' "#       This will cause the update process to skip the backup step   #"
        printf '%s\n' "#       for the update.                                              #"
        printf '%s\n' "#       function and performs the update.                            #"
        printf '%s\n' "######################################################################"
        echo
        exit 0
    }

    addsudoers () {
        # Lets get the username to add to the sudoers list
        if [[ -v $1 ]];
        then
            USERNAMETOSUDOERS=$1
            id ${USERNAMETOSUDOERS} &> /dev/null
            USEREXISTS=$?
            if [[ USEREXISTS -ne 0 ]]; then
                echo "Specified username, ${USERNAMETOSUDOERS}, is not valid. Exiting." | systemd-cat --identifier=Upgrades --priority=err
                printf '%s\n' "${TEXTFORMATTING[RED]}Specified username, ${TEXTFORMATTING[BRIGHT]}${USERNAMETOSUDOERS}${TEXTFORMATTING[NORMAL]}${TEXTFORMATTING[RED]}, is not valid. Exiting."
                exit 10
            fi
        else
            USERNAMETOSUDOERS=$(logname)
        fi
        # Only continue if it is not root
        if [ $USERNAMETOSUDOERS == "root" ]; then
            printf '%s\n' "${TEXTFORMATTING[RED]}${TEXTFORMATTING[BRIGHT]}SCRIPT SHOULDN'T BE RUN AS ROOT. USE sudo INSTEAD. EXITING.${TEXTFORMATTING[NORMAL]}"
            exit 9
        fi
        sudo install --owner=root --group=root --mode=0440 /dev/null /etc/sudoers.d/manjaro-update-helper
        SUDOERSFILECREEATION=$?
        if [[ ${SUDOERSFILECREEATION} -eq 0 ]]; then
            printf '%s\n' "${TEXTFORMATTING[GREEN]}Successfully created file ${TEXTFORMATTING[BRIGHT]}/etc/sudoers.d/manjaro-update-helper${TEXTFORMATTING[NORMAL]}"
        else
            printf '%s\n' "${TEXTFORMATTING[RED]}Failed create file ${TEXTFORMATTING[BRIGHT]}/etc/sudoers.d/manjaro-update-helper ${TEXTFORMATTING[NORMAL]}${TEXTFORMATTING[RED]}due to not having the required permissions."
            exit 8
        fi
        SUDOERSENTRY="${USERNAMETOSUDOERS} ALL=(ALL) NOPASSWD: /usr/bin/timeshift *,/usr/bin/pamac"
        echo ${SUDOERSENTRY} | sudo tee --append /etc/sudoers.d/manjaro-update-helper > /dev/null
        SUDOERSENTRYADDED=$?
        if [[ $SUDOERSENTRYADDED -eq 0 ]]; then
                printf '%s\n' "sudoers entry created successfully in ${TEXTFORMATTING[BRIGHT]}/etc/sudoers.d/manjaro-update-helper${TEXTFORMATTING[NORMAL]}."
        else
                printf '%s\n' "${TEXTFORMATTING[RED]}Failed to create sudoers entry for user ${TEXTFORMATTING[BRIGHT]}${USERNAMETOSUDOERS}${TEXTFORMATTING[NNORMAL]}${TEXTFORMATTING[RED]} in ${TEXTFORMATTING[BRIGHT]}/etc/sudoers.d/manjaro-update-helper${TEXTFORMATTING[NORMAL]}."
        fi
        # Some housekeeping for this functionality, the adding sudoers functionality.
        unset USERNAMETOSUDOERS USEREXISTS SUDOERSENTRY SUDOERSFILECREEATION SUDOERSENTRYADDED
        exit 0
    }
    # a Function to check and enszure the dependencies are available
    checkdeps() {
        declare -A DEPENDENCIES=(
            [xsel]=0
            [ncurses]=0
            [pamac-cli]=0
            [pacman]=0
            [inxi]=0
            [meld]=0
        )
        DEPENDENCIESTOINSTALL=""
        # Let's see if pamac is installed
        pamac --version 1> /dev/null 2> /dev/null
        CMDSTATUS=$?
        if [[ $CMDSTATUS -eq 0 ]]; then  # pamac is installed, now let's check the rest
            INSTALLEDPKGLIST=$(pamac list --installed)
            for item in "${!DEPENDENCIES[@]}"; do
                ISPKGINSTALLEDNFO=$(echo "${INSTALLEDPKGLIST}" | grep "^${item} ")
                ISPKGINSTALLEDCMDRESULT=$?
                if [[ ${ISPKGINSTALLEDCMDRESULT} -ne 0 ]]; then
                    DEPENDENCIESTOINSTALL+="${item} "
                fi
            done
        fi
        DEPENDENCIESTOINSTALL=$(echo "${DEPENDENCIESTOINSTALL}" | sed -e 's/\ *$//g')
        if [ ! -z "${DEPENDENCIESTOINSTALL}" ]; then
            for dependency in ${DEPENDENCIESTOINSTALL}; do
                PKGNFO=$(pamac info $dependency)
                PKGFOUNDCHK=$?
                if [[ ${PKGFOUNDCHK} -eq 0 ]]; then
                    INSTALLSOURCE=$(echo "${PKGNFO}" | grep Repository | awk -F': ' '{print $2}')
                    if [ "${INSTALLSOURCE}" == "AUR" ]; then
                        PKGINSTALLCMD="pamac build ${dependency}"
                    else
                        PKGINSTALLCMD="pamac install ${dependency}"
                    fi
                fi
            done
        fi
        # Some housekeeping for above functionality
        unset DEPENDENCIESTOINSTALL DEPENDENCIES CMDSTATUS INSTALLEDPKGLIST ISPKGINSTALLEDNFO ISPKGINSTALLEDCMDRESULT PKGNFO PKGFOUNDCHK INSTALLSOURCE PKGINSTALLCMD
    }
    # Since arguments given, parse them
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help|-h)
                usage
            ;;
            --addsudoers|-a)
                addsudoers $2
                shift
            ;;
            --skipbackup|-s)
                SKIPBACKUPs=true
                shift
            ;;
            --checkdeps|-d)
                checkdeps
                shift
        esac
    done
fi
# Make sure the script isnt's being run as root
[[ $UID -eq 0 ]] && printf '%s\n' "${TEXTFORMATTING[BRIGHT]}You are attempting to run the script as root which isn't allowed. Exiting.${TEXTFORMATTING[NORMAL]}" | tee /dev/tty | systemd-cat --identifier=Upgrades --priority=err && exit 1

# Check that there are updates, and confirm with the use whether to apply them or not.
UPDATES_AVAILABLE=$(pamac checkupdates | head -n 1 | awk '{print $1}')
[[ $UPDATES_AVAILABLE -gt 0 ]] && read -p "There are ${TEXTFORMATTING[BRIGHT]}${UPDATES_AVAILABLE}${TEXTFORMATTING[NORMAL]} updates available, continue? [Y/n]: " CONTINUEUPDATE
CONTINUEUPDATE=${CONTINUEUPDATE:-Y}
if [[ $CONTINUEUPDATE =~ [nN] ]];
then
    echo "Upgrade cancelled." | tee /dev/tty | systemd-cat --identifier=Upgrades && exit 7
fi
RUNTIMESTAMP=$(date +%Y.%m.%d@%H:%M)
RUNDATE=$(echo $RUNTIMESTAMP | awk -F'@' '{print $1}')

# Create temporary logs directory
[[ ! -d "/tmp/manjaro-update" ]] && /usr/bin/mkdir /tmp/manjaro-update
[[ -d "/tmp/manjaro-update" ]] && /usr/bin/mkdir "/tmp/manjaro-update/logs.$RUNTIMESTAMP"
[[ -d "/tmp/manjaro-update/logs.$RUNTIMESTAMP" ]] && LOGSDIR="/tmp/manjaro-update/logs.$RUNTIMESTAMP"

# Make the timeshift backup
# If wished, the following can be added to /etc/sudoers.d/upgradescript to allow this command to run without requiring a password:
#           <username> ALL=(ALL) NOPASSWD: /usr/bin/timeshift *
#
# Replace '<username>' with the user name the script is bein run from.
# This will allow all "timeshift" commands to be run with 'sudo' withoout requiring a password
# If choosing to add the current user to sudoers, with the '-a' or '--addsudoers' arguments, this will be done automatically.
# BUT BE CAREFUL WITH sudoers. You can lock yourself out of your system with it. Hence the recommendation to create a new file in /etc/sudoers.d/
# Functionality to accomplish this has been added with the --addsudoers or -a argument

# Check that timeshhift is installed and can be executed.
if ! command -v timeshift &> /dev/null
then
    echo "Timeshift could not be found. Exiting." | tee /dev/tty | systemd-cat --identifier=Upgrades && exit 2
fi

# If the option to skip backups were not given, perform the backups and set the value to the exit status of the command
if [ "${SKIPBACKUPS}" != true];
then
    sudo timeshift --create --comments "$(date +%Y.%m.%d@%H:%M)' - Pre-update'"
    TIMESHIFT_COMMAND_RESULT=$?
else
    # However, if it was given, set the output as a success, so the rest of the script can carry on.
    TIMESHIFT_COMMAND_RESULT=0
fi

# If timeshift was successful, continue with the upgrade
if [[ $TIMESHIFT_COMMAND_RESULT -eq 0 ]];
then
    if [ -z ${LOGSDIR+x} ];
    then
        echo "\$LOGSDIR is unset. Cannot log process";
        LOGSDIR=""
    else
        touch $LOGSDIR"/system-upgrade.output";
        SYSUPDLOGFILE=$LOGSDIR"/system-upgrade.output";
    fi
    echo
    echo -e '\033[0;92mPre-upgrade backup snapshot successfully created. Continuing with upgrade...\e[0m' | tee /dev/tty | systemd-cat --identifier=Upgrades --priority=info
    echo
    pamac upgrade --force-refresh --enable-downgrade | /usr/bin/tee --append $SYSUPDLOGFILE
    UPGRADE_OFFICIAL_RESULT=$?
    # Check if the official update from the repositories is successful, and if so continue with the AUR upgrade.
    if [[ $UPGRADE_OFFICIAL_RESULT -eq 0 ]];
    then
        kdialog --title="System upgrade" --passivepopup="<b>Official package</b> upgrade successful, using <code>pamac upgrade</code> successfully finished." 5
        if [ -z ${LOGSDIR+x} ];
        then
            echo "\$LOGSDIR is unset. Cannot log process";
            LOGSDIR=""
        else
            touch $LOGSDIR"/aur-upgrade.output";
            AURUPDLOGFILE=$LOGSDIR"/aur-upgrade.output";
        fi
        # Let's update AUR packages now.
        pamac upgrade --enable-downgrade --aur --devel | /usr/bin/tee --append $AURUPDLOGFILE
        UPGRADE_AUR_RESULT=$?
        # Check if AUR packages' upgrade was successful, and if so, continue with merging .pacnew files.
        if [[ $UPGRADE_AUR_RESULT -eq 0 ]];
        then
            kdialog --title="System upgrade" --passivepopup="<b>AUR package</b> upgrade successful, using <code>pamac upgrade</code> successfully finished." 5
            echo -e '\033[0;92mAUR package upgrade, using pamac upgrade successfully finished.\e[0m' | tee /dev/tty | systemd-cat --identifier=Upgrades --priority=info
            # An now, we have to merge any .pacnew files.
            sudo DIFFPROG=meld pacdiff
            NEWMERGE_RESULT=$?
            # Check if merging .pacnew files were successful and if so, show success notification.
            if [[ $NEWMERGE_RESULT -eq 0 ]];
            then
                kdialog --title="System upgrade" --passivepopup="<b><code>.pacnew</code></b> files successfully, merged." 5
                echo -e '\033[0;92m.pacnew files successfully merged.\e[0m' | tee /dev/tty | systemd-cat --identifier=Upgrades --priority=info
            else
                echo -e '\033[0;91mAn error occurred during merging of the .pacnew files.\e[0m' | tee /dev/tty | systemd-cat --identifier=Upgrades --priority=err
                exit 6
            fi
        # Show noptification that the AUR packages' update was unsuccessful.
        else
            kdialog --ok-label='OK' --msgbox="<b>AUR package</b>(s) upgrade failed using <b><code>pamac upgrade</code></b>.<br /><b><i>Human intervention required.</b></i><br/></b>Not continuing.</b>"
            echo -e '\033[0;91mAUR package using pamac upgrade failed.\e[0m' | tee /dev/tty | systemd-cat --identifier=Upgrades --priority=err
            exit 5
        fi
    # Show notification that official packackaages' updates was unsuccessful.
    else
        kdialog --ok-label='OK' --msgbox="There was an error during the upgrade procedure using <b><code>pamac upgrade</code></b>.<br /><b><i>Human intervention required.</b></i>"
        exit 4
    fi
# If timeshift wasn't succeessful, notify, log and exit.
else
    echo
    echo -e '\033[0;91m!!! An error occurred while making the pre-update backup snapshot. Not continuing. !!! \e[0m'  | tee /dev/tty | systemd-cat --identifier=Upgrades --priority=err
    kdialog --ok-label='OK' --msgbox="An error occurred while making the backup snapshot.<br /><br/> </b>Not continuing.</b>"
    echo
    exit 3
fi
# If there were errors with the official packages' upgrade, show prompt about copying the process' output to the clipboard.
if [[ $UPGRADE_OFFICIAL_RESULT -eq 0 ]];
then
    read -p "There were errors while performing the updates from the official repositories. Copy result? [y/N]: " COPYOFFICIALCHOICE
    COPYOFFICIALCHOICE=${COPYOFFICIALCHOICE:-N}
fi
# If there were errors with the AUR packages' upgrade, show prompt about copying the process' output to the clipboard.
if [[ $UPGRADE_AUR_RESULT -eq 0 ]];
then
    read -p "There were errors while performing the updates from the AUR. Copy result? [y/N]: " COPYAURCHOICE
    COPYAURCHOICE=${COPYAURCHOICE:-N}
fi

# Get the information required for a standard forum post
SYSTEMINFO=$(inxi --admin --verbosity=7 --filter --no-host --width)

# Compose a forum message.
if [[ $COPYOFFICIALCHOICE =~ [Yy] ]] || [[ $COPYAURCHOICE =~ [Yy] ]];
then
    MESSAGE='I encountered errors during the lat update,  which I performed on  **`'${RUNDATE}'`**. Please find my information below:

'

fi

# If chosen, add official update output.
if [[ $COPYOFFICIALCHOICE =~ [Yy] ]];
then
    MESSAGE+="##### \`pamac upgrade --force-refresh --enable-downgrade\`:

[details=View more]
~~~
$(cat $SYSUPDLOGFILE)
~~~
[/details]

"
fi

# If chosen, add AUR packages' output.
if [[ $COPYAURCHOICE =~ [Yy] ]];
then
    MESSAGE+="##### \`pamac upgrade --enable-downgrade --aur --devel\`:

[details=View more]
~~~
$(cat $AURUPDLOGFILE)
~~~
[/details]

"
fi

# Add system information gathered above, if any of the outputs are copied.
if [[ $COPYOFFICIALCHOICE =~ [Yy] ]] || [[ $COPYAURCHOICE =~ [Yy] ]];
then
    MESSAGE+="##### My **\`inxi --admin --verbosity=7 --filter --no-host --width\`**:

~~~
"$SYSTEMINFO"
~~~

***

# PLEASE REMOVE THIS TEXT AND ADD YOUR OWN DESCRIPTION HERE, BELOW THE LINE!

"
fi

# Copy the message to a (temporary) log, as well as to the clipboard.
[[ $(echo "${MESSAGE}" | tee ${LOGSDIR}"/${RUNTIMESTAMP}.update.log" | xsel --clipboard) ]] && printf 'Update successfully completed.\nDesired information copied successfully.\n'

# Copy the log for more permanent storage, so that it can be retrived later
[[ ! -d "/var/log/manjaro-update-helper" ]] && sudo mkdir "/var/log/manjaro-update-helper"
if [[ $(sudo cp ${LOGSDIR}"/${RUNTIMESTAMP}.update.log" "/var/log/manjaro-update-helper/${RUNTIMESTAMP}.update.log") ]]; then
    printf '%s\n' "${GREEEN}Log output successfully saved to ${BRIGHT}/var/log/manjaro-update-helper/${RUNTIMESTAMP}.update.log${NORMAL}"
    echo "Log output successfully saved to /var/log/manjaro-update-helper/${RUNTIMESTAMP}.update.log" | systemd-cat --identifier=Upgrades --priority=notice
fi

if [[ $? = 0 ]];
then
    echo
    echo "Message to start forum topic successfully copied to clipboard.
Please visit https://forum.manjaro.org/ and start a new support topic and paste the copied messaage ass the main post, but only after checking if the issue hasn't been asked and resolved already.
Remember that a forum account is required for creating a new support request and that the forum is manned by volunteers, so no demand can be madee on their time.
Please see https://forum.manjaro.org/t/howto-request-support/91463 for more information and guides to request support.
"
fi

# Some of the logs are only stored in RAM, so will be cleared on shutdown or restart.
## Clean out any logs except the 5 latest.
ls -tp /var/log/manjaro-update-helper/ | grep -v '/$' | tail -n +5 | tr '\n' '\0' | sudo xargs -I {} rm -- {}
# Unset any and all variables, functions and whatever else was used.

unset TEXTFORMATTING UPDATES_AVAILABLE CONTINUEUPDATE RUNTIMESTAMP RUNDATE TIMESHIFT_COMMAND_RESULT LOGSDIR SYSUPDLOGFILE UPGRADE_AUR_RESULT NEWMERGE_RESULT COPYOFFICIALCHOICE COPYAURCHOICE SYSTEMINFO MESSAGE