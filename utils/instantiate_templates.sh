#!/bin/bash

set -e

if [ -f /.all_templates_processed ]; then
    echo "Pentaho PDI containerized installation templates already changed!"
    exit 0
fi

# Generate password
PASS=${CARTE_USER_PWD:-$(pwgen -s 12 1)}
IP_ADDRESS=`ip route get 8.8.8.8 | awk '{print $NF; exit}'`

# Set variables to defaults if they are not already set
: ${MASTER_NAME:=carte-master}
: ${MASTER_USER:=admin}
: ${IS_CARTE_SERVER:=N}
: ${CONFIGURE_AS_MASTER:=Y}

: ${CARTE_INCLUDE_MASTERS:=N}

: ${SLAVE_REPORT_MASTER:=Y}
: ${SLAVE_NAME:=carte-slave}
: ${SLAVE_USER:=admin}
: ${CARTE_MASTER_HOSTNAME:=localhost}
: ${CARTE_MASTER_PORT:=8080}
: ${CARTE_MASTER_USER:=cluster}
: ${CARTE_MASTER_PASSWORD:=cluster}
: ${CARTE_MASTER_IS_MASTER:=Y}

echo
echo "=================================================================================="
echo "=> Modifying carte ${MASTER_USER} user passwords to ${PASS}"
echo "=================================================================================="
echo

cd /opt/pentaho/data-integration

if [ "$IS_CARTE_SERVER" = "Y" ]; then
    if [ "$CONFIGURE_AS_MASTER" = "Y" ]; then
        mkdir ./config
        cp ./templates/carte-master.xml ./config/carte-config.xml
        sed -i 's/@@MASTER_NAME@@/'${MASTER_NAME}'/g' ./config/carte-config.xml
        sed -i 's/@@HOST@@/'${IP_ADDRESS}'/g' ./config/carte-config.xml
        sed -i 's/@@MASTER_USER@@/'${MASTER_USER}'/g' ./config/carte-config.xml
        sed -i 's/@@MASTER_PWD@@/'${PASS}'/g' ./config/carte-config.xml
    else
        mkdir ./config
        cp ./templates/carte-slave.xml ./config/carte-config.xml
        sed -i 's/@@MASTER_NAME@@/'${MASTER_NAME}'/g' ./config/carte-config.xml
        sed -i 's/@@SLAVE_NAME@@/'${SLAVE_NAME}'/g' ./config/carte-config.xml
        sed -i 's/@@HOST@@/'${IP_ADDRESS}'/g' ./config/carte-config.xml
        sed -i 's/@@SLAVE_USER@@/'${SLAVE_USER}'/g' ./config/carte-config.xml
        sed -i 's/@@SLAVE_PWD@@/'${PASS}'/g' ./config/carte-config.xml

        sed -i 's/@@MASTER_HOST@@/'${MASTER_HOST}'/g' ./config/carte-config.xml
        sed -i 's/@@MASTER_PORT@@/'${MASTER_PORT}'/g' ./config/carte-config.xml
        sed -i 's/@@MASTER_USER@@/'${MASTER_USER}'/g' ./config/carte-config.xml
        sed -i 's/@@MASTER_PWD@@/'${MASTER_PWD}'/g' ./config/carte-config.xml
        sed -i 's/@@SLAVE_REPORT_MASTER@@/'${SLAVE_REPORT_MASTER}'/g' ./config/carte-config.xml
    fi
fi

echo "Pentaho PDI containerized installation templates processed successfully!"
touch /.all_templates_processed
