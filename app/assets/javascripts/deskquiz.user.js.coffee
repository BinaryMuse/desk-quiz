mod = angular.module 'deskquiz.user', []

mod.value 'currentUser', { username: null }

mod.factory 'authentication', ($http, $q) ->
  login: (username, password) ->
    deferred = $q.defer()
    $http.post('/api/session', username: username, password: password)
      .success (data) =>
        deferred.resolve(data)
      .error =>
        deferred.reject('Invalid password.')
    deferred.promise

  logout: ->
    $http.delete('/api/session')

mod.controller 'AuthenticationController', ($scope, authentication, currentUser) ->
  $scope.currentUser = currentUser
  $scope.auth =
    username: ''
    password: ''
    error: ''

  $scope.login = ->
    return unless $scope.authForm.$valid
    success = (data) -> currentUser.username = data.username
    failure = -> $scope.auth.error = 'That password is invalid.'
    authentication.login($scope.auth.username, $scope.auth.password)
      .then(success, failure)

  $scope.logout = ->
    authentication.logout()
    currentUser.username = null
