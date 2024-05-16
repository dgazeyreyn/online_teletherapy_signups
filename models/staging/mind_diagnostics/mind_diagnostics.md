{% docs log_visitor %}
	
One of the following values: 

| Field name        | Type           | Comments
|----------------   |-------------   | -------------
| id                | INTEGER        | Unique to each row
| ip                | STRING         | An unknown proportion of our traffic will share IP addresses. For example many bots will share an IP address. This means that an individual IP address is not equivalent to an individual user. 
| user_agent        | STRING         | The "user agent" metadata string is a line of text that web browsers send to websites to identify themselves. It contains several key pieces of information about the browser and the operating system it's running on.
| geo               | STRING         | We ping a 3rd party service with a user’s IP address which then returns the example Geo data you see here.
| mduid             | STRING         | Anonymized Mind Diagnostics visitor id; unique to each row
| created_at        | TIMESTAMP      | UTC
| updated_at        | TIMESTAMP      | UTC
| inbound_params    | STRING         | Inbound Parameters can have a combination of any of the following fields: browser - Denotes whether a user is using a desktop device (includes laptops and tablets) or a mobile device. gclid - This is a unique code that we receive from Google (“Google Click ID”) for Google Ads-derived traffic and which we subsequently pass to and record with BetterHelp. Note: If no gclid is present in either our or the BetterHelp data, we assume that the source is organic search. |utm_source - MD = Main mind-diagnostics.org, FM = faithfulmind.org, PM = pridemind.org, RD = relationshipdiagnostics.org; Faithfulmind, Pridemind, and Relationship Diagnostics are all sister sties to the main Mind Diagnostics site. utm_campaign
| browser_name      | STRING         | Parsed from user_agent above
| browser_version   | STRING         | Parsed from user_agent above
| browser_major     | STRING         | Parsed from user_agent above
| engine_name       | STRING         | Parsed from user_agent above
| engine_version    | STRING         | Parsed from user_agent above
| os_name           | STRING         | Parsed from user_agent above
| os_version        | STRING         | Parsed from user_agent above
| device_vendor     | STRING         | Parsed from user_agent above
| device_model      | STRING         | Parsed from user_agent above
| device_type       | STRING         | Parsed from user_agent above
| arch              | STRING         | Parsed from user_agent above

{% enddocs %}

{% docs log_tests %}
	
One of the following values: 

| Field name            | Type           | Comments
|----------------       |-------------   | -------------
| id                    | INTEGER        | Unique to each row
| test_taken            | STRING         | We also assign each test a number which is given in row 11 below.
| duration              | INTEGER        | Seconds
| completed             | BOOLEAN        | If “False” then no duration will be present
| result                | INTEGER        | Score from test
| ip_address            | STRING         | We do not record an MDUID within the Log Test data so attribution to a specific user will have to be done via the IP address.
| user_agent            | STRING         | Note: The values here differ from the User Agent value in the Log Visitor table
| channel               | STRING         | 
| geo                   | STRING         | We ping a 3rd party service with a user’s IP address which then returns the example Geo data you see here.
| created_at            | TIMESTAMP      | UTC
| updated_at            | TIMESTAMP      | UTC
| uniq_id               | STRING         | 
| city                  | STRING         | Individual fields for parsed out Geo Data
| region                | STRING         | Individual fields for parsed out Geo Data
| region_code           | STRING         | Individual fields for parsed out Geo Data
| country               | STRING         | Individual fields for parsed out Geo Data
| country_name          | STRING         | Individual fields for parsed out Geo Data
| continent_code        | STRING         | Individual fields for parsed out Geo Data
| postal                | STRING         | Individual fields for parsed out Geo Data
| latitude              | FLOAT          | Individual fields for parsed out Geo Data
| longitude             | FLOAT          | Individual fields for parsed out Geo Data
| timezone              | STRING         | Individual fields for parsed out Geo Data
| utc_offset            | INTEGER        | Individual fields for parsed out Geo Data
| country_calling_code  | STRING         | Individual fields for parsed out Geo Data
| currency              | STRING         | Individual fields for parsed out Geo Data
| languages             | STRING         | Individual fields for parsed out Geo Data
| asn                   | STRING         | Individual fields for parsed out Geo Data
| org                   | STRING         | Individual fields for parsed out Geo Data
| test_taken_id         | INTEGER        | Test number in our backend systems
| site_id               | INTEGER        | Site number corresponds to whether it is the main MD site (0), Relationshipdiagnostics, Faithfulmind, or Pridemind. 

{% enddocs %}