#!/bin/bash

NDK=/Users/mapletang/Library/Android/ndk/android-ndk-r10e
SYSROOT=$NDK/platforms/android-9/arch-arm/
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64

function build_one
{
./configure \
    --prefix=$PREFIX \
    --enable-static \
    --disable-shared \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-ffserver \
    --disable-avdevice \
    --disable-doc \
    --disable-symver \
    --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
    --target-os=linux \
    --arch=arm \
    --enable-cross-compile \
    --enable-runtime-cpudetect \
    --disable-asm \
    --disable-stripping \
    # --cc=$TOOLCHAIN/bin/arm-linux-androideabi-gcc \
    # --nm=$TOOLCHAIN/bin/arm-linux-androideabi-nm \
    --enable-version3 \
    --enable-small \
    --disable-vda \
    --disable-iconv \
    --disable-encoders \
    --disable-decoders \
    --enable-decoder=aac \
    --enable-decoder=aac_latm \
    --enable-decoder=h264 \
    --disable-muxers \
    --disable-demuxers \
    --enable-demuxer=h264 \
    --disable-parsers \
    --enable-parser=aac \
    --enable-parser=ac3 \
    --enable-parser=h264 \
    --disable-protocols \
    --enable-protocol=file \
    --enable-protocol=rtmp \
    --disable-bsfs \
    --enable-bsf=aac_adtstoasc \
    --enable-bsf=h264_mp4toannexb \
    --disable-indevs \
    --enable-zlib \
    --disable-outdevs \
    --disable-debug \
    --sysroot=$SYSROOT \
    --extra-cflags="-Os -fpic $ADDI_CFLAGS" \
    --extra-ldflags="$ADDI_LDFLAGS" \
    $ADDITIONAL_CONFIGURE_FLAG
make clean
make -j8
make install

$TOOLCHAIN/bin/arm-linux-androideabi-ld -rpath-link=$SYSROOT/usr/lib -L$SYSROOT/usr/lib -L$PREFIX/lib -soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so \
    libavcodec/libavcodec.a \
    libavfilter/libavfilter.a \
    libswresample/libswresample.a \
    libavformat/libavformat.a \
    libavutil/libavutil.a \
    libswscale/libswscale.a \
    -lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker $TOOLCHAIN/lib/gcc/arm-linux-androideabi/4.9/libgcc.a  
}
CPU=arm
PREFIX=$(pwd)/android/$CPU 
ADDI_CFLAGS="-marm"
build_one