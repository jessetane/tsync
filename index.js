#!/usr/bin/env node

var vfs = require('vinyl-fs');
var thru  = require('through2');
var spawn = require('child_process').spawn;
var minimist = require('minimist');

var argv = minimist(process.argv.slice(2));
var args = argv._;
var transforms = args.slice(1, -1);

if (args.length < 3) {
  console.error('usage: tsync \'src-glob\' transform [\'otherTransform --option\'] [..] dest');
  process.exit(1);
}

var input = vfs.src(args[0], { buffer: false });
var output = vfs.dest(args.slice(-1)[0]);
var pipeline = thru.obj(function(file, enc, cb) {
  if (file.isNull()) return cb();

  if (argv.x || argv.extension) {
    file.path = file.path.replace(/(.*\.).*/, '$1' + (argv.x || argv.extension));
  }

  var first = null;
  var last = null;

  for (var i=0; i<transforms.length; i++) {
    var transform = transforms[i];
    var parts = transform.split(' ');
    var cmd = parts[0];
    var args = parts.slice(1);
    var status = 0;

    var proc = spawn(cmd, args);

    proc.stderr.pipe(process.stderr);
    proc.stderr.on('close', function() {
      if (status !== 0) process.exit(status);
    });

    proc.on('error', function(err) {
      console.error(err);
      process.exit(err.code === 'ENOENT' ? 127 : 1);
    });

    proc.on('exit', function(code) {
      status = code;
    });

    if (!first) first = proc;
    if (last) last.stdout.pipe(proc.stdin);
    last = proc;
  }

  file.contents.pipe(first.stdin);
  file.contents = last.stdout.pipe(thru());
  
  cb(null, file);
});

input
  .pipe(pipeline)
  .pipe(output);
