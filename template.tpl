___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Inventory Data Collector",
  "categories": ["PERSONALIZATION", "UTILITY"],
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "Collects inventory data from data layer",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "merchantID",
    "displayName": "Merchant ID",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "endPoint",
    "displayName": "End Point",
    "simpleValueType": true
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const log = require('logToConsole');
const copyFromDataLayer = require('copyFromDataLayer');
const sendPixel = require('sendPixel');
const getTimestampMillis = require('getTimestampMillis');
const JSON = require('JSON');

const event = copyFromDataLayer('event');
const eventTimestamp = getTimestampMillis();
 
const endPoint = data.endPoint;
const merchantID = data.merchantID;

// store_code or store address 
const fields = ['item_id', 'store_code', 'availability', 'price', 'pickup_method', 'pickup_sla'];
 
const inventory = {
  'timestamp': eventTimestamp,
  'merchant_id': merchantID
};

log('inventory initialized: ', inventory);

for (const key of fields) {
  const value = copyFromDataLayer(key);
  log(key, value);
  inventory[key] = value;
}

log('inventory: ', inventory);
const onSuccess = (response) => {
  log(response);
  data.gtmOnSuccess();
};
const onFailure = (response) => {
  log(response);
  data.gtmOnFailure();
};

sendPixel(
  endPoint + '?data=' + JSON.stringify(inventory),
  onSuccess,
  onFailure
);


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_pixel",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "event"
              },
              {
                "type": 1,
                "string": "item_id"
              },
              {
                "type": 1,
                "string": "store_code"
              },
              {
                "type": 1,
                "string": "availability"
              },
              {
                "type": 1,
                "string": "price"
              },
              {
                "type": 1,
                "string": "pickup_method"
              },
              {
                "type": 1,
                "string": "pickup_sla"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 6/17/2022, 4:05:34 PM


