ARG GO_VERSION=1.21
ARG GO_OS=linux
 
# STAGE 1: building the executable
FROM golang:${GO_VERSION}-alpine AS build

FROM golang:latest

# Create a user and group with specific IDs
RUN groupadd -g 10000 goapp && useradd -u 10000 -g goapp -m goapp

# Define the current working directory
WORKDIR /usr/share/go

# Install Go dependencies
COPY ./go.mod ./

# # Create the cache directory
# RUN mkdir /go-cache \
#     && chown -R 1000:1000 /go-cache \
#     && chmod -R +t /go-cache

# # Specify the default user and group to run the application (10000:goapp).
# USER 1000
# USER :1000

# Define Go cache directory
ENV GOCACHE /dev/null
# Install Go dependencies
RUN go mod download

# Copy the source code into the image
COPY ./ ./

# Build the Go application
RUN CGO_ENABLED=0 GOOS=$GO_OS go build \
    -o ./app ./cmd/app

# Set permissions for the executable
RUN chmod 770 ./app && \
    chown 10000:goapp ./app

# # Set permissions for the executable
# RUN chmod 770 /app && \
#     chown 10000:goapp /app

# Create user
USER goapp

# Execute the Go application
CMD ["./app"]
