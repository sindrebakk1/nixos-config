_: {
  config = {
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      baseIndex = 1;
      clock24 = true;
      historyLimit = 100000;
      shortcut = "a";
    };
  };
}
