# Getting OpenAPI specs and documentation from existing RESTful API in Golang

## References

- https://dev.to/vearutop/tutorial-developing-a-restful-api-with-go-json-schema-validation-and-openapi-docs-2490

## Steps

### 1. Prerequisites

1. Install Golan 1.16 or later.
You can use the [official guide](https://go.dev/doc/install) or if you are using Ubuntu 22.04 follow next commands:
```sh
$ sudo apt install golang
$ go version
go version go1.18.1 linux/amd64
```
2. Install an IDE to write your code there. [VSCode](https://code.visualstudio.com/download) is the recommended IDE.
3. Install and configure a Terminal to run the commands there.
4. Install `cURL`. It will be used query the RESTful API.

### 2. Run the RESTful API 

1. Clone the code.

Open a Terminal and clone the code.

```sh
$ git clone https://github.com/vearutop/rest-tutorial
```

2. From n the directory containing `main.go`, run the code to start the server.

```sh
$ go run .
```

3. From a different Terminal, use `curl` to make a request to your running web service.

```sh
$ curl http://localhost:8080/albums/2
```

The command should display JSON for the album whose ID you used. If the album wasn’t found, you’ll get JSON with an error message.

```json
{
    "id": "2",
    "title": "Jeru",
    "artist": "Gerry Mulligan",
    "price": 17.99
}
```
