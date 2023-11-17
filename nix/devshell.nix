# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  perSystem = {pkgs, ...}: {
    devShells.kernel = pkgs.mkShell {
      packages = with pkgs; [
        ncurses
        pkg-config
        python3
        python3Packages.pip
      ];

      inputsFrom = [pkgs.linux_latest];

      shellHook = ''
        export src=${pkgs.linux_latest.src}
        if [ ! -d "linux-${pkgs.linux_latest.version}" ]; then
          unpackPhase
          patchPhase
        fi
        cd linux-${pkgs.linux_latest.version}

        # python3+pip for kernel-hardening-checker
        export PIP_PREFIX=$(pwd)/_build/pip_packages
        export PYTHONPATH="$PIP_PREFIX/${pkgs.python3.sitePackages}:$PYTHONPATH"
        export PATH="$PIP_PREFIX/bin:$PATH"

        # install kernel-hardening-checker via pip under "linux-<version" for
        # easy clean-up with directory removal - if not already installed
        if [ ! -f "_build/pip_packages/bin/kernel-hardening-checker" ]; then
          python3 -m pip install git+https://github.com/a13xp0p0v/kernel-hardening-checker
        fi

        export PS1="[ghaf-kernel-devshell:\w]$ "
      '';
    };

    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        git
        nix
        nixos-rebuild
        reuse
        alejandra
      ];
    };
  };
}
