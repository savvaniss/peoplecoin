add_library(qrcodegen)

target_sources(qrcodegen
    PUBLIC
        FILE_SET HEADERS
        BASE_DIRS ${CMAKE_CURRENT_SOURCE_DIR}
        FILES
            ${CMAKE_CURRENT_SOURCE_DIR}/QrCode.hpp
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/QrCode.cpp
    )

target_include_directories(qrcodegen
        PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        PUBLIC $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
        )

monero_install_library(qrcodegen)
