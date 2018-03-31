module.exports = {
  entry: __dirname + "/web/index.js",
  output: {
    path: __dirname + '/dist', // Folder to store generated bundle
    filename: 'bundle.js.ecr',  // Name of generated bundle after build
    publicPath: '/' // public URL of the output directory when referenced in a browser
  },
  module: {
      rules: [
      ]
  },
  plugins: [
  ]
};
