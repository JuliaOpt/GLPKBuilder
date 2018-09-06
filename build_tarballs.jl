# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "GLPKBuilder"
version = v"4.64"

# Collection of sources required to build GLPKBuilder
sources = [
    "http://ftpmirror.gnu.org/gnu/glpk/glpk-4.64.tar.gz" =>
    "4281e29b628864dfe48d393a7bedd781e5b475387c20d8b0158f329994721a10",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd glpk-4.64/
cd $WORKSPACE/srcdir
cd glpk-4.64/
export LDFLAGS="-L${prefix}/lib"                         
if [ $target = "x86_64-w64-mingw32" ] || [ $target = "i686-w64-mingw32" ]; then export CPPFLAGS="-I${prefix}/include -D__WOE__=1";   else export CPPFLAGS="-I${prefix}/include"; fi
./configure --prefix=$prefix  --host=${target} --with-gmp
make -j${nproc}
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc, :eabihf),
    Linux(:powerpc64le, :glibc),
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl, :eabihf),
    MacOS(:x86_64),
    Windows(:i686),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libglpk", :libglpk)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/JuliaMath/GMPBuilder/releases/download/v6.1.2-2/build_GMP.v6.1.2.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

