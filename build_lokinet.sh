#!/bin/bash

echo "install required packages"

echo "sudo apt-get update"
echo "sudo apt-get install -y build-essential cmake git libcap-dev pkg-config automake libtool libuv1-dev libsodium-dev libzmq3-dev libcurl4-openssl-dev libevent-dev nettle-dev libunbound-dev libsqlite3-dev libssl-dev nlohmann-json3-dev libjemalloc-dev libjemalloc2 doxygen aria2"

cd ~/
mkdir lokinet_build
cd  lokinet_build
mkdir lokinet_main bin_lokinet oxen-mq

echo "------------Building oxen-mq for liboxenmq-----------"
cd ~/lokinet_build/oxen-mq
aria2c https://github.com/123ahaha/Lokinet-DEB-riscv/raw/main/liboxenmq1.2.12_1.2.12-1%7Edeb11_amd64.deb #you can just import your DEB #CHANGE_VERSION

dpkg-deb -x ~/lokinet_build/oxen-mq/liboxenmq1.2.12_1.2.12-1~deb11_amd64.deb ~/lokinet_build/oxen-mq/liboxenmq1.2.11_1.2.11-2~deb11_riscv64 #change the version each time i guess CHANGE_VERSION
dpkg-deb --control ~/lokinet_build/oxen-mq/liboxenmq1.2.12_1.2.12-1~deb11_amd64.deb

git clone --recursive https://github.com/oxen-io/oxen-mq.git
cd oxen-mq && mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX:PATH=/usr -DOXENMQ_INSTALL_CPPZMQ=ON -DOXENMQ_BUILD_TESTS=OFF
make CPUS=$(nproc)

mv ~/lokinet_build/oxen-mq/DEBIAN ~/lokinet_build/oxen-mq/liboxenmq1.2.11_1.2.11-2~deb11_riscv64/
cp ~/lokinet_build/oxen-mq/oxen-mq/build/liboxenmq.so.0 ~/lokinet_build/oxen-mq/liboxenmq1.2.11_1.2.11-2~deb11_riscv64/usr/lib/x86_64-linux-gnu/liboxenmq.so.1.2.11 #will have to change version each time CHANGE_VERSION
echo "!! YOU HAVE TO REPALCE THE CHECKSUM OF ~/lokinet_build/oxen-mq/liboxenmqX.X.XX_X.X.XX-X~deb11_riscv64/usr/lib/x86_64-linux-gnu/liboxenmq.so.X.X.XX in the BY THIS !!"
md5sum ~/lokinet_build/oxen-mq/liboxenmq1.2.11_1.2.11-2~deb11_riscv64/usr/lib/x86_64-linux-gnu/liboxenmq.so.1.2.11 #CHANGE_VERSION
echo "!! IN THE ~/lokinet_build/oxen-mq/liboxenmqX.X.XX_X.X.XX-2~deb11_riscv64/DEBIAN/md5sums FILE !!"
echo "!! I LL REPASTE IT AT THE END !!"


echo "------------Building lokinet | lokinet-vpn | lokinet-bootstrap for lokinet package-----------"
cd ~/lokinet_build/lokinet_main
aria2c https://github.com/123ahaha/Lokinet-DEB-riscv/raw/main/lokinet_0.9.9-2%7Edeb11_all.deb #you can just import your DEB #CHANGE_VERSION
dpkg-deb -x ~/lokinet_build/lokinet_main/lokinet_0.9.9-2~deb11_all.deb ~/lokinet_build/lokinet_main/lokinet_0.9.9-2~deb11_riscv64 #CHANGE_VERSION
dpkg-deb --control ~/lokinet_build/lokinet_main/lokinet_0.9.9-2~deb11_all.deb
mv ~/lokinet_build/lokinet_main/DEBIAN ~/lokinet_build/lokinet_main/lokinet_0.9.9-2~deb11_riscv64/

git clone --recursive https://github.com/oxen-io/lokinet
cd ~/lokinet_build/lokinet_main/lokinet && mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release \
         -DCMAKE_C_FLAGS="-march=rv64imafdc -mabi=lp64d" \
         -DCMAKE_CXX_FLAGS="-march=rv64imafdc -mabi=lp64d" \
         -DNATIVE_BUILD=OFF \
         -DUSE_AVX2=OFF \
         -DWITH_TESTS=OFF \
         -DWITH_SYSTEMD=ON \
         -DBUILD_SHARED_LIBS=OFF

make CPUS=$(nproc)


cp ~/lokinet_build/lokinet_main/lokinet/contrib/lokinet-resolvconf ~/lokinet_build/lokinet_main/lokinet_0.9.9-2~deb11_riscv64/usr/sbin/ #CHANGE_VERSION

echo "!! YOU HAVE TO REPALCE THE CHECKSUM OF ~/lokinet_build/lokinet_main/lokinet_X.X.X-X~deb11_riscv64/usr/sbin/lokinet-resolvconf BY THIS : !!"
md5sum ~/lokinet_build/lokinet_main/lokinet_0.9.9-2~deb11_riscv64/usr/sbin/lokinet-resolvconf #CHANGE_VERSION
echo "!! IN THE ~/lokinet_build/lokinet_main/lokinet_X.X.X-X~deb11_riscv64/DEBIAN/md5sums FILE !!"
echo "!! I LL REPASTE IT AT THE END !!"



echo "------------Building lokinet-bin -----------"

cd ~/lokinet_build/bin_lokinet
aria2c https://github.com/123ahaha/Lokinet-DEB-riscv/raw/main/lokinet-bin_0.9.9-2%7Edeb11_amd64.deb #you can just import your DEB #CHANGE_VERSION
dpkg-deb -x ~/lokinet_build/bin_lokinet/lokinet-bin_0.9.9-2~deb11_amd64.deb ~/lokinet_build/bin_lokinet/lokinet-bin_0.9.9-2~deb11_riscv64 #CHANGE_VERSION
dpkg-deb --control ~/lokinet_build/bin_lokinet/lokinet-bin_0.9.9-2~deb11_amd64.deb #CHANGE_VERSION
mv DEBIAN ~/lokinet_build/bin_lokinet/lokinet-bin_0.9.9-2~deb11_riscv64 #CHANGE_VERSION

cp ~/lokinet_build/lokinet_main/lokinet/build/daemon/lokinet ~/lokinet_build/bin_lokinet/lokinet-bin_0.9.9-2~deb11_riscv64/usr/bin/ #CHANGE_VERSION
cp ~/lokinet_build/lokinet_main/lokinet/build/daemon/lokinet-bootstrap ~/lokinet_build/bin_lokinet/lokinet-bin_0.9.9-2~deb11_riscv64/usr/bin/ #CHANGE_VERSION
cp ~/lokinet_build/lokinet_main/lokinet/build/daemon/lokinet-vpn ~/lokinet_build/bin_lokinet/lokinet-bin_0.9.9-2~deb11_riscv64/usr/bin/ #CHANGE_VERSION

echo "!! YOU HAVE TO REPALCE THE CHECKSUM OF ~/lokinet_build/bin_lokinet/lokinet-bin_X.X.X-X~deb11_riscv64/usr/bin/* BY THIS : !!"
md5sum ~/lokinet_build/bin_lokinet/lokinet-bin_0.9.9-2~deb11_riscv64/usr/bin/lokinet #CHANGE_VERSION
md5sum ~/lokinet_build/bin_lokinet/lokinet-bin_0.9.9-2~deb11_riscv64/usr/bin/lokinet-bootstrap #CHANGE_VERSION
md5sum ~/lokinet_build/bin_lokinet/lokinet-bin_0.9.9-2~deb11_riscv64/usr/bin/lokinet-vpn #CHANGE_VERSION
echo "!! IN THE ~/lokinet_build/bin_lokinet/lokinet-bin_X.X.X-X~deb11_riscv64/DEBIAN/md5sums FILE !!"
echo "!! I LL REPASTE IT AT THE END !!"

echo "------------Replacing ./DEBIAN/control file in oxen-mq -----------"
echo "just changing amd64 to riscv64"
cat > ~/lokinet_build/oxen-mq/liboxenmq1.2.11_1.2.11-2~deb11_riscv64/DEBIAN/control << "EOF"
Package: liboxenmq1.2.11
Source: oxenmq
Version: 1.2.11-2~deb11
Architecture: riscv64
Maintainer: Jason Rhinelander <jason@imaginary.ca>
Installed-Size: 2045
Depends: libc6 (>= 2.12), libgcc-s1 (>= 3.0), libsodium23 (>= 0.6.0), libstdc++6 (>= 9), libzmq5 (>= 4.3.1)
Section: libs
Priority: optional
Homepage: https://github.com/oxen-io/oxen-mq
Description: zeromq-based Oxen message passing library
 This C++17 library contains an abstraction layer around ZeroMQ to support
 integration with Oxen authentication, RPC, and message passing.  It is
 designed to be usable as the underlying communication mechanism of SN-to-SN
 communication ("quorumnet"), the RPC interface used by wallets and local
 daemon commands, communication channels between oxend and auxiliary services
 (storage server, lokinet), and also provides a local multithreaded job
 scheduling within a process.
 .
 This package contains the library file needed by software built using oxenmq.

EOF


echo "------------Replacing ./DEBIAN/control file in lokinet-bin -----------"  #CHANGE_VERSION
echo " just changing libssl1.1 (>= 1.1.0) to libssl3, and amd64 to riscv64"
cat > ~/lokinet_build/bin_lokinet/lokinet-bin_0.9.8-2~deb11_riscv64/DEBIAN/control << "EOF"
Package: lokinet-bin
Source: lokinet
Version: 0.9.8-2~deb11
Architecture: riscv64
Maintainer: Jeff Becker (probably not evil) <jeff@i2p.rocks>
Installed-Size: 3976
Depends: libc6 (>= 2.29), libcurl4 (>= 7.16.2), libgcc-s1 (>= 3.4), libjemalloc2 (>= 5.0.0), liboxenmq1.2.11, libsodium23 (>= 1.0.18), libsqlite3-0 (>= 3.7.15), libssl3, libstdc++6 (>= 9), libsystemd0 (>= 221), libunbound8 (>= 1.8.0), libuv1 (>= 1.7.0), lsb-base, curl
Section: net
Priority: optional
Homepage: https://lokinet.org/
Description: Lokinet anonymous, decentralized overlay network -- binaries
 Lokinet private, decentralized, market-based, Sybil resistant overlay network
 for the internet.
 .
 This package contains the lokinet binaries; most users will want to install
 the lokinet or lokinet-router packages to run lokinet as a system service.

EOF


echo "------------Replacing ./DEBIAN/control file in lokinet -----------"  #CHANGE_VERSION
echo " just changing all to riscv64"
cat > ~/lokinet_build/lokinet_main/lokinet_0.9.8-2~deb11_riscv64/DEBIAN/control << "EOF"
Package: lokinet
Version: 0.9.8-2~deb11
Architecture: riscv64
Maintainer: Jeff Becker (probably not evil) <jeff@i2p.rocks>
Installed-Size: 82
Depends: lokinet-bin (= 0.9.8-2~deb11), adduser, ucf
Recommends: resolvconf
Section: net
Priority: optional
Homepage: https://lokinet.org/
Description: Lokinet anonymous, decentralized overlay network - client service
 Lokinet private, decentralized, market-based, Sybil resistant overlay network
 for the internet.
 .
 This package contains contains the configuration needed to run lokinet as a
 system service to allow the local system to access lokinet either as an
 anonymous client or as a lokinet "snapp".
 .
 Most users looking to access lokinet want to install this package.

EOF



echo "NOW WE WILL UPDATE THE MD5SUM OF EACH ./DEBIAN/md5sums FILE"
echo "and finally build the .deb packages"
echo "!! YOU HAVE TO REPALCE THE CHECKSUM OF ~/lokinet_build/lokinet_main/lokinet_X.X.X-X~deb11_riscv64/usr/sbin/lokinet-resolvconf BY THIS : !!"
md5sum ~/lokinet_build/lokinet_main/lokinet_0.9.9-2~deb11_riscv64/usr/sbin/lokinet-resolvconf #CHANGE_VERSION
echo "!! IN THE ~/lokinet_build/lokinet_main/lokinet_X.X.X-X~deb11_riscv64/DEBIAN/md5sums FILE !!"
echo ""

echo "!! YOU HAVE TO REPALCE THE CHECKSUM OF ~/lokinet_build/oxen-mq/liboxenmqX.X.XX_X.X.XX-X~deb11_riscv64/usr/lib/x86_64-linux-gnu/liboxenmq.so.X.X.XX in tX in the BY THIS !!"
md5sum ~/lokinet_build/oxen-mq/liboxenmq1.2.11_1.2.11-2~deb11_riscv64/usr/lib/x86_64-linux-gnu/liboxenmq.so.1.2.11 #CHANGE_VERSION
echo "!! IN THE ~/lokinet_build/oxen-mq/liboxenmqX.X.XX_X.X.XX-2~deb11_riscv64/DEBIAN/md5sums FILE !!"
echo ""

echo "!! YOU HAVE TO REPALCE THE CHECKSUM OF ~/lokinet_build/bin_lokinet/lokinet-bin_X.X.X-X~deb11_riscv64/usr/bin/* BY THIS : !!"
md5sum ~/lokinet_build/bin_lokinet/lokinet-bin_0.9.9-2~deb11_riscv64/usr/bin/lokinet #CHANGE_VERSION
md5sum ~/lokinet_build/bin_lokinet/lokinet-bin_0.9.9-2~deb11_riscv64/usr/bin/lokinet-bootstrap #CHANGE_VERSION
md5sum ~/lokinet_build/bin_lokinet/lokinet-bin_0.9.9-2~deb11_riscv64/usr/bin/lokinet-vpn #CHANGE_VERSION
echo "!! IN THE ~/lokinet_build/bin_lokinet/lokinet-bin_X.X.X-X~deb11_riscv64/DEBIAN/md5sums FILE !!"
echo ""

echo "when you're done, just run thoses command to build the packages"

cd
echo "dpkg -b ~/lokinet_build/lokinet_main/lokinet-bin_0.9.9-2~deb11_riscv64 lokinet_0.9.9-2~deb11_riscv64.deb"

echo "dpkg -b ~/lokinet_build/bin-lokinet/lokinet-bin_0.9.9-2~deb11_riscv64 lokinet-bin_0.9.9-2~deb11_riscv64.deb"

echo "dpkg -b ~/lokinet_build/oxen-mq/liboxenmq1.2.11_1.2.11-2~deb11_riscv64 liboxenmq1.2.11_1.2.11-2~deb11_riscv64.deb"
