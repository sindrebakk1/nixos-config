{lib, ...}: {
  config = {
    home-manager.users.sindreb = {
      programs.starship = {
        enable = true;
        enableBashIntegration = true;
        settings = {
          add_newline = false;
          command_timeout = 1000;
          character = {
            success_symbol = "[󱄅 ❯](bold green)";
            error_symbol = "[󱄅 ❯](bold red)";
          };

          format = lib.concatStrings [
            "$directory"
            "$git_branch"
            "$git_status"
            "$direnv"
            "$terraform"
            "$kubernetes"
            "$cmd_duration"
            "\n󱞪(2) $character"
          ];

          right_format = lib.concatStrings [
            "$hostname"
          ];

          git_status = {
            conflicted = " \${count}x ";
            ahead = " \${count}x ";
            behind = " \${count}x ";
            diverged = "󱐎 \${count}x ";
            untracked = "\${count}x ";
            stashed = "󰆔 \${count}x ";
            modified = "󰴓\${count}x ";
            staged = "󰅕\${count}x ";
            renamed = "󰑕\${count}x ";
            deleted = " \${count}x ";
          };

          directory = {
            home_symbol = "  ";
            read_only = "  ";
          };

          terraform = {
            disabled = false;
            symbol = "󱁢 ";
            detect_folders = [
              ".terraform"
              "src/.terraform"
              "clusters/.terraform"

            ];
            detect_files = [
              "environment"
            ];
            format = "on workspace [$symbol$workspace]($style) ";
          };

          kubernetes = {
            disabled = false;
            symbol = "󱃾 ";
            format = "using context [$symbol$context]($style) ";
          };

          direnv = {
            disabled = false;
            symbol = "󱃼 ";
            format = "[$symbol]($style) ";
            style = "12";
          };

          hostname = {
            ssh_symbol = " ";
            format = "connected to [$ssh_symbol$hostname]($style) ";
          };

          line_break = {
            disabled = true;
          };
        };
      };
    };
  };
}
