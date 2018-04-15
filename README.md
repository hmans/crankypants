# crankypants

A thing that does things.

### Giving it a try via Docker

```
docker run --rm \
  -v crankypants-data:/data \
  -p 3000:3000 \
  -e "CRANKY_LOGIN=any-user-name" \
  -e "CRANKY_PASSWORD=any-password" \
  hmans/crankypants
```

### Deploying on hyper.sh

```
hyper run -d --name mycrankypants \
  -v /data \
  -p 80:3000 \
  -e "CRANKY_LOGIN=any-user-name" \
  -e "CRANKY_PASSWORD=any-password" \
  --size s1 \
  --restart always hmans/crankypants
```

### Configuration

Your Crankypants provides an app at `/app` (and an API at `/api`). Both are protected using a simple HTTP Basic Auth scheme. Please provide a login name and password through the environment variables `CRANKY_LOGIN` and `CRANKY_PASSWORD`. (These can be anything you like. You are the only user of your Crankypants installation.)

If any of these variables are missing, Crankypants will not make App or API available at all.

### Hacking on Crankypants

This currently assumes that you're on macOS. (Hacking on Crankypants on other operating systems is, of course, perfectly possible, as long as Crystal has support for them.)

```
brew bundle
shards install
yarn install
hivemind  # or any other Procfile manager

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

- [ ] Nicer validation hints in forms?
- [ ] Move database into a subdirectory (important for Docker volumes)
- [ ] CLI option to specify which database to use
- [ ] CLI option to specify which port to use

Deployment/etc.:

- [ ] https://traefik.io/
- [ ] https://github.com/umputun/nginx-le
