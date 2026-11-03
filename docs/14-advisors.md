# What Supabase warns about

You do not need this list to understand row level security. It is a checklist for a project you are about to share with other people. Nothing on it changes who can see the Notebook.

Supabase keeps a warning list for the project. One part asks "could someone get at something they should not?" The other asks "will this get slow when there are many rows?"

Reading the list changes nothing. The page still works. The Notebook is still there.

In the dashboard the list is under Advisors. From Cursor, the MCP connection can ask for the same list. The name of that request is `get_advisors`. That name is not a SQL command and not a button on the page. It means "send me the warning list."

## A helper that turns on row security

Creating the project used **Enable automatic RLS**. That added a helper called `rls_auto_enable`.

Its job is narrow. When a new table is created, the database runs this helper, and the helper turns row level security on for that table. This is why `items` had row level security on before any policy was written.

Supabase warns because the helper is allowed to run with more permission than a visitor has, and a visitor is allowed to try to call it. A try was made, as a visitor, to the address `POST /rest/v1/rpc/rls_auto_enable`. It did not change any table. The answer was HTTP 400, `cannot display a value of type event_trigger`. In plain words: this helper is not a request you send. The database runs it itself when a table is created.

The warning is "that permission is wider than the job." The helper stays. It is what turns row level security on for a new table.

## Stolen passwords are not checked

Auth can refuse a password that has already been published in a list of stolen passwords. That check is off. It is a switch on the login system, not a column on `items`. Ada can still sign in with `ada-password`.

## Two speed notes that do not matter here

`movements` stores an item id. The warning says that column has no index. An index is an extra lookup list so a search does not read every row. This project has one movement.

The owner policies ask "who is signed in?" in a form that, on a very large table, can ask once per row. This project has three items. The policies stay as they were written.
