#!/bin/bash

# init-hydrodev-irods.sh

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

# Replace the following line in /var/lib/irods/.irods/.irodsEnv
#irodsHost HYDRODEV_IRODS_IPADDR
echo "*** Replacing value of HYDRODEV_IRODS_IPADDR with ${1} in /var/lib/irods/.irods/.irodsEnv ***"
sed "s/HYDRODEV_IRODS_IPADDR/${1}/g" /var/tmp/initfiles/.irodsEnv > /var/lib/irods/.irods/.irodsEnv

# Update host value for hydrodevResc as localhost
sudo -u irods iadmin modresc hydrodevResc host localhost

# Provide instructions to user for use of iDrop Web
echo "*** Completed ***"
echo ""
echo "*** Once system reboots, perform the following: ***"
echo ""
echo "  1. go to http://${1}/idrop-web2/login/login in your local browser"
echo ""
echo "  2. Login as:"
echo "     User Name: hsproxy"
echo "     Password: proxywater1"
echo ""
echo "*** Rebooting VM in 10 seconds to allow new settings to take effect ***"

COUNTDOWN=10
while [ $COUNTDOWN -gt 0 ]; do
  echo -n "${COUNTDOWN}.."
  sleep 1s
  let COUNTDOWN-=1
done

shutdown -r now