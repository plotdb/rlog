require! <[fs-extra readline fs date-fns path]>

desdir = "/"
upload = ({type, file, dest}) -> fs.unlink-sync file

rl = readline.createInterface do
  input: process.stdin
  output: process.stdout
  terminal: false
lc = {}

fs-extra.ensure-dir-sync 'log'

rl.on \line, (line) ->
  #now = date-fns.format(new Date!, 'yyyy-MM-dd')
  now = date-fns.format(new Date!, 'hh-mm')
  if lc.date != now =>
    lc.date = now
    if lc.out => lc.out.end!
    lc.filename = "log/#now.log"
    lc.out = fs.createWriteStream lc.filename, {flags: \a}

  lc.out.write(line + \\n)
  console.log "[#{fs.stat-sync(lc.filename).size}] #line"
  
  fs.readdir-sync 'log'
    .filter -> /\.log$/.exec(path.basename(it))
    .map -> "log/#it"
    .filter -> (Date.now! - +fs.stat-sync it .mtime) > (120 * 1000)
    .map (file) ->
      dest = path.join(desdir, file)
      upload {file, dest, type: 'plain/text'}

