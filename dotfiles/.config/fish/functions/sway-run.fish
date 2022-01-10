function sway-run
  set -gx MOZ_ENABLE_WAYLAND 1
  set -gx QT_QPA_PLATFORM wayland
  set -gx SDL_VIDEODRIVER wayland
  sway
end
