﻿CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

SET(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS TRUE)

PROJECT(CM2012)

IF(CYGWIN)
	MESSAGE("use Cygwin")

	set(CMAKE_LEGACY_CYGWIN_WIN32 0) # Remove when CMake >= 2.8.4 is required
ENDIF(CYGWIN)

OPTION(BUILD_BASE_LIB 			"Build Base Library"						TRUE	)
OPTION(BUILD_OPENGL_LIB			"Build OpenGL Library"						FALSE	)
OPTION(BUILD_OPENAL_LIB			"Build OpenAL Library"						FALSE	)
OPTION(BUILD_NETWORK_LIB		"Build Network Library"						TRUE	)
OPTION(BUILD_NETWORK_SCTP		"Include SCTP Support"						FALSE	)
OPTION(BUILD_QT4_SUPPORT_LIB	"Build QT4 Support Library"					FALSE	)
OPTION(BUILD_EXAMPLES_PROJECT	"Build Examples Project"					FALSE	)
OPTION(BUILD_TEST_PROJECT		"Build Test Project"						FALSE	)

OPTION(BUILD_GUI_TOOLS			"Build GUI Tools"							FALSE	)

IF(WIN32)
	OPTION(USE_64_BIT	"Build 64bit Library" FALSE)
ELSE(WIN32)
	IF(APPLE)
		SET(USE_LLVM_CLANG			TRUE	)
	ELSE(APPLE)
		IF(${CMAKE_SYSTEM_NAME} MATCHES ".*FreeBSD.*")
			SET(USE_LLVM_CLANG			TRUE	)
		ELSE()
			OPTION(USE_LLVM_CLANG			"Use LLVM Clang Compiler"	FALSE	)
		ENDIF()
	ENDIF(APPLE)

	OPTION(USE_CPP14				"Use C++ 14"							FALSE	)
	OPTION(USE_CPP11				"Use C++ 11"							TRUE	)
	OPTION(USE_ICE_CREAM			"Use IceCream"							TRUE	)

	OPTION(USE_GPERF_TOOLS			"Use Google Performance Tools"			FALSE	)
ENDIF(WIN32)

IF(USE_LLVM_CLANG)
OPTION(USE_LLVM_CLANG_STATIC_ANALYZER	"the static analyzer"				OFF		)
ENDIF(USE_LLVM_CLANG)

OPTION(LOG_INFO					"Output Log info"							TRUE	)
OPTION(LOG_INFO_THREAD			"Output Log info include ThreadPID"			TRUE	)
OPTION(LOG_INFO_TIME			"Output Log info include time"				TRUE	)
OPTION(LOG_INFO_SOURCE			"Output Log info include source and line"	OFF		)
OPTION(LOG_FILE_ONLY_ERROR 		"Only log error to file"					TRUE	)
OPTION(LOG_THREAD_MUTEX			"Log Thread Mutex"							FALSE	)
OPTION(LOG_CDB_LOADER_LOG		"Output CDBLoader log"						FALSE	)

IF(MSVC AND USE_64_BIT)
	OPTION(BUILD_INTEL64		"Optimize for Intel 64"						FALSE	)
	OPTION(BUILD_AMD64			"Optimize for AMD 64"						FALSE	)
ENDIF()

IF(BUILD_OPENGL_LIB)
	OPTION(OPENGL_PROFILE_CORE		"Use OpenGL Core")
	OPTION(OPENGL_PROFILE_ES1		"Use OpenGL ES1")
	OPTION(OPENGL_PROFILE_ES2		"Use OpenGL ES2")
	OPTION(OPENGL_PROFILE_ES3		"Use OpenGL ES3")

	IF(OPENGL_PROFILE_CORE)
		ADD_DEFINITIONS("-DGLFW_INCLUDE_GLCOREARB")
	ENDIF(OPENGL_PROFILE_CORE)

	IF(OPENGL_PROFILE_ES1)
		ADD_DEFINITIONS("-DGLFW_INCLUDE_ES1")
	ENDIF(OPENGL_PROFILE_ES1)

	IF(OPENGL_PROFILE_ES2)
		ADD_DEFINITIONS("-DGLFW_INCLUDE_ES2")
	ENDIF(OPENGL_PROFILE_ES2)

	IF(OPENGL_PROFILE_ES3)
		ADD_DEFINITIONS("-DGLFW_INCLUDE_ES3")
	ENDIF(OPENGL_PROFILE_ES3)
ENDIF(BUILD_OPENGL_LIB)

OPTION(USE_APR_MEMCACHE			"Use Apache Memcache"						FALSE	)

IF(USE_APR_MEMCACHE)
	ADD_DEFINITIONS(-DUSE_APR_MEMCACHE)
ENDIF(USE_APR_MEMCACHE)

IF(WIN32)
	IF(USE_64_BIT)
		SET(HGL_BITS 64)
		SET(WIN_3RD_ARCH "x64")
	ELSE(USE_64_BIT)
		SET(HGL_BITS 32)
		SET(WIN_3RD_ARCH "Win32")
	ENDIF(USE_64_BIT)
ELSE(WIN32)
	if(CMAKE_SIZEOF_VOID_P EQUAL 8)
		MESSAGE("Target OS bits is 64")
		SET(HGL_BITS	64)
	endif(CMAKE_SIZEOF_VOID_P EQUAL 8)

	if(CMAKE_SIZEOF_VOID_P EQUAL 4)
		MESSAGE("Target OS bits is 32")
		SET(HGL_BITS	32)
	endif(CMAKE_SIZEOF_VOID_P EQUAL 4)
ENDIF(WIN32)

ADD_DEFINITIONS("-DUNICODE -D_UNICODE")

IF(LOG_INFO)
	MESSAGE("Output LogInfo")
ELSE(LOG_INFO)
	add_definitions("-DNO_LOGINFO")
	MESSAGE("Don't output LogInfo")
ENDIF(LOG_INFO)

IF(LOG_INFO_THREAD)
	add_definitions("-DLOG_INFO_THREAD")
ENDIF(LOG_INFO_THREAD)

IF(LOG_INFO_TIME)
	add_definitions("-DLOG_INFO_TIME")
ENDIF(LOG_INFO_TIME)

IF(LOG_INFO_SOURCE)
	add_definitions("-DLOG_INFO_SOURCE")
ENDIF(LOG_INFO_SOURCE)

IF(LOG_THREAD_MUTEX)
	add_definitions("-DLOGINFO_THREAD_MUTEX")
	MESSAGE("LogInfo use ThreadMutex")
ELSE(LOG_THREAD_MUTEX)
	MESSAGE("LogInfo don't use ThreadMutex")
ENDIF(LOG_THREAD_MUTEX)

if(LOG_FILE_ONLY_ERROR)
	add_definitions("-DONLY_LOG_FILE_ERROR")
	MESSAGE("File Log only record ERROR")
else(LOG_FILE_ONLY_ERROR)
	MESSAGE("File Log record all.")
endif(LOG_FILE_ONLY_ERROR)

if(LOG_CDB_LOADER_LOG)
	add_definitions("-DLOG_CDB_LOADER_LOG")
endif(LOG_CDB_LOADER_LOG)

IF(USE_LLVM_CLANG_STATIC_ANALYZER)
	add_definitions("--analyze")
ENDIF(USE_LLVM_CLANG_STATIC_ANALYZER)

SET(HGL_PLATFORM_STRING	${CMAKE_SYSTEM_NAME}_${CMAKE_SYSTEM_PROCESSOR}_${CMAKE_BUILD_TYPE})

SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMGDK_PATH}/bin/${HGL_PLATFORM_STRING})
SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMGDK_PATH}/lib/${HGL_PLATFORM_STRING})
SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMGDK_PATH}/plug-in/${HGL_PLATFORM_STRING})

link_directories(${CMAKE_LIBRARY_OUTPUT_DIRECTORY})

IF(UNIX)
SET(LIB_3RD_FIND_HINT	/usr/lib${HGL_BITS}
						/usr/local/lib${HGL_BITS}
						/usr/lib
						/usr/local/lib
						/usr/lib/${CMAKE_SYSTEM_PROCESSOR}-linux-gnu)

MESSAGE("UNIX LIB 3RD FIND HINT:" ${LIB_3RD_FIND_HINT})
ENDIF(UNIX)

IF(WIN32)
SET(INC_3RD_FIND_HINT ${CMGDK_PATH}/3rdpty/inc)
SET(LIB_3RD_FIND_HINT ${CMGDK_PATH}/3rdpty/lib${HGL_BITS})
ENDIF(WIN32)

link_directories(${CMAKE_ARCHIVE_OUTPUT_DIRECTORY})

INCLUDE_DIRECTORIES(${CMGDK_PATH}/inc)
INCLUDE_DIRECTORIES(${CMGDK_PATH}/inc/cml)
INCLUDE_DIRECTORIES(${CMGDK_PATH}/3rdpty/MathGeoLib/src)

link_directories(${CMGDK_PATH}/3rdpty/MathGeoLib)

ADD_DEFINITIONS(-DHGL_PLATFORM_STRING="${HGL_PLATFORM_STRING}")

IF(UNIX)

	IF(USE_ICE_CREAM)
		IF(USE_LLVM_CLANG)
			SET(CMAKE_C_COMPILER /usr/lib/icecc/bin/clang)
			SET(CMAKE_CXX_COMPILER /usr/lib/icecc/bin/clang++)
		ELSE(USE_LLVM_CLANG)
			SET(CMAKE_C_COMPILER /usr/lib/icecc/bin/gcc)
			SET(CMAKE_CXX_COMPILER /usr/lib/icecc/bin/g++)
		ENDIF(USE_LLVM_CLANG)
	ELSE(USE_ICE_CREAM)
		IF(USE_LLVM_CLANG)
			SET(CMAKE_C_COMPILER clang)
			SET(CMAKE_CXX_COMPILER clang++)
		ENDIF(USE_LLVM_CLANG)
	ENDIF(USE_ICE_CREAM)

	IF(USE_CPP14)
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")
		add_definitions("-DHGL_CPP14")
		add_definitions("-DHGL_CPP11")
	ELSE(USE_CPP14)
		IF(USE_CPP11)
			SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
			add_definitions("-DHGL_CPP11")
		ENDIF(USE_CPP11)
	ENDIF(USE_CPP14)

	SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11")

	IF(HGL_BITS EQUAL 32)
		add_definitions(-DHGL_32_BITS)
	ELSE()
		add_definitions(-DHGL_64_BITS)
	ENDIF(HGL_BITS EQUAL 32)

	IF(${CMAKE_BUILD_TYPE} STREQUAL "Debug")
		add_definitions(-ggdb3)
	ELSE()
		add_definitions(-Ofast)
	ENDIF()

	add_definitions(-fno-rtti)
	add_definitions(-msse2)

	FIND_PATH(ICONV_INCLUDE_DIR
		NAMES iconv.h
		HINTS
		/usr/include
		/usr/local/include)
	INCLUDE_DIRECTORIES(${ICONV_INCLUDE_DIR})

	IF(NOT ${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
	FIND_PATH(ICONV_LIBRARY_DIR
		NAMES libiconv.so
		HINTS
		${LIB_3RD_FIND_HINT})
	LINK_DIRECTORIES(${ICONV_LIBRARY_DIR})
	ENDIF(NOT ${CMAKE_SYSTEM_NAME} STREQUAL "Linux")

    FIND_PATH(EXPAT_INCLUDE_DIR
        NAMES expat.h
        HINTS
        /usr/include
        /usr/local/include)
    INCLUDE_DIRECTORIES(${EXPAT_INCLUDE_DIR})

    FIND_PATH(EXPAT_LIBRARY_DIR
        NAMES libexpat.so
        HINTS
        ${LIB_3RD_FIND_HINT})
    LINK_DIRECTORIES(${EXPAT_LIBRARY_DIR})

	FIND_PATH(APR_INCLUDE_DIR
		NAMES apr.h
		HINTS
		/usr/include
		/usr/include/apr-1
		/usr/local/include/apr-1
		/usr/include/apr-1.0
		/usr/local/include/apr-1.0
		/usr/apr/1.3/include)					# solaris 目录
	INCLUDE_DIRECTORIES(${APR_INCLUDE_DIR})

	FIND_PATH(APR_LIBRARY_DIR
		NAMES libapr-1.so
		HINTS
		${LIB_3RD_FIND_HINT}
		/usr/apr/1.3/lib)						# solaris 的目录
	LINK_DIRECTORIES(${APR_LIBRARY_DIR})

# 	FIND_PATH(MYSQL_INCLUDE_DIR
# 		NAMES mysql.h
# 		HINTS
# 		/usr/include
# 		/usr/include/mysql
# 		/usr/local/include
# 		/usr/local/include/mysql
# 		/usr/mysql/include/mysql)				#solaris 目录
# 	INCLUDE_DIRECTORIES(${MYSQL_INCLUDE_DIR})
#
# 	FIND_PATH(MYSQL_LIBRARY_DIR
# 		NAMES libmysqlclient.so
# 		HINTS
# 		${LIB_3RD_FIND_HINT}
# 		/usr/lib${HGL_BITS}/mysql
# 		/usr/local/lib${HGL_BITS}/mysql
# 		/usr/lib/mysql
# 		/usr/local/lib/mysql
#
# 		/usr/mysql/lib/${CMAKE_SYSTEM_PROCESSOR}/mysql	#solaris amd64 目录
# 		/usr/mysql/lib/mysql)
# 	LINK_DIRECTORIES(${MYSQL_LIBRARY_DIR})

# 	IF(BUILD_OPENAL_LIB)
# 		FIND_PATH(OPENAL_INCLUDE_DIR
# 			NAMES al.h
# 			HINTS
# 			/usr/include/AL
# 			/usr/local/include/AL)
# 		INCLUDE_DIRECTORIES(${OPENAL_INCLUDE_DIR})
#
# 		FIND_PATH(OPENAL_LIBRARY_DIR
# 			NAMES libopenal.so
# 			HINTS
# 			${LIB_3RD_FIND_HINT})
# 		LINK_DIRECTORIES(${OPENAL_LIBRARY_DIR})
# 	ENDIF(BUILD_OPENAL_LIB)

	IF(BUILD_OPENGL_LIB)
		INCLUDE_DIRECTORIES(${CMGDK_PATH}/3rdpty/glew/include)
		SET(GLEW_SOURCE ${CMGDK_PATH}/3rdpty/glew/src/glew.c)

		INCLUDE_DIRECTORIES(${CMGDK_PATH}/3rdpty/glfw/include/GLFW)
		LINK_DIRECTORIES(${CMGDK_PATH}/3rdpty/glfw/src)
	ENDIF(BUILD_OPENGL_LIB)
ENDIF(UNIX)

IF(WIN32)

    FIND_PATH(EXPAT_INCLUDE_DIR
        NAMES expat.h
        HINTS
        ${INC_3RD_FIND_HINT}
		${CMGDK_PATH}/3rdpty/expat/lib)
    INCLUDE_DIRECTORIES(${EXPAT_INCLUDE_DIR})

    FIND_PATH(EXPAT_LIBRARY_DIR
        NAMES expat.lib
        HINTS
        ${LIB_3RD_FIND_HINT}
		${CMGDK_PATH}/3rdpty/expat/${CMAKE_BUILD_TYPE}
		)
    LINK_DIRECTORIES(${EXPAT_LIBRARY_DIR})

	FIND_PATH(APR_INCLUDE_DIR
		NAMES apr.h
		HINTS
		${INC_3RD_FIND_HINT}
		${CMGDK_PATH}/3rdpty/apr)
	INCLUDE_DIRECTORIES(${APR_INCLUDE_DIR})

	FIND_PATH(APR_LIBRARY_DIR
		NAMES libapr-1.lib
        HINTS
        ${LIB_3RD_FIND_HINT}
		${CMGDK_PATH}/3rdpty/apr/${CMAKE_BUILD_TYPE}
		)
	LINK_DIRECTORIES(${APR_LIBRARY_DIR})

# 	IF(BUILD_OPENAL_LIB)
# 		FIND_PATH(OPENAL_INCLUDE_DIR
# 			NAMES al.h
# 			HINTS
# 			${INC_3RD_FIND_HINT})
# 		INCLUDE_DIRECTORIES(${OPENAL_INCLUDE_DIR})
#
# 		FIND_PATH(OPENAL_LIBRARY_DIR
# 			NAMES libopenal.lib
# 			HINTS
# 			${LIB_3RD_FIND_HINT})
# 		LINK_DIRECTORIES(${OPENAL_LIBRARY_DIR})
# 	ENDIF(BUILD_OPENAL_LIB)
ENDIF(WIN32)

SET(HGL_BASE_LIB CM.Base CM.BaseObject CM.UT CM.SceneGraph CM.DFS MathGeoLib)

IF(BUILD_OPENAL_LIB)
	SET(HGL_AUDIO_LIB CM.OpenALEE)
ENDIF(BUILD_OPENAL_LIB)

IF(BUILD_NETWORK_LIB)
	SET(HGL_NETWORK_LIB CM.Network)
ENDIF(BUILD_NETWORK_LIB)

FIND_PATH(HGL_QT4_SOURCE_PATH
		NAMES PlatformQT4.cpp
		HINTS ${CMGDK_PATH}/src/OS/QT)

SET(HGL_QT_MAIN_SOURCE ${HGL_QT4_SOURCE_PATH}/PlatformQT4.cpp)
SET(HGL_QT_LIB QT4Support)

IF(UNIX)
	MESSAGE("Host OS is UNIX")

	FIND_PATH(HGL_UNIX_SOURCE_PATH
		NAMES UnixConsole.cpp
		HINTS ${CMGDK_PATH}/src/OS/UNIX)

	SET(HGL_CONSOLE_MAIN_SOURCE ${HGL_UNIX_SOURCE_PATH}/UnixConsole.cpp)
	SET(HGL_GRAPHICS_MAIN_SOURCE ${HGL_UNIX_SOURCE_PATH}/UnixOpenGL.cpp)

	SET(HGL_BASE_LIB ${HGL_BASE_LIB} pthread dl rt apr-1 aprutil-1 expat)

	IF(USE_GPERF_TOOLS)
		SET(HGL_BASE_LIB ${HGL_BASE_LIB} tcmalloc)
	ENDIF(USE_GPERF_TOOLS)

	IF(${CMAKE_SYSTEM_NAME} MATCHES ".*Linux.*")
		IF(ANDROID)
			MESSAGE("Set Android HGL_BASE_LIB")
		ELSE(ANDROID)
			MESSAGE("Set Linux HGL_BASE_LIB")
		ENDIF(ANDROID)
	ENDIF()

	IF(${CMAKE_SYSTEM_NAME} MATCHES ".*MacOS.*")
		MESSAGE("Set MacOS HGL_BASE_LIB")
		SET(HGL_BASE_LIB ${HGL_BASE_LIB} iconv)
	ENDIF()

	IF(${CMAKE_SYSTEM_NAME} MATCHES ".*FreeBSD.*")
		MESSAGE("Set FreeBSD HGL_BASE_LIB")
		SET(HGL_BASE_LIB ${HGL_BASE_LIB} iconv)
	ENDIF()

	IF(${CMAKE_SYSTEM_NAME} MATCHES ".*SunOS")
		MESSAGE("Set Solaris HGL_BASE_LIB")
		SET(HGL_BASE_LIB ${HGL_BASE_LIB} socket nsl)
	ENDIF()

	IF(BUILD_NETWORK_SCTP)
		SET(HGL_NETWORK_LIB ${HGL_NETWORK_LIB} sctp)
		add_definitions("-DHGL_NETWORK_SCTP_SUPPORT")
	ENDIF(BUILD_NETWORK_SCTP)

	SET(HGL_CONSOLE_LIB ${HGL_BASE_LIB} ${HGL_NETWORK_LIB})
	SET(HGL_GRAPHICS_LIB ${HGL_CONSOLE_LIB} CM.BaseGraphObject CM.SceneGraphRender CM.RenderDevice glfw)
ELSE(UNIX)
	MESSAGE("Host OS don't is UNIX")
ENDIF(UNIX)

IF(WIN32)
	MESSAGE("Host OS is Windows")

	SET(HGL_CONSOLE_MAIN_SOURCE ${CMGDK_PATH}/src/OS/Win/WinConsole.cpp)
	SET(HGL_BASE_LIB ${HGL_BASE_LIB} AngelScript)
	SET(HGL_GUI_MAIN_SOURCE ${CMGDK_PATH}/src/OS/Win/WinGame.cpp)
	SET(HGL_CONSOLE_LIB ${HGL_BASE_LIB} ${HGL_NETWORK_LIB})
ENDIF(WIN32)

message("CMAKE_SIZEOF_VOID_P = ${CMAKE_SIZEOF_VOID_P}")

MESSAGE("HGL_CONSOLE_LIB: " ${HGL_CONSOLE_LIB})
MESSAGE("Processor: " ${CMAKE_SYSTEM_PROCESSOR})
MESSAGE("Sytem: " ${CMAKE_SYSTEM})
MESSAGE("System Name: " ${CMAKE_SYSTEM_NAME})
MESSAGE("C Compiler: " ${CMAKE_C_COMPILER})
MESSAGE("C++ Compiler: " ${CMAKE_CXX_COMPILER})
MESSAGE("C Flags: " ${CMAKE_C_FLAGS})
MESSAGE("C++ Flags: " ${CMAKE_CXX_FLAGS})
MESSAGE("C Debug Flags: " ${CMAKE_C_FLAGS_DEBUG})
MESSAGE("C++ Debug Flags: " ${CMAKE_CXX_FLAGS_DEBUG})
MESSAGE("C Release Flags: " ${CMAKE_C_FLAGS_RELEASE})
MESSAGE("C++ Release Flags: " ${CMAKE_CXX_FLAGS_RELEASE})
