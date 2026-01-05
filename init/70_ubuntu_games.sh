#!/usr/bin/env bash
# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

snaps=(
    steam
)

e_header "Installing snaps"
for snap in "${snaps[@]}"; do
    if sudo snap install "$snap"; then
        e_success "$snap"
    else
        e_error "$snap"
    fi
done

flatpak_remotes=(
    "flathub https://flathub.org/repo/flathub.flatpakrepo"
)

flatpak_apps=(
    "flathub com.heroicgameslauncher.hgl"
)

e_header "Adding flatpak remotes"
for flatpak_remote in "${flatpak_remotes[@]}"; do
    IFS=' ' read -r -a pieces <<< "$flatpak_remote"
    if [[ "${#pieces[@]}" -ne 2 ]]; then
        e_error "$flatpak_remote (invalid remote format)"
        continue
    fi
    flatpak_remote_name="${pieces[0]}"
    flatpak_remote_url="${pieces[1]}"
    if flatpak remote-add --if-not-exists "$flatpak_remote_name" "$flatpak_remote_url"; then
        e_success "$flatpak_remote_name"
    else
        e_error "$flatpak_remote_name"
    fi
done

e_header "Installing flatpak applications"
for flatpak_app in "${flatpak_apps[@]}"; do
    IFS=' ' read -r -a pieces <<< "$flatpak_app"
    if [[ "${#pieces[@]}" -ne 2 ]]; then
        e_error "$flatpak_app (invalid app format)"
        continue
    fi
    flatpak_remote_name="${pieces[0]}"
    flatpak_app_name="${pieces[1]}"
    if flatpak install --assumeyes --noninteractive --or-update "$flatpak_remote_name" "$flatpak_app_name"; then
        e_success "$flatpak_app_name"
    else
        e_error "$flatpak_app_name"
    fi
done
