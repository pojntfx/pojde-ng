#!/bin/bash

# Upgrade script
function upgrade() {
    # Read configuration file
    . /opt/pojde-ng/preferences/preferences.sh

    # Create notebooks directory
    su - $POJDE_NG_USERNAME -c "mkdir -p /home/${POJDE_NG_USERNAME}/Notebooks"

    # Change the password to the new value and enable remote access without binding to all interfaces
    su - $POJDE_NG_USERNAME -c "jupyter server --generate-config -y"
    CONFIG_FILE=/home/$POJDE_NG_USERNAME/.jupyter/jupyter_server_config.py
    echo "c.NotebookApp.password='"$(python3 -c "from IPython.lib.security import passwd; print(passwd(passphrase='${POJDE_NG_PASSWORD}', algorithm='sha1'))")"'" >>$CONFIG_FILE
    echo 'c.NotebookApp.allow_remote_access = True' >>$CONFIG_FILE
    echo "c.NotebookApp.allow_origin = '*'" >>$CONFIG_FILE

    # Enable & restart the services
    if [ "${POJDE_NG_OPENRC}" = 'true' ]; then
        rc-service jupyter-lab restart
        rc-update add jupyter-lab default
    else
        systemctl enable "jupyter-lab@${POJDE_NG_USERNAME}"
        systemctl restart "jupyter-lab@${POJDE_NG_USERNAME}"
    fi
}

# Refresh script
function refresh() {
    :
}
