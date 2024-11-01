cmake_minimum_required(VERSION 3.15)

project(Rtl8812auNet)

# the `pkg_check_modules` function is created with this call
find_package(PkgConfig REQUIRED)

# this calls create special `PkgConfig::LIBUSB` variables
pkg_check_modules(LIBUSB REQUIRED IMPORTED_TARGET libusb-1.0)
pkg_check_modules(LIBPCAP REQUIRED IMPORTED_TARGET libpcap)
pkg_check_modules(LIBSODIUM REQUIRED IMPORTED_TARGET libsodium)

find_package(spdlog CONFIG REQUIRED)

add_library(wfb-ng STATIC
        ${CMAKE_SOURCE_DIR}/wfb-ng/src/fec.c
        ${CMAKE_SOURCE_DIR}/wfb-ng/src/fec.h
        ${CMAKE_SOURCE_DIR}/wfb-ng/src/ieee80211_radiotap.h
        ${CMAKE_SOURCE_DIR}/wfb-ng/src/radiotap.c
        ${CMAKE_SOURCE_DIR}/wfb-ng/src/wifibroadcast.hpp
        ${CMAKE_SOURCE_DIR}/wfb-ng/src/wifibroadcast.cpp)
set_target_properties(wfb-ng PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_SOURCE_DIR}/wfb-ng)
target_include_directories(wfb-ng PUBLIC ${CMAKE_SOURCE_DIR}/wfb-ng)
target_compile_definitions(wfb-ng PRIVATE __WFB_RX_SHARED_LIBRARY__)

add_library(DualDevourer STATIC
        ${CMAKE_SOURCE_DIR}/DualDevourer/hal/Hal8812PhyReg.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/hal/Hal8812PwrSeq.c
        ${CMAKE_SOURCE_DIR}/DualDevourer/hal/Hal8812PwrSeq.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/hal/basic_types.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/hal/hal8812a_fw.c
        ${CMAKE_SOURCE_DIR}/DualDevourer/hal/hal8812a_fw.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/hal/hal_com_reg.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/hal/rtl8812a_hal.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/hal/rtl8812a_recv.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/hal/rtl8812a_spec.h

        ${CMAKE_SOURCE_DIR}/DualDevourer/src/EepromManager.cpp
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/EepromManager.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/Firmware.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/FirmwareManager.cpp
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/FirmwareManager.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/FrameParser.cpp
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/FrameParser.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/HalModule.cpp
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/HalModule.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/ParsedRadioPacket.cpp
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/RadioManagementModule.cpp
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/RadioManagementModule.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/Rtl8812aDevice.cpp
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/Rtl8812aDevice.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/RtlUsbAdapter.cpp
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/RtlUsbAdapter.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/SelectedChannel.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/WiFiDriver.cpp
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/WiFiDriver.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/registry_priv.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/ieee80211_radiotap.h
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/Radiotap.c
        ${CMAKE_SOURCE_DIR}/DualDevourer/src/logger.h)
set_target_properties(DualDevourer PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_SOURCE_DIR}/DualDevourer)
target_include_directories(DualDevourer PUBLIC ${CMAKE_SOURCE_DIR}/DualDevourer/src)
target_include_directories(DualDevourer PUBLIC ${CMAKE_SOURCE_DIR}/DualDevourer/hal)
target_link_libraries(DualDevourer PRIVATE spdlog::spdlog_header_only)
set_property(TARGET DualDevourer PROPERTY CXX_STANDARD 20)

add_executable(wfb_tx
    src/tx.cpp
    )

target_link_libraries(wfb_tx PRIVATE
    DualDevourer
    wfb-ng
    PkgConfig::LIBUSB
    PkgConfig::LIBPCAP
    PkgConfig::LIBSODIUM
    # use the header-only version
    spdlog::spdlog_header_only
)

set_property(TARGET wfb_tx PROPERTY CXX_STANDARD 20)
#target_include_directories(wfb_tx PRIVATE 
#    ${CMAKE_SOURCE_DIR}/../wfb-ng/src/
#    ${CMAKE_SOURCE_DIR}/../DualDevourer/src/
#    ${CMAKE_SOURCE_DIR}/../DualDevourer/hal/
#)

target_compile_options(wfb_tx PRIVATE)
target_link_options(wfb_tx PRIVATE)
