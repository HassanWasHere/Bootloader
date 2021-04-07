# Basic script written to download and build gcc and binutils for i386-elf then install it.

BINUTILS_VERSION=2.24
GCC_VERSION=4.9.1

if [ $# -ne 1 ]; then
    echo "Usage: ./crosscompile-install.sh PREFIX"
    exit
fi
echo $1
if [ ! -d $1 ]; then
    mkdir -p $1
fi

cd $1

# Fetch binutils and gcc
if [ ! -e binutils-$BINUTILS_VERSION.tar.gz ]; then
    curl -O http://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz
fi
if [ ! -e gcc-$GCC_VERSION.tar.gz ]; then
curl -O https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.bz2
fi
tar -xf binutils-$BINUTILS_VERSION.tar.gz
tar -xf gcc-$GCC_VERSION.tar.bz2

mkdir binutils-$BINUTILS_VERSION/build

# Configure and make

cd binutils-$BINUTILS_VERSION/build
../configure --target=i386-elf --enable-interwork --enable-multilib --disable-nls --disable-werror --prefix=$1
make
make install

mkdir ../../gcc-$GCC_VERSION/build
cd ../../gcc-$GCC_VERSION/
./contrib/download_prerequisites
cd build
../configure --target=i386-elf --prefix=$1 --disable-nls --disable-libssp --enable-languages=c --without-headers
make all-gcc 
make all-target-libgcc 
make install-gcc 
make install-target-libgcc 
