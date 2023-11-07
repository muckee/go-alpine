ARG GO_VERSION=1.21
 
# STAGE 1: building the executable
FROM golang:${GO_VERSION}-alpine AS build

FROM golang:latest

# # Create a user with a specific UID and assign them to the group
# RUN addgroup --shell goapp && adduser --shell -u 10000 --group goapp goapp

# # # Create an empty directory for GOCACHE to disable caching.
# RUN mkdir -p /usr/src/go/go-cache && chown -R 10000:goapp /usr/src/go/

# # Define Go cache directory
# ENV GOCACHE /tmp/gocache
# ENV CGO_ENABLED 0
# ENV GOOS linux

# RUN mkdir "$GOCACHE" && chmod -R 1770 "$GOCACHE"

WORKDIR /usr/src/app

# Install Go dependencies
COPY ./go.mod ./

# Install Go dependencies
RUN go mod download

# Copy the source code into the image
COPY ./ ./

# Build the Go application
RUN GOCACHE=/tmp/gocache CGO_ENABLED=0 GOOS=linux go build \
    -o ./app ./cmd/app

# Set permissions for the executable
RUN chmod 770 ./app
    # chown $GO_USER_ID:$GO_USER_NAME ./app

# # Set user
# USER goapp

# Execute the Go application
CMD ["/go/app"]
