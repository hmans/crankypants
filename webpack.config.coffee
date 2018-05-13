# Webpack 4 is "zero configuration", so here's our Webpack
# configuration. It's zero! Really!

CleanWebpackPlugin = require "clean-webpack-plugin"
path = require "path"
webpack = require "webpack"
MiniCssExtractPlugin = require "mini-css-extract-plugin"
ZopfliPlugin = require "zopfli-webpack-plugin"


# Set up our module rules.

rules = (env, argv) ->
  r = []

  r.push
    test: /\.vue$/
    loader: "vue-loader"

  r.push
    test: /\.coffee$/
    use: "coffee-loader"

  r.push
    test: /\.(s?)css$/
    use: [
      "css-hot-loader"
      MiniCssExtractPlugin.loader
      "css-loader"
      "sass-loader"
    ]

  r

# Aaaaaand a bunch of plugins.

plugins = (env, argv) ->
  p = []

  p.push new CleanWebpackPlugin ["public/assets"]

  p.push new MiniCssExtractPlugin
    filename: "[name].css"
    chunkFilename: "[id].css"

  if argv.mode == "production"
    p.push new ZopfliPlugin
      asset: "[path].gz"
      algorithm: "zopfli"
      minRatio: 0
  else # development
    p.push new webpack.NamedModulesPlugin
    p.push new webpack.HotModuleReplacementPlugin

  p


# Here's the Webpack configuration itself.

module.exports = (env, argv) ->
  entry:
    blog: "./web/blog/index.coffee"
    app: "./web/app/index.coffee"

  output:
    path: __dirname + "/public/assets"
    filename: "[name]-bundle.js"
    publicPath: "http://localhost:8080/assets"

  module:
    rules: rules(env, argv)

  resolve:
    extensions: ["*", ".js", ".coffee", ".vue"]
    alias:
      "@": path.resolve __dirname, "web/app"

  plugins: plugins(env, argv)

  devServer:
    inline: true
    hot: true
    public: "localhost:8080"
    contentBase: __dirname + "/public/assets"
    headers: { "Access-Control-Allow-Origin": "*" }﻿
    overlay:
      warnings: true
      errors: true
    watchOptions:
      ignored: /node_modules/
    stats:
      colors: true

  watchOptions:
    ignored: /node_modules/
