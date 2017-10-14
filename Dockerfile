FROM ruby:2.3-slim

# Install dependencies
RUN apt-get update && apt-get install -qq -y --no-install-recommends build-essential libpq-dev

# Set PATH
ENV INSTALL_PATH /faqbot

# Create dir
RUN mkdir -p $INSTALL_PATH

# Set out path as work path
WORKDIR $INSTALL_PATH

# Copy Gemfile
COPY Gemfile ./

# Install gems
RUN bundle install

# Copy our code inside container
COPY . .

# run server
CMD rackup config.ru -o 0.0.0.0
