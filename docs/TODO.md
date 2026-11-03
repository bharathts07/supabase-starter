# Still to do

Steps 1–15 are written. Two pieces of row level security are not written yet. Do one, write its note, then stop.

The Notebook is `22222222-2222-2222-2222-222222222222`. Its owner is Ada, `11111111-1111-1111-1111-111111111111`. Bea is `44444444-4444-4444-4444-444444444444`.

When an item is done, add its note to [README.md](../README.md) and say so here.

## 1. The grant and the policy

Being allowed to update the table is the grant. Which rows that update may touch is the policy. A signed-in person can pass the grant and still change no rows. Show those as two separate checks.

## 2. Two policies for the same command

If either policy says yes, the row is allowed. Add a second select policy and show a row the owner policy would hide.

After those two, the basic picture of row level security in this project is complete.

The warning list in step 14 is optional. Movements stay as they are in steps 11–13. Sign-up, logs, Realtime, Storage, and Edge Functions are other Supabase pieces. They are not required for how row security works.
