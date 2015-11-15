fs = require 'fs'

module.exports = (env, callback) ->

  class StaticPlugin extends env.ContentPlugin

    constructor: (@filepath, @text) ->

    getFilename: -> @filepath.relative # relative to content directory

    getView: -> (env, locals, contents, templates, callback) ->
      callback null, new Buffer @text

  StaticPlugin.fromFile = (filepath, callback) ->
    fs.readFile filepath.full, (error, buffer) ->
      if error
        callback error
      else
        callback null, new StaticPlugin filepath, buffer.toString()

  env.registerContentPlugin 'static', '**/static/*', StaticPlugin
  callback() # tell the plugin manager we are done