# Webpack 4 is "zero configuration", so here's our Webpack
# configuration. It's zero! Really!

CleanWebpackPlugin = require "clean-webpack-plugin"
path = require "path"
webpack = require "webpack"
ExtractTextPlugin = require "extract-text-webpack-plugin"
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
    use: ExtractTextPlugin.extract
      fallback: "style-loader"
      use: [
        loader: "css-loader"
        options:
          minimize: true
      ,
        "sass-loader"
      ]

  r

# Aaaaaand a bunch of plugins.

plugins = (env, argv) ->
  p = []

  p.push new CleanWebpackPlugin ["public/assets"]

  p.push new ExtractTextPlugin
    filename: "[name].css"

  if argv.mode == "production"
    p.push new ZopfliPlugin
      asset: "[path].gz"
      algorithm: "zopfli"
      minRatio: 0
  else
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
    publicPath: "/assets"

  module:
    rules: rules(env, argv)

  resolve:
    extensions: ["*", ".js", ".coffee", ".vue"]
    alias:
      "@": path.resolve __dirname, "web/app"

  plugins: plugins(env, argv)

  devServer:
    watchOptions:
      ignored: /node_modules/

  watchOptions:
    ignored: /node_modules/
