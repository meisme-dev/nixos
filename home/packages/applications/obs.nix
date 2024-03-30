{pkgs, config, ...}:  

{  
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      looking-glass-obs
      input-overlay
      obs-pipewire-audio-capture
    ];
  };
} 
