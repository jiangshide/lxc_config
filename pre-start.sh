#!/bin/bash

ANDROID_COMPATIBLE_ENV=/opt/compatible/android/

mount_tmp(){
        if [ -n "$1" ] && [ -n "$2" ]; then
                if [ ! -d  $1 ];then
                        mkdir -p $1
                fi

                if  mountpoint -q $1 ; then
                        :
                else
                        mount -t tmpfs -o size=$2 tmpfs $1
                fi
        fi
}

# TODO: 暂时没有好的解决方法
while [ ! -S "/run/user/1000/wayland-1" ]
do
        echo "wayland sock not exist"
        sleep 1
done

# TODO: 主要用于解决开机 kwin 黑屏的问题，需要找一个好的启动点，等待 5 秒会
# 影响解锁过程
sleep 5

if [ ! -d ${ANDROID_COMPATIBLE_ENV}/system ]; then
        mkdir ${ANDROID_COMPATIBLE_ENV}/system
fi

if [ ! -d ${ANDROID_COMPATIBLE_ENV}/vendor ]; then
        mkdir ${ANDROID_COMPATIBLE_ENV}/vendor
fi

mount ${ANDROID_COMPATIBLE_ENV}/images/system-rebuild.img ${ANDROID_COMPATIBLE_ENV}/system
mount ${ANDROID_COMPATIBLE_ENV}/images/vendor-rebuild.img ${ANDROID_COMPATIBLE_ENV}/vendor

# TODO: 1000 能否不写死
mount --bind /run/user/1000 ${ANDROID_COMPATIBLE_ENV}/system/wayland/
mount --bind /dev ${ANDROID_COMPATIBLE_ENV}/system/dev

if [ ! -d ${ANDROID_COMPATIBLE_ENV}/data-compat ]; then
	mkdir -p ${ANDROID_COMPATIBLE_ENV}/data-compat
fi

if [ ! -d ${ANDROID_COMPATIBLE_ENV}/cache-compat ]; then
	mkdir -p ${ANDROID_COMPATIBLE_ENV}/cache-compat
fi

if [ ! -d ${ANDROID_COMPATIBLE_ENV}/system ]; then
	mkdir -p ${ANDROID_COMPATIBLE_ENV}/system
fi

if [ ! -d ${ANDROID_COMPATIBLE_ENV}/vendor ]; then
	mkdir -p ${ANDROID_COMPATIBLE_ENV}/vendor
fi

mount_tmp /${ANDROID_COMPATIBLE_ENV}/lxc-mount-compat 100m
if [ ! -d  /${ANDROID_COMPATIBLE_ENV}/lxc-mount-compat/dev ];then
        mkdir -p /${ANDROID_COMPATIBLE_ENV}/lxc-mount-compat/dev
fi

# 挂载 HOST 分区
mkdir ${ANDROID_COMPATIBLE_ENV}/system/host_system
mkdir ${ANDROID_COMPATIBLE_ENV}/system/host_vendor

mount --bind /system ${ANDROID_COMPATIBLE_ENV}/system/host_system
mount --bind /vendor ${ANDROID_COMPATIBLE_ENV}/system/host_vendor

rm -rf ${ANDROID_COMPATIBLE_ENV}/vendor/lib/egl
cp ${ANDROID_COMPATIBLE_ENV}/system/host_vendor/lib/egl ${ANDROID_COMPATIBLE_ENV}/vendor/lib/ -arf

rm -rf ${ANDROID_COMPATIBLE_ENV}/vendor/lib64/egl
cp ${ANDROID_COMPATIBLE_ENV}/system/host_vendor/lib64/egl ${ANDROID_COMPATIBLE_ENV}/vendor/lib64/ -arf

cd ${ANDROID_COMPATIBLE_ENV}/vendor/lib64/hw/
rm -f camera.default.so
ln -s camera.ranchu.so camera.default.so

rm -f gatekeeper.default.so
ln -s gatekeeper.ranchu.so gatekeeper.default.so

rm -f gps.default.so
ln -s gps.ranchu.so gps.default.so

rm -f gralloc.default.so
cp ${ANDROID_COMPATIBLE_ENV}/system/host_vendor/lib64/hw/gralloc.ud710.so .
ln -s gralloc.ud710.so gralloc.default.so

rm -f hwcomposer.default.so
ln -s hwcomposer.ranchu.so hwcomposer.default.so

rm -f sensors.default.so
ln -s sensors.ranchu.so sensors.default.so

cd ${ANDROID_COMPATIBLE_ENV}/vendor/lib/hw
rm -f gralloc.default.so
cp ${ANDROID_COMPATIBLE_ENV}/system/host_vendor/lib/hw/gralloc.ud710.so .
ln -s gralloc.ud710.so gralloc.default.so

rm -f camera.default.so
ln -s camera.ranchu.so camera.default.so

cd ${ANDROID_COMPATIBLE_ENV}

cp ${ANDROID_COMPATIBLE_ENV}/system/host_vendor/lib64/android.hardware.audio.common* ${ANDROID_COMPATIBLE_ENV}/vendor/lib64
cp ${ANDROID_COMPATIBLE_ENV}/system/host_vendor/lib64/libdrm.so ${ANDROID_COMPATIBLE_ENV}/vendor/lib64
cp ${ANDROID_COMPATIBLE_ENV}/system/host_vendor/lib64/libglslcompiler.so ${ANDROID_COMPATIBLE_ENV}/vendor/lib64
cp ${ANDROID_COMPATIBLE_ENV}/system/host_vendor/lib64/libIMGegl.so ${ANDROID_COMPATIBLE_ENV}/vendor/lib64
cp ${ANDROID_COMPATIBLE_ENV}/system/host_vendor/lib64/libsrv_um.so ${ANDROID_COMPATIBLE_ENV}/vendor/lib64
cp ${ANDROID_COMPATIBLE_ENV}/system/host_vendor/lib64/libusc.so ${ANDROID_COMPATIBLE_ENV}/vendor/lib64

cp ${ANDROID_COMPATIBLE_ENV}/system/host_vendor/lib/android.hardware.audio.common* ${ANDROID_COMPATIBLE_ENV}/vendor/lib
cp ${ANDROID_COMPATIBLE_ENV}/system/host_vendor/lib/libdrm.so ${ANDROID_COMPATIBLE_ENV}/vendor/lib
cp ${ANDROID_COMPATIBLE_ENV}/system/host_vendor/lib/libglslcompiler.so ${ANDROID_COMPATIBLE_ENV}/vendor/lib
cp ${ANDROID_COMPATIBLE_ENV}/system/host_vendor/lib/libIMGegl.so ${ANDROID_COMPATIBLE_ENV}/vendor/lib
cp ${ANDROID_COMPATIBLE_ENV}/system/host_vendor/lib/libsrv_um.so ${ANDROID_COMPATIBLE_ENV}/vendor/lib
cp ${ANDROID_COMPATIBLE_ENV}/system/host_vendor/lib/libusc.so ${ANDROID_COMPATIBLE_ENV}/vendor/lib

