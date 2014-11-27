#!/usr/bin/env bash

set -e

cd "$(dirname "$BASH_SOURCE")"

# coffee-script
../index.js -x js\
            'fixtures/**/*.coffee'\
            'coffee -c --stdio'\
            actual

echo "✓ coffee-script"

# html repair and minify
../index.js 'fixtures/**/*.html'\
            htmlmin\
            actual

echo "✓ htmlmin"

# jade + uglify
../index.js -x js\
            'fixtures/**/*.jade'\
            'jade -cD'\
            'uglifyjs'\
            actual

echo "✓ jade + uglify"

# lessc
../index.js --extension css\
            'fixtures/**/*.less'\
            'lessc -'\
            actual

echo "✓ lessc"

# diff actual against expected
diff -r actual expected

echo ""
echo "✓ build matches expected output"
