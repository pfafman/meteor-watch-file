Package.describe({
  summary: "Add Watch to meteor",
  version: "0.1.0",
  git: "https://github.com/pfafman/meteor-watch-file.git"
});


Package.on_use(function (api) {
  api.versionsFrom("METEOR@1.0");

  api.use([
    'underscore',
    'coffeescript',
  ], ['client', 'server']);

  api.use([
    'templating',
    'mongo'
  ], ['client']);

  api.add_files([
    'server.coffee'
  ], 'server');

  api.add_files([
    'style.css',
    'client.html',
    'client.coffee',
  ], 'client');

  api.add_files([
    'common.coffee'
  ], ['client', 'server']);
});

Package.on_test(function (api) {
  api.use(['pfafman:watch', 'tinytest', 'test-helpers'], 'server');
  api.add_files('tests.js', 'server');
});