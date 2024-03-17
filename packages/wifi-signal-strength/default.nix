# Copyright 2022-2024 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  gawk,
  lib,
  networkmanager,
  openssh,
  writeShellApplication,
  wifiDevice,
}: let
  # Replace the IP address with "net-vm.ghaf" after DNS/DHCP module merge
  netvm_address = "192.168.100.1";
in
  pkgs.writeShellApplication {
    name = "wifi-signal-strength";

    text = ''
      export DBUS_SESSION_BUS_ADDRESS=unix:path=/tmp/ssh_session_dbus.sock
      export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/tmp/ssh_system_dbus.sock
      ${openssh}/bin/ssh -M -S /tmp/nmcli_socket \
          -f -N -q ghaf@${netvm_address} \
          -i /run/waypipe-ssh/id_ed25519 \
          -o StrictHostKeyChecking=no \
          -o StreamLocalBindUnlink=yes \
          -o ExitOnForwardFailure=yes \
          -L /tmp/ssh_session_dbus.sock:/run/user/1000/bus \
          -L /tmp/ssh_system_dbus.sock:/run/dbus/system_bus_socket
      signal0=󰤟
      signal1=󰤢
      signal2=󰤥
      signal3=󰤨
      no_signal=󰤭
      # Get IP address of netvm
      address=$(${networkmanager}/bin/nmcli device show ${wifiDevice} | ${gawk}/bin/awk '{ if ($1=="IP4.ADDRESS[1]:") {print $2}}')
      # Get signal strength and ssid
      connection=($(${networkmanager}/bin/nmcli -f IN-USE,SIGNAL,SSID dev wifi | ${gawk}/bin/awk '/^\*/{if (NR!=1) {print $2; print $3}}'))
      connection[0]=$(if [ -z ''${connection[0]} ]; then echo "-1"; else echo ''${connection[0]}; fi)
      # Set the icon of signal level
      signal_level=$(if [ ''${connection[0]} -gt 80 ]; then echo $signal3; elif [ ''${connection[0]} -gt 60 ]; then echo $signal2; elif [ ''${connection[0]} -gt 30 ]; then echo $signal1; elif [ ''${connection[0]} -gt 0 ]; then echo signal0; else echo $no_signal; fi)
      tooltip=$(if [ -z $address ]; then echo ''${connection[0]}%; else echo $address ''${connection[0]}%; fi)
      text=$(if [ -z ''${connection[1]} ]; then echo "No connection"; else echo ''${connection[1]} $signal_level; fi)
      # Return as json format for waybar
      echo "{\"percentage\":\""''${connection[0]}"\", \"text\":\""$text"\", \"tooltip\":\""$tooltip"\", \"class\":\"1\"}"
      # Use the control socket to close the ssh tunnel.
      ${openssh}/bin/ssh -q -S /tmp/nmcli_socket -O exit ghaf@${netvm_address}
    '';

    meta = with lib; {
      description = "Script to get wifi data from nmcli to show network of netvm using D-Bus over SSH on Waybar.";
      platforms = [
        "x86_64-linux"
      ];
    };
  }
