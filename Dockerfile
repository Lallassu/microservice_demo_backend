FROM ruby:latest
ADD . /backend


WORKDIR /backend
RUN apt update -y && \
    apt install -y nodejs && \
    gem install rack && \
    gem install bundle && \
    bundle install

EXPOSE 3000

CMD rackup -o 0.0.0.0 
