# Ask from a page

[browser/index.html](../browser/index.html) runs the two calls from [docs/07-sign-in.md](07-sign-in.md). The page signs in as Ada and keeps the access token. Nothing is copied from the sign-in response.

The page uses `fetch` and the same two headers as the `curl` commands. `apikey` is the publishable key in both calls. `Authorization` is the publishable key for the visitor and Ada’s access token after sign-in.

Open the file through a local page, not as a file on disk. A `file://` address is blocked before the request leaves the browser.

From the repo root:

```bash
python3 -m http.server 8000
```

Then open [http://localhost:8000/browser/index.html](http://localhost:8000/browser/index.html) and press Ask all three ways.

The visitor column is `[]` with HTTP 200. Ada’s column is the Notebook and the Pen. After [docs/09-two-owners.md](09-two-owners.md), Bea’s column is the Stapler.
