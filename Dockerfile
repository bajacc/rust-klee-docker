FROM archlinux

RUN pacman -Syu --noconfirm

RUN pacman -Sy --noconfirm \
	git \
	vim \
	gcc \
	cmake \
	clang \
	gdb \
	z3 \
	make \
	llvm \
	gperftools \
	sudo \
	rustup


ARG USERNAME=arch
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
ENV USER_HOME=/home/${USERNAME}

RUN groupadd --gid=${USER_GID} ${USERNAME} && \
	useradd --shell=/bin/bash --uid=${USER_UID} --gid=${USER_GID} --create-home ${USERNAME} && \
	echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USERNAME}
WORKDIR ${USER_HOME}

RUN git clone https://github.com/klee/klee.git && cd klee && mkdir build && cd build && \
	cmake .. && make -j 12 && sudo make install

# with version 1.52.0 (current): when using klee target/debug/examples/get_sign*.ll
# LLVM ERROR: Cannot lower a call to a non-intrinsic function 'llvm.experimental.noalias.scope.decl'!
RUN rustup default 1.51.0

RUN git clone https://gitlab.henriktjader.com/pln/cargo-klee.git && cd cargo-klee && cargo install --path cargo-klee
