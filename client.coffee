
DEBUG = false

WatchFiles = new Mongo.Collection('watchFiles')

Template.fileWatcher.created = ->
  @filenames = new ReactiveVar([])
  @file = new ReactiveVar()
  @loading = new ReactiveVar(true)
  @searchString = new ReactiveVar()
  console.log("fileWatcher created data", @data) if DEBUG
  Meteor.call "listFilesInDir", @data.path, (err, filenames) =>
    if err
      console.log("fileWatcher error on getting file list", err)
    else
      @filenames.set(filenames)
  
  @autorun =>
    if @file.get()?
      Template.instance().loading.set(true)
      @sub = Meteor.subscribe("watchFile", @data.path, @file.get())
    if @sub?.ready()
      Template.instance().loading.set(false)


Template.fileWatcher.helpers
  files: ->
    console.log('files', Template.instance().filenames.get()) if DEBUG
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


  loading: ->
    Template.instance().loading.get()


  fileContents: ->
    if Template.instance().file?.get()?
      if $('#scroll-to-bottom').is(':checked')
        Meteor.setTimeout ->
          pre = $('.file-pre')
          console.log("scroll", pre) if DEBUG
          pre.animate({ scrollTop: pre.prop("scrollHeight") }, "slow")
        , 10

      contents = WatchFiles.findOne
        _id: Template.instance().file.get()
      ?.fileContent

      searchString = Template.instance().searchString.get()
      if searchString? and searchString isnt ""
        re = new RegExp(searchString,"i")
        lines = contents.split("\n")
        searchedLines = []
        for line in lines
          searchedLines.push(line) if line.search(re) isnt -1
        searchedLines.join("\n")
      else
        contents

    

Template.fileWatcher.events

  'change #file-selector': (e, tmpl) ->
    console.log('file changed', $(e.target).val()) if DEBUG
    tmpl.loading.set(true)
    tmpl.file.set($(e.target).val())


  'keyup #search-string': (e, tmpl) ->
    console.log("search", $(e.target).val()) if DEBUG
    tmpl.searchString.set($(e.target).val())



    