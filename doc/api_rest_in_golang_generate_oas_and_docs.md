# Getting OpenAPI specs and docs from existing RESTful API in Golang

## References

- https://stackoverflow.com/questions/66171424/how-to-generate-openapi-v3-specification-from-go-source-code
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

2. From in the directory containing `main.go`, run the code to start the server.

```sh
$ go run .
```

3. From a different Terminal, use `curl` to make a request to your running web service.

```sh
$ curl http://localhost:8080/albums/2
```

The command should display JSON for the album whose ID you used. If the album wasn’t found, you’ll get JSON with an error message.

```sh
curl -s http://localhost:8080/albums/2 | jq .
```

The `jq .` is used to give a json format.

```json
{
    "id": "2",
    "title": "Jeru",
    "artist": "Gerry Mulligan",
    "price": 17.99
}
```

### 3. Getting OpenAPI specs


1. The documentation is available at [http://localhost:8080/docs.](http://localhost:8080/docs). 

1. The OpenAPI specs are available at [http://localhost:8080/docs/openapi.json](http://localhost:8080/docs/openapi.json).

```sh
$ curl http://localhost:8080/docs/openapi.json -s | jq . > oas3.json

```

And the `oas3.json` contains:

```json
{
  "openapi": "3.0.3",
  "info": {
    "title": "Albums API",
    "description": "This service provides API to manage albums.",
    "version": "v1.0.0"
  },
  "paths": {
    "/albums": {
      "get": {
        "tags": [
          "Album"
        ],
        "summary": "Get Albums",
        "operationId": "getAlbums",
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": {
                    "$ref": "#/components/schemas/Album"
                  }
                }
              }
            }
          }
        }
      },
      "post": {
        "tags": [
          "Album"
        ],
        "summary": "Post Albums",
        "operationId": "postAlbums",
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/Album"
              }
            }
          }
        },
        "responses": {
          "201": {
            "description": "Created",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Album"
                }
              }
            }
          },
          "409": {
            "description": "Conflict",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/RestErrResponse"
                }
              }
            }
          }
        }
      }
    },
    "/albums/{id}": {
      "get": {
        "tags": [
          "Album"
        ],
        "summary": "Get Album By ID",
        "operationId": "getAlbumByID",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "required": true,
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/Album"
                }
              }
            }
          },
          "404": {
            "description": "Not Found",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/RestErrResponse"
                }
              }
            }
          }
        }
      }
    }
  },
  "components": {
    "schemas": {
      "Album": {
        "required": [
          "id",
          "title"
        ],
        "type": "object",
        "properties": {
          "artist": {
            "type": "string",
            "description": "Album author, can be empty for multi-artist compilations."
          },
          "id": {
            "minLength": 1,
            "type": "string",
            "description": "ID is a unique string that determines album."
          },
          "price": {
            "minimum": 0,
            "type": "number",
            "description": "Price in USD."
          },
          "title": {
            "type": "string",
            "description": "Title of the album."
          }
        }
      },
      "RestErrResponse": {
        "type": "object",
        "properties": {
          "code": {
            "type": "integer",
            "description": "Application-specific error code."
          },
          "context": {
            "type": "object",
            "additionalProperties": {},
            "description": "Application context."
          },
          "error": {
            "type": "string",
            "description": "Error message."
          },
          "status": {
            "type": "string",
            "description": "Status text."
          }
        }
      }
    }
  }
}
```

### 3. Assessing OWASP Top 10 API

We are going to use Spectra to check the security of RESTful API using its OpenAPI specs.

* [api_security_checks.md](api_security_checks.md)