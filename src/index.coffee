# Hexo
extend = hexo.extend
util = hexo.util
file = hexo.file
htmlTag = hexo.util.html_tag

# Modules
async = require 'async'
colors = require 'colors'
fs = require 'fs'

# Local
packageInfo = require '../package.json'
Command = require './Command'

# Options
umlOptions = 
        desc: packageInfo.description
        usage: '<argument>'
        arguments: [
                {name: 'install', desc: 'Install assets.'},
                {name: 'uninstall', desc: 'Uninstall assets.'}
        ]

# The console
hexo.extend.console.register "uml", packageInfo.description, umlOptions, (args, callback) ->
        cmd = new Command callback
        cmd.execute args._[0]

# Block Tag
hexo.extend.tag.register "uml", ((args, content) ->
        diagramType = args[0]
        if diagramType == ''
                diagramType = "sequence"
        if diagramType != "sequence" and diagramType != "robustness"
                return "<p>[hexo-tag-uml error: invalid diagram type: '#{diagramType}']</p>"
        result = "<script type='text/jumly+#{diagramType}'>#{content}</script>"
        return result
        ), true
