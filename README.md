# `parser_forti`

A personal Fluentd plugin to parse syslog line from FortiGate.

input:

```
date=2023-01-01 time=12:23:45 tz="+0900" devname="forti_01" type="utm" subtype="dns" ...
```

output:

```
{
    "timestamp": "2023-01-01 03:23:45",
    "record": { "devname": "forti_01", "type": "utm", "subtype": "dns", ... }
}
```

## Installation

Copy `parser_forti.rb` to the plugin directory.

## Parameters

### `reserve_time`

| type   | default |
| -      | -       |
| `bool` | `false` |

Keeps the original event time in the parsed result (as `date`, `time`, and `tz` fields).

## Example Configuration

```
<source>
  @type syslog
  tag forti.syslog
  <parse>
    @type forti
  </parse>
</source>
```
