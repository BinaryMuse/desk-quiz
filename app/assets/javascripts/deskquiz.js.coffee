#=require ./deskquiz.user

app = angular.module 'deskquiz', ['ngRoute', 'deskquiz.user']

app.config ($locationProvider, $routeProvider) ->
  $locationProvider.html5Mode(true)
  $routeProvider.when '/',
    templateUrl: '/templates/index'
    controller: 'AuthenticationController'
