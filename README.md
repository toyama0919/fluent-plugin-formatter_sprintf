# fluent-plugin-formatter_sprintf

[![Build Status](https://secure.travis-ci.org/toyama0919/fluent-plugin-formatter_sprintf.png?branch=master)](http://travis-ci.org/toyama0919/fluent-plugin-formatter_sprintf)
[![Gem Version](https://badge.fury.io/rb/fluent-plugin-formatter_sprintf.svg)](http://badge.fury.io/rb/fluent-plugin-formatter_sprintf)

Fluentd sprintf formatter plugin

## Install

Use RubyGems:

```
gem install fluent-plugin-formatter_sprintf
```

## Configuration Example

`out_file` and `out_s3` plugin supports formatter plugin.

### out_file

```apache
<match test.file>
  type file
  path /tmp/test.log
  <format>
    @type sprintf
    sprintf_format "${tag} ${time} ${url} ${ip_address}\n"
  </format>
  time_format "%Y-%m-%d %H:%M:%S"
</match>
```

### out_s3

```apache
<match test.s3>
  type s3

  aws_key_id XXXXXXXXXXXXXXXXXX
  aws_sec_key XXXXXXXXXXXXXXXXXX
  s3_bucket sample-bucket
  s3_object_key_format %{path}%{time_slice}%{index}
  path logs/
  buffer_path /tmp/fluent/s3
  buffer_chunk_limit 8m

  time_slice_format %Y/%m/%d/test.log.%H%M
  time_slice_wait 1m
  time_format %Y-%m-%d %H:%M:%S,%3N
  store_as text

  <format>
    @type sprintf
    sprintf_format "${tag} ${time} ${url} ${ip_address}\n"
  </format>
</match>
```

### blank string(include [nil, empty?, blank?])

```apache
  <format>
    @type sprintf
    sprintf_format "${tag} ${time} ${url} ${ip_address}\n"
    sprintf_blank_string -
  </format>
```

##### input
```json
2016-03-15 14:21:40 +0900 analysis.pageview: { "url": null, "ip_address": null }
```

##### output
```
analysis.pageview 2016-01-01 00:00:00 - -
```

### bad syntax(at error)

```apache
<format>
  @type sprintf
  sprintf_format "%s ${tag} ${time} ${url} ${ip_address}\n"
</format>
```

## ChangeLog

See [CHANGELOG.md](CHANGELOG.md) for details.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new [Pull Request](../../pull/new/master)

## Copyright

Copyright (c) 2014 Hiroshi Toyama. See [LICENSE](LICENSE) for details.
