/**
 * @providesModule BeaconBroadcast
 * @flow
 */
'use strict';
import React from 'react';
import { NativeModules } from 'react-native';

// const { RNIBeacontransmit } = NativeModules;
const NativeBeacontransmit = NativeModules.RNIBeacontransmit;

const iBeaconBroadcast = {
    startAdvertisingBeaconWithString: function (uuid, identifier, major, minor) {
        NativeBeacontransmit.startSharedAdvertisingBeaconWithString(uuid, major, minor, identifier);
    },

    stopAdvertisingBeacon: function () {
        NativeBeacontransmit.stopSharedAdvertisingBeacon();
    },
};

export default iBeaconBroadcast;
