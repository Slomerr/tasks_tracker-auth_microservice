FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["tasks_tracker-auth_microservice.csproj", "./"]
RUN dotnet restore "tasks_tracker-auth_microservice.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "tasks_tracker-auth_microservice.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "tasks_tracker-auth_microservice.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "tasks_tracker-auth_microservice.dll"]
