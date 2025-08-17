# Base image: Ruby with necessary dependencies for Jekyll
FROM ruby:3.2

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /usr/src/app

# Copy the Gemfile AND Gemfile.lock to resolve dependencies correctly
COPY Gemfile Gemfile.lock ./

# Install the gems specified in the Gemfile.lock
RUN bundle install

# Copy the rest of your website's code into the container
COPY . .

# Create a non-root user and set permissions
# This is done AFTER bundle install to avoid permission issues
RUN groupadd -g 1000 vscode && \
    useradd -m -u 1000 -g vscode vscode && \
    chown -R vscode:vscode /usr/src/app

# Switch to the non-root user
USER vscode

# Command to serve the Jekyll site
CMD ["jekyll", "serve", "-H", "0.0.0.0", "-w"]