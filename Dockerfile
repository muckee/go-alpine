FROM golang:latest

# Define the current working directory
WORKDIR /usr/share/go

# Install Go dependencies
COPY ./go.mod ./

# Ensure that the Go cache is stored in a path with write permissions
ENV GOCACHE /usr/share/go-cache

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
