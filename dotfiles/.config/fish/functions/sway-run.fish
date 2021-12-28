function sway-run
  set -gx LIBVA_DRIVER_NAME i965
  set -gx MOZ_ENABLE_WAYLAND 1
  set -gx QT_QPA_PLATFORM wayland
  set -gx SDL_VIDEODRIVER wayland
  set -gx VDPAU_DRIVER va_gl
  sway
end
