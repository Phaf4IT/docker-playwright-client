# Docker Image: Playwright Client with WebSocket Support

This Docker image sets up a Playwright environment with an attached WebSocket server, enabling you to run tests against a Playwright browser instance via a WebSocket connection.

You can expose the WebSocket server on a specific port and set a custom WebSocket path using the `$WS_PATH` environment variable in your run configuration. If `$WS_PATH` is not provided, a random path will be generated for each run.

---

## **Usage**

To use this image, you can either build it locally or use the pre-built image available on GitHub Container Registry (`ghcr.io/phaf4it/docker-playwright-client:main`).

You can configure the WebSocket path by setting the `WS_PATH` environment variable in your Docker container or Docker Compose configuration. If not set, a random path will be generated automatically.

#### **Run Configuration with Docker Compose:**

```yaml
version: '3'

services:
  playwright-container:
    image: ghcr.io/phaf4it/docker-playwright-client:main  # Replace with your image tag
    ports:
      - "9222:9222"  # Expose the WebSocket port
    environment:
      - WS_PATH=playwright  # Set a custom WebSocket path (optional)
```

In this example, the WebSocket server will listen on ws://localhost:9222/playwright. If you do not set WS_PATH, a random path will be generated (e.g., ws://localhost:9222/<random-path>).

### Run Configuration with docker run:
Alternatively, if you're running the container directly with docker run, you can set the WS_PATH environment variable as follows:
```
docker run --rm -p 9222:9222 -e WS_PATH=playwright ghcr.io/phaf4it/docker-playwright-client:main
```
In this case, the WebSocket server will also be available at ws://localhost:9222/playwright.

## How It Works:
- The container starts a Playwright server and listens for WebSocket connections.
- By default, the server will expose the WebSocket server on port 9222. This can be modified by updating the EXPOSE directive in the Dockerfile.
- The wsPath can be customized via the WS_PATH environment variable. If WS_PATH is not set, a random WebSocket path will be generated.
- You can connect to the WebSocket server and interact with the Playwright browser instance using the exposed ws://localhost:9222 endpoint.

## WebSocket Path
- If the WS_PATH environment variable is set (e.g., WS_PATH=playwright), the WebSocket path will be statically set to playwright, and you will connect via ws://localhost:9222/playwright.
- If WS_PATH is not set, the path will be randomly generated, and the WebSocket server will give you a ws://localhost:9222/<random-path> URL. The random path is generated each time you start the container.