function refreshallbt
    # Extract MAC addresses from the known devices list
    set mac_list (bluetoothctl devices | awk '{print $2}')

    if test -z "$mac_list"
        echo "No Bluetooth devices found in local cache."
        return 1
    end

    for mac in $mac_list
        echo "Resetting device: $mac"

        bluetoothctl remove $mac
        sleep 2
        bluetoothctl pair $mac
        bluetoothctl trust $mac
        bluetoothctl connect $mac

        echo "Finished with $mac"
        echo ----------------------
    end
end
