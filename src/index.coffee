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
mathOptions = 
        desc: packageInfo.description
        usage: '<argument>'
        arguments: [
                {name: 'install', desc: 'Install assets.'},
                {name: 'uninstall', desc: 'Uninstall assets.'}
        ]

# The console
hexo.extend.console.register "uml", packageInfo.description, mathOptions, (args, callback) ->
        cmd = new Command callback
        cmd.execute args._[0]

# Block Tag
hexo.extend.tag.register "uml", ((args, content) ->
        result = "<script type='text/jumly+sequence'>#{content}</script>"
        return result
        ), true
