-- Set makeprg to run CMake in build directory
vim.bo.makeprg = "cd build && cmake -DCMAKE_BUILD_TYPE=debug -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .. && cmake --build ."

-- Use GCC errorformat for quickfix parsing
vim.cmd("compiler gcc")

