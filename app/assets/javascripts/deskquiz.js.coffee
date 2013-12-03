#=require ./deskquiz.user

app = angular.module 'deskquiz', ['ngRoute', 'deskquiz.user']

# Rails CSRF protection
app.config ($httpProvider) ->
  authToken = $('meta[name="csrf-token"]').attr('content')
  $httpProvider.defaults.headers.common["X-CSRF-TOKEN"] = authToken

app.config ($locationProvider, $routeProvider) ->
  $locationProvider.html5Mode(true)
  $routeProvider.when '/',
    templateUrl: '/templates/index'
    controller: 'AuthenticationController'
  .when '/quiz',
    templateUrl: '/templates/quiz'
