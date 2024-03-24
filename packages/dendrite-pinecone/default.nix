# Copyright 2022-2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
#
{pkgs, ...}:
with pkgs;
  buildGo119Module rec {
    pname = "dendrite-pinecone";
    version = "0.9.1";

    TcpPort = "49000";
    McastUdpPort = "60606";
    McastUdpIp = "239.0.0.114";
    TcpPortInt = 49000;
    McastUdpPortInt = 60606;
    src = pkgs.fetchFromGitHub {
      owner = "tiiuae";
      repo = "dendrite";
      rev = "feature/ghaf-integration";
      sha256 = "sha256-UhA9deqWu3ERa08GMGV6/NVHEBZaAdPf7hXQb3GTRcA=";
    };
    subPackages = ["cmd/dendrite-demo-pinecone"];
    # patches = [./turnserver-crendentials-flags.patch];

    vendorHash = "sha256-xMOd4N3hjajpNl9zxJnPrPIJjS292mFthpIQUHWqoYI=";
  }
