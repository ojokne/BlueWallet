# # 1. Start with a clean Ubuntu base (same as GitHub Actions)
# # FROM ubuntu:22.04
# FROM node:24-bullseye

# # 2. Set non-interactive to avoid prompts
# ENV DEBIAN_FRONTEND=noninteractive

# # 3. Install basic tools
# RUN apt-get update && apt-get install -y \
#     curl git unzip zip libglu1-mesa wget build-essential ruby-full \
#     && rm -rf /var/lib/apt/lists/*

# # 4. Install Java 17 (Pinned to your requirements)
# RUN apt-get update && apt-get install -y openjdk-17-jdk
# ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
# ENV PATH=$PATH:$JAVA_HOME/bin

# # 5. Install Node 24 (Pinned to your requirements)
# # RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
# #     && apt-get install -y nodejs

# # 6. Install Android SDK (Version 35)
# ENV ANDROID_SDK_ROOT=/opt/android-sdk
# RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools \
#     && wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/tools.zip \
#     && unzip /tmp/tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools \
#     && mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest \
#     && rm /tmp/tools.zip

# ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools

# # 7. Accept licenses and install specific Build Tools/Platforms
# RUN yes | sdkmanager --licenses \
#     && sdkmanager "platforms;android-35" "build-tools;35.0.0" "ndk;27.1.12297006"

# WORKDIR /app

# # export SOURCE_DATE_EPOCH=$(git log -1 --format=%ct)

# # docker build -t bluewallet-builder .

# # docker volume create node-modules
# # docker run --rm \
# #   -v $(pwd):/app \
# #   -v node-modules:/app/node_modules \
# #   -v android-cache:/root/.gradle \
# #   android-builder \
# #   bash -c "npm ci --omit=dev --yes && cd android && ./gradlew assembleRelease"

# # docker run --rm -v $(pwd):/app -v node-modules:/app/node_modules -v android-cache:/root/.gradle -e JAVA_OPTS="-Djava.net.preferIPv4Stack=true" android-builder  bash -c "npm ci --omit=dev --yes && cd android && ./gradlew assembleRelease"


# # docker build -t android-build-env .

# # cd /app
# # chmod +x gradlew
# # ./gradlew assembleRelease

# # docker run -it --rm \
# #   -v $(pwd):/app \
# #   -v android-sdk:/opt/android-sdk \
# #   -v gradle-cache:/root/.gradle \
# #   android-build-env \
# #   bash

# # docker run -it --rm \
# #   -v $(pwd):/app \
# #   -v $HOME/.ssh:/root/.ssh:ro \
# #   rn-android \
# #   bash


# # docker run -it --rm \
# #   -v $(pwd):/app \
# #   -u $(id -u):$(id -g) \
# #   -v android-sdk:/opt/android-sdk \
# #   -v gradle-cache:/root/.gradle \
# #   -v $HOME/.ssh:/root/.ssh:ro \
# #   android-build-env \
# #   bash

# # docker run -it --rm \
# #   -v $(pwd):/app \
# #   -v android-sdk:/opt/android-sdk \
# #   -v gradle-cache:/root/.gradle \
# #   android-build-env \
# #   bash

# # git config --global --add safe.directory /app

# # git config --global --get-all safe.directory

# # npm ci --omit=dev --yes
# # ssh -T git@github.com

# # npm config set fetch-retries 5
# # npm config set fetch-retry-factor 10
# # npm config set fetch-retry-mintimeout 20000
# # npm config set fetch-retry-maxtimeout 600000
# # npm config set prefer-online true


# # rm -rf android/app/build
# # rm -rf ~/.gradle/
# # rm -rf ~/.npm/

# # npm cache clean --force
# # rm -rf node_modules

# # npm install --fetch-retries=5 --fetch-retry-factor=2 --fetch-retry-mintimeout=2000


# # docker run -it --rm \
# #   -v $(pwd):/app \
# #   -v $HOME/.ssh:/root/.ssh:ro \
# #   android-build-env \
# #   bash

# docker run -it --rm android-build-env /bin/bash


# Base image with Node 24
FROM node:24-bullseye

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install essential packages and Java 17 in a single layer
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git unzip zip libglu1-mesa wget build-essential ruby-full openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# Set Java environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Android SDK environment
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH

# Install Android command-line tools (stable version)
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools \
    && wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/tools.zip \
    && unzip /tmp/tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools \
    && mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest \
    && rm /tmp/tools.zip

# Accept licenses and install required SDK components
RUN yes | sdkmanager --sdk_root=$ANDROID_SDK_ROOT --licenses \
    && sdkmanager --sdk_root=$ANDROID_SDK_ROOT "platforms;android-35" "build-tools;35.0.0" "ndk;27.1.12297006" \
    && rm -rf $ANDROID_SDK_ROOT/cmdline-tools/tmp

WORKDIR /app

COPY . /app
