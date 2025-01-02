################################################################################

# https://github.com/gglin001/Dockerfiles/blob/main/mesa/Dockerfile

################################################################################

micromamba install xorg-libx11 xorg-libxext xorg-libxfixes
micromamba install xorg-libxshmfence xorg-libxxf86vm xorg-libxrandr

################################################################################

args=(
  --buildtype=debug
  -Dprefix=$PWD/build/install
  -Dplatforms=wayland,x11
  -Dopengl=true
  -Dgles1=disabled
  -Dgles2=disabled
  -Dglx=dri
  -Degl=disabled
  -Dllvm=enabled
  -Dshared-llvm=disabled
  -Ddraw-use-llvm=true
  -Dgallium-drivers="llvmpipe"
  -Dgallium-opencl=icd
  -Dgallium-rusticl=false
  # -Dgallium-rusticl=true
  -Drust_std=2021
  -Dopencl-spirv=true
  -Dvulkan-drivers="swrast"
  -Dstatic-libclc=all
  -Dperfetto=false
  -Dbuild-tests=false
  -Denable-glcpp-tests=false
)
PKG_CONFIG_PATH=/opt/spirv-tools/lib/pkgconfig:$PKG_CONFIG_PATH \
  PKG_CONFIG_PATH=/opt/llvm-spirv/lib/pkgconfig:$PKG_CONFIG_PATH \
  PKG_CONFIG_PATH=/opt/libclc/share/pkgconfig:$PKG_CONFIG_PATH \
  CC=/usr/bin/clang CXX=/usr/bin/clang++ \
  RUSTC=clippy-driver \
  meson setup --reconfigure build "${args[@]}"

meson compile -C build
meson install -C build

################################################################################

git clone git@github.com:gglin001/cl_demos.git
pushd cl_demos
cmake --preset sdk
cmake --build build --target all
popd

export OCL_ICD_FILENAMES=$PWD/build/install/lib/aarch64-linux-gnu/libMesaOpenCL.so

cl_demos/build/bin/cl_enumopencl
cl_demos/build/bin/cl_simple
cl_demos/build/bin/cl_absf

################################################################################

# log:

# (pyenv) root@7a5c74b67293:.../mesa# cl_demos/build/bin/cl_enumopencl
# Enumerated 1 platforms.

# Platform[0]:
#         Name:           Clover
#         Vendor:         Mesa
#         Driver Version: OpenCL 1.1 Mesa 24.3.2 (git-de0dc35519)
# Device[0]:
#         Type:           CPU
#         Name:           llvmpipe (LLVM 19.1.0, 128 bits)
#         Vendor:         Mesa
#         Device Version: OpenCL 1.1 Mesa 24.3.2 (git-de0dc35519)
#         Device Profile: FULL_PROFILE
#         Driver Version: 24.3.2

# Done.

################################################################################
