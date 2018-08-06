/**
 * @providesModule BeaconBroadcast
 * @flow
 */
'use strict';
import React from 'react';
import {
    NativeModules,
} from 'react-native';

const NativeBeacontransmit = NativeModules.RNIBeacontransmit;

const iBeaconBroadcast = {
    checkTransmissionSupported: function() {
        return new Promise((resolve, reject) => {
            NativeBeacontransmit.checkTransmissionSupported(function(result) {
                const errors = {
                    1: 'NOT_SUPPORTED_MIN_SDK',
                    2: 'NOT_SUPPORTED_BLE',
                    3: 'DEPRECATED_NOT_SUPPORTED_MULTIPLE_ADVERTISEMENTS',
                    4: 'NOT_SUPPORTED_CANNOT_GET_ADVERTISER',
                    5: 'NOT_SUPPORTED_CANNOT_GET_ADVERTISER_MULTIPLE_ADVERTISEMENTS'
                }
                if (result === 0) {
                    resolve()
                } else {
                    reject(errors[result])
                }
            });
        });
    },
    startAdvertisingBeaconWithString: function (uuid, identifier, major, minor) {
        NativeBeacontransmit.startSharedAdvertisingBeaconWithString(uuid, major, minor, identifier);
    },

    stopAdvertisingBeacon: function () {
        NativeBeacontransmit.stopSharedAdvertisingBeacon();
    },
};

export default iBeaconBroadcast;
