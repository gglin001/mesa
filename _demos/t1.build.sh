################################################################################

# https://github.com/gglin001/Dockerfiles/blob/main/mesa/Dockerfile

################################################################################

# pushd _demos
# git clone git@github.com:gglin001/cl_demos.git
# popd
# pushd _demos/cl_demos
# cmake --preset pocl -DWITH_CLINFO=ON -DPOCL_INCLUDE_DIR=/opt/mesa/include -DPOCL_LIB_DIR=/opt/mesa/lib/aarch64-linux-gnu
# cmake --build $PWD/build --target all
# ./build/bin/cl_enumopencl
# ./build/bin/cl_clinfo

################################################################################

PKG_CONFIG_PATH=/opt/spirv-tools/lib/pkgconfig:/opt/llvm-spirv/lib/pkgconfig:/opt/libclc/share/pkgconfig:$PKG_CONFIG_PATH \
  CC=/usr/bin/clang CXX=/usr/bin/clang++ \
  meson setup --reconfigure build \
  --buildtype=release \
  -Dprefix=$PWD/build/install \
  -Dplatforms=wayland \
  -Dopengl=true \
  -Dgles1=disabled \
  -Dgles2=disabled \
  -Dglx=disabled \
  -Degl=disabled \
  -Dllvm=enabled \
  -Ddraw-use-llvm=true \
  -Dgallium-drivers="swrast" \
  -Dgallium-opencl=standalone \
  -Dgallium-rusticl=false \
  -Dopencl-spirv=true \
  -Dvulkan-drivers="swrast" \
  -Dperfetto=false \
  -Dbuild-tests=false \
  -Denable-glcpp-tests=false

meson compile -C build
meson install -C build

################################################################################
