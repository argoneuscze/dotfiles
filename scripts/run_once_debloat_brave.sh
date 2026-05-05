#!/bin/bash

POLICY_DIR="/etc/brave/policies/managed"
POLICY_FILE="$POLICY_DIR/brave_debloat.json"

echo "Applying Brave policies (may ask for sudo password)..."

# Create the directory
sudo mkdir -p "$POLICY_DIR"

# Write the JSON policy file using tee
sudo tee "$POLICY_FILE" > /dev/null <<EOF
{
  "TorDisabled": true,
  "BraveRewardsDisabled": true,
  "BraveWalletDisabled": true,
  "BraveVPNDisabled": true,
  "BraveAIChatEnabled": false,
  "BraveNewsEnabled": true,
  "BraveTalkDisabled": true,
  "BravePlaylistEnabled": false,
  "BraveWebDiscoveryEnabled": false,
  "BraveStatsPingEnabled": false,
  "BraveP3AEnabled": false
}
EOF

# Set correct permissions
sudo chmod 644 "$POLICY_FILE"

echo "Brave policies applied to $POLICY_FILE."

