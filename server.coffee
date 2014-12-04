
fs = Npm.require('fs')


Meteor.methods
  listFilesInDir: (path) ->
    fs.readdirSync(path)


Meteor.publish "watchFile", (path, filename) ->
  console.log("watchFile sub", path, filename)
  sub = @
  
  fullpath = path + '/' + filename
  fileContent = fs.readFileSync fullpath,
    encoding: 'utf8'
  sub.added 'watchFiles', filename,
    fileContent: fileContent

  watcher = fs.watch fullpath, (event, file) ->
    console.log(event, file, fullpath)
    fileContent = fs.readFileSync fullpath,
      encoding: 'utf8'
    sub.changed 'watchFiles', filename,
      fileContent: fileContent

  @ready()
  @onStop ->
    watcher.close()