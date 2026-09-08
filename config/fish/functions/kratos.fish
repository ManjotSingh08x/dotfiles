function kratos
    # 1. Ensure the local mount directory exists
    mkdir -p ~/mnt/kratos

    # 2. Start the rclone mount in the background. 
    # Redirecting error output prevents terminal clutter if it is already mounted.
    sshfs flame@kratos.sdslabs.org:/opt/watchdog/users/flame ~/mnt/kratos

    # 3. Open the interactive SSH session (with your port forwards from ~/.ssh/config)
    ssh flame@kratos.sdslabs.org

    # 4. Optional: Unmount automatically when you type 'exit' and leave the SSH session
    #  fusermount -u ~/mnt/kratos
end
function iitrvpn
    sudo openconnect --protocol=anyconnect vpn.iitr.ac.in
end
