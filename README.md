# Certbot Hooks DNS Zeit Now

If you're trying to setup a wildard LetsEncrypt SSL domain with Certbot you
will need to provide scripts in order to let it handle the domain ownership verification via
DNS TXT, so it will be able to renew programmatically.

Use the flags `manual-auth-hook` and `manual-cleanup-hook` with the scripts provided.

```sh
sudo /usr/local/bin/certbot-auto certonly --manual --preferred-challenges=dns --manual-auth-hook cert-auth.sh --manual-cleanup-hook cert-cleanup.sh -d "*.domain.com" --email xxx@domain.com -w /var/www/_letsencrypt -n --agree-tos --force-renewal --manual-public-ip-logging-ok --dry-run
```
As the process may fail several times until everything is configured correctly, make sure the `--dry-run` flag is used, which increases the LetsEncrypt's APIs rate limit. As soon as everything is running without errors, remove `--dry-run` to make it happen :sparkles:

Remember to check if Cerbot renew is in place after that, which should add itself to your crontab:

```sh
crontab -l 
# or 
vim /etc/crontab
```
Which should have an entry similar to this:

```sh
0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && /usr/local/bin/certbot-auto renew -q
```

Run the renew command if that's not the case:
```sh
sudo certbot renew
```

More details at:
* https://certbot.eff.org/lets-encrypt/ubuntuxenial-nginx
* https://certbot.eff.org/docs/using.html#hooks
* https://letsencrypt.org/docs/rate-limits/
