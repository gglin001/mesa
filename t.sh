docker run -d -it \
  --name mesa_dev_0 \
  -v ssh:/root/.ssh \
  -v repos:/repos \
  -w /repos \
  base:latest

################################################################################

# TODO: check
# .gitlab-ci/container/debian/arm64_build.sh

micromamba install -y meson mako
micromamba install -y glslang spirv-tools
micromamba install -y llvm-tools llvmdev
micromamba install -y clangdev
micromamba install -y bison

# meson cannot find spirv-tools from conda
apt install -y spirv-tools

apt install -y lua5.4 liblua5.4-dev
apt install -y libarchive-dev
apt install -y libelf-dev

apt install -y libclc-dev
apt install -y libdrm-dev
# apt install -y libvulkan-dev
apt install -y \
  libx11-dev \
  libx11-xcb-dev \
  libxcb-dri2-0-dev \
  libxcb-dri3-dev \
  libxcb-glx0-dev \
  libxcb-present-dev \
  libxcb-randr0-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  libxdamage-dev \
  libxext-dev \
  libxrandr-dev \
  libxshmfence-dev \
  libxtensor-dev \
  libxxf86vm-dev

# install `llvm-spirv` manully
# llvm-spirv in conda version dismatch
mkdir -p demos
git clone https://github.com/KhronosGroup/SPIRV-LLVM-Translator.git demos
pushd demos/SPIRV-LLVM-Translator
git checkout -b v17.0.0 v17.0.0
cmake -G Ninja -S$PWD -B$PWD/build
# default prefix is `/usr/local/`, pkgconfig will find it, if you install it to other folder, need setup env `PKG_CONFIG_PATH`
cmake --build $PWD/build --target install
popd

################################################################################

meson setup --reconfigure build \
  -Dprefix=$PWD/build/install \
  -Dplatforms=x11 \
  -Dgallium-drivers=swrast \
  -Dgallium-opencl=standalone \
  -Dopencl-spirv=true \
  -Dvulkan-drivers=swrast \
  -Dgles1=false \
  -Dgles2=false \
  -Dopengl=false \
  -Dllvm=enabled \
  -Dbuild-tests=true \
  2>&1 | tee demos/meson.setup.log

# TODO: enable `gallium-rusticl`

# meson configure --clearcache build
meson compile -C build
meson install -C build

################################################################################

# debug
meson --help
