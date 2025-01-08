Docker Image: Playwright Server with WebSocket Support
======================================================

This Docker image sets up a Playwright environment with an attached WebSocket server, enabling you to run tests against a Playwright browser instance via a WebSocket connection.

The container also sets up an **Nginx proxy** that allows you to interact with services running on your host machine from within the container. This proxy forwards requests to your host machine, allowing you to interact with services running on `localhost` from the container, even if Docker cannot directly access `localhost` due to network isolation.

You can expose the WebSocket server on a specific port and set a custom WebSocket path using the `$WS_PATH` environment variable in your run configuration. If `$WS_PATH` is not provided, a random path will be generated for each run.

Additionally, you can configure the port from the host to the container using the `$HOST_PORT` environment variable, allowing you to control which port from the host will be forwarded to `localhost` in the container.

**Usage**
---------

To use this image, you can either build it locally or use the pre-built image available on GitHub Container Registry (`ghcr.io/phaf4it/docker-playwright-client:main`).

### **Run Configuration with Docker Compose:**

```yaml
version: '3'

services:
  playwright-container:
    image: ghcr.io/phaf4it/docker-playwright-client:main  # Replace with your image tag
    ports:
      - "9222:9222"  # Expose the WebSocket port
      - "80:80"      # Expose the Nginx proxy port (optional)
    environment:
      - WS_PATH=playwright  # Set a custom WebSocket path (optional)
      - HOST_PORT=3000      # Set the host port to be forwarded to localhost (optional)
```

In this example:

*   The WebSocket server will listen on `ws://localhost:9222/playwright` (or a random path if `WS_PATH` is not set).

*   The Nginx proxy will forward requests from `localhost:3000` on the host machine to `localhost:3000` inside the container.

*   If `HOST_PORT` is not set, it defaults to `3000`.


### **Run Configuration with docker run:**

Alternatively, if you're running the container directly with docker run, you can set the `WS_PATH` and `HOST_PORT` environment variables as follows:

```bash
docker run --rm -p 9222:9222 -p 80:80 -e WS_PATH=playwright -e HOST_PORT=3000 ghcr.io/phaf4it/docker-playwright-client:main
```

In this case:

*   The WebSocket server will be available at ws://localhost:9222/playwright.

*   The Nginx proxy will forward requests from `localhost:3000` on the host machine to `localhost:3000` inside the container.


How It Works:
-------------

1.  **Playwright Server**: The container starts a Playwright server and listens for WebSocket connections on port `9222`.

    *   The WebSocket path can be customized by setting the `WS_PATH` environment variable. If not set, a random WebSocket path is generated.

2.  **Nginx Proxy**: An Nginx instance is included in the container, which forwards requests from the host to localhost inside the container.

    *   The Nginx proxy listens on port 80 by default and forwards requests to http://host.docker.internal:`$HOST_PORT`, where `$HOST_PORT` is an environment variable (defaulting to `3000`).

    *   This allows you to reach services running on localhost of your host machine from within the container, even if Docker can't directly access localhost.

3.  **Playwright Client**: You can connect to the Playwright WebSocket server via `ws://localhost:9222/`, where is either the custom path defined by the `WS_PATH` environment variable or a randomly generated path.

4.  **Environment Variables**:

    *   `WS_PATH`: If set, the WebSocket path is statically defined (e.g., `ws://localhost:9222/playwright`). If not set, a random path will be generated.

    *   `HOST_PORT`: Defines which host port is forwarded to the container. If not set, the default is port 3000.


WebSocket Path:
---------------

*   If the `WS_PATH` environment variable is set (e.g., `WS_PATH`=playwright), the WebSocket path will be statically set to playwright, and you will connect via `ws://localhost:9222/playwright`.

*   If `WS_PATH` is not set, the path will be randomly generated, and the WebSocket server will give you a `ws://localhost:9222/` URL. The random path is generated each time you start the container.


Example WebSocket Connection
----------------------------

To connect to the Playwright WebSocket server from your local machine, you can use a WebSocket client such as `wscat`:

```bash
wscat -c ws://localhost:9222/playwright
```
Or, if `WS_PATH` is not set and the path is randomly generated, you can retrieve the URL from the container logs or inspect the environment variable for the exact path.

In your code, you may use:

```ecmascript 6
import {Browser, chromium} from "playwright-core";

const playwrightWebsocketUrl = 'ws://localhost:9222/playwright';
const browser = await chromium.connect(playwrightWebsocketUrl, {});
```

Container Logs
--------------

If you encounter any issues with the WebSocket server or the Nginx proxy, you can inspect the container logs for details. For example, you can view the logs of the container as follows:

```bash
docker logs <container_id>
```
The logs will provide insights into the Playwright server, Nginx proxy, and any errors that might have occurred during startup.

### Notes:

*   The WebSocket server uses `chromium` by default. You can change the browser or additional settings by modifying the `playwright.json` file and build de docker image yourself, however it is not yet available to define in the existing image.

*   The container is configured to automatically install Playwright and the required Chromium dependencies.

*   If you're using a Docker-based CI/CD pipeline, you can set the appropriate environment variables (`WS_PATH`, `HOST_PORT`) to match your test configuration.