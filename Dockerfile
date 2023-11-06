FROM golang:latest

# Define the current working directory
WORKDIR /usr/share/go

# Install Go dependencies
COPY ./go.mod ./

# Create the cache directory
RUN mkdir /.cache && chown -R 10000:10000 /.cache

# Specify the default user and group to run the application (10000:goapp).
USER 10000
USER :10000

# Define Go cache directory
ENV GOCACHE /.cache

# Install Go dependencies
RUN go mod download

# Copy the source code into the image
COPY ./ ./

# Build the Go application
RUN CGO_ENABLED=0 go build \
    -o ./app ./cmd/app

# # Set permissions for the executable
# RUN chmod 770 /app && \
#     chown 10000:goserver /app

# Execute the Go application
CMD ["./app"]
