# tsync
Sync [globs](https://github.com/isaacs/node-glob#glob) of files from `src/*` to `dest` transforming them along the way with a pipeline of stream-friendly programs (ones that read from stdin and write to stdout).

## Why
I really like how easy [Gulp](https://github.com/gulpjs/gulp) makes it to accomplish the feat described above. I really _don't_ like that Gulp is also a "task runner", and that it can only be used with bespoke plugins. `tsync` takes what is in my opinion the best part of Gulp (check out [vinyl-fs](https://github.com/wearefractal/vinyl-fs)) and makes it play nice with existing tools.

Rant 1
> You're already using a task runner. It's your shell. Whether you use `bash`, `zsh`, `fish` or something else doesn't really matter as long as it can fork a child process. It's perfectly acceptable for "tasks" to simply be executable programs or shell scripts in a "bin" folder. You can write them in any language you like! Just use the appropriate [shabang](http://tldp.org/LDP/abs/html/sha-bang.html).

Rant 2
> Plugins are an anti-pattern. In certain cases the need for them is unavoidable, but in this one they are largely unnecessary. With tsync, any stream-friendly program can be used as a transform, which means tons of existing tools will Just Work, and any new transforms you write (again, in any language you like) will be flexible enough to remain useful in their own right.

## How
Consider the following directory tree:
```bash
$ tree
.
└── src
    └── a.txt "a"

1 directory, 1 file
```

Using `tsync` we can sync the files in the `src` directory into a new directory `dest` that doesn't yet exist, transforming them along the way with `sed` (a program that is about 35 years old):
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

## Install
```bash
$ npm install tsync [-g]
```

## Test
```bash
$ npm test
```
**Note:** The tests will probably only run in unix-like environments since they require the external dependencies `bash` and `diff`.

## Use
```bash
$ tsync [OPTION] 'src-glob' transform ['otherTransform --option'] [..] dest
```

#### `[OPTION]`
* -x --extension <u>extension</u>  
Change file extensions to <u>extension</u> before writing to `dest`.

#### `'src-glob'`
The [glob](https://github.com/isaacs/node-glob#glob) pattern to use when finding files. Be careful to quote your src-glob pattern as your shell may perform expansion before `tsync` gets invoked!

#### `transform`
A transform program. The transform should be a stream-friendly program that reads from stdin, and writes to stdout. You must specify at least one transform. If you don't need to transform anything, use `cp -R` or `rsync -au` to sync files.

#### `['otherTransform --option']`
If you need to pass options to a transform make sure to quote the full command string.

#### `[..]`
You can pass as many transforms as you like, `tsync` will pipe them together for you.

#### `dest`
The destination directory `tsync` should sync the transformed versions of the files matched by `src-glob` to.

## Releases
The latest stable version is published to [npm](https://www.npmjs.org/package/tsync).
* [1.0.0](https://github.com/jessetane/tsync/releases/tag/1.0.0)
 * First release

## License
Copyright © 2014 Jesse Tane <jesse.tane@gmail.com>

This work is free. You can redistribute it and/or modify it under the
terms of the [WTFPL](http://www.wtfpl.net/txt/copying).

No Warranty. The Software is provided "as is" without warranty of any kind, either express or implied, including without limitation any implied warranties of condition, uninterrupted use, merchantability, fitness for a particular purpose, or non-infringement.
