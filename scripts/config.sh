#!/bin/bash

echo "change python script parameters"
while getopts r:d:u:p: option
do
case "${option}"
in
r) sed -i 's/rest_server = rest-ip/rest_server = '${OPTARG}'/' /etc/datacore/datacore_get_perf.ini;;
d) sed -i 's/datacore_server = dcs-ip/datacore_server = '${OPTARG}'/' /etc/datacore/datacore_get_perf.ini;;
u) sed -i 's/user = user/user = '${OPTARG}'/' /etc/datacore/datacore_get_perf.ini;;
p) sed -i 's/passwd = pass/passwd = '${OPTARG}'/' /etc/datacore/datacore_get_perf.ini;;
esac
done

echo "Create Influxdb DataCore database"
curl  --silent --output /dev/null -POST 'http://127.0.0.1:8086/query?pretty=true' --data-urlencode "q=CREATE DATABASE DataCoreRestDB WITH DURATION 6w REPLICATION 1"

echo "Create Grafana Data Source"
curl --silent --output /dev/null  -X POST \
  http://127.0.0.1:3000/api/datasources \
  -H 'Accept: application/json' \
  -H 'Authorization: Basic Z3JhZmFuYTpncmFmYW5h' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -d '{
  "name":"DataCoreRestDB",
  "type":"influxdb",
  "url":"http://localhost:8086",
  "database":"DataCoreRestDB",
  "access":"proxy",
  "isdefault":true
}'

echo "Create Grafana DataCore Dashboard"
curl  --silent --output /dev/null  -X POST \
  http://127.0.0.1:3000/api/dashboards/db \
  -H 'Accept: application/json' \
  -H 'Authorization: Basic Z3JhZmFuYTpncmFmYW5h' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -d '{
  "dashboard": {
  "__inputs": [
    {
      "name": "DataCoreRestDB",
      "label": "DataCoreRestDB",
      "description": "",
      "type": "datasource",
      "pluginId": "influxdb",
      "pluginName": "InfluxDB"
    }
  ],
  "__requires": [
    {
      "type": "grafana",
      "id": "grafana",
      "name": "Grafana",
      "version": "5.2.4"
    },
    {
      "type": "panel",
      "id": "graph",
      "name": "Graph",
      "version": "5.0.0"
    },
    {
      "type": "datasource",
      "id": "influxdb",
      "name": "InfluxDB",
      "version": "5.0.0"
    }
  ],
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": "-- Grafana --",
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "editable": true,
  "gnetId": null,
  "graphTooltip": 1,
  "id": null,
  "iteration": 1536777772689,
  "links": [
    {
      "asDropdown": true,
      "icon": "external link",
      "tags": [
        "Home"
      ],
      "title": "All Dashboards",
      "type": "dashboards"
    },
    {
      "asDropdown": true,
      "icon": "external link",
      "tags": [
        "DataCore_REST"
      ],
      "title": "DataCore Dashboards",
      "type": "dashboards"
    }
  ],
  "panels": [
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 0
      },
      "id": 15,
      "panels": [],
      "repeat": null,
      "title": "DataCore Servers",
      "type": "row"
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "DataCoreRestDB",
      "fill": 1,
      "gridPos": {
        "h": 9,
        "w": 12,
        "x": 0,
        "y": 1
      },
      "height": "350px",
      "id": 1,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "sort": "current",
        "sortDesc": false,
        "total": false,
        "values": true
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "minSpan": null,
      "nullPointMode": "null",
      "percentage": false,
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "repeat": null,
      "seriesOverrides": [
        {
          "alias": "/Poller Dedicated/",
          "yaxis": 2
        },
        {
          "alias": "/Poller Load/",
          "yaxis": 2
        }
      ],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "alias": "$tag_instance : Reads",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "1s"
              ],
              "type": "time"
            },
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "DataCore_Servers",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "A",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "TotalReads"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [
                  "1s"
                ],
                "type": "derivative"
              }
            ]
          ],
          "tags": [
            {
              "key": "host",
              "operator": "=~",
              "value": "/^$DataCore_Servers$/"
            }
          ]
        },
        {
          "alias": "$tag_instance : Writes",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "1s"
              ],
              "type": "time"
            },
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "DataCore_Servers",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "B",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "TotalWrites"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [
                  "1s"
                ],
                "type": "derivative"
              }
            ]
          ],
          "tags": [
            {
              "key": "host",
              "operator": "=~",
              "value": "/^$DataCore_Servers$/"
            }
          ]
        },
        {
          "alias": "$tag_instance : Total",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "1s"
              ],
              "type": "time"
            },
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "DataCore_Servers",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "C",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "TotalOperations"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [
                  "1s"
                ],
                "type": "derivative"
              }
            ]
          ],
          "tags": [
            {
              "key": "host",
              "operator": "=~",
              "value": "/^$DataCore_Servers$/"
            }
          ]
        },
        {
          "alias": "$tag_instance : Poller Dedicated",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            }
          ],
          "measurement": "DataCore_Servers",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "D",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "PollerDedicatedCPUs"
                ],
                "type": "field"
              }
            ]
          ],
          "tags": [
            {
              "key": "host",
              "operator": "=~",
              "value": "/^$DataCore_Servers$/"
            }
          ]
        },
        {
          "alias": "$tag_instance : Poller Load",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            }
          ],
          "measurement": "DataCore_Servers",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "E",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "PollerLoad"
                ],
                "type": "field"
              }
            ]
          ],
          "tags": [
            {
              "key": "host",
              "operator": "=~",
              "value": "/^$DataCore_Servers$/"
            }
          ]
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeShift": null,
      "title": "IOPS",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "transparent": false,
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "iops",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "none",
          "label": "",
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "DataCoreRestDB",
      "fill": 1,
      "gridPos": {
        "h": 9,
        "w": 12,
        "x": 12,
        "y": 1
      },
      "height": "350px",
      "id": 2,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "hideEmpty": false,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "sort": "current",
        "sortDesc": true,
        "total": false,
        "values": true
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "minSpan": null,
      "nullPointMode": "connected",
      "percentage": false,
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "alias": "$tag_instance : Front-end Maximum Time",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "$__interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "DataCore_Servers",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "A",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "FrontEndTargetMaxIOTime"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mode"
              }
            ]
          ],
          "tags": [
            {
              "key": "host",
              "operator": "=~",
              "value": "/^$DataCore_Servers$/"
            }
          ]
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeShift": null,
      "title": "Latency",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "transparent": false,
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "ms",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "none",
          "label": "",
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 10
      },
      "id": 16,
      "panels": [],
      "repeat": null,
      "title": "DataCore Virtual Disks",
      "type": "row"
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "DataCoreRestDB",
      "fill": 1,
      "gridPos": {
        "h": 9,
        "w": 12,
        "x": 0,
        "y": 11
      },
      "height": "350px",
      "hideTimeOverride": false,
      "id": 3,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "sort": "current",
        "sortDesc": true,
        "total": false,
        "values": true
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "minSpan": null,
      "nullPointMode": "null",
      "percentage": false,
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "repeat": null,
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "alias": "$tag_instance : Reads",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "1s"
              ],
              "type": "time"
            },
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "DataCore_Virtual_Disks",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "A",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "TotalReads"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [
                  "1s"
                ],
                "type": "derivative"
              }
            ]
          ],
          "tags": [
            {
              "key": "instance",
              "operator": "=~",
              "value": "/^$DataCore_Virtual_Disks$/"
            }
          ]
        },
        {
          "alias": "$tag_instance : Writes",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "1s"
              ],
              "type": "time"
            },
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "DataCore_Virtual_Disks",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "B",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "TotalWrites"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [
                  "1s"
                ],
                "type": "derivative"
              }
            ]
          ],
          "tags": [
            {
              "key": "instance",
              "operator": "=~",
              "value": "/^$DataCore_Virtual_Disks$/"
            }
          ]
        },
        {
          "alias": "$tag_instance : Total",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "1s"
              ],
              "type": "time"
            },
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "DataCore_Virtual_Disks",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "C",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "TotalOperations"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [
                  "1s"
                ],
                "type": "derivative"
              }
            ]
          ],
          "tags": [
            {
              "key": "instance",
              "operator": "=~",
              "value": "/^$DataCore_Virtual_Disks$/"
            }
          ]
        },
        {
          "alias": "$tag_instance : Cache Read Misses",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "1s"
              ],
              "type": "time"
            },
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "DataCore_Virtual_Disks",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "D",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "CacheReadMisses"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [
                  "10s"
                ],
                "type": "derivative"
              }
            ]
          ],
          "tags": [
            {
              "key": "instance",
              "operator": "=~",
              "value": "/^$DataCore_Virtual_Disks$/"
            }
          ]
        },
        {
          "alias": "$tag_instance : Cache Write Misses",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "1s"
              ],
              "type": "time"
            },
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "DataCore_Virtual_Disks",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "E",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "CacheWriteMisses"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [
                  "10s"
                ],
                "type": "derivative"
              }
            ]
          ],
          "tags": [
            {
              "key": "instance",
              "operator": "=~",
              "value": "/^$DataCore_Virtual_Disks$/"
            }
          ]
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeShift": null,
      "title": "IOPS",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "transparent": false,
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "iops",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "none",
          "label": "",
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "DataCoreRestDB",
      "fill": 1,
      "gridPos": {
        "h": 9,
        "w": 12,
        "x": 12,
        "y": 11
      },
      "height": "350px",
      "id": 4,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "sort": "current",
        "sortDesc": true,
        "total": false,
        "values": true
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "minSpan": null,
      "nullPointMode": "connected",
      "percentage": false,
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "alias": "$tag_instance : Maximum Time",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "$__interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            }
          ],
          "measurement": "DataCore_Virtual_Disks",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "A",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "MaxReadWriteTime"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mode"
              }
            ]
          ],
          "tags": [
            {
              "key": "instance",
              "operator": "=~",
              "value": "/^$DataCore_Virtual_Disks$/"
            }
          ]
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeShift": null,
      "title": "Latency",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "transparent": false,
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "ms",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "none",
          "label": "",
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "collapsed": true,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 20
      },
      "id": 17,
      "panels": [
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": "DataCoreRestDB",
          "fill": 1,
          "gridPos": {
            "h": 9,
            "w": 12,
            "x": 0,
            "y": 19
          },
          "height": "350px",
          "id": 5,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": false,
            "min": false,
            "rightSide": false,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 1,
          "links": [],
          "minSpan": null,
          "nullPointMode": "null",
          "percentage": false,
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "repeat": null,
          "seriesOverrides": [],
          "spaceLength": 10,
          "stack": false,
          "steppedLine": false,
          "targets": [
            {
              "alias": "$tag_instance : Reads",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "1s"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_Disk_pools",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "A",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "TotalReads"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  },
                  {
                    "params": [
                      "1s"
                    ],
                    "type": "derivative"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_Disk_pools$/"
                }
              ]
            },
            {
              "alias": "$tag_instance : Writes",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "1s"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_Disk_pools",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "B",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "TotalWrites"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  },
                  {
                    "params": [
                      "1s"
                    ],
                    "type": "derivative"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_Disk_pools$/"
                }
              ]
            },
            {
              "alias": "$tag_instance : Total",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "1s"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_Disk_pools",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "C",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "TotalOperations"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  },
                  {
                    "params": [
                      "1s"
                    ],
                    "type": "derivative"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_Disk_pools$/"
                }
              ]
            }
          ],
          "thresholds": [],
          "timeFrom": null,
          "timeShift": null,
          "title": "IOPS",
          "tooltip": {
            "shared": true,
            "sort": 0,
            "value_type": "individual"
          },
          "transparent": false,
          "type": "graph",
          "xaxis": {
            "buckets": null,
            "mode": "time",
            "name": null,
            "show": true,
            "values": []
          },
          "yaxes": [
            {
              "format": "iops",
              "label": null,
              "logBase": 1,
              "max": null,
              "min": null,
              "show": true
            },
            {
              "format": "none",
              "label": "",
              "logBase": 1,
              "max": null,
              "min": "0",
              "show": true
            }
          ]
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": "DataCoreRestDB",
          "fill": 1,
          "gridPos": {
            "h": 9,
            "w": 12,
            "x": 12,
            "y": 19
          },
          "height": "350px",
          "id": 6,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": false,
            "min": false,
            "rightSide": false,
            "show": true,
            "sort": "current",
            "sortDesc": false,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 1,
          "links": [],
          "minSpan": null,
          "nullPointMode": "null",
          "percentage": false,
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [],
          "spaceLength": 10,
          "stack": false,
          "steppedLine": false,
          "targets": [
            {
              "alias": "$tag_instance : Maximum Operation",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "$__interval"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_Disk_pools",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "A",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "MaxReadWriteTime"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_Disk_pools$/"
                }
              ]
            },
            {
              "alias": "$tag_instance : Maximum Read",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "$__interval"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_Disk_pools",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "B",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "MaxReadTime"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_Disk_pools$/"
                }
              ]
            },
            {
              "alias": "$tag_instance : Maximum Write",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "$__interval"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_Disk_pools",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "C",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "MaxWriteTime"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_Disk_pools$/"
                }
              ]
            }
          ],
          "thresholds": [],
          "timeFrom": null,
          "timeShift": null,
          "title": "Latency",
          "tooltip": {
            "shared": true,
            "sort": 0,
            "value_type": "individual"
          },
          "transparent": false,
          "type": "graph",
          "xaxis": {
            "buckets": null,
            "mode": "time",
            "name": null,
            "show": true,
            "values": []
          },
          "yaxes": [
            {
              "format": "ms",
              "label": null,
              "logBase": 1,
              "max": null,
              "min": null,
              "show": true
            },
            {
              "format": "none",
              "label": "",
              "logBase": 1,
              "max": null,
              "min": "0",
              "show": true
            }
          ]
        }
      ],
      "repeat": null,
      "title": "DataCore Pools",
      "type": "row"
    },
    {
      "collapsed": false,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 21
      },
      "id": 18,
      "panels": [],
      "repeat": null,
      "title": "DataCore Physical Disks",
      "type": "row"
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "DataCoreRestDB",
      "fill": 1,
      "gridPos": {
        "h": 9,
        "w": 12,
        "x": 0,
        "y": 22
      },
      "height": "350px",
      "id": 7,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "sort": "current",
        "sortDesc": true,
        "total": false,
        "values": true
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "minSpan": null,
      "nullPointMode": "null",
      "percentage": false,
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "repeat": null,
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "alias": "$tag_instance : Reads",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "1s"
              ],
              "type": "time"
            },
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "DataCore_Physical_disk",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "A",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "TotalReads"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [
                  "1s"
                ],
                "type": "derivative"
              }
            ]
          ],
          "tags": [
            {
              "key": "instance",
              "operator": "=~",
              "value": "/^$DataCore_Physical_Disks$/"
            }
          ]
        },
        {
          "alias": "$tag_instance : Writes",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "1s"
              ],
              "type": "time"
            },
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "DataCore_Physical_disk",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "B",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "TotalWrites"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [
                  "1s"
                ],
                "type": "derivative"
              }
            ]
          ],
          "tags": [
            {
              "key": "instance",
              "operator": "=~",
              "value": "/^$DataCore_Physical_Disks$/"
            }
          ]
        },
        {
          "alias": "$tag_instance : Total",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "1s"
              ],
              "type": "time"
            },
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "DataCore_Physical_disk",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "C",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "TotalOperations"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              },
              {
                "params": [
                  "1s"
                ],
                "type": "derivative"
              }
            ]
          ],
          "tags": [
            {
              "key": "instance",
              "operator": "=~",
              "value": "/^$DataCore_Physical_Disks$/"
            }
          ]
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeShift": null,
      "title": "IOPS",
      "tooltip": {
        "shared": false,
        "sort": 0,
        "value_type": "individual"
      },
      "transparent": false,
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "iops",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        },
        {
          "format": "none",
          "label": "",
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": "DataCoreRestDB",
      "fill": 1,
      "gridPos": {
        "h": 9,
        "w": 12,
        "x": 12,
        "y": 22
      },
      "height": "350px",
      "id": 8,
      "legend": {
        "alignAsTable": true,
        "avg": true,
        "current": true,
        "max": false,
        "min": false,
        "rightSide": false,
        "show": true,
        "sort": "current",
        "sortDesc": true,
        "total": false,
        "values": true
      },
      "lines": true,
      "linewidth": 1,
      "links": [],
      "minSpan": null,
      "nullPointMode": "null",
      "percentage": false,
      "pointradius": 5,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [
        {
          "alias": "/Pending Commands/",
          "yaxis": 2
        }
      ],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "alias": "$tag_instance : Maximum Operation",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "$__interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "DataCore_Physical_disk",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "A",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "MaxReadWriteTime"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              }
            ]
          ],
          "tags": [
            {
              "key": "instance",
              "operator": "=~",
              "value": "/^$DataCore_Physical_Disks$/"
            }
          ]
        },
        {
          "alias": "$tag_instance : Maximum Read",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "$__interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "DataCore_Physical_disk",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "B",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "MaxReadTime"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              }
            ]
          ],
          "tags": [
            {
              "key": "instance",
              "operator": "=~",
              "value": "/^$DataCore_Physical_Disks$/"
            }
          ]
        },
        {
          "alias": "$tag_instance : Maximum Write",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "$__interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "DataCore_Physical_disk",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "C",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "MaxWriteTime"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              }
            ]
          ],
          "tags": [
            {
              "key": "instance",
              "operator": "=~",
              "value": "/^$DataCore_Physical_Disks$/"
            }
          ]
        },
        {
          "alias": "$tag_instance : Pending Commands",
          "dsType": "influxdb",
          "groupBy": [
            {
              "params": [
                "$__interval"
              ],
              "type": "time"
            },
            {
              "params": [
                "instance"
              ],
              "type": "tag"
            },
            {
              "params": [
                "null"
              ],
              "type": "fill"
            }
          ],
          "measurement": "DataCore_Physical_disk",
          "orderByTime": "ASC",
          "policy": "default",
          "refId": "D",
          "resultFormat": "time_series",
          "select": [
            [
              {
                "params": [
                  "TotalPendingCommands"
                ],
                "type": "field"
              },
              {
                "params": [],
                "type": "mean"
              }
            ]
          ],
          "tags": [
            {
              "key": "instance",
              "operator": "=~",
              "value": "/^$DataCore_Physical_Disks$/"
            }
          ]
        }
      ],
      "thresholds": [],
      "timeFrom": null,
      "timeShift": null,
      "title": "Latency",
      "tooltip": {
        "shared": false,
        "sort": 0,
        "value_type": "individual"
      },
      "transparent": false,
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "ms",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "none",
          "label": "",
          "logBase": 1,
          "max": null,
          "min": "0",
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    },
    {
      "collapsed": true,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 31
      },
      "id": 19,
      "panels": [
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": "DataCoreRestDB",
          "fill": 1,
          "gridPos": {
            "h": 9,
            "w": 12,
            "x": 0,
            "y": 28
          },
          "height": "350px",
          "id": 9,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": false,
            "min": false,
            "rightSide": false,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 1,
          "links": [],
          "minSpan": null,
          "nullPointMode": "null",
          "percentage": false,
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "repeat": null,
          "seriesOverrides": [
            {
              "alias": "/Total Busy Count/",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": false,
          "steppedLine": false,
          "targets": [
            {
              "alias": "$tag_instance : Reads",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "1s"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "hide": false,
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "A",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "TargetReads"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  },
                  {
                    "params": [
                      "1s"
                    ],
                    "type": "derivative"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            },
            {
              "alias": "$tag_instance : Writes",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "1s"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "hide": false,
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "B",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "TargetWrites"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  },
                  {
                    "params": [
                      "1s"
                    ],
                    "type": "derivative"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            },
            {
              "alias": "$tag_instance : Total",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "1s"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "hide": false,
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "C",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "Target_Operations_/_sec"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  },
                  {
                    "params": [
                      "1s"
                    ],
                    "type": "derivative"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            },
            {
              "alias": "$tag_instance : Total Busy Count",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "$__interval"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "D",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "BusyCount"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            }
          ],
          "thresholds": [],
          "timeFrom": null,
          "timeShift": null,
          "title": "IOPS",
          "tooltip": {
            "shared": true,
            "sort": 0,
            "value_type": "individual"
          },
          "transparent": false,
          "type": "graph",
          "xaxis": {
            "buckets": null,
            "mode": "time",
            "name": null,
            "show": true,
            "values": []
          },
          "yaxes": [
            {
              "format": "iops",
              "label": null,
              "logBase": 1,
              "max": null,
              "min": "0",
              "show": true
            },
            {
              "format": "none",
              "label": "",
              "logBase": 1,
              "max": null,
              "min": "0",
              "show": true
            }
          ]
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": "DataCoreRestDB",
          "fill": 1,
          "gridPos": {
            "h": 9,
            "w": 12,
            "x": 12,
            "y": 28
          },
          "height": "350px",
          "id": 10,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": false,
            "min": false,
            "rightSide": false,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 1,
          "links": [],
          "minSpan": null,
          "nullPointMode": "null",
          "percentage": false,
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "alias": "/Pending Commands/",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": false,
          "steppedLine": false,
          "targets": [
            {
              "alias": "$tag_instance : Maximum Operation",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "$__interval"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "A",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "TargetMaxIOTime"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            },
            {
              "alias": "$tag_instance : Maximum Read",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "$__interval"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "B",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "TargetMaxReadTime"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            },
            {
              "alias": "$tag_instance : Maximum Write",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "$__interval"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "C",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "TargetMaxWriteTime"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            },
            {
              "alias": "$tag_instance : Pending Commands",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "1s"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "D",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "PendingTargetCommands"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  },
                  {
                    "params": [
                      "1s"
                    ],
                    "type": "derivative"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            }
          ],
          "thresholds": [],
          "timeFrom": null,
          "timeShift": null,
          "title": "Latency",
          "tooltip": {
            "shared": true,
            "sort": 0,
            "value_type": "individual"
          },
          "transparent": false,
          "type": "graph",
          "xaxis": {
            "buckets": null,
            "mode": "time",
            "name": null,
            "show": true,
            "values": []
          },
          "yaxes": [
            {
              "format": "ms",
              "label": null,
              "logBase": 1,
              "max": null,
              "min": "0",
              "show": true
            },
            {
              "format": "none",
              "label": "",
              "logBase": 1,
              "max": null,
              "min": "0",
              "show": true
            }
          ]
        }
      ],
      "repeat": null,
      "title": "DataCore Server SCSI ports Target",
      "type": "row"
    },
    {
      "collapsed": true,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 32
      },
      "id": 20,
      "panels": [
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": "DataCoreRestDB",
          "fill": 1,
          "gridPos": {
            "h": 9,
            "w": 12,
            "x": 0,
            "y": 29
          },
          "height": "350px",
          "id": 11,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": false,
            "min": false,
            "rightSide": false,
            "show": true,
            "sort": "current",
            "sortDesc": false,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 1,
          "links": [],
          "minSpan": null,
          "nullPointMode": "null",
          "percentage": false,
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "repeat": null,
          "seriesOverrides": [
            {
              "alias": "/Total Busy Count/",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": false,
          "steppedLine": false,
          "targets": [
            {
              "alias": "$tag_instance : Reads",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "1m"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "A",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "InitiatorReads"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  },
                  {
                    "params": [
                      "1s"
                    ],
                    "type": "derivative"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            },
            {
              "alias": "$tag_instance : Writes",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "1s"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "B",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "InitiatorWrites"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  },
                  {
                    "params": [
                      "1s"
                    ],
                    "type": "derivative"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            },
            {
              "alias": "$tag_instance : Total",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "1s"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "C",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "InitiatorOperations"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  },
                  {
                    "params": [
                      "1s"
                    ],
                    "type": "derivative"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            },
            {
              "alias": "$tag_instance : Total Busy Count",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "$__interval"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "D",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "BusyCount"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            }
          ],
          "thresholds": [],
          "timeFrom": null,
          "timeShift": null,
          "title": "IOPS",
          "tooltip": {
            "shared": true,
            "sort": 0,
            "value_type": "individual"
          },
          "transparent": false,
          "type": "graph",
          "xaxis": {
            "buckets": null,
            "mode": "time",
            "name": null,
            "show": true,
            "values": []
          },
          "yaxes": [
            {
              "format": "iops",
              "label": null,
              "logBase": 1,
              "max": null,
              "min": "0",
              "show": true
            },
            {
              "format": "none",
              "label": "",
              "logBase": 1,
              "max": null,
              "min": "0",
              "show": true
            }
          ]
        },
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": "DataCoreRestDB",
          "fill": 1,
          "gridPos": {
            "h": 9,
            "w": 12,
            "x": 12,
            "y": 29
          },
          "height": "350px",
          "id": 12,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": false,
            "min": false,
            "rightSide": false,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 1,
          "links": [],
          "minSpan": null,
          "nullPointMode": "null",
          "percentage": false,
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "seriesOverrides": [
            {
              "alias": "/Pending Commands/",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": false,
          "steppedLine": false,
          "targets": [
            {
              "alias": "$tag_instance : Maximum Read",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "$__interval"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "B",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "InitiatorMaxReadTime"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            },
            {
              "alias": "$tag_instance : Maximum Write",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "$__interval"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "C",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "InitiatorMaxWriteTime"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            },
            {
              "alias": "$tag_instance : Pending Commands",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "$__interval"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "D",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "PendingInitiatorCommands"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            }
          ],
          "thresholds": [],
          "timeFrom": null,
          "timeShift": null,
          "title": "Latency",
          "tooltip": {
            "shared": true,
            "sort": 0,
            "value_type": "individual"
          },
          "transparent": false,
          "type": "graph",
          "xaxis": {
            "buckets": null,
            "mode": "time",
            "name": null,
            "show": true,
            "values": []
          },
          "yaxes": [
            {
              "format": "ms",
              "label": null,
              "logBase": 1,
              "max": null,
              "min": "0",
              "show": true
            },
            {
              "format": "none",
              "label": "",
              "logBase": 1,
              "max": null,
              "min": "0",
              "show": true
            }
          ]
        }
      ],
      "repeat": null,
      "title": "DataCore Server SCSI ports Initiator",
      "type": "row"
    },
    {
      "collapsed": true,
      "gridPos": {
        "h": 1,
        "w": 24,
        "x": 0,
        "y": 33
      },
      "id": 21,
      "panels": [
        {
          "aliasColors": {},
          "bars": false,
          "dashLength": 10,
          "dashes": false,
          "datasource": "DataCoreRestDB",
          "fill": 1,
          "gridPos": {
            "h": 11,
            "w": 24,
            "x": 0,
            "y": 30
          },
          "height": "",
          "id": 13,
          "legend": {
            "alignAsTable": true,
            "avg": true,
            "current": true,
            "max": false,
            "min": false,
            "rightSide": false,
            "show": true,
            "sort": "current",
            "sortDesc": true,
            "total": false,
            "values": true
          },
          "lines": true,
          "linewidth": 1,
          "links": [],
          "minSpan": null,
          "nullPointMode": "null",
          "percentage": false,
          "pointradius": 5,
          "points": false,
          "renderer": "flot",
          "repeat": null,
          "seriesOverrides": [
            {
              "alias": "/Total Pending Commands/",
              "yaxis": 2
            }
          ],
          "spaceLength": 10,
          "stack": false,
          "steppedLine": false,
          "targets": [
            {
              "alias": "$tag_instance : Reads",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "1s"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "A",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "TotalReads"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  },
                  {
                    "params": [
                      "1s"
                    ],
                    "type": "derivative"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            },
            {
              "alias": "$tag_instance : Writes",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "1s"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "B",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "TotalWrites"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  },
                  {
                    "params": [
                      "1s"
                    ],
                    "type": "derivative"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            },
            {
              "alias": "$tag_instance : Total",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "1s"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "C",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "TotalOperations"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  },
                  {
                    "params": [
                      "1s"
                    ],
                    "type": "derivative"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            },
            {
              "alias": "$tag_instance : Total Pending Commands",
              "dsType": "influxdb",
              "groupBy": [
                {
                  "params": [
                    "$__interval"
                  ],
                  "type": "time"
                },
                {
                  "params": [
                    "instance"
                  ],
                  "type": "tag"
                },
                {
                  "params": [
                    "null"
                  ],
                  "type": "fill"
                }
              ],
              "measurement": "DataCore_SCSI_ports",
              "orderByTime": "ASC",
              "policy": "default",
              "refId": "D",
              "resultFormat": "time_series",
              "select": [
                [
                  {
                    "params": [
                      "TotalPendingCommands"
                    ],
                    "type": "field"
                  },
                  {
                    "params": [],
                    "type": "mean"
                  }
                ]
              ],
              "tags": [
                {
                  "key": "instance",
                  "operator": "=~",
                  "value": "/^$DataCore_SCSI_Ports$/"
                }
              ]
            }
          ],
          "thresholds": [],
          "timeFrom": null,
          "timeShift": null,
          "title": "IOPS",
          "tooltip": {
            "shared": true,
            "sort": 0,
            "value_type": "individual"
          },
          "transparent": false,
          "type": "graph",
          "xaxis": {
            "buckets": null,
            "mode": "time",
            "name": null,
            "show": true,
            "values": []
          },
          "yaxes": [
            {
              "format": "iops",
              "label": null,
              "logBase": 1,
              "max": null,
              "min": "0",
              "show": true
            },
            {
              "format": "none",
              "label": "",
              "logBase": 1,
              "max": null,
              "min": "0",
              "show": true
            }
          ]
        }
      ],
      "repeat": null,
      "title": "DataCore Server SCSI ports",
      "type": "row"
    }
  ],
  "refresh": "10s",
  "schemaVersion": 16,
  "style": "dark",
  "tags": [
    "DataCore_REST",
    "Home"
  ],
  "templating": {
    "list": [
      {
        "allValue": null,
        "current": {},
        "datasource": "DataCoreRestDB",
        "hide": 0,
        "includeAll": true,
        "label": "DataCore Servers",
        "multi": true,
        "name": "DataCore_Servers",
        "options": [],
        "query": "SHOW TAG VALUES WITH KEY = \"host\" WHERE \"objectname\" = '\''DataCore Servers'\''",
        "refresh": 1,
        "regex": "",
        "sort": 0,
        "tagValuesQuery": "",
        "tags": [],
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "allValue": null,
        "current": {},
        "datasource": "DataCoreRestDB",
        "hide": 0,
        "includeAll": true,
        "label": "DataCore Virtual Disks",
        "multi": true,
        "name": "DataCore_Virtual_Disks",
        "options": [],
        "query": "SHOW TAG VALUES WITH KEY = \"instance\" WHERE \"objectname\" = '\''DataCore Virtual disks'\''",
        "refresh": 1,
        "regex": "",
        "sort": 0,
        "tagValuesQuery": "",
        "tags": [],
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "allValue": null,
        "current": {},
        "datasource": "DataCoreRestDB",
        "hide": 0,
        "includeAll": true,
        "label": "DataCore Disk Pools",
        "multi": true,
        "name": "DataCore_Disk_pools",
        "options": [],
        "query": "SHOW TAG VALUES WITH KEY = \"instance\" WHERE \"objectname\" = '\''DataCore Disk pools'\''",
        "refresh": 1,
        "regex": "",
        "sort": 0,
        "tagValuesQuery": "",
        "tags": [],
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "allValue": null,
        "current": {},
        "datasource": "DataCoreRestDB",
        "hide": 0,
        "includeAll": true,
        "label": "DataCore Physical Disk",
        "multi": true,
        "name": "DataCore_Physical_Disks",
        "options": [],
        "query": "SHOW TAG VALUES WITH KEY = \"instance\" WHERE \"objectname\" = '\''DataCore Physical disk'\''",
        "refresh": 1,
        "regex": "",
        "sort": 0,
        "tagValuesQuery": "",
        "tags": [],
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      },
      {
        "allValue": null,
        "current": {},
        "datasource": "DataCoreRestDB",
        "hide": 0,
        "includeAll": true,
        "label": "DataCore SCSI Ports",
        "multi": true,
        "name": "DataCore_SCSI_Ports",
        "options": [],
        "query": "SHOW TAG VALUES WITH KEY = \"instance\" WHERE \"objectname\" = '\''DataCore SCSI ports'\''",
        "refresh": 1,
        "regex": "",
        "sort": 0,
        "tagValuesQuery": "",
        "tags": [],
        "tagsQuery": "",
        "type": "query",
        "useTags": false
      }
    ]
  },
  "time": {
    "from": "now-30m",
    "to": "now"
  },
  "timepicker": {
    "refresh_intervals": [
      "5s",
      "10s",
      "30s",
      "1m",
      "5m",
      "15m",
      "30m",
      "1h",
      "2h",
      "1d"
    ],
    "time_options": [
      "5m",
      "15m",
      "1h",
      "6h",
      "12h",
      "24h",
      "2d",
      "7d",
      "30d"
    ]
  },
  "timezone": "",
  "title": "DataCore Perf Monitor",
  "uid": "000000026",
  "version": 1
},
  "folderId": 0,
  "overwrite": true
}'



echo "Set DataCore Dashboard as Home"
curl  --silent --output /dev/null  -X PUT \
  http://docker:3000/api/user/preferences \
  -H 'Accept: application/json' \
  -H 'Authorization: Basic Z3JhZmFuYTpncmFmYW5h' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -d '{
    "theme": "",
    "homeDashboardId": 1,
    "timezone": ""
}'



exit 0