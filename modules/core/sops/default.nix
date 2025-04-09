_: {
  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age = {
      keyFile = "/home/sindreb/.config/sops/age/keys.txt";
      sshKeyPaths = [
        "/data/etc/ssh/ssh_host_ed25519_key"
      ];
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

      "authorized_keys/root" = {
        path = "/root/.ssh/authorized_keys";
      };

      "authorized_keys/sindreb" = {
        path = "/home/sindreb/.ssh/authorized_keys";
        owner = "sindreb";
      };
    };
  };
}
