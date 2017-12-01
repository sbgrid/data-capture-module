# Components

The DCM is based on a system described in `DOI:10.1038/ncomms10882`.

In order to interact with the repository frontend, allow users to deposit datasets, and verify the integratiy of the datasets, the DCM functionality is divided into several components.

## API / web server
The repository frontend sends messages to the DCM to several HTTP API endpoints; requiring a web server to listen for these requests.
This is currently using [http://www.lighttpd.net/](lighttpd) and python CGI; other CGI capable web servers should work but are not tested.
The `ur.py` endpoint recieves a request from the repository frontend (on dataset creation), writes the request to local storage, and informs the generator.
The `sr.py` endpoint recieves a request from the repository frontend for a previously created transfer script, which the end-user uses to deposit data.

## Request Queue / Generator

## Upload Endpoint


