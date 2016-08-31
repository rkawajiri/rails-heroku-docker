FROM ruby:2.3-alpine

RUN set -ex \
 && apk add --update --upgrade --no-cache \
    build-base \
    zlib-dev \
    libxml2 \
    libxml2-dev \
    libxslt \
    libxslt-dev \
    tzdata \
    yaml-dev \
    mysql-dev \
    nodejs \
    yaml

# WORKING DIR
RUN set -ex \
 && mkdir /webapp
WORKDIR /webapp

# Pre-install gems and configure bundle
RUN set -ex \
 && gem install -N nokogiri \
 && echo 'gem: --no-document --no-rdoc --no-ri' >> ~/.gemrc \
 && bundle config --global build.nokogiri --use-system-libraries

# Bundle install
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN set -ex \
 && bundle install

# Copy Apps
COPY . .

# Run the image as a non-root user
RUN adduser -D myuser
USER myuser

# Start rails server
CMD bundle exec rails s -p $PORT -b '0.0.0.0'
