{ config, pkgs, ... }:

{
	home.username = "ch1p";
	home.homeDirectory = "/home/ch1p";
	home.stateVersion = "26.05";
	programs.bash = {
		enable = true;
		shellAliases = {
			btw = "echo I use nixos, btw";
			nrsf = "sudo nixos-rebuild switch --impure --flake ~/.dotfiles";
      n = "nvim";
      ls = "lsd -l";
		};
		initExtra = ''
        export PS1='\[\e[38;5;76m\]\u\[\e[0;2m\]@\[\e[0;38;5;32m\]\H\[\e[0m\] \[\e[97;3m\]\w\[\e[0m\] \\$ '
		'';
	};

  programs.git.enable = true;
  programs.git.settings.user.email = "<REDACTED>";
  programs.git.settings.user.name = "ch1p";

	home.file.".config/alacritty".source = ./config/alacritty;
	home.file.".config/oxwm".source = ./config/oxwm;
	home.file.".config/rofi".source = ./config/rofi;
	home.file.".config/nvim".source = ./config/nvim;
	home.packages = with pkgs; [
		neovim
		nil
		nixpkgs-fmt
		nodejs
		gcc
    lsd
    maim
	];
}
