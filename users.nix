{ ... }

{
  users.users.sindreb = {
    isNormalUser = true;
    description = "Sindre B";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
