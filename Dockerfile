FROM bitnami/minideb-extras:jessie-r13

RUN install_packages build-essential libtool make cmake cmake-data openssl libssl-dev libmysqlclient-dev libmysql++-dev libreadline6-dev zlib1g-dev libbz2-dev libboost1.55-dev libboost-thread1.55-dev libboost-filesystem1.55-dev libboost-system1.55-dev libboost-program-options1.55-dev libboost-iostreams1.55-dev wget software-properties-common git

RUN wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -

RUN echo "yes" | sudo add-apt-repository 'deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty-3.9 main'

RUN install_packages clang-3.9

ADD ./scripts/rootfs /

ENV CC=clang-3.9 \
    CXX=clang++-3.9

VOLUME ["/TrinityCore", "/trinitycore"]

CMD ["./compile_3.3.5.sh"]
