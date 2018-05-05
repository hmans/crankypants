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
  -e "CRANKY_TITLE=My Crankypants" \
  hmans/crankypants:latest
```

### Deploying on hyper.sh

```
hyper run -d --name mycrankypants \
  -v /data \
  -p 80:3000 \
  -e "CRANKY_LOGIN=any-user-name" \
  -e "CRANKY_PASSWORD=any-password" \
  -e "CRANKY_TITLE=My Crankypants" \
  --size s1 \
  --restart always hmans/crankypants:latest
```

### Configuration

| ENV               | Value                                                           |
| ----------------- | --------------------------------------------------------------- |
| `CRANKY_LOGIN`    | Login name when authenticating `/app` or `/api`                 |
| `CRANKY_PASSWORD` | Password (see above)                                            |
| `CRANKY_TITLE`    | Title of your site (will be displayed at the top of every page) |

If `CRANKY_LOGIN` or `CRANKY_PASSWORD` are missing, Crankypants will not make its App or API available at all.

### Hacking on Crankypants

```
cp .env-sample .env
docker-compose up

# http://localhost:3000/ (server-rendered public-facing blog)
# http://localhost:3000/app/ (your crankypants app)
```

### Development Roadmap

Please peruse this project's [issues](https://github.com/hmans/crankypants/issues) for an overview of what's planned/broken/still missing.
