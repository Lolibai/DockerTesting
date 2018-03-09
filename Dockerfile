FROM node:8.10.0
WORKDIR .
RUN npm install -g yarn
ADD package.json .
ADD yarn.lock .
RUN yarn

FROM microsoft/aspnetcore-build:2.0 AS build-env
WORKDIR .

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM microsoft/aspnetcore:2.0
WORKDIR .
COPY --from=build-env ./out .
ENTRYPOINT ["dotnet", "DockerLearning.dll"]
