![Dependency startus](https://gemnasium.com/f7698bd38ca0cd10ad57fd50dc5a915f.svg)
[![Build Status](https://travis-ci.org/Cervajz/VirtAdmin.svg?branch=master)](https://travis-ci.org/Cervajz/VirtAdmin)
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

TODO

### LOGIN
```
Email: admin@admin.com
Pasword: password
```
