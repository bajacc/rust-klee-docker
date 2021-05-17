
![Alt text](logo.png)

# RUST-KLEE docker

## Install

build:

```bash
docker build -t rkd .
```

run:

```bash
docker run --rm -it rkd
```

## How to use 

you can test klee with `klee-example`:

Go to `klee-example`:

```bash
cd cargo-klee/klee-examples
```

Compile to `llvm-ir` (you can also compile to `llvm-bc`)

```bash
cargo rustc -v --features klee-analysis --example get_sign --color=always -- -C linker=true -C lto --emit=llvm-ir
```

Run klee on the `.ll` file

```bash
klee target/debug/examples/get_sign*.ll
```

output:
```bash
KLEE: output directory is "/home/arch/klee-example/target/debug/examples/klee-out-0"
KLEE: Using Z3 solver backend

KLEE: done: total instructions = 89
KLEE: done: completed paths = 3
KLEE: done: partially completed paths = 0
KLEE: done: generated tests = 3
```

alternatively you can use:
```bash
cargo klee --example get_sign
```

## future work

Find a way to insert this docker in the general workflow of `doge-home`


