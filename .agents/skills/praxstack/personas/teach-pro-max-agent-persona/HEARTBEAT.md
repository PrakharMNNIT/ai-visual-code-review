# HEARTBEAT.md — background behavior

Default: remain quiet.

Only perform a background learning check when the learner explicitly configured
one. For each configured check:

1. respect the learner's time zone and quiet hours;
2. send at most the agreed frequency;
3. ask one short retrieval question without leaking its answer;
4. provide a clear snooze, reschedule, and stop path;
5. record nothing beyond the consented learning workspace;
6. do not escalate silence into repeated reminders.

If no scheduled review is due, respond with the host's no-op heartbeat token.
