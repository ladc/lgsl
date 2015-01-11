#!/bin/sh

LGT_PACKAGE_NAME=$1
LGT_VERSION=$2
LGT_LUA=$3

LGT_ISIZE_A=(`du -s debian_build`)
LGT_ISIZE=${LGT_ISIZE_A[0]}

LGT_ARCH=`dpkg-architecture -qDEB_HOST_ARCH`
LGT_MAINTAINER="${USER}@${HOSTNAME}"

mkdir debian_build/DEBIAN

cat debian/control | sed "s/LGT_PACKAGE_NAME/$LGT_PACKAGE_NAME/;s/LGT_VERSION/$LGT_VERSION/;s/LGT_INSTALLED_SIZE/$LGT_ISIZE/;s/LGT_ARCH/$LGT_ARCH/;s/LGT_LUA/$LGT_LUA/;s/LGT_MAINTAINER/$LGT_MAINTAINER/" - > debian_build/DEBIAN/control

chown root.root -R debian_build
chmod a-w -R debian_build
chmod 0755 debian_build/DEBIAN

dpkg-deb -b debian_build "${LGT_PACKAGE_NAME}_${LGT_VERSION}-1_${LGT_ARCH}.deb"
