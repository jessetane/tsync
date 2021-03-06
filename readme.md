# tsync
Sync a [glob](https://github.com/isaacs/node-glob#glob) of files through a [unix pipeline](http://en.wikipedia.org/wiki/Pipeline_%28Unix%29) to a destination directory.

[![npm](http://img.shields.io/npm/v/tsync.svg?style=flat-square)](http://www.npmjs.org/tsync)
[![tests](https://img.shields.io/travis/jessetane/tsync.svg?style=flat-square&branch=master)](https://travis-ci.org/jessetane/tsync)

## Why
So you can transform and sync files [gulp](http://gulpjs.com/)-style, but at the process level via the [universal interface](http://en.wikipedia.org/wiki/Standard_streams).

## How
Consider the following directory tree:
```bash
$ tree
.
└── src
    └── a.txt "a"

1 directory, 1 file
```

Using `tsync` we can sync the files in the `src` directory into a new directory `dest` that doesn't yet exist, transforming them along the way with [sed](http://en.wikipedia.org/wiki/Sed):
```bash
$ tsync 'src/*' 'sed s/a/b/' dest
```

Gives:
```bash
$ tree
.
├── src
│   └── a.txt "a"
└── dest
    └── a.txt "b"

2 directories, 2 files
```

### Note
> In the example above only one pipeline gets created as there is only one file to sync - a unique pipeline is required for each file being synced however, and all pipelines execute concurrently. You can use the [`-c`](https://github.com/jessetane/tsync#option) flag if you need to limit the number of concurrent pipelines.

## Install
```bash
$ npm install tsync [-g]
```

## Test
```bash
$ npm test
```
**Note:** Currently the tests will probably only run in unix-like environments since they require the external dependencies `bash` and `diff`.

## Use
```bash
$ tsync [OPTION] 'src-glob' transform [..] ['otherTransform --option'] dest
```

#### `[OPTION]`
* -x --extension <u>extension</u>  
Change file extensions to <u>extension</u> before writing to `dest`.

* -c --concurrency <u>concurrency</u>  
The maximum number of concurrent pipelines. Defaults to `Infinity`.

#### `'src-glob'`
The pattern to use when [globbing](https://github.com/isaacs/node-glob#glob) files. Be careful to quote your pattern as your shell may perform expansion before `tsync` gets invoked!

#### `transform`
A transform program. The transform should be a stream-friendly program that reads from stdin, and writes to stdout. You must specify at least one transform. If you don't need to transform anything, use `cp -R` or `rsync -au` to sync files.

#### `[..] ['otherTransform --option']`
You can pass as many transforms as you like, `tsync` will pipe them together for you. If you need to pass options to a transform make sure to quote the full command string.

#### `dest`
The destination directory transformed files will be synced to.

## Releases
The latest stable release is published to [npm](https://www.npmjs.org/package/tsync). Tarballs for each release can be found [here](https://github.com/jessetane/tsync/releases).
* [1.2.x](https://github.com/jessetane/tsync/releases/tag/1.2.0)
 * Changed default concurrency to `Infinity`.
* [1.1.x](https://github.com/jessetane/tsync/releases/tag/1.1.4)
 * Added concurrency control.
* [1.0.0](https://github.com/jessetane/tsync/releases/tag/1.0.0)
 * First release.

## License
Copyright © 2014 Jesse Tane <jesse.tane@gmail.com>

This work is free. You can redistribute it and/or modify it under the
terms of the [WTFPL](http://www.wtfpl.net/txt/copying).

No Warranty. The Software is provided "as is" without warranty of any kind, either express or implied, including without limitation any implied warranties of condition, uninterrupted use, merchantability, fitness for a particular purpose, or non-infringement.
