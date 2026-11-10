# The movies' MPEG-2 decoder: a minimal LGPL FFmpeg, the only FFmpeg code the game links.
# ct_port's plain target_link_libraries forbids kz_ffmpeg's keyword form, so the link goes on ct_options,
# the interface ct_link_game hands to the game and to darkchronicle_tests.
include(${KZ_ROOT}/cmake/KazarovFfmpeg.cmake)
kz_ffmpeg(ct_options INTERFACE)
