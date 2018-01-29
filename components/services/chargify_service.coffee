AppConfig = require 'shared/services/app_config.coffee'
Session   = require 'shared/services/session.coffee'

_      = require 'lodash'
moment = require 'moment'

angular.module('loomioApp').factory 'ChargifyService', ->
  new class ChargifyService

    chargifyUrlFor: (group, kind) ->
      "#{@chargify().host}#{@chargify().plans[kind].path}?#{@encodedParams(group)}"

    encodedParams: (group) ->
      params =
        first_name:   Session.user().firstName()
        last_name:    Session.user().lastName()
        email:        Session.user().email
        organization: group.name
        reference:    "#{group.key}-#{moment().unix()}"

      _.map(_.keys(params), (key) ->
        encodeURIComponent(key) + "=" + encodeURIComponent(params[key])
      ).join('&')

    chargify: ->
      AppConfig.pluginConfig('loomio_org_plugin').config.chargify
