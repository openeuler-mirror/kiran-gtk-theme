cmake_minimum_required(VERSION 3.2)

project(kiran-gtk-theme)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")

find_package(KGT REQUIRED)
find_program(SASSC NAMES "sassc" REQUIRED)
find_package(PythonCairo)

add_subdirectory(src)

