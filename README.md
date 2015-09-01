A ruby script to automate invites from a Typeform form to a Slack community

Based on [levels.io](https://levels.io/slack-typeform-auto-invite-sign-ups/)'s post re: Slack / Typeform

## Usage

- Rename `config.example.yml` to `config.yml`, and input the required values (read the above for more details)
- Upload `invite_script.rb` and `config.yml` to a server
- Install a crontab to run `cd /your/folder/path && ruby invite_script.rb` at some interval (once an hour might do!)
- Relax, you've earned it!
