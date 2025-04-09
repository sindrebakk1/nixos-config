_: {
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age = {
      keyFile = "/home/sindreb/.config/sops/age/keys.txt";
      generateKey = true;
    };

    secrets = {
      "users/sindreb" = {
        neededForUsers = true;
      };

      "users/root" = {
        neededForUsers = true;
      };

      wireless = {};
    };
  };
}
