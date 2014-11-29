#!/usr/bin/env bash

set -e

cd "$(dirname "$BASH_SOURCE")"

tsync="../bin/tsync"

echo "TAP version 13"
echo ""
echo "1..5"

# coffee-script
$tsync -x js 'fixtures/**/*.coffee' 'coffee -c --stdio' actual
echo "ok 1 - coffee-script ✓"

# html repair and minify
$tsync 'fixtures/**/*.html' htmlmin actual
echo "ok 2 - htmlmin ✓"

# jade + uglify
$tsync -x js 'fixtures/**/*.jade' 'jade -cD' uglifyjs actual
echo "ok 3 - jade + uglify ✓"

# lessc
$tsync --extension css 'fixtures/**/*.less' 'lessc -' actual
echo "ok 4 - lessc ✓"

# diff actual against expected
diff -r actual expected
echo "ok 5 - build matches expected output ✓"
