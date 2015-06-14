[![Build Status](https://travis-ci.org/virtio/VirtAdmin.svg?branch=master)](https://travis-ci.org/virtio/VirtAdmin)
[![Test Coverage](https://codeclimate.com/github/virtio/VirtAdmin/badges/coverage.svg)](https://codeclimate.com/github/virtio/VirtAdmin/coverage)
[![Code Climate](https://codeclimate.com/github/virtio/VirtAdmin/badges/gpa.svg)](https://codeclimate.com/github/virtio/VirtAdmin)
![Dependency status](https://gemnasium.com/f7698bd38ca0cd10ad57fd50dc5a915f.svg)

## THIS DOCUMENT IS WIP

### REQUIREMENTS

```
postgres
ruby 2.2.2
libvirt
GeoLite2 database from MaxMind
```

### INSTALLATION

```
cp config/database.example.yml config/database.yml
cp config/settings.example.yml config/settings.yml
cp config/secrets.example.yml config/secrets.yml
```

```
bundle install
rake db:migrate
rake db:seed
rake test (optional)
```

### MaxMind Database

```
wget -P lib/geolite/ http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
gunzip -f lib/geolite/GeoLite2-City.mmdb.gz
```

### LOGIN
```
Email: admin@admin.com
Pasword: password
```
