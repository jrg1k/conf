function update-all
  sudo pacman -Syu
  flatpak update
  omf update
end
