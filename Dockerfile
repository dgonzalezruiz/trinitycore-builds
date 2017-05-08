FROM bitnami/minideb-extras:jessie-r13

RUN install_packages build-essential libtool make cmake cmake-data openssl libssl-dev libreadline6-dev zlib1g-dev libbz2-dev libboost1.55-dev libboost-thread1.55-dev libboost-filesystem1.55-dev libboost-system1.55-dev libboost-program-options1.55-dev libboost-iostreams1.55-dev wget software-properties-common git p7zip

RUN wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -

RUN echo "yes" | sudo add-apt-repository 'deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty-3.9 main'

RUN install_packages clang-3.9

ADD ./scripts/rootfs /

ENV CC=clang-3.9 \
    CXX=clang++-3.9 \
    PATH=/opt/bitnami/mysql/bin:$PATH

RUN bitnami-pkg install mysql-client-10.1.23-0 --checksum 9c38e41f237a4b9ce1aca7b9ecad86be5c55b924880cef45b87d635a4aea9d3d

VOLUME ["/TrinityCore", "/trinitycore"]

CMD ["./compile_3.3.5.sh"]
