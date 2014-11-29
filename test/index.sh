#!/usr/bin/env bash

set -e

cd "$(dirname "$BASH_SOURCE")"

tsync="../bin/tsync"

# coffee-script
$tsync -x js 'fixture/**/*.coffee' 'coffee -c --stdio' actual
echo "✓ coffee-script"

# html repair and minify
$tsync 'fixture/**/*.html' htmlmin actual
echo "✓ htmlmin"

# jade + uglify
$tsync -x js 'fixture/**/*.jade' 'jade -cD' uglifyjs actual
echo "✓ jade + uglify"

# lessc
$tsync --extension css 'fixture/**/*.less' 'lessc -' actual
echo "✓ lessc"

# diff actual against expected
diff -r actual expected
echo -e "\n✓ build matches expected output"
