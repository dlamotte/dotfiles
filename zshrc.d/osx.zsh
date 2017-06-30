alias lock='/System/Library/CoreServices/"Menu Extras"/User.menu/Contents/Resources/CG\Session -suspend'

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

make-my-webcam-work() {
    echo sudo killall AppleCameraAssistant
    sudo killall AppleCameraAssistant
    echo sudo killall VDCAssistant
    sudo killall VDCAssistant
}

mac32compile() {
    export ARCHFLAGS='-arch i386' CFLAGS='-arch i386' CXXFLAGS='-arch i386' LDFLAGS='-arch i386'
}
