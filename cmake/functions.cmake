include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

function(monero_install_library targetName)
    set(flags)
    set(args)
    set(listArgs INCLUDE_DIR HEADERS)
    cmake_parse_arguments(arg "${flags}" "${args}" "${listArgs}" ${ARGN})

    set(include_dir "${arg_INCLUDE_DIR}")
    set(headers "${arg_HEADERS}")

    if(NOT include_dir)
        set(include_dir "${CMAKE_INSTALL_INCLUDEDIR}/monero/")
    endif()

    if(${targetName} STREQUAL "device")
        message(STATUS "lol")
    endif()

    if(headers AND include_dir)
        install_with_directory(DESTINATION ${include_dir} FILES ${headers})
    endif()

    install(TARGETS ${targetName} EXPORT MoneroTargets
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}/monero/
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/monero/
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}/monero/
        INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/monero/)
endfunction()

function(print_cmake_summary)
    message(STATUS "\n====================================== SUMMARY")
    message(STATUS "Using C security hardening flags: ${C_SECURITY_FLAGS}")
    message(STATUS "Using C++ security hardening flags: ${CXX_SECURITY_FLAGS}")
    message(STATUS "Using linker security hardening flags: ${LD_SECURITY_FLAGS}")

    if(GIT_FOUND)
        execute_process(COMMAND git rev-parse "HEAD" WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/wownero OUTPUT_VARIABLE _WOWNERO_HEAD OUTPUT_STRIP_TRAILING_WHITESPACE)
        if(NOT _WOWNERO_HEAD STREQUAL WOWNERO_HEAD)
            message(STATUS "[+] WOWNERO HEAD: ${_WOWNERO_HEAD} ... while CMake requested ${WOWNERO_HEAD}")
        else()
            message(STATUS "[+] WOWNERO HEAD: ${WOWNERO_HEAD}")
        endif()
    endif()

    message(STATUS "[+] VERSION: ${VERSION}")
    message(STATUS "[+] STATIC: ${STATIC}")
    message(STATUS "[+] ARM: ${ARM}")
    message(STATUS "[+] Android: ${ANDROID}")
    message(STATUS "[+] iOS: ${IOS}")

    message(STATUS "[+] OpenSSL")
    message(STATUS "  - version: ${OPENSSL_VERSION}")
    message(STATUS "  - dirs: ${OPENSSL_INCLUDE_DIR}")
    message(STATUS "  - libs: ${OPENSSL_LIBRARIES}")

    if(CAIRO_FOUND)
        message(STATUS "[+] Cairo")
        message(STATUS "  - version: ${CAIRO_VERSION}")
        message(STATUS "  - dirs: ${CAIRO_INCLUDE_DIRS}")
        message(STATUS "  - libs: ${CAIRO_LIBRARIES}")
    endif()

    if(XFIXES_FOUND)
        message(STATUS "[+] Xfixes")
        message(STATUS "  - dirs: ${XFIXES_INCLUDE_DIR}")
        message(STATUS "  - libs: ${XFIXES_LIBRARY}")
    endif()

    message(STATUS "[+] Boost")
    message(STATUS "  - version: ${Boost_VERSION}")
    message(STATUS "  - dirs: ${Boost_INCLUDE_DIRS}")
    message(STATUS "  - libs: ${Boost_LIBRARIES}")

    if(Iconv_FOUND)
        message(STATUS "[+] Iconv")
        message(STATUS "  - version: ${Iconv_VERSION}")
        message(STATUS "  - libs: ${Iconv_LIBRARIES}")
        message(STATUS "  - dirs: ${Iconv_INCLUDE_DIRS}")
    endif()

endfunction()

macro(install_with_directory)
    set(optionsArgs "")
    set(oneValueArgs "DESTINATION")
    set(multiValueArgs "FILES")
    cmake_parse_arguments(CAS "${optionsArgs}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

    foreach(FILE ${CAS_FILES})
        get_filename_component(DIR ${FILE} DIRECTORY)
        INSTALL(FILES ${FILE} DESTINATION ${CAS_DESTINATION}/${DIR})
    endforeach()
endmacro(install_with_directory)