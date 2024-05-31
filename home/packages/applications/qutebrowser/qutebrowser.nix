{ pkgs, ... }:  
let 
    readability = (pkgs.buildNpmPackage rec {
      pname = "readability";
      version = "0.5.0";

      src = pkgs.fetchFromGitHub {
        owner = "mozilla";
        repo = pname;
        rev = "${version}";
        sha256 = "sha256-tGfevW5cMOnYJHEvRbPbufoN3hIvfV6odDWCqP34/rQ=";
      };

      npmDepsHash = "sha256-1HvBWLt2/ckFZSVqzpYfXVzqqqXSEPCcRU+1+4w8XFU=";
      dontNpmBuild = true;
    });
    
    qutejs = (pkgs.buildNpmPackage rec {
      pname = "qutejs";
      version = "f27e11e57c28c0ec3b8ec163c880595ddf1a8041";

      src = pkgs.fetchFromGitHub {
        owner = "aidanharris";
        repo = pname;
        rev = "${version}";
        hash = "sha256-8xIfBzYlihuxRKu1kOM5uzReR8WnCUrnUKl3g4GZQGo=";
      };

      npmDepsHash = "sha256-x6cvdwA9s+sRXxxgofjdg8r6Cp9iruostYD1mV1N26U=";
      dontNpmBuild = true;

      postPatch = ''
        cp ${./qutejs-lock.json} package-lock.json
      '';
    });

    jsdom = (pkgs.buildNpmPackage rec {
      pname = "jsdom";
      version = "24.0.0";

      src = pkgs.fetchFromGitHub {
        owner = "jsdom";
        repo = pname;
        rev = "${version}";
        hash = "sha256-T6AyE/8uSlJRO8CNY/shbPcgX9kfGT8G2cuqoSCehxs=";
      };

      npmDepsHash = "sha256-+Jc2w/HxcNLth1cqs12xnCfS7FwZ0ClWiDc6RDxLNAw=";
      dontNpmBuild = true;
    });
in {  
  home.packages = with pkgs; [
    readability
    qutejs
    jsdom
    nodejs
  ];

  programs.qutebrowser = {
    enable = true;
    greasemonkey = [
      (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/1d1be041a65c251692ee082eda64d2637edf6444/youtube_sponsorblock.js";
        sha256 = "sha256-e3QgDPa3AOpPyzwvVjPQyEsSUC9goisjBUDMxLwg8ZE=";
      })
      (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/33884a540ae5f7fa37d2273bab500b71462a297d/youtube_adblock.js";
        sha256 = "1l2d2rxb1lqyqsds29rjiar3vzf1mfpm51d8irijrq85dj2h1vvw";
      })
    ];
  };

  xdg.dataFile."qutebrowser/userscripts/readability-js" = {
    text = 
      builtins.readFile(builtins.fetchurl {
        url = "https://raw.githubusercontent.com/qutebrowser/qutebrowser/12fcff9fe89277426ce910d17e579e20922a799b/misc/userscripts/readability-js";
        sha256 = "08nv0jrsmx428nkiq44cffxc55b3shd6rm3y1cbc1xjn1kpppi6k";
      });
    executable = true;
  };

  xdg.dataFile."qutebrowser/userscripts/view_in_mpv" = {
    text = 
      builtins.readFile(builtins.fetchurl {
        url = "https://raw.githubusercontent.com/qutebrowser/qutebrowser/d4a7619f9c51db56016ab710ee007239d1733fc7/misc/userscripts/view_in_mpv";
        sha256 = "0kda0jw8xchfnmhf5jhllxfdv7azq60p87v49bz4gwm70mgy4d19";
      });
    executable = true;
  };

  home.sessionVariables = {
    NODE_PATH = "${jsdom}/lib/node_modules:${qutejs}/lib/node_modules:${readability}/lib/node_modules";
  };
} 
