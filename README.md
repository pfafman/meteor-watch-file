Watch-File
==========

Meteor smart package to watch a file and display contents.  Use to watch log files reactively.

WARNING
-------
This is a work in progress (WIP).  I have seen a few stability issues.


Installation
------------

```
meteor add pfafman:watch-file
```

Use
---

Pull in the template and pass the directory you want to select a file from
```
   {{> fileWatcher path="/path/to/what/I/want/to/watch"}} 
```

Notes
-----

Only works on systems that use '/'.  TODO: Fix this to work on any system.