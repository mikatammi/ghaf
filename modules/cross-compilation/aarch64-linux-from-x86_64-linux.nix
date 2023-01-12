{
  nixpkgs.buildPlatform = {
    config = "x86_64-unknown-linux-gnu";
    system = "x86_64-linux";
  };
  nixpkgs.hostPlatform = {
    config = "aarch64-unknown-linux-gnu";
    system = "aarch64-linux";
  };
}
