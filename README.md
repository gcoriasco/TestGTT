# TestGTT
This is an iOS app for testing Turin GTT public APIs:
- stops list: http://www.5t.torino.it/ws2.1/rest/stops/all
- departures: http://www.5t.torino.it/ws2.1/rest/stops/{{stop_id}}/departures

In order to avoid lagging, stops are displayed on map only when their number is lower than or equal to 250.
