# ddev-typo3

## cron

You can Start cron on every Start with this code in a config.cron.yml.

```yaml
hooks:
  post-start:
  - exec: echo '*/1 * * * * root TYPO3_CONTEXT=Development/Local /usr/bin/php /var/www/html/public/typo3/sysext/core/bin/typo3
      scheduler:run' | sudo tee -a /etc/cron.d/typo3
  - exec: sudo chmod 0600 /etc/cron.d/typo3 && sudo service cron start
webimage_extra_packages: [cron]
```

But this always build a new Image for the webserver because webimage_extra_packages included. 

The easier Way is to run 'ddev t3cron' if you need the Scheduler.