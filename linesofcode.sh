#!/bin/bash


find "source" -type f \( -iname "*.asm" -o -iname "*.cpp" -o -iname "*.h" \) -print0 | \
    xargs -0 cat | wc -l
