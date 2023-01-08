#!/bin/env bash

# Prerequisites:
#  xsel
#  tput
#  pamac
#  pacdiff
#  inxi

####################################################
# NOTE:                                            #
#    Change -ne on Line  96 to -eq for production. #
#    Change -ne on Line 109 to -eq for production. #
#    Change -eq on Line 137 to -ne for production. #
#    Change -eq on Line 143 to -ne for production. #
####################################################

# Let's define a few colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)

##################################################################################
# NOTE:                                                                          #
#     This section contains the part handling the sudoers installation requests. #
##################################################################################
if [[ $# -gt 0 ]];
then
    if [[ "$1" == "addsudoers" ]]; then
      if [[ "$1" == "addsudoers" ]]; then
        if [[ $(sudo touch /etc/sudoers.d/manjaro-update-helper 2>&1> /dev/null) ]]; then
            printf '%s\n' "${GREEN}Successfully created file ${BRIGHT}/etc/sudoers.d/manjaro-update-helper${NORMAL}"
        else
            printf '%s\n' "${RED}Failed create file ${BRIGHT}/etc/sudoers.d/manjaro-update-helper ${NORMAL}${RED}due to not having the required permissions."
            exit 8
        fi
        # Check if scipt is run with sudo
        CURRENTUSERNAME=$(whoami)
        if [[ "${CURRENTUSERNAME}" != "root" ]]; then
            USERNAMETOSUDOERS=$(whoami)
        else
            if [ -z "$2" ];
            then
                printf '%s\n' "${RED}No username specified to add sudoers permissions for.${NORMAL}"
            else
                USERNAMETOSUDOERS=$2
                if id "$USERNAMETOSUDOERS" &>/dev/null; then
                    SUDOERSENTRY="${USERNAMETOSUDOERS} ALL=(ALL) NOPASSWD: timeshift *,/usr/bin/timeshift *"
                    if [[ $(echo $SUDOERSENTRY >> /etc/sudoers.d/manjaro-update-helper) ]]; then
                        printf '%s\n' "sudoers entry created successfully in ${BRIGHT}/etc/sudoers.d/manjaro-update-helper${NORMAL}."
                else
                    printf '%s\n' "${RED}Specified username, ${BRIGHT}${USERNAMETOSUDOERS}${NORMAL}${RED} not a valid user. Please specify a valid user and try again.${NORMAL}"
                    exit 9
                fi
            fi
        fi
        # Some housekeeping for this functionality
        unset CURRENTUSERNAME
        unset USERNAMETOSUDOERS
        unset SUDOERSENTRY
        exit 0
    fi
fi
###################################################################################
# This marks the end of thee section handling the sudoers innstallation requests. #
###################################################################################

# Make sure the script isnt's being run as root
[[ $UID -eq 0 ]] && printf '%s\n' "${BRIGHT}You are attempting to run the script as root which isn't allowed. Exiting.${NORMAL}" | tee /dev/tty | systemd-cat --identifier=Upgrades --priority=err && exit 1

# Check that there is updates, and confirm with the use whether to apply them or not.
#M UPDATES_AVAILABLE=$(pamac checkupdates | head -n 1 | awk '{print $1}')
UPDATES_AVAILABLE=2
[[ $UPDATES_AVAILABLE -gt 0 ]] && read -p "There are ${BRIGHT}${UPDATES_AVAILABLE}${NORMAL} updates available, continue? [Y/n]: " CONTINUEUPDATE
CONTINUEUPDATE=${CONTINUEUPDATE:-Y}
if [[ $CONTINUEUPDATE =~ [nN] ]];
then
    echo "Upgrade cancelled." | tee /dev/tty | systemd-cat --identifier=Upgrades && exit 7
fi
RUNTIMESTAMP=$(date +%Y.%m.%d@%H:%M)
RUNDATE=$(echo $RUNTIMESTAMP | awk -F'@' '{print $1}')

# Create temporary logs' directory
[[ ! -d "/tmp/manjaro-update" ]] && /usr/bin/mkdir /tmp/manjaro-update
[[ -d "/tmp/manjaro-update" ]] && /usr/bin/mkdir "/tmp/manjaro-update/logs.$RUNTIMESTAMP"
[[ -d "/tmp/manjaro-update/logs.$RUNTIMESTAMP" ]] && LOGSDIR="/tmp/manjaro-update/logs.$RUNTIMESTAMP"

# Check that timeshhift is installed and can be executed.
if ! command -v timeshift &> /dev/null
then
    echo "Timeshift could not be found. Exiting." | tee /dev/tty | systemd-cat --identifier=Upgrades && exit 2
fi

# Make the timeshift backup
# If wished, the following can be added to /etc/sudoers.d/upgradescript to allow this command to run without requiring a password:
#           <username> ALL=(ALL) NOPASSWD: /usr/bin/timeshift *
#
# Replace '<username>' with the user name the script is bein run from.
# This will allow all "timeshift" commands to be run with 'sudo' withoout requiring a password
# BUT BE CAREFUL WITH sudoers. You can lock yourself out of your system with it. Hence the recommendation to create a new file in /etc/sudoers.d/
sudo timeshift --create --comments "$(TZ='Harare/Pretoria' date +%Y.%m.%d@%H:%M)' - Pre-update'" --tags 0
TIMESHIFT_COMMAND_RESULT=$?

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
    # Check if the official update from the repositories is successful and if so, continue with the AUR upgrade.
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
        #let's update AUR packages now.
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
        # Shopw noptification that the AUR packages' update was unsuccessful.
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
# If timeshift wasn't succeessful, print an error and exit
else
    echo
    echo -e '\033[0;91m!!! An error occurred while making the pre-update backup snapshot. Not continuing. !!! \e[0m'  | tee /dev/tty | systemd-cat --identifier=Upgrades --priority=err
    kdialog --ok-label='OK' --msgbox="An error occurred while making the backup snapshot.<br /><br/> </b>Not continuing.</b>"
    echo
    exit 3
fi
# If there were errorrs with the official packages' upgrade, show prompt about copying the process' output to the clipboard.
if [[ $UPGRADE_OFFICIAL_RESULT -eq 0 ]];
then
    read -p "There were errors while performing the updates from the official repositories. Copy result? [y/N]: " COPYOFFICIALCHOICE
    COPYOFFICIALCHOICE=${COPYOFFICIALCHOICE:-N}
fi
# If there were errorrs with the AUR packages' upgrade, show prompt about copying the process' output to the clipboard.
if [[ $UPGRADE_AUR_RESULT -eq 0 ]];
then
    read -p "There were errors while performing the updates from the AUR. Copy result? [y/N]: " COPYAURCHOICE
    COPYAURCHOICE=${COPYAURCHOICE:-N}
fi

# Get the information required for a standard forum post/
SYSTEMINFO=$(inxi --admin --verbosity=7 --filter --no-host --width)

# Compose a forum message
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

# If  chosen, add AUR packages' output.
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

# Add system information gathered above, whether any of the outputs are copied
if [[ $COPYOFFICIALCHOICE =~ [Yy] ]] || [[ $COPYAURCHOICE =~ [Yy] ]];
then
    MESSAGE+="##### My **\`inxi --admin --verbosity=7 --filter --no-host --width\`**:

~~~
"$SYSTEMINFO"
~~~

***

# PLEASE ADD YOUR OWN DESCRIPTION HERE, BELOW THE LINE!
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
## Housekeeping follows.
# Clean out any logs except the 5 latest.
ls -tp /var/log/manjaro-update-helper/ | grep -v '/$' | tail -n +5 | tr '\n' '\0' | sudo xargs -I {} rm -- {}
# Unset any and all variables, functions and whatever else was used.

unset UPDATES_AVAILABLE
unset CONTINUEUPDATE
unset RUNTIMESTAMP
unset RUNDATE
unset GREEN
unset BRIGHT
unset NORMAL
unset TIMESHIFT_COMMAND_RESULT
unset LOGSDIR
unset SYSUPDLOGFILE
unset UPGRADE_AUR_RESULT
unset NEWMERGE_RESULT
unset COPYOFFICIALCHOICE
unset COPYAURCHOICE
unset SYSTEMINFO
unset MESSAGE