#!/bin/sh

rm -rf /vendor/lib/egl
cp /host_vendor/lib/egl /vendor/lib/ -arf

rm -rf /vendor/lib64/egl
cp /host_vendor/lib64/egl /vendor/lib64/ -arf

cd /vendor/lib64/hw/
rm -f camera.default.so
ln -s camera.ranchu.so camera.default.so

rm -f gatekeeper.default.so
ln -s gatekeeper.ranchu.so gatekeeper.default.so

rm -f gps.default.so
ln -s gps.ranchu.so gps.default.so

rm -f gralloc.default.so
ln -s /host_vendor/lib64/hw/gralloc.ud710.so gralloc.default.so

rm -f hwcomposer.default.so
ln -s hwcomposer.ranchu.so hwcomposer.default.so

rm -f sensors.default.so
ln -s sensors.ranchu.so sensors.default.so

cd /vendor/lib/hw
rm -f gralloc.default.so
ln -s /host_vendor/lib/hw/gralloc.ud710.so gralloc.default.so

cd /

cp /host_vendor/lib64/android.hardware.audio.common* /vendor/lib64
cp /host_vendor/lib64/libdrm.so /vendor/lib64
cp /host_vendor/lib64/libglslcompiler.so /vendor/lib64
cp /host_vendor/lib64/libIMGegl.so /vendor/lib64
cp /host_vendor/lib64/libsrv_um.so /vendor/lib64
cp /host_vendor/lib64/libusc.so /vendor/lib64

cp /host_vendor/lib/android.hardware.audio.common* /vendor/lib
cp /host_vendor/lib/libdrm.so /vendor/lib
cp /host_vendor/lib/libglslcompiler.so /vendor/lib
cp /host_vendor/lib/libIMGegl.so /vendor/lib
cp /host_vendor/lib/libsrv_um.so /vendor/lib
cp /host_vendor/lib/libusc.so /vendor/lib
