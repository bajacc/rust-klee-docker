FROM ubuntu:20.04

RUN apt-get --yes update

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install --yes \
	git \
	vim \
	gcc \
	cmake \
	clang \
	gdb \
	z3 \
	make \
	llvm \
	sudo \
	build-essential \
	curl \
	libcap-dev \
	libncurses5-dev \
	python3-minimal \
	python3-pip unzip \
	libtcmalloc-minimal4 \
	libgoogle-perftools-dev \
	libsqlite3-dev \
	doxygen \
	gcc-multilib \
	g++-multilib

RUN pip3 install lit tabulate wllvm

ARG USERNAME=ubuntu
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
ENV USER_HOME=/home/${USERNAME}

RUN groupadd --gid=${USER_GID} ${USERNAME} && \
	useradd --shell=/bin/bash --uid=${USER_UID} --gid=${USER_GID} --create-home ${USERNAME} && \
	echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USERNAME}
WORKDIR ${USER_HOME}

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV PATH=${USER_HOME}/.cargo/bin:$PATH

# With version 1.52.0 (current): when using klee target/debug/examples/get_sign*.ll
# LLVM ERROR: Cannot lower a call to a non-intrinsic function 'llvm.experimental.noalias.scope.decl'!
RUN rustup default 1.51.0

# You can use the following lines to install klee with a compatible rust version on your machine
# Current LLVM version: 11.1.0

RUN git clone https://github.com/klee/klee.git && cd klee && mkdir build && cd build && \
	cmake .. && make -j 12 && sudo make install

RUN git clone https://gitlab.henriktjader.com/pln/cargo-klee.git && cd cargo-klee && cargo install --path cargo-klee
