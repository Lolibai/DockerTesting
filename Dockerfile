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
RUN dotnet publish -c Debug -o out

# Build runtime image
FROM microsoft/aspnetcore:2.0
WORKDIR .
COPY --from=build-env /var/lib/jenkins/workspace/DockerLearning/out .
ENTRYPOINT ["dotnet", "DockerLearning.dll"]
