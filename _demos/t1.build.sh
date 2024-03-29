# pushd _demos
# wget https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.2/libclc-18.1.2.src.tar.xz
# tar xf libclc-18.1.2.src.tar.xz
# popd
# pushd _demos/libclc-18.1.2.src
# cmake \
#   -DCMAKE_INSTALL_PREFIX=$PWD/build/install \
# 	-DCMAKE_BUILD_TYPE=Release \
# 	-DCMAKE_MODULE_PATH=$CONDA_PREFIX/lib/cmake/llvm:/opt/spirv-tools/lib/cmake/SPIRV-Tools \
#   -DLLVM_SPIRV=/opt/llvm-spirv/bin/llvm-spirv \
#   -DLIBCLC_TARGETS_TO_BUILD="clspv-- clspv64-- spirv-mesa3d- spirv64-mesa3d-" \
#   -S$PWD -B$PWD/build -GNinja
# cmake --build $PWD/build --target install

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
  -Dprefix=/opt/mesa \
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
  -Dopencl-spirv=false \
  -Dvulkan-drivers="swrast" \
  -Dperfetto=false \
  -Dbuild-tests=false \
  -Denable-glcpp-tests=false

meson compile -C build
meson install -C build

################################################################################

