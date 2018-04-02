const CleanWebpackPlugin = require('clean-webpack-plugin')

module.exports = {
  entry: {
    blog: "./web/blog/index.coffee",
    app: "./web/app/index.coffee"
  },
  output: {
    path: __dirname + "/public", // Folder to store generated bundle
    filename: "[name]-bundle.js", // Name of generated bundle after build
    publicPath: "/" // public URL of the output directory when referenced in a browser
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        loader: 'vue-loader'
      },
      {
        test: /\.(s?)css$/,
        use: ["style-loader", "css-loader", "sass-loader"]
      },
      {
        test: /\.coffee$/,
        use: ["coffee-loader"]
      }
    ]
  },
  plugins: [
    new CleanWebpackPlugin(['public'])
  ]
};
