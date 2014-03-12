# Imports
colors = require 'colors'
Log = require './Log'
async = require 'async'
fs = require 'fs'

log = new Log()

# Hexo
file = hexo.file
themeDir = hexo.theme_dir
layoutDir = themeDir + "layout\\"
assetDir = __dirname + "\\..\\asset\\"
jumlyLayoutName = "jumly.ejs"
jumlyLayoutAsset = assetDir + jumlyLayoutName
jumlyLayoutFile = layoutDir + "_partial\\" + jumlyLayoutName

resFiles = [
        "jumly\\coffee-script.js",
        "jumly\\jumly.css",
        "jumly\\jumly.min.js"
        ]

sourceDir = themeDir + "source\\"
jumlyDir = sourceDir + "jumly\\"
pad = (val, length, padChar = '.') ->
        val += ''
        numPads = length - val.length
        if (numPads > 0) then val + new Array(numPads + 1).join(padChar) else val

yesOrNo = (b) ->
        answer = if b then "YES".green else "NO".red
        "#{"[".bold}#{answer}#{"]".bold}"

doneOrFail = (b) ->
        answer = if b then "DONE".green else "FAIL".red
        "#{"[".bold}#{answer}#{"]".bold}"

checkAndLink = (f, src) ->
        deployed = fs.existsSync f
        log.info pad("#{f} deployed ", 50) + " #{yesOrNo(deployed)}"
        if not deployed
                try
                        fs.linkSync src, f
                        log.info pad("Deploy #{f} ", 50) +  " #{doneOrFail(true)}"
                catch error
                        log.error pad("Deploy #{f} ", 50) +  " #{doneOrFail(false)}"
                        log.error error

checkAndUnlink = (f) ->
        deployed = fs.existsSync f
        log.info pad("#{f} deployed ", 50) + " #{yesOrNo(deployed)}"
        if deployed
                try
                        fs.unlinkSync f
                        log.info pad("Undeploy #{f} ", 50) +  " #{doneOrFail(true)}"
                catch error
                        log.error pad("Undeploy #{f} ", 50) +  " #{doneOrFail(false)}"
                        log.error error
                

check = (next) ->
        checkAndLink jumlyLayoutFile, jumlyLayoutAsset
        if not fs.existsSync jumlyDir
                fs.mkdirSync jumlyDir
        for f in resFiles
                src = assetDir + f
                dst = sourceDir + f
                checkAndLink dst, src

uncheck = (next) ->
        checkAndUnlink jumlyLayoutFile
        for f in resFiles
                dst = sourceDir + f
                checkAndUnlink dst
        if fs.existsSync jumlyDir
                fs.rmdirSync jumlyDir

        
module.exports = class Command
        constructor: (@callback) ->

        execute: (opt) ->
                handler = @[opt]
                if handler?
                        handler()
                else
                        log.error "Unknown command: #{opt}"
                        hexo.call 'help', {_: ['math']}, @callback


        
        install: () ->
                async.waterfall [
                        check,
                        ], (err, result) ->
                                if err?
                                        log.error err
                                else
                                        log.info "Done!"
                
        uninstall: () ->
                async.waterfall [
                        uncheck,
                        ], (err, result) ->
                                if err?
                                        log.error err
                                else
                                        log.info "Done!"
