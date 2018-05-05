const CleanWebpackPlugin = require("clean-webpack-plugin");
const path = require("path");
const webpack = require("webpack");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const ZopfliPlugin = require("zopfli-webpack-plugin");

module.exports = {
  entry: {
    blog: "./web/blog/index.coffee",
    app: "./web/app/index.coffee"
  },
  output: {
    path: __dirname + "/public/assets", // Folder to store generated bundle
    filename: "[name]-bundle.js", // Name of generated bundle after build
    publicPath: "/assets" // public URL of the output directory when referenced in a browser
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        loader: "vue-loader"
      },
      {
        test: /\.(s?)css$/,
        use: ExtractTextPlugin.extract({
          fallback: "style-loader",
          use: [
            {
              loader: "css-loader",
              options: { minimize: true }
            },
            "sass-loader"
          ]
        })
      },
      {
        test: /\.coffee$/,
        use: ["coffee-loader"]
      }
    ]
  },
  resolve: {
    extensions: ["*", ".js", ".coffee", ".vue"],
    alias: {
      "@": path.resolve(__dirname, "web/app")
    }
  },
  plugins: [
    new CleanWebpackPlugin(["public/assets"]),
    new ExtractTextPlugin({
      filename: "[name].css"
    }),
    new ZopfliPlugin({
      asset: "[path].gz",
      algorithm: "zopfli",
      minRatio: 0
    })
  ],
  watchOptions: {
    ignored: /node_modules/
  }
};
