# About #
This module installs the Oracle JDK 8 on Debian or Ubuntu. Smoke tests are performed to verify that you can use this version.

# Contact #

Jörn Franke - ZuInnoTe (jornfranke@gmail.com)

# License #
MIT

# Usage #

You simply use the following code snippet:


```puppet
include oraclejdk8
oraclejdk8::install{oraclejdk8-local:}
```


If you do not want to install the default environment variables you can use the following code snippet:
```puppet
include oraclejdk8
oraclejdk8::install{oraclejdk8-local:set_default_env=>false}
```

