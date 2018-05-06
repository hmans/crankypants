CleanWebpackPlugin = require "clean-webpack-plugin"
path = require "path"
webpack = require "webpack"
ExtractTextPlugin = require "extract-text-webpack-plugin"
ZopfliPlugin = require "zopfli-webpack-plugin"

module.exports =
  entry:
    blog: "./web/blog/index.coffee"
    app: "./web/app/index.coffee"

  output:
    path: __dirname + "/public/assets"
    filename: "[name]-bundle.js"
    publicPath: "/assets"

  module:
    rules: [
      test: /\.vue$/
      loader: "vue-loader"
    ,
      test: /\.coffee$/
      use: "coffee-loader"
    ,
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
    ]

  resolve:
    extensions: ["*", ".js", ".coffee", ".vue"]
    alias:
      "@": path.resolve __dirname, "web/app"

  plugins: [
    new CleanWebpackPlugin ["public/assets"]
    new ExtractTextPlugin
      filename: "[name].css"
    new ZopfliPlugin
      asset: "[path].gz"
      algorithm: "zopfli"
      minRatio: 0
  ]

  watchOptions:
    ignored: /node_modules/
