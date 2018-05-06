# Webpack 4 is "zero configuration", so here's our Webpack
# configuration. It's zero! Really!

CleanWebpackPlugin = require "clean-webpack-plugin"
path = require "path"
webpack = require "webpack"
ExtractTextPlugin = require "extract-text-webpack-plugin"
ZopfliPlugin = require "zopfli-webpack-plugin"


# Set up our module rules.

rules = []
rules.push
  test: /\.vue$/
  loader: "vue-loader"

rules.push
  test: /\.coffee$/
  use: "coffee-loader"

rules.push
  test: /\.(s?)css$/
  use: ExtractTextPlugin.extract
    fallback: "style-loader"
    use: [
      loader: "css-loader"
      options:
        minimize: true
    ,
      "sass-loader"
    ]


# Aaaaaand a bunch of plugins.

plugins = []
plugins.push new CleanWebpackPlugin ["public/assets"]
plugins.push new ExtractTextPlugin
  filename: "[name].css"
plugins.push new ZopfliPlugin
  asset: "[path].gz"
  algorithm: "zopfli"
  minRatio: 0


# Here's the Webpack configuration itself.

module.exports =
  entry:
    blog: "./web/blog/index.coffee"
    app: "./web/app/index.coffee"

  output:
    path: __dirname + "/public/assets"
    filename: "[name]-bundle.js"
    publicPath: "/assets"

  module:
    rules: rules

  resolve:
    extensions: ["*", ".js", ".coffee", ".vue"]
    alias:
      "@": path.resolve __dirname, "web/app"

  plugins: plugins

  watchOptions:
    ignored: /node_modules/
