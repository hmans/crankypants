# crankypants

A thing that does things.

[![CircleCI](https://circleci.com/gh/hmans/crankypants.svg?style=svg)](https://circleci.com/gh/hmans/crankypants)

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

| ENV     | Value |
|---------|-------|
| `CRANKY_LOGIN` | Login name when authenticating `/app` or `/api` |
| `CRANKY_PASSWORD` | Password (see above) |
| `CRANKY_TITLE` | Title of your site (will be displayed at the top of every page) |

If `CRANKY_LOGIN` or `CRANKY_PASSWORD` are missing, Crankypants will not make its App or API available at all.

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
- [x] Editing posts
- [x] Validate posts
- [x] Deleting posts
- [x] Authentication
- [ ] Configuration

etc.

- [ ] Nicer validation hints in forms?
- [x] Move database into a subdirectory (important for Docker volumes)
- [ ] CLI option to specify which database to use
- [ ] CLI option to specify which port to use

Deployment/etc.:

- [ ] https://traefik.io/
- [ ] https://github.com/umputun/nginx-le
