# Use the .NET SDK image as the base image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the project files to the working directory
COPY src .

# Build the project
RUN dotnet build -c Release

# Expose port 80 to the outside world (if needed)
EXPOSE 80

# Define the entry point for the container
CMD ["dotnet", "run", "--project", "TodoApi.csproj"]
