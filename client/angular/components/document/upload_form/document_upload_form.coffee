Records = require 'shared/services/records.coffee'

angular.module('loomioApp').directive 'documentUploadForm', ->
  scope: {model: '='}
  restrict: 'E'
  templateUrl: 'generated/components/document/upload_form/document_upload_form.html'
  replace: true
  controller: ($scope, $element) ->

    $scope.$on 'filesPasted', (_, files) -> $scope.files = files
    $scope.$watch 'files',               -> $scope.upload($scope.files)

    $scope.upload = ->
      return unless $scope.files
      $scope.model.setErrors({})
      $scope.$emit 'processing'
      for file in $scope.files
        Records.documents.upload(file, $scope.progress)
                         .then($scope.success, $scope.failure)
                         .finally($scope.reset)

    $scope.selectFile = ->
      $element.find('input')[0].click()

    $scope.progress = (progress) ->
      return unless progress.total > 0
      $scope.percentComplete = Math.floor(100 * progress.loaded / progress.total)
      $scope.$apply()

    $scope.abort = ->
      Records.documents.abort()

    $scope.success = (response) ->
      $scope.$emit 'documentAdded', Records.documents.find(response.documents[0].id)

    $scope.failure = (response) ->
      $scope.model.setErrors(response.data.errors)

    $scope.reset = ->
      $scope.$emit 'doneProcessing'
      $scope.files = null
      $scope.percentComplete = 0
    $scope.reset()
