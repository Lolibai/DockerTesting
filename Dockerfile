FROM node:8.10.0
WORKDIR /var/lib/jenkins/workspace/DockerLearning
COPY package.json ./
RUN yarn

FROM microsoft/aspnetcore-build:2.0 AS build-env
WORKDIR /var/lib/jenkins/workspace/DockerLearning

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM microsoft/aspnetcore:2.0
RUN apt-get -qq update && apt-get -qqy --no-install-recommends install wget gnupg \
    git \
    unzip

RUN curl -sL https://deb.nodesource.com/setup_8.x | -E bash -
RUN apt-get install -y nodejs
WORKDIR /var/lib/jenkins/workspace/DockerLearning
COPY --from=build-env /var/lib/jenkins/workspace/DockerLearning/out ./
ENTRYPOINT ["dotnet", "DockerLearning.dll"]
