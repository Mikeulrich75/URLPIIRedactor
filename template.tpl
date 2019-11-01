___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "displayName": "URL - PII Redactor",
  "categories": ["REMARKETING", "ANALYTICS", "UTILITY"],
  "description": "Redact all emails and any listed parameters and their values from your URL or pathname. Avoid PII violations by cleaning up your URLs before sending them to analytics or other 3rd party platforms.",
  "securityGroups": [],
  "id": "cvt_temp_public_id",
  "type": "MACRO",
  "version": 1,
  "containerContexts": [
    "WEB"
  ],
  "brand": {}
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "urL",
    "displayName": "URL Variable",
    "simpleValueType": true,
    "valueHint": "Add a URL or pagepath string",
    "valueValidators": [
      {
        "type": "NON_EMPTY",
        "errorMessage": "Needs a URL or pagepath string"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "emailRedaction",
    "checkboxText": "Redact Emails",
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "params",
    "displayName": "Param List",
    "simpleValueType": true,
    "valueHint": "ie: address|name|email",
    "help": "Pipe delimited list redacts matched parameters values"
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const URL = data.urL;
const parameters = data.params ? data.params : undefined;
const paramArray = data.params ? parameters.split('|') : undefined;
const paramRegexArray = [];
const emailRedaction = data.emailRedaction;
let url = URL;
if (emailRedaction) {
    const emailRegEx = '[aA-zZ0-9._]+@[aA-zZ0-9.-]+.[aA-zZ][&?]|[aA-zZ0-9._]+@[aA-zZ0-9.-]+.[aA-zZ]';
    let flag = false;
    let matched = url.match(emailRegEx) ? url.match(emailRegEx) : undefined;
    let index = matched ? matched.index : undefined;
    let length = matched ? matched[0].replace("&", '').length : undefined;
    let calc = index + length;
    //do/while loop to match and redact each instances of a Regex matched email
    do {
        url = matched ? url.substring(0, index) + "[REDACTED_EMAIL]" + url.substring(calc) : url;
        matched = url.match(emailRegEx) ? url.match(emailRegEx) : undefined;
        index = matched ? matched.index : undefined;
        length = matched ? matched[0].replace("&", '').length : undefined;
        calc = index + length;
        flag = matched ? true : false;
    }
    while (flag);
}
//for loop to build regex pattern for all added parameters and their values
if (parameters) {
    for (let i = 0; i < paramArray.length; i++) {
        let value = '(' + paramArray[i] + '=([^&]*))';
        paramRegexArray.push(value);
    }
    const parameterRegex = paramRegexArray.toString().split(',').join('|');
    let match = url.match(parameterRegex) ? url.match(parameterRegex) : undefined;
    let matching = url.match(parameterRegex) ? match[0] : undefined;
    let flag = false;
    let index = match ? match.index : undefined;
    let indexMod = match ? index + matching.split('=')[0].toString().length : undefined;
    let length = match ? matching.length : undefined;
    let lengthMod = match ? matching.split('=')[1].toString().length : undefined;
    let calc = match ? (indexMod + lengthMod) + 1 : undefined;
    //do/while loop to match and redact each instances of a Regex matched parameter and its value
    do {
        url = match ? url.substring(0, indexMod) + "[REDACTED_PARAM]" + url.substring(calc) : url;
        match = url.match(parameterRegex) ? url.match(parameterRegex) : undefined;
        matching = url.match(parameterRegex) ? match[0] : undefined;
        flag = match ? true : false;
        index = match ? match.index : undefined;
        indexMod = match ? index + matching.split('=')[0].toString().length : undefined;
        length = match ? matching.length : undefined;
        lengthMod = match ? matching.split('=')[1].toString().length : undefined;
        calc = match ? (indexMod + lengthMod) + 1 : undefined;
    }
    while (flag);
}
return url;


___NOTES___

Created on 10/31/2019, 2:30:14 AM
