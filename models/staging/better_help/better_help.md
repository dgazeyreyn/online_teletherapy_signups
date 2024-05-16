{% docs better_help %}

One of the following values: 

| Field name                            | Type           | Comments
|----------------                       |-------------   | -------------
| Stat_datetime                         | TIMESTAMP      | Date/time that a User Signup or Trial Converted event occurred; IMPORTANT: Appears to be in EST and will need to be converted to UTC in order to be compatible with log_visitor and log_tests.
| Goal_name                             | STRING         | Will be one of either `User Signup` or `Trial Converted`
| Country_name                          | STRING         | Date/time that a User Signup or Trial Converted event occurred
| Stat_ad_id                            | STRING         | Unique ID for a user assigned by BetterHelp. Note that this unique ID will be duplicated across two rows for a user who both signs up and converts.
| Stat_affiliate_info1                  | STRING         | This records the originating site/application where: md = Mind Diagnostics, pm = Pridemind, fm = Faithfulmind, rd = Relationship Diagnostics
| Stat_affiliate_info2                  | STRING         | Will be either: mobile_web, desktop_web, mobile_app, email
| Stat_affiliate_info3                  | STRING         | The page or page element that a user clicked to get to BetterHelp. Can be: result_popup = Popup on Results Screen, listing = Therapist Listing Page, find_help = find help screen in mobile app, results_email = email sent to users when they request their results, results_followup_email = follow up email to resulst_email
| Stat_affiliate_info4                  | STRING         | Records test that user came from (if from a results screen), blank otherwise; It’s possible that a user can come from Google Ads - and so have a gclid assigned - but signup via a listing page rather than a results page. In that scenario Stat.affiliate_info4 will be blank.
| Stat_affiliate_info5                  | STRING         | MDUID
| ConversionsMobile_affiliate_click_id  | STRING         | GCLID (if available, and denotes Google Ads-derived traffic), otherwise blank (which denotes organic traffic)

{% enddocs %}