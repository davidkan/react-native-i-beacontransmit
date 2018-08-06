
package com.reactlibrary;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

public class RNIBeacontransmitModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNIBeacontransmitModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }
 private static final String TAG = "iBeaconBroadcast";
  private final ReactApplicationContext context;
  private static android.content.Context applicationContext;
  private static final String SUPPORTED = "SUPPORTED";
	private static final String NOT_SUPPORTED_MIN_SDK = "NOT_SUPPORTED_MIN_SDK";
	private static final String NOT_SUPPORTED_BLE = "NOT_SUPPORTED_BLE";
	private static final String NOT_SUPPORTED_CANNOT_GET_ADVERTISER_MULTIPLE_ADVERTISEMENTS = "NOT_SUPPORTED_CANNOT_GET_ADVERTISER_MULTIPLE_ADVERTISEMENTS";
	private static final String NOT_SUPPORTED_CANNOT_GET_ADVERTISER = "NOT_SUPPORTED_CANNOT_GET_ADVERTISER";
	private static BeaconTransmitter beaconTransmitter = null;

  public iBeaconBroadcast(ReactApplicationContext reactContext) {
    super(reactContext);
    this.context = reactContext;
  }


@Override
	public Map<String, Object> getConstants() {
		final Map<String, Object> constants = new HashMap<>();
		constants.put(SUPPORTED, BeaconTransmitter.SUPPORTED);
		constants.put(NOT_SUPPORTED_MIN_SDK, BeaconTransmitter.NOT_SUPPORTED_MIN_SDK);
		constants.put(NOT_SUPPORTED_BLE, BeaconTransmitter.NOT_SUPPORTED_BLE);
		constants.put(NOT_SUPPORTED_CANNOT_GET_ADVERTISER_MULTIPLE_ADVERTISEMENTS, BeaconTransmitter.NOT_SUPPORTED_CANNOT_GET_ADVERTISER_MULTIPLE_ADVERTISEMENTS);
		constants.put(NOT_SUPPORTED_CANNOT_GET_ADVERTISER, BeaconTransmitter.NOT_SUPPORTED_CANNOT_GET_ADVERTISER);
		return constants;
	}

  @Override
  public String getName() {
    return TAG;
  }

  @ReactMethod
	public void checkTransmissionSupported(Callback cb) {
		int result = BeaconTransmitter.checkTransmissionSupported(context);
		cb.invoke(result);
	}

  @ReactMethod
  public void startSharedAdvertisingBeaconWithString(String uuid, int major, int minor,String identifier) {
		int manufacturer = 0x4C;
		Beacon beacon = new Beacon.Builder()
				.setId1(uuid)
				.setId2(String.valueOf(major))
				.setId3(String.valueOf(minor))
				.setManufacturer(manufacturer)
				.setBluetoothName(identifier)
				.setTxPower(-59)
				.build();
		BeaconParser beaconParser = new BeaconParser()
				.setBeaconLayout("m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24");
		this.beaconTransmitter = new BeaconTransmitter(context, beaconParser);
		this.beaconTransmitter.startAdvertising(beacon, new AdvertiseCallback() {

			@Override
			public void onStartFailure(int errorCode) {
				Log.d("ReactNative", "Error from start advertising " + errorCode);
			}

			@Override
			public void onStartSuccess(AdvertiseSettings settingsInEffect) {
				Log.d("ReactNative", "Success start advertising");
			}
		});
  }

  @ReactMethod
  public void stopSharedAdvertisingBeacon() {
		if(this.beaconTransmitter != null) {
			try {
				this.beaconTransmitter.stopAdvertising();
			} catch (Exception ex) {
			}
		}
  }
}
  @Override
  public String getName() {
    return "RNIBeacontransmit";
  }
}
