{pkgs, ...}: {
  imports = [
    ./starship
    ./bash
  ];

  users = {
    defaultUserShell = pkgs.bash;
  };
}
