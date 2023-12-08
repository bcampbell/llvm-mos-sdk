platform(f256k COMPLETE PARENT common)

if(NOT CMAKE_CROSSCOMPILING)
  return()
endif()

add_platform_library(f256k-crt0)
merge_libraries(f256k-crt0
  common-crt0
  common-init-stack
  common-copy-zp-data
  common-zero-bss
  common-exit-return
)

target_compile_options(f256k-crt0 PUBLIC -mcpu=mosw65c02)
#target_include_directories(dodo-c SYSTEM BEFORE PUBLIC .)
#target_compile_options(f256k-c PUBLIC -mcpu=mos65c02)
