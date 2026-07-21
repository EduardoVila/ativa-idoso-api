FROM ruby:3.4.2

RUN apt-get update -qq && apt-get install -y \
  locales \
  postgresql-client \
  graphviz \
  && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
  && locale-gen \
  && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

WORKDIR /ativa-idoso-api

COPY Gemfile /ativa-idoso-api/Gemfile
COPY Gemfile.lock /ativa-idoso-api/Gemfile.lock

RUN gem install bundler:2.6.3
RUN bundle install

COPY . /ativa-idoso-api

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3001

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "config.ru"]
