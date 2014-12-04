
WatchFiles = new Mongo.Collection('watchFiles')

Template.fileWatcher.created = ->
  @filenames = new ReactiveVar([])
  @file = new ReactiveVar()
  console.log("fileWatcher created data", @data)
  Meteor.call "listFilesInDir", @data.path, (err, filenames) =>
    if err
      console.log("fileWatcher error on getting file list", err)
    else
      @filenames.set(filenames)
  
  @autorun =>
    if @file.get()?
      Meteor.subscribe("watchFile", @data.path, @file.get())


Template.fileWatcher.helpers
  files: ->
    console.log('files', Template.instance().filenames.get())
    list = []
    list.push
      value: ''
      label: 'Select File'
    for file in Template.instance().filenames.get()
      list.push
        value: file
        label: file
    list


  file: ->
    Template.instance().file.get()


  fileContents: ->
    if Template.instance().file?.get()?
      Meteor.setTimeout ->
        pre = $('.file-pre')
        console.log("scroll", pre)
        pre.animate({ scrollTop: pre.prop("scrollHeight") }, "slow")
      , 10

      WatchFiles.findOne
        _id: Template.instance().file.get()
      ?.fileContent
    

Template.fileWatcher.events
  'change #file-selector': (e, tmpl) ->
    console.log('file changed', $(e.target).val())
    tmpl.file.set($(e.target).val())
    