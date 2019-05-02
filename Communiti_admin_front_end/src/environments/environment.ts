// The file contents for the current environment will overwrite these during build.
// The build system defaults to the dev environment which uses `environment.ts`, but if you do
// `ng build --env=prod` then `environment.prod.ts` will be used instead.
// The list of which env maps to which file can be found in `.angular-cli.json`.


export const environment = {
	production: false,
	API_ENDPOINT: 'http://communitytheapp.com/community/services/index.php/adminController/',
    //API_ENDPOINT: 'http://192.168.88.2:8434/community/services/index.php/adminController/',
    //API_ENDPOINT: 'http://communitytheapp.com/community_demo/services/index.php/adminController/',
    //API_ENDPOINT: 'http://communitytheapp.com/community_demo/services/index.php/adminController/',//'http://192.168.88.94/community1/AdminController/',
    firebase: {
	    apiKey: "AIzaSyBjfSJjJAGt83SvmRZjLh3Zg4wK3mnfwDw",
	    authDomain: "communiti-5940c.firebaseapp.com",
	    databaseURL: "https://communiti-5940c.firebaseio.com",
	    projectId: "communiti-5940c",
	    storageBucket: "communiti-5940c.appspot.com",
	    messagingSenderId: "788350046844"
    }
};
