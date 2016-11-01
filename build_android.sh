#!/bin/bash
NDK=/Users/mapletang/Library/Android/ndk/android-ndk-r10e
# Use ANDROID_NDK enviroment variable, r10e is recommended.
SYSROOT=$NDK/platforms/android-9/arch-arm/
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64

function build_one
{
    ./configure \
        --prefix=$PREFIX \
        --enable-static \
        --disable-shared \
        --disable-doc \
        --disable-htmlpages \
        --disable-manpages \
        --disable-podpages \
        --disable-txtpages \
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
        --disable-runtime-cpudetect \
        --disable-stripping \
        --enable-small \
        --disable-vda \
        --disable-iconv \
        --disable-encoders \
        --disable-decoders \
        --enable-decoder=aac \
        --enable-decoder=aac_latm \
        --enable-decoder=h264 \
        --disable-hwaccels \
        --disable-muxers \
        --disable-demuxers \
        --enable-demuxer=h264 \
        --enable-demuxer=m4v \
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
        --disable-programs \
        --disable-postproc \
        --disable-avfilter \
        --disable-filters \
        --sysroot=$SYSROOT \
        --extra-cflags="-Os -fpic $ADDI_CFLAGS" \
        --extra-ldflags="$ADDI_LDFLAGS" \
        $ADDITIONAL_CONFIGURE_FLAG

    make clean
    make -j8
    make install

    $TOOLCHAIN/bin/arm-linux-androideabi-ld -rpath-link=$SYSROOT/usr/lib -L$SYSROOT/usr/lib -L$PREFIX/lib -soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so \
        libavcodec/libavcodec.a \
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