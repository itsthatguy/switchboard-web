# Switchboard Multi-Service Chat Client (pre-alpha)

Switchboard is built using a modular adapter system that allows you to integrate custom chat protocols with relative ease. Simply follow the 'Adapter Interface Requirements'. Switchboard and the client will handle the rest.


### Note

*Currently setup to run locally in the browser, or deploy to a server. The alpha version will include node-webkit version, which removes the express dependency, and adds native desktop support for mac/windows/linux.*


## Protocol adapter list

- ~~IRC (done)~~
- Flowdock (not-started)
- Slack (not-started)
- others... (not-started)


## Screenshot!!

Avatars are generated using a (soon to be released) new service built with [@bigtiger](https://github.com/bigtiger) and [@adorableio](https://github.com/adorableio)

<img src="https://cloud.githubusercontent.com/assets/1118006/2958272/de38007c-daa7-11e3-8682-5d72db11be8d.png" width="514" height="625"/>



## Getting started

```bash
npm install coffee-script -g
npm install
bower install
```

## Run the local server (for accessing the webserver)

When you run `npm start` the server will automatically precompile any files as they change.

```bash
npm start
```

Point your browsering devices to: `http://localhost:3002/`


## Contributing

There's a ton of work to do. Want to help?

### Ways to help:

- Submit feature requests using github issues
- Build adapters
- Give code review/suggestions
- Contact me on twitter: [@itg](http://twitter.com/itg)


