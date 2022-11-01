# Base64 Search

It is just an idea...

From a given string, calculate all possible base64 representations.
Then, use these to directly search in a base64 encoded blob without decoding.

## Calculating variants

See: https://serverfault.com/a/876667

```bash
bash variants.sh searchterm
```

## Usage example: GREP

```bash
# Will generate: /(c2NyaX|Njcmlw|zY3Jpc)/
bash variants.sh script

# Find in given file
grep -P '(c2NyaX|Njcmlw|zY3Jpc)' /tmp/hax0r.htm

# Find in string
echo '<script>' | base64 | grep -P '(c2NyaX|Njcmlw|zY3Jpc)'
```

## Usage example: Spamassassin

This custom rule finds javascript hidden in attachments, which are conveniently
base64-encoded for all emails.

```
full       T_JS_BASE64         /(amF2YXNjcmlw|phdmFzY3JpcH|qYXZhc2NyaXB)/
score      T_JS_BASE64         2.90
describe   T_JS_BASE64         Encoded javascript found
```

## Todo

- Case insensitivity, which should generate a dirty looking regex