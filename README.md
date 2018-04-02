# crankypants

```
brew bundle
shards install
yarn install
yarn run dev

# http://localhost:3000/ (server-rendered public-facing blog)
# http://localhost:3000/app/ (your crankypants app)
```

### TODO

- [ ] Make the blog look nicer :-)
- [x] Building & overall setup
- [x] Creating posts
- [ ] Editing posts
- [x] Validate posts
- [x] Deleting posts
- [ ] Authentication
- [ ] Configuration

etc.

- [ ] Uglify webpack bundles for production/release
- [ ] Nicer validation hints in forms?
- [ ] Teach Kilt to embed plain files so we don't have to go through ECR all the time
- [ ] Move database into a subdirectory (important for Docker volumes)
- [ ] CLI option to specify which database to use
- [ ] CLI option to specify which port to use
