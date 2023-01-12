{self}: {
  hydraJobs = {
    intel-nuc.x86_64-linux = self.packages.x86_64-linux.intel-nuc;
    vm.x86_64-linux = self.packages.x86_64-linux.vm;
    nvidia-jetson-orin = {
      aarch64-linux = self.packages.aarch64-linux.nvidia-jetson-orin;
      x86_64-linux = self.packages.aarch64-linux-cross-from-x86_64-linux.nvidia-jetson-orin;
    };
  };
}
