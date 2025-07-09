#!/bin/bash

# This script provides network management functionality for Waybar.
# It displays the current connection status and allows you to select
# and activate network connections via a rofi/wofi menu.

# --- Configuration ---
# Path to your preferred menu utility.
# Uncomment the one you use. 'rofi' is common for X11, 'wofi' for Wayland.
# ROFI_CMD="rofi -dmenu -i -p \"Network Connections\""
WOFI_CMD='wofi --show dmenu -i -p "Network Connections"'

# --- Functions ---

# Function to get the current network status for Waybar display.
# It outputs a JSON string with 'text' for the bar and 'tooltip' for hover.
get_status() {
    # Initialize variables for active connections
    ACTIVE_WIFI=""
    ACTIVE_WIRED=""
    ACTIVE_VPN=""

    # Attempt to get active Wi-Fi connection.
    ACTIVE_WIFI=$(nmcli -t -f active,ssid device wifi | grep '^yes' | cut -d':' -f2 | tr -d '\n' 2>/dev/null || true)

    # Attempt to get active wired connection.
    ACTIVE_WIRED=$(nmcli -t -f active,device connection show --active | grep '^yes' | grep -v 'wifi' | grep -v 'lo' | cut -d':' -f2 | tr -d '\n' 2>/dev/null || true)

    # Attempt to get active wired connection.
    ACTIVE_VPN=$(nmcli -t -f name,type connection show --active | grep 'vpn' | cut -d':' -f1 | tr -d '\n' 2>/dev/null || true)

    # Initialize text and tooltip variables
    local icon="󰌙"
    local text="Disconnected"
    local tooltip="No active network connection"


    if [[ -n "$ACTIVE_WIFI" ]]; then
        icon="󰤨"
        text="$ACTIVE_WIFI"
        tooltip="Wi-Fi: $ACTIVE_WIFI"
    elif [[ -n "$ACTIVE_WIRED" ]]; then
        icon="󰈀"
        text="$ACTIVE_WIRED"
        tooltip="Wired: $ACTIVE_WIRED"
    fi

    if [[ -n "$ACTIVE_VPN" ]]; then
        icon="󰖂"
        tooltip="VPN: $ACTIVE_VPN"
    fi

    # Output the JSON. Ensure no extra newlines or characters.
    printf '{"text": "%s", "tooltip": "%s"}\n' "$icon" "$tooltip"
}

# Function to display a menu of available connections and activate the selected one.
display_menu() {
    # Get all available network connections.
    # -t: tabular output, -f name,type: only show name and type fields
    # grep -v ':vpn': exclude VPN connections (can be complex, might need separate handling)
    # cut -d':' -f1: get only the connection name
    # sort: sort connections alphabetically
    # 2>/dev/null: redirect stderr to /dev/null to prevent nmcli errors from interfering
    CONNECTIONS=$(nmcli -t -f name,type con show 2>/dev/null | grep -v ':lo' | cut -d':' -f1 | sort || true)

    # Check if there are any connections to display
    if [[ -z "$CONNECTIONS" ]]; then
        # If no connections found, send a notification and exit.
        notify-send "Network Manager" "No network connections found."
        exit 1
    fi

    # Use the configured menu command (rofi or wofi) to let the user select a connection.
    # The 'echo -e "$CONNECTIONS"' feeds the list of connections to rofi/wofi.
    # 2>/dev/null: redirect stderr to /dev/null for rofi/wofi output
    SELECTED_CONNECTION=$(echo -e "$CONNECTIONS" | eval $WOFI_CMD 2>/dev/null) # Change to $WOFI_CMD if using wofi

    # Check if a connection was selected (i.e., the user didn't just close the menu)
    if [[ -n "$SELECTED_CONNECTION" ]]; then
        # Attempt to bring up the selected connection.
        # This command requires appropriate permissions (e.g., via sudoers or Polkit rules).
        # Redirect stdout and stderr to /dev/null to keep the script's output clean.
        if nmcli con up "$SELECTED_CONNECTION" >/dev/null 2>&1; then
            notify-send "Network Manager" "Successfully connected to '$SELECTED_CONNECTION'."
        else
            notify-send "Network Manager" "Failed to connect to '$SELECTED_CONNECTION'. Check permissions or connection details."
        fi
    else
        notify-send "Network Manager" "Connection selection cancelled."
    fi
}

# --- Main Script Logic ---
# This 'case' statement handles the arguments passed to the script from Waybar.
case "$1" in
    status)
        # If the argument is 'status', call the get_status function.
        get_status
        ;;
    menu)
        # If the argument is 'menu', call the display_menu function.
        display_menu
        ;;
    *)
        # If no argument or an unknown argument is provided, default to 'status'.
        get_status
        ;;
esac
