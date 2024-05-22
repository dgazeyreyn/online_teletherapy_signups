{% docs log_visitor %}
	
Inbound Parameters can have a combination of any of the following fields: 

| inbound_params | definition                                                                                                                                                                                                                                                                                 |
|----------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| browser        | Denotes whether a user is using a desktop device (includes laptops and tablets) or a mobile device.                                                                                                                                                                                        |
| gclid          | This is a unique code that we receive from Google (“Google Click ID”) for Google Ads-derived traffic and which we subsequently pass to and record with BH. Note: If no gclid is present in either our or the BH data, we assume that the source is organic search. |
| utm_source     | MD = Main md.org domain-sourced traffic, FM = fm.org, PM = pm.org, RD = rd.org; FM, PM, and RD are all sister sites to the main MD site.                                          |
| utm_campaign   | This (probably!) records the test that the user arrived on. We do not use this in our analysis.                                                                                                                                                                                            |

{% enddocs %}