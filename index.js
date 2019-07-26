const { Application, genesisBlockDevnet, configDevnet} = require('lisk-sdk'); // require the lisk-sdk package

const app = new Application(genesisBlockDevnet, configDevnet); // create a new application with default genesis block for a local devnet

app.run() // start the application
   .then(() => app.logger.info('App started...')) // code that is executed after the successful start of the application.
   .catch(error => { // code that is executed if the application start fails.
        console.error('Faced error in application', error);
        process.exit(1);
});
