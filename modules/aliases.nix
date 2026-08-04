# Shell aliases configuration
# This file contains all shell aliases for better organization

{
  # Modern replacements
  ls   = "eza --icons=always";
  ll   = "eza -l --icons=always";
  la   = "eza -la --icons=always";
  cat  = "bat --plain";
  cd   = "z";
  du   = "dust";
  find = "fd";
  top  = "btop";

  # Git shortcuts
  g  = "git";
  gs = "git status";
  ga = "git add";
  gcm = "git commit -m";
  gp  = "git push";
  gl  = "git pull";
  gpf = "git push --force-with-lease origin";
  greset = "git reset --hard origin/main";


  # Utilities

  # Docker aliases
  d      = "docker";
  dc     = "docker-compose";
  dps    = "docker ps";
  dpsa   = "docker ps -a";
  di     = "docker images";
  dex    = "docker exec -it";
  dlogs  = "docker logs";
  dstop  = "docker stop";
  drm    = "docker rm";
  drmi   = "docker rmi";
  dprune = "docker system prune -af";

  # Podman aliases
  p      = "podman";
  pc     = "podman-compose";
  pps    = "podman ps";
  ppsa   = "podman ps -a";
  pi     = "podman images";
  pex    = "podman exec -it";
  plogs  = "podman logs";
  pstop  = "podman stop";
  prm    = "podman rm";
  prmi   = "podman rmi";
  pprune = "podman system prune -af";

  # Gcloud aliases
  gc      = "gcloud";
  gcl     = "gcloud auth list";
  gcpl    = "gcloud projects list";
  gccl    = "gcloud config list";
  gcsl    = "gcloud services list";
  gcal    = "gcloud auth login";
  gcaal   = "gcloud auth application-default login";
  gcat    = "gcloud auth application-default print-access-token";
  gcar    = "gcloud auth revoke";
  gcaar   = "gcloud auth application-default revoke";
  gcgp    = "gcloud config get-value project";
  gcsp    = "gcloud config set project";
  gcil    = "gcloud compute instances list";


  # Custom + System
  ytdlvp    = "yt-dlp --cookies youtube_cookies.txt --merge-output-format mp4 --no-overwrites";
  ytdlv     = "yt-dlp --cookies youtube_cookies.txt --merge-output-format mp4 --no-overwrites --no-playlist";
  free     = "top -l 1 -s 0 | grep PhysMem";
  cpu      = "sysctl -a | grep machdep.cpu";
  gpu      = "system_profiler SPDisplaysDataType";
  projects = "cd ~/Documents/Coding";
  update   = "cd ~/Documents/Coding/nixos-configs-mac && sudo darwin-rebuild switch --flake \".#$(hostname | sed \"s/\\./-/g\")\"";
  upgrade  = "cd ~/Documents/Coding/nixos-configs-mac && nix flake update && sudo darwin-rebuild switch --flake \".#$(hostname | sed \"s/\\./-/g\")\"";
  cleanup  = "nix-collect-garbage -d";

  # Navigation

  # AI & Editors
  code        = "code";
  open-code   = "opencode";
}
