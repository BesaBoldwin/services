FROM elixir:latest AS build

RUN apt update
#RUN apt install npm -y git -y python -y

#ENV SECRET_KEY_BASE=$SECRET_KEY_BASE
ARG SECRET_KEY_BASE=Juf3gmfiopuWIWmSlm+iCglQ1EcEgAYdebmvJ4I5GDRCoy2IP9bGgc5MwjjCCMXC
# prepare build dir
WORKDIR /app
# export secret key
RUN export SECRET_KEY_BASE=Juf3gmfiopuWIWmSlm+iCglQ1EcEgAYdebmvJ4I5GDRCoy2IP9bGgc5MwjjCCMXC
# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force
# set build ENV
ENV MIX_ENV=prod

# set build in development
#ENV MIX_ENV=dev

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
#RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
#RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM ubuntu:20.04 AS app

WORKDIR /app

RUN apt update
RUN apt install libssl-dev -y wget -y

RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb
RUN apt install ./wkhtmltox_0.12.6-1.focal_amd64.deb -y

COPY --from=build /app/_build/prod/rel/services ./

ENV HOME=/app

CMD ["bin/find", "start"]