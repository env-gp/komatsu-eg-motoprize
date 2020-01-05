#ベースイメージを指定。必須項目
FROM ruby:2.6.2

# RUN命令は１命令ごとに１イメージを作成する
# イメージをまとめるためにRUN命令はできるだけまとめる
# パッケージリストの更新
# postgresql-clientのインストール
# パッケージインデックスファイルの削除
RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends \
    postgresql-client \
  && rm -rf /var/lib/apt/lists/*

# build-essential、nodejsのインストール
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    node.js \
  && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get install -y nodejs


# chromeの追加
RUN apt-get update && apt-get install -y unzip && \
  CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
  wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ && \
  unzip ~/chromedriver_linux64.zip -d ~/ && \
  rm ~/chromedriver_linux64.zip && \
  chown root:root ~/chromedriver && \
  chmod 755 ~/chromedriver && \
  mv ~/chromedriver /usr/bin/chromedriver && \
  sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
  apt-get update && apt-get install -y google-chrome-stable

# Bundlerのインストール
RUN gem install bundler

# イメージ内にappディレクトリを作成
WORKDIR /app

# Gemfile, Gemfile.lockをイメージにコピーしてbundle install
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

# ホスト上のカレントディレクトリファイルをイメージのカレントディレクトリにコピー
ADD . .
