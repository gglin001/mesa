################################################################################

# https://github.com/gglin001/Dockerfiles/blob/main/mesa/Dockerfile

################################################################################

micromamba install xorg-libx11 xorg-libxext xorg-libxfixes
micromamba install xorg-libxshmfence xorg-libxxf86vm xorg-libxrandr

################################################################################

PKG_CONFIG_PATH=/opt/spirv-tools/lib/pkgconfig:/opt/llvm-spirv/lib/pkgconfig:/opt/libclc/share/pkgconfig:$PKG_CONFIG_PATH \
  CC=/usr/bin/clang CXX=/usr/bin/clang++ \
  meson setup --reconfigure build \
  --buildtype=debug \
  -Dprefix=$PWD/build/install \
  -Dplatforms=wayland,x11 \
  -Dopengl=true \
  -Dgles1=disabled \
  -Dgles2=disabled \
  -Dglx=dri \
  -Degl=disabled \
  -Dllvm=enabled \
  -Dshared-llvm=disabled \
  -Ddraw-use-llvm=true \
  -Dgallium-drivers="llvmpipe" \
  -Dgallium-opencl=icd \
  -Dgallium-rusticl=false \
  -Dopencl-spirv=true \
  -Dvulkan-drivers="swrast" \
  -Dstatic-libclc=all \
  -Dperfetto=false \
  -Dbuild-tests=false \
  -Denable-glcpp-tests=false

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
