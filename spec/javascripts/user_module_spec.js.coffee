#= require angular
#= require angular-mocks
#= require deskquiz.user

describe 'the deskquiz.user module', ->
  beforeEach module('deskquiz.user')

  describe 'authentication', ->
    [$httpBackend] = [undefined]

    beforeEach inject (_$httpBackend_) ->
      $httpBackend = _$httpBackend_

    afterEach ->
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()

    it 'returns a promise resolving to the user data when successful', inject (authentication) ->
      postData = username: 'user', password: 'pass'
      userData = username: 'user'
      $httpBackend.expectPOST('/api/session', postData)
        .respond(201, userData)

      promise = authentication.login('user', 'pass')
      success = jasmine.createSpy('success')
      failure = jasmine.createSpy('failure')
      promise.then(success, failure)
      $httpBackend.flush()
      expect(success).toHaveBeenCalledWith(userData)
      expect(failure).not.toHaveBeenCalled()

    it 'returns a promise rejected with an error message when unsuccessful', inject (authentication) ->
      postData = username: 'user', password: 'badpass'
      $httpBackend.expectPOST('/api/session', postData)
        .respond(401)

      promise = authentication.login('user', 'badpass')
      success = jasmine.createSpy('success')
      failure = jasmine.createSpy('failure')
      promise.then(success, failure)
      $httpBackend.flush()
      expect(success).not.toHaveBeenCalled()
      expect(failure).toHaveBeenCalledWith('Invalid password.')

    it 'logs out', inject (authentication) ->
      $httpBackend.expectDELETE('/api/session')
        .respond(204)

      authentication.logout()
      $httpBackend.flush()

  describe 'AuthenticationController', ->
    [$rootScope, $scope, currentUser, authentication, $controller] = [undefined]

    beforeEach inject (_$rootScope_, _currentUser_, _authentication_, _$controller_) ->
      $rootScope = _$rootScope_
      $scope = $rootScope.$new()
      currentUser = _currentUser_
      authentication = _authentication_
      $controller = _$controller_
      $controller('AuthenticationController', $scope: $scope)

    it 'sets the currentUser service onto the scope', ->
      expect($scope.currentUser).toEqual(currentUser)

    describe 'when logging in', ->
      it 'returns without calling authentication#login if the form is invalid', ->
        spyOn(authentication, 'login').andCallThrough()
        $scope.authForm = $valid: false

        $scope.login()
        expect(authentication.login).not.toHaveBeenCalled()

      it 'calls authentication#login', ->
        spyOn(authentication, 'login').andCallThrough()
        $scope.authForm = $valid: true

        $scope.auth.username = 'username'
        $scope.auth.password = 'password'
        $scope.login()
        expect(authentication.login).toHaveBeenCalledWith('username', 'password')

    describe 'when logging in successfully with #login', ->
      beforeEach inject ($q) ->
        $scope.authForm = $valid: true
        spyOn(authentication, 'login').andCallFake (username, password) ->
          deferred = $q.defer()
          deferred.resolve(username: username)
          deferred.promise

      it 'sets currentUser data', ->
        $scope.auth.username = 'username'
        $scope.login()
        $rootScope.$apply()
        expect(currentUser.username).toEqual('username')

    describe 'when logging in unsuccessfully with #login', ->
      beforeEach inject ($q) ->
        $scope.authForm = $valid: true
        spyOn(authentication, 'login').andCallFake (username, password) ->
          deferred = $q.defer()
          deferred.reject('Invalid password.')
          deferred.promise

      it 'sets an error on the scope', ->
        $scope.login()
        $rootScope.$apply()
        expect($scope.auth.error).toMatch(/invalid/)

    describe 'when logging out with #logout', ->
      beforeEach ->
        spyOn(authentication, 'logout')

      it 'calls #logout on authentication', ->
        currentUser.username = 'user'
        $scope.logout()
        expect(authentication.logout).toHaveBeenCalled()

      it 'clears the currentUser data', ->
        currentUser.username = 'user'
        $scope.logout()
        expect(currentUser.username).toEqual(null)
