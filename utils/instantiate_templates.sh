#!/bin/bash

set -e

if [ -f /.all_templates_processed ]; then
    echo "Pentaho PDI containerized installation templates already changed!"
    exit 0
fi

# Generate password
PASS=${PENTAHO_DB_USER_PWD:-$(pwgen -s 12 1)}
IP_ADDRESS=`ip route get 8.8.8.8 | awk '{print $NF; exit}'`
echo
echo "=================================================================================="
echo "=> Modifying carte admin user passwords to ${PASS}"
echo "=================================================================================="
echo

cd /opt/pentaho/data-integration/config

sed -i 's/@@MASTER_NAME@@/carte-master/g' ./carte-master.xml
sed -i 's/@@MASTER_HOST@@/'${IP_ADDRESS}'/g' ./carte-master.xml
sed -i 's/@@MASTER_USER@@/admin/g' ./carte-master.xml
sed -i 's/@@MASTER_PWD@@/'${PASS}'/g' ./carte-master.xml
sed -i 's/@@IS_MASTER@@/Y/g' ./carte-master.xml

# DB_HOST=${PENTAHO_DB_PORT_5432_TCP_ADDR:-'localhost'}
# echo "=> Modifying database host to ${DB_HOST}"

# sed -i 's/@@DB_HOST@@/'${DB_HOST}'/g' `find ./data/${DB_TYPE} -name *.sql`
# sed -i 's/@@DB_HOST@@/'${DB_HOST}'/g' `find ./pentaho-solutions/system -name *.properties`
# sed -i 's/@@DB_HOST@@/'${DB_HOST}'/g' `find ./pentaho-solutions/system -name *.xml`
# sed -i 's/@@DB_HOST@@/'${DB_HOST}'/g' `find ./tomcat/webapps -name *.xml`
# sed -i 's/@@DB_HOST@@/'${DB_HOST}'/g' `find ./utils -name init_pentaho_db.sh`

echo "Pentaho PDI containerized installation templates processed successfully!"
touch /.all_templates_processed   
