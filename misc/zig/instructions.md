# Zig

## Nightly builds

* auto-download (if necessary) and link latest nightly: `cd nightly && ./update_zig.sh`
* manually clean up old versions
* link: `ln -s $PWD/nightly/latest/zig $HOME/.local/bin/`

## Build from source

* [repo](https://github.com/ziglang/zig)
* [instructions](https://github.com/ziglang/zig/wiki/Building-Zig-From-Source)
* build:
    ```sh
    cd zig
    mkdir build
    cd build
    cmake -DCMAKE_BUILD_TYPE=Release ..
    make install
    ```
* link: `ln -s $PWD/zig/build/zig/zig/build/stage3/bin/zig $HOME/.local/bin/`


# ZLS

## Build from source

* [repo](https://github.com/zigtools/zls)
* build: `zig build -Doptimize=ReleaseSafe`
* link: `ln -s $PWD/zls/zig-out/bin/zls $HOME/.local/bin/`
