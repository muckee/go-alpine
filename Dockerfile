ARG GO_VERSION=1.21
ARG GO_OS=linux
ARG GO_USER_ID=10000
ARG GO_USER_NAME=goapp
 
# STAGE 1: building the executable
FROM golang:${GO_VERSION}-alpine AS build

FROM golang:latest

# Create a user and group with specific IDs
RUN groupadd -g $GO_USER_ID $GO_USER_NAME && useradd -u $GO_USER_ID -g $GO_USER_NAME -m $GO_USER_NAME

# # Create an empty directory for GOCACHE to disable caching.
# RUN mkdir /go-cache && chown -R $GO_USER_NAME:$GO_USER_NAME /go-cache

# # Define Go cache directory
# ENV GOCACHE /go-cache

# Define the current working directory
WORKDIR /usr/share/go

# Install Go dependencies
COPY ./go.mod ./

# Install Go dependencies
RUN go mod download

# Copy the source code into the image
COPY ./ ./

# Build the Go application
RUN CGO_ENABLED=0 GOOS=$GO_OS go build \
    -o ./app ./cmd/app

# Set permissions for the executable
RUN chmod 770 ./app && \
    chown $GO_USER_ID:$GO_USER_NAME ./app

# Create user
USER $GO_USER_NAME

# Execute the Go application
CMD ["./app"]
