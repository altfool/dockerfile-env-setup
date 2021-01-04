#!/bin/bash

set -e

XAUTH=$HOME/.docker.xauth
echo -e "Start to fix file $XAUTH..."
xauth_list=$(xauth nlist :0 | tail -n 1 | sed -e 's/^..../ffff/')
if [ ! -f $XAUTH ]; then
    rm -rf $XAUTH
    echo -e "File $XAUTH not exists. Create it now."
    touch $XAUTH
    chmod a+r $XAUTH
fi
if [ ! -z "$xauth_list" ]; then
    echo -e "merge xauth list to file $XAUTH"
    echo $xauth_list | xauth -f $XAUTH nmerge -
fi
echo "Done."
echo -e "\nVerifying file contents:"
file $XAUTH
echo "--> It should say \"X11 Xauthority data\"."
echo -e "\nPermissions:"
ls -FAlh $XAUTH
echo "done"
