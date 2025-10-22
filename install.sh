#!/bin/bash

cd ~/
base_url="https://raw.githubusercontent.com/DollarNoob/Macsploit-Mirror/main"

print_title() {
    clear
    echo -e "\033[1;35m"
    center "  __  __             _____       _       _ _    "
    center " |  \/  |           / ____|     | |     (_) |   "
    center " | \  / | __ _  ___| (___  _ __ | | ___  _| |_  "
    center " | |\/| |/ _\` |/ __|\___ \| '_ \| |/ _ \| | __| "
    center " | |  | | (_| | (__ ____) | |_) | | (_) | | |_  "
    center " |_|  |_|\__,_|\___|_____/| .__/|_|\___/|_|\__| "
    center "                          | |                   "
    center "                          |_|                   "
    echo -e "\033[0m"
}

check_requirements() {
    local os_version=$(sw_vers -productVersion)
    architecture=$(uname -m)
    if [ "$(echo "$os_version" | cut -d. -f1)" -ge 11 ]; then
        if [ $architecture == "arm64" ]; then
            center "✅ \033[1;36mmacOS $os_version\033[0m (Apple Silicon)"
        else
            center "✅ \033[1;36mmacOS $os_version\033[0m (Intel)"
        fi
        echo
        center "============================================================"
        echo
    else
        if [ $architecture == "arm64" ]; then
            center "❌ \033[1;31mmacOS $os_version\033[0m (Apple Silicon)"
        else
            center "❌ \033[1;31mmacOS $os_version\033[0m (Intel)"
        fi
        center "\033[31mYour device is not compatible with MacSploit.\033[0m"
        center "\033[31mPlease upgrade to macOS 11.0+ if possible.\033[0m"
        echo
        exit
    fi
}

check_permissions() {
    if [[ ! -w . || ! -x . ]]; then
        center "\033[31mTerminal is unable to access your Home folder.\033[0m"
        center "\033[31mPlease input your password to run the installer with sudo permissions.\033[0m"
        echo
        sudo -E bash -c "$(curl -s "$base_url/install.sh")"
        exit
    fi

    if [[ ! -w ./Downloads || ! -x ./Downloads ]]; then
        center "\033[31mTerminal is unable to access your Downloads folder.\033[0m"
        center "\033[31mPlease grant Full Disk Access to Terminal and try again.\033[0m"
        echo
        open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
        exit
    fi

    if [[ ! -w /Applications || ! -x /Applications ]]; then
        center "\033[31mTerminal is unable to access your Applications folder.\033[0m"
        center "\033[31mPlease input your password to run the installer with sudo permissions.\033[0m"
        echo
        sudo -E bash -c "$(curl -s "$base_url/install.sh")"
        exit
    fi

    if [[ -d "/Applications/Roblox.app" ]]; then
        if find "/Applications/Roblox.app" ! -exec test -w {} \; -print -quit | grep -q .; then
            center "\033[31mTerminal is unable to access your current Roblox installation.\033[0m"
            center "\033[31mPlease input your password to run the installer with sudo permissions.\033[0m"
            echo
            sudo -E bash -c "$(curl -s "$base_url/install.sh")"
            exit
        fi
    fi

    if [[ -d "./Applications/Roblox.app" ]]; then
        if find "./Applications/Roblox.app" ! -exec test -w {} \; -print -quit | grep -q .; then
            center "\033[31mTerminal is unable to access your current Roblox installation.\033[0m"
            center "\033[31mPlease input your password to run the installer with sudo permissions.\033[0m"
            echo
            sudo -E bash -c "$(curl -s "$base_url/install.sh")"
            exit
        fi
    fi

    if [[ -d "/Applications/MacSploit.app" ]]; then
        if find "/Applications/MacSploit.app" ! -exec test -w {} \; -print -quit | grep -q .; then
            center "\033[31mTerminal is unable to access your current MacSploit installation.\033[0m"
            center "\033[31mPlease input your password to run the installer with sudo permissions.\033[0m"
            echo
            sudo -E bash -c "$(curl -s "$base_url/install.sh")"
            exit
        fi
    fi

    if [[ -d "./Applications/MacSploit.app" ]]; then
        if find "./Applications/MacSploit.app" ! -exec test -w {} \; -print -quit | grep -q .; then
            center "\033[31mTerminal is unable to access your current MacSploit installation.\033[0m"
            center "\033[31mPlease input your password to run the installer with sudo permissions.\033[0m"
            echo
            sudo -E bash -c "$(curl -s "$base_url/install.sh")"
            exit
        fi
    fi

    if [ "$architecture" == "arm64" ] && ! /usr/bin/pgrep -q oahd; then
        center "\033[31mRosetta is not installed on your system.\033[0m"
        center "\033[31mThis is required since MacSploit runs on top of Rosetta.\033[0m"
        echo
        center "Do you want to install Rosetta? (Y/N): \c"
        while read -n 1 -s -r answer; do
            if [[ "$answer" =~ ^[Yy]$ ]]; then
                echo
                echo
                softwareupdate --install-rosetta --agree-to-license
                bash -c "$(curl -s "$base_url/install.sh")"
                exit
            elif [[ "$answer" =~ ^[Nn]$ ]]; then
                echo
                echo
                exit
            fi
        done
    fi
}

check_version() {
    if [ $architecture == "arm64" ]; then
        curl -s "$base_url/jq-macos-arm64" -o "./jq"
    else
        curl -s "$base_url/jq-macos-amd64" -o "./jq"
    fi
    chmod +x ./jq

    roblox_version_info=$(curl -s "https://clientsettingscdn.roblox.com/v2/client-version/MacPlayer")
    roblox_version=$(echo $roblox_version_info | ./jq -r ".clientVersionUpload")
    center "✅ \033[1;34mRoblox\033[0m | $roblox_version"

    version_info=$(curl -s "$base_url/version.json")
    version=$(echo $version_info | ./jq -r ".clientVersionUpload")

    if [ "$version" == "$roblox_version" ]; then
        center "✅ \033[1;35mMacSploit\033[0m | $version"
        sleep 1
    else
        center "❗ \033[1;35mMacSploit\033[0m | \033[33m$version\033[0m"
        center "\033[33mMacSploit is not updated to the latest version of Roblox.\033[0m"
        center "\033[33mThis does not mean MacSploit would not work at all.\033[0m"
        center "\033[33mThanks to update hooks, MacSploit may still function for a few days.\033[0m"
        echo
        center "Do you want to proceed? (Y/N): \c"
        while read -n 1 -s -r answer; do
            if [[ "$answer" =~ ^[Yy]$ ]]; then
                break
            elif [[ "$answer" =~ ^[Nn]$ ]]; then
                echo
                echo
                exit
            fi
        done
    fi
}

install_roblox() {
    print_title
    center "📥 \033[1;34mDownloading RobloxPlayer...\033[0m"
    echo
    if [ $architecture == "arm64" ]; then
        curl -# "https://setup.rbxcdn.com/mac/arm64/$version-RobloxPlayer.zip" -o "./RobloxPlayer.zip"
    else
        curl -# "https://setup.rbxcdn.com/mac/$version-RobloxPlayer.zip" -o "./RobloxPlayer.zip"
    fi
    echo

    center "⚙️  \033[1;34mInstalling RobloxPlayer...\033[0m"
    [ -d "/Applications/Roblox.app" ] && rm -rf "/Applications/Roblox.app"
    [ -d "./Applications/Roblox.app" ] && rm -rf "./Applications/Roblox.app"

    unzip -o -q "./RobloxPlayer.zip"
    mv ./RobloxPlayer.app /Applications/Roblox.app
    rm ./RobloxPlayer.zip
}

patch_roblox() {
    print_title
    center "📥 \033[1;35mDownloading MacSploit DYLIB...\033[0m"
    echo
    if [ $architecture == "arm64" ]; then
        curl -# "$base_url/macsploit_arm64.dylib" -o "./macsploit.dylib"
    else
        curl -# "$base_url/macsploit_x86_64.dylib" -o "./macsploit.dylib"
    fi
    curl -#O "$base_url/insert_dylib"
    echo

    center "⚙️  \033[1;35mPatching RobloxPlayer...\033[0m"
    if [ $architecture == "arm64" ]; then
        codesign --remove-signature /Applications/Roblox.app
    fi

    mv ./macsploit.dylib "/Applications/Roblox.app/Contents/MacOS/macsploit.dylib"

    chmod +x ./insert_dylib
    local output=$(./insert_dylib "/Applications/Roblox.app/Contents/MacOS/macsploit.dylib" "/Applications/Roblox.app/Contents/MacOS/RobloxPlayer" --strip-codesig --all-yes)
    if [[ "$output" != "Added LC_LOAD_DYLIB to /Applications/Roblox.app/Contents/MacOS/RobloxPlayer_patched" ]]; then
        center "\033[31mTerminal was unable to patch RobloxPlayer.\033[0m"
        center "\033[31mThis is usually caused by anti-virus softwares.\033[0m"
        center "\033[31mIf you have one running, please disable it and try again.\033[0m"
        echo
        exit
    fi

    if [ $architecture == "arm64" ]; then
        echo
        center "🖊️  \033[1;36mSigning RobloxPlayer...\033[0m"
        codesign -s "-" /Applications/Roblox.app
    fi

    mv "/Applications/Roblox.app/Contents/MacOS/RobloxPlayer_patched" "/Applications/Roblox.app/Contents/MacOS/RobloxPlayer"
}

install_macsploit() {
    print_title
    center "📥 \033[1;35mDownloading MacSploit...\033[0m"
    echo
    curl -#O "$base_url/MacSploit.zip"
    echo

    center "⚙️  \033[1;35mInstalling MacSploit...\033[0m"
    [ -d "/Applications/MacSploit.app" ] && rm -rf "/Applications/MacSploit.app"
    [ -d "./Applications/MacSploit.app" ] && rm -rf "./Applications/MacSploit.app"

    unzip -o -q "./MacSploit.zip"
    mv ./MacSploit.app /Applications/MacSploit.app
    rm ./MacSploit.zip
}

clean_up() {
    print_title
    center "🧹 \033[1;36mCleaning Up...\033[0m"
    echo

    if touch ./Downloads/ms-version.json 2>&1 | grep -q "Operation not permitted"; then
        center "\033[31mTerminal is unable to access your Downloads folder.\033[0m"
        center "\033[31mPlease grant Full Disk Access to Terminal and try again.\033[0m"
        echo
        open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
        exit
    fi
    echo $version_info > ./Downloads/ms-version.json

    rm ./jq
    rm ./insert_dylib
    rm -r "/Applications/Roblox.app/Contents/MacOS/Roblox.app"
    rm -r "/Applications/Roblox.app/Contents/MacOS/RobloxPlayerInstaller.app"

    # Check if user is running on sudo permissions
    sudo -n true >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        # Create required folder (without this Roblox would crash due to lack of permissions)
        sudo mkdir /Applications/Roblox.app/Contents/Resources/content/custom
    fi

    center '✨ \033[1;32mInstallation Complete!\033[0m'
    echo
}

center() {
    local text="$1"
    local cols=$(tput cols)
    local plaintext=$(echo -e "$text" | sed "s/\x1B\[[0-9;]*m//g")
    local pad=$(( (cols - ${#plaintext}) / 2 ))
    printf "%*s%b\n" "$pad" "" "$text"
}

print_title
check_requirements
check_permissions
check_version
install_roblox
patch_roblox
install_macsploit
clean_up
