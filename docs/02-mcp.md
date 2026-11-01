# Connect the MCP server

`.cursor/mcp.json` points Cursor at `https://mcp.supabase.com/mcp`.

1. Open Cursor Settings → Tools & MCP.
2. Connect the Supabase server.
3. In the browser, grant the organization that contains `inventory-lab`.
4. Confirm the server is connected and its tools are listed.

No personal access token.

If the browser does not open:

1. Open the Output panel and select the Supabase MCP channel.
2. Copy the URL that starts with `https://api.supabase.com/v1/oauth/authorize`.
3. Open that URL in a browser and finish the grant.
