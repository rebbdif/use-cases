# Pave Sample Admin Dashboard

Sample dashboard to show the capabilities of the Financial insights API. 

## Contents

1. [Getting Started](#getting-started)
1. [Setting up](#setting-up)
1. [Getting Data setup](#getting-data-setup)
1. [Development](#development)
1. [Docker](#docker)

## Getting Started
Make sure you're running node.js version 14 or greater. This project is shipped with a `.devcontainer` folder that takes advantage of the [VS Code Remote Containers](https://code.visualstudio.com/docs/remote/remote-overview) feature. In order to make setup easier, you can use the docker development machine included with this project. 

### Setting up

Once you have node.js set up or once you've logged into the dev container, you need to run `npm install`. This will install the app's dev dependencies. Now you're ready to start modifying the source code. 

Additionally, you need to rename the `.env.sample` file to `.env` by running:

```sh
cp .env.sample .env
```

Then update the `REACT_APP_API_KEY` variable with one you obtained from us. **Waring: Adding the environment variables in this manner is unsecure and will expose your API Key in the browser.** As a result, this demo is only meant to be used in a development capacity. To learn more about environment variables, click [here](https://create-react-app.dev/docs/adding-custom-environment-variables/).

### Getting Data setup
You should also supply `users.json` file. Objects in this file should adhere to the following schema:

```
[ 
  {"name":"Fisher Troy","userId":"user_1"},
  {"name":"Ebert Reece","userId":"user_2"}
]
```

This will allow us to prepopulate the users table on the dashboard. 

## Development

You'll find the following folder structure in the project.

  ```
  ├── .gitignore
  ├── .dockerignore
  ├── package.json
  ├── package-lock.json
  ├── README.md
  ├── Dockerfile
  ├── docker-compose.yml
  ├── build/
  ├── public/
  │   ├── index.html
  │   └── manifest.json
  └── src/
      ├── assets/
      │   ├── img/
      │   └── scss/
      ├── components/
      ├── data/
      ├── layouts/
      ├── pages/
      ├── redux/
      ├── routes/
      ├── vendor/
      ├── App.js
      └── index.js
  ```

 The main part of the dashboard is located in `src/dashboards/pages/Pave`. This should be your entry point to start changing the dashboard.

### `npm start`

Runs the app in the development mode.<br>
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

The page will reload if you make edits.<br>
You will also see any lint errors in the console.

### Working with the API

The main code for interacting with the API can be found in `src/redux/actions/apiActions.js`. This app uses `react-redux` to manage state changes. You can read learn more about it [here](https://react-redux.js.org/).


## Docker
You can also run the up using docker. 
