module.exports = {
  entry: __dirname + "/web/index.js",
  output: {
    path: __dirname + "/public", // Folder to store generated bundle
    filename: "crankypants.js", // Name of generated bundle after build
    publicPath: "/" // public URL of the output directory when referenced in a browser
  },
  module: {
    rules: [
      {
        test: /\.(s?)css$/,
        use: ["style-loader", "css-loader", "sass-loader"]
      }
    ]
  },
  plugins: []
};
