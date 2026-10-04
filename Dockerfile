FROM ruby:4.0-slim

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libsqlite3-dev \
    sqlite3 \
    git \
    curl \
    libyaml-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000
CMD ["sh", "-lc", "bin/rails db:migrate && bin/rails server -b 0.0.0.0"]
