#= require ./deskquiz.user
#= require ./deskquiz.quiz

app = angular.module 'deskquiz', ['ngRoute', 'deskquiz.user', 'deskquiz.quiz']

# Rails CSRF protection
app.config ($httpProvider) ->
  authToken = $('meta[name="csrf-token"]').attr('content')
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken

# Disable SCE to simplify quiz layout
app.config ($sceProvider) ->
  $sceProvider.enabled(false)

app.config ($locationProvider, $routeProvider) ->
  $locationProvider.html5Mode(true)
  $routeProvider.when '/',
    templateUrl: '/templates/index'
    controller: 'AuthenticationController'
  .when '/quiz',
    templateUrl: '/templates/quiz'
