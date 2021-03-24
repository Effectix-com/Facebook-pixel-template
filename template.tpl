___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Facebook Pixel by Effectix",
  "categories": ["CONVERSIONS", "ADVERTISING", "MARKETING"],
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "Unofficial Facebook Pixel Template",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "pixelId",
    "displayName": "Facebook Pixel ID(s)",
    "simpleValueType": true,
    "alwaysInSummary": true,
    "valueHint": "e.g. 12345678910,2345678910",
    "valueValidators": [
      {
        "type": "NON_EMPTY",
        "errorMessage": "You must provide a Pixel ID"
      },
      {
        "type": "REGEX",
        "args": [
          "^[0-9,]+$"
        ]
      }
    ]
  },
  {
    "type": "SELECT",
    "name": "eventName",
    "displayName": "Event Name",
    "selectItems": [
      {
        "value": "PageView",
        "displayValue": "PageView"
      },
      {
        "value": "ViewContent",
        "displayValue": "ViewContent"
      },
      {
        "value": "AddToCart",
        "displayValue": "AddToCart"
      },
      {
        "value": "Purchase",
        "displayValue": "Purchase"
      },
      {
        "value": "Custom",
        "displayValue": "Custom"
      }
    ],
    "simpleValueType": true,
    "subParams": [
      {
        "type": "TEXT",
        "name": "customEventName",
        "displayName": "Custom Event Name",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "eventName",
            "paramValue": "Custom",
            "type": "EQUALS"
          }
        ]
      }
    ],
    "alwaysInSummary": true
  },
  {
    "type": "GROUP",
    "name": "objectProperties",
    "displayName": "Object Properties",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "SIMPLE_TABLE",
        "name": "propertyList",
        "displayName": "",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Property Name",
            "name": "name",
            "type": "TEXT",
            "isUnique": true
          },
          {
            "defaultValue": "",
            "displayName": "Property Value",
            "name": "value",
            "type": "TEXT"
          }
        ],
        "newRowButtonText": "Add property"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "moreSettings",
    "displayName": "More Settings",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "disableAutoConfig",
        "checkboxText": "Disable Automatic Configuration",
        "simpleValueType": true,
        "help": "Facebook collects some metadata (e.g. structured data) and user interactions (e.g. clicks) automatically. Check this box to disable this automatic configuration of the pixel."
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const createQueue = require('createQueue');
const callInWindow = require('callInWindow');
const aliasInWindow = require('aliasInWindow');
const copyFromWindow = require('copyFromWindow');
const setInWindow = require('setInWindow');
const injectScript = require('injectScript');
const makeTableMap = require('makeTableMap');

const initIds = copyFromWindow('_fbq_gtm_ids') || [];
const pixelIds = data.pixelId;

// Utility function to use either fbq.queue[]
// (if the FB SDK hasn't loaded yet), or fbq.callMethod()
// if the SDK has loaded.
const getFbq = () => {
  // Return the existing 'fbq' global method if available
  const fbq = copyFromWindow('fbq');
  if (fbq) {
    return fbq;
  }
  
  // Initialize the 'fbq' global method to either use
  // fbq.callMethod or fbq.queue)
  setInWindow('fbq', function() {    
    const callMethod = copyFromWindow('fbq.callMethod.apply');
    if (callMethod) {           
      callInWindow('fbq.callMethod.apply', null, arguments); 
    } else {       
      callInWindow('fbq.queue.push', arguments);
    }
  });
  aliasInWindow('_fbq', 'fbq');
  
  // Create the fbq.queue
  createQueue('fbq.queue');
    
  // Return the global 'fbq' method, created above
  return copyFromWindow('fbq');
};

// Get reference to the global method
const fbq = getFbq();

// Build the fbq() command arguments
const props = data.propertyList ? makeTableMap(data.propertyList, 'name', 'value') : {};
const command = data.eventName !== 'Custom' ? 'trackSingle' : 'trackSingleCustom';
const eventName = data.eventName !== 'Custom' ? data.eventName : data.customEventName;

// Handle multiple, comma-separated pixel IDs,
// and initialize each ID if not done already.
pixelIds.split(',').forEach(pixelId => {
  if (initIds.indexOf(pixelId) === -1) {
    
    // If the user has chosen to disable automatic configuration
    if (data.disableAutoConfig) {
      fbq('set', 'autoConfig', false, pixelId);
    }

    // Initialize pixel and store in global array
    fbq('init', pixelId);
    initIds.push(pixelId);
    setInWindow('_fbq_gtm_ids', initIds, true);
    
  }
  
  // Call the fbq() method with the parameters defined earlier
  fbq(command, pixelId, eventName, props);
});

injectScript('https://connect.facebook.net/en_US/fbevents.js', data.gtmOnSuccess, data.gtmOnFailure, 'fbPixel');


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "fbq"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "_fbq_gtm"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "_fbq"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "fbq.queue"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "_fbq_gtm_ids"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "fbq.callMethod.apply"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "fbq.queue.push"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
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
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://connect.facebook.net/en_US/fbevents.js"
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

Created on 24. 3. 2021 18:13:39


