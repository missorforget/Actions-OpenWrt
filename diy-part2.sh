#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate


mkdir Modem-Support
pushd Modem-Support
git clone --depth=1 https://github.com/Siriling/5G-Modem-Support .
rm -rf ../package/wwan/driver/quectel_QMI_WWAN
rm -rf ../package/wwan/app/quectel_cm_5G
rm -rf ../package/wwan/driver/quectel_MHI
cp -rf quectel_QMI_WWAN ../package/wwan/driver/
cp -rf quectel_cm_5G ../package/wwan/app/
cp -rf quectel_MHI ../package/wwan/driver/
popd

mkdir MyConfig
pushd MyConfig
git clone --depth=1 https://github.com/Siriling/OpenWRT-MyConfig .
popd

mkdir package/community
pushd package/community

# 5G通信模组拨号工具
# mkdir quectel_QMI_WWAN
# mkdir quectel_cm_5G
# mkdir quectel_MHI
# mkdir luci-app-hypermodem
# cp -rf ../../Modem-Support/luci-app-hypermodem/* luci-app-hypermodem

# 5G模组短信插件
mkdir sms-tool
mkdir luci-app-sms-tool
cp -rf ../../Modem-Support/sms-tool/* sms-tool
cp -rf ../../Modem-Support/luci-app-sms-tool/* luci-app-sms-tool
cp -rf ../../MyConfig/configs/lede/general/applications/luci-app-sms-tool/* luci-app-sms-tool

# 5G模组信息插件+AT工具
mkdir luci-app-modem
cp -rf ../../Modem-Support/luci-app-modem/* luci-app-modem

popd

#5G相关
echo "
# 5G模组信号插件
# CONFIG_PACKAGE_ext-rooter-basic=y

# 5G模组短信插件
CONFIG_PACKAGE_luci-app-sms-tool=y

# 5G模组信息插件
# CONFIG_PACKAGE_luci-app-3ginfo-lite=y
# CONFIG_PACKAGE_luci-app-3ginfo=y

# 5G模组信息插件+AT工具
# CONFIG_PACKAGE_luci-app-cpe=y
# CONFIG_PACKAGE_sendat=y
CONFIG_PACKAGE_luci-app-modem=y

# QMI拨号工具（移远，广和通）
# CONFIG_PACKAGE_quectel-CM-5G=y
# CONFIG_PACKAGE_fibocom-dial=y

# QMI拨号软件
# CONFIG_PACKAGE_kmod-qmi_wwan_f=y
# CONFIG_PACKAGE_luci-app-hypermodem=y

# Gobinet拨号软件
# CONFIG_PACKAGE_kmod-gobinet=y
# CONFIG_PACKAGE_luci-app-gobinetmodem=y

# 串口调试工具
CONFIG_PACKAGE_minicom=y

# 脚本拨号工具依赖
# CONFIG_PACKAGE_grep=y
# CONFIG_PACKAGE_procps-ng=y
#　CONFIG_PACKAGE_procps-ng-ps=y

" >> .config
