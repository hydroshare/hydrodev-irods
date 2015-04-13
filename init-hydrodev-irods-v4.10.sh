#!/bin/bash

# init-hydrodev-irods-v4.10.sh

# author: Michael J. Stealey
# email: michael.j.stealey@gmail.com

# Copy versions of orginal files into their respective directories
# cp /var/tmp/initfiles/idrop-web-config2.groovy /etc/idrop-web/idrop-web-config2.groovy
if [ -z $1 ];
  then
    echo "*** Please enter the hydrdev-irods IP address ***"
    exit;
  else
    echo "*** Using ${1} as the IP Address for hydrodev-irods ***";
fi


# Replace the following line in /etc/idrop-web/idrop-web-config2.groovy
# production {  grails.serverURL = "http://HYDRODEV_IRODS_IPADDR/idrop-web2" }
echo "*** Replacing value of HYDRODEV_IRODS_IPADDR with ${1} in /etc/idrop-web/idrop-web-config2.groovy ***"
sed "s/HYDRODEV_IRODS_IPADDR/${1}/g" /var/tmp/initfiles/idrop-web-config2.groovy > /etc/idrop-web/idrop-web-config2.groovy

# Replace the following line in /var/lib/irods/.irods/irods_environment.json
#irodsHost HYDRODEV_IRODS_IPADDR
echo "*** Replacing value of HYDRODEV_IRODS_IPADDR with ${1} in /var/lib/irods/.irods/irods_environment.json ***"
sed "s/HYDRODEV_IRODS_IPADDR/${1}/g" /var/tmp/initfiles/irods_environment.json.rods > /var/lib/irods/.irods/irods_environment.json

# Replace the following line in /home/hydro/.irods/irods_environment.json
#irodsHost HYDRODEV_IRODS_IPADDR
echo "*** Replacing value of HYDRODEV_IRODS_IPADDR with ${1} in /home/hydro/.irods/irods_environment.json ***"
sed "s/HYDRODEV_IRODS_IPADDR/${1}/g" /var/tmp/initfiles/irods_environment.json.hsproxy > /home/hydro/.irods/irods_environment.json

# Restart tomcat server
echo "*** Stop tomcat server ***"
sleep 1
sudo /etc/init.d/tomcat stop
echo "*** Start tomcat server using IP Address ${1} ***"
sleep 1
sudo /etc/init.d/tomcat start


# Provide instructions to user for use of iDrop Web
echo "*** Completed ***"
echo ""
echo "*** Wait a moment for the tomcat server to restart, then: ***"
echo ""
echo "  1. go to http://${1}:8080/idrop-web2/login/login in your local browser"
echo ""
echo "  2. Login as:"
echo "     User Name: hsproxy"
echo "     Password: proxywater1"
echo ""
echo "*** FINISHED SCRIPT init-hydrodev-irods.sh ***"
exit;