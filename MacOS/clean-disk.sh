#!/bin/bash
# mac_cleanup_before_grandperspective.sh
# Interactive cleanup script for macOS Monterey and newer

echo "=============================="
echo "  macOS Safe Cleanup Utility"
echo "  (Pre-GrandPerspective Scan)"
echo "=============================="
echo ""

read -p "⚠️  This script will ask before deleting any files. Continue? (y/n): " proceed
if [[ "$proceed" != "y" ]]; then
  echo "Aborted."
  exit 0
fi

######################################
# 1. User Cache Cleanup
######################################
echo ""
read -p "🧹 Clear user cache (~Library/Caches)? (y/n): " clear_user_cache
if [[ "$clear_user_cache" == "y" ]]; then
  echo "Deleting user cache..."
  rm -rf ~/Library/Caches/*
  echo "✅ User cache cleared."
else
  echo "⏩ Skipping user cache."
fi

######################################
# 2. System Cache Cleanup
######################################
echo ""
read -p "🧹 Clear system cache (/Library/Caches)? (y/n): " clear_system_cache
if [[ "$clear_system_cache" == "y" ]]; then
  echo "Deleting system cache (requires sudo)..."
  sudo rm -rf /Library/Caches/*
  echo "✅ System cache cleared."
else
  echo "⏩ Skipping system cache."
fi

######################################
# 3. iOS Backups
######################################
IOS_PATH="$HOME/Library/Application Support/MobileSync/Backup"
if [ -d "$IOS_PATH" ]; then
  echo ""
  echo "📱 Found iOS backups in:"
  echo "$IOS_PATH"
  echo "Available backups:"
  ls "$IOS_PATH"
  echo ""
  read -p "Delete one or more backups? (y/n): " delete_ios
  if [[ "$delete_ios" == "y" ]]; then
    echo "Enter names of backups to delete (space-separated, or 'all' for all):"
    read backups
    if [[ "$backups" == "all" ]]; then
      rm -rf "$IOS_PATH"/*
      echo "✅ All iOS backups deleted."
    else
      for b in $backups; do
        rm -rf "$IOS_PATH/$b"
        echo "✅ Deleted $b"
      done
    fi
  else
    echo "⏩ Skipping iOS backups."
  fi
else
  echo "ℹ️  No iOS backups found."
fi

######################################
# 4. Time Machine Local Snapshots
######################################
echo ""
snapshots=$(tmutil listlocalsnapshots /)
if [[ -n "$snapshots" ]]; then
  echo "🕓 Local Time Machine snapshots found:"
  echo "$snapshots"
  echo ""
  read -p "Delete specific snapshots (1), thin all (2), or skip (3)? Enter 1/2/3: " snap_choice

  if [[ "$snap_choice" == "1" ]]; then
    echo "Enter snapshot dates to delete (space-separated):"
    read snapdates
    for snap in $snapdates; do
      sudo tmutil deletelocalsnapshots "$snap"
      echo "✅ Deleted snapshot $snap"
    done
  elif [[ "$snap_choice" == "2" ]]; then
    echo "Thinning snapshots by 10GB..."
    sudo tmutil thinlocalsnapshots / 10000000000 4
    echo "✅ Snapshots thinned."
  else
    echo "⏩ Skipping snapshots."
  fi
else
  echo "ℹ️  No local Time Machine snapshots found."
fi

######################################
# 5. System & User Logs
######################################
echo ""
read -p "🧾 Clear old system logs (/private/var/log) and user logs (~Library/Logs)? (y/n): " clear_logs
if [[ "$clear_logs" == "y" ]]; then
  echo "Deleting logs..."
  sudo rm -rf /private/var/log/*
  rm -rf ~/Library/Logs/*
  echo "✅ Logs cleared."
else
  echo "⏩ Skipping logs."
fi

######################################
# 6. Developer Data (Optional)
######################################
if [ -d "$HOME/Library/Developer/Xcode" ]; then
  echo ""
  read -p "🧑‍💻 Remove Xcode DerivedData, Archives, and Simulators? (y/n): " clear_xcode
  if [[ "$clear_xcode" == "y" ]]; then
    rm -rf ~/Library/Developer/Xcode/DerivedData/*
    rm -rf ~/Library/Developer/Xcode/Archives/*
    rm -rf ~/Library/Developer/CoreSimulator/*
    echo "✅ Xcode developer data cleared."
  else
    echo "⏩ Skipping Xcode data."
  fi
fi

######################################
# 7. Swap and Sleep Files (Optional)
######################################
if [ -f "/private/var/vm/sleepimage" ]; then
  echo ""
  read -p "💤 Delete sleepimage and swap files to save space? (y/n): " clear_vm
  if [[ "$clear_vm" == "y" ]]; then
    sudo rm /private/var/vm/sleepimage
    sudo rm -f /private/var/vm/swapfile*
    echo "✅ Sleep and swap files cleared."
  else
    echo "⏩ Skipping sleep/swap cleanup."
  fi
fi

######################################
# 8. Final Cleanup
######################################
echo ""
read -p "🗑️  Empty Trash and finish cleanup? (y/n): " empty_trash
if [[ "$empty_trash" == "y" ]]; then
  sudo rm -rf ~/.Trash/*
  echo "✅ Trash emptied."
fi

echo ""
echo "🎉 Cleanup complete! Reboot recommended before scanning with GrandPerspective."
echo "Done."
