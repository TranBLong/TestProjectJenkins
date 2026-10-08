FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY ["MyBlazorApp/MyBlazorApp/MyBlazorApp.csproj", "MyBlazorApp/"]
COPY ["MyBlazorApp/MyBlazorApp.Client/MyBlazorApp.Client.csproj", "MyBlazorApp.Client/"]
RUN dotnet restore "MyBlazorApp/MyBlazorApp.csproj"

COPY . .
WORKDIR "/src/MyBlazorApp/MyBlazorApp"
RUN dotnet publish "MyBlazorApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_HTTP_PORTS=80
EXPOSE 80

ENTRYPOINT ["dotnet", "MyBlazorApp.dll"]