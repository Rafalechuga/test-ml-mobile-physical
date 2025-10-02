# test-ml-mobile-physical
Test for the Mercado Libre app on a physical device



PREREQUISITES

Grant execution permissions to the scripts:

	chmod +x scripts/*.sh

The project contains the following scripts:

├── scripts
│   ├── debug-system.sh             # Clean and debug the system before or after execution (e.g., clean Appium web sockets)
│   ├── download-appium-inspector.sh # Download and configure the GUI for Appium Inspector
│   ├── find_activity.sh             # Find the activity of the Mercado Libre app
│   ├── install-prerequisites.sh     # Install and configure the required programs on your machine
│   ├── launch-appium-inspector.sh   # Launch the Appium Inspector GUI
│   ├── run-physical-tests.sh        # Run feature tests
│   └── test_activity.sh             # Find the activity of the Mercado Libre app


If you only want to run the features, execute the scripts in the following order:

	install-prerequisites.sh

	run-physical-tests.sh

CONSIDERATIONS

For the phone used in the tests:

	1:The Mercado Libre app must be installed beforehand.

	2:The phone must be connected via USB with developer options enabled (USB debugging must also be enabled).

 	3:The device used in the tests must have a screen resolution close to 1080 x 2340 pixels (6.5").

		Note: The phone used during development was a Samsung A15 with Android 15.This project is theoretically capable of detecting and running on other devices automatically, but this has not been fully tested on different phones.

		If the program does not recognize your device, you can manually configure it in env.rb with the following structure:

			{
			  platformName: 'Android',
			  platformVersion: ENV['PLATFORM_VERSION'] || '15',
			  deviceName: ENV['DEVICE_NAME'] || 'SM_A155M',
			  automationName: 'UiAutomator2',
			  appPackage: ENV['APP_PACKAGE'] || 'com.mercadolibre',
			  appActivity: ENV['APP_ACTIVITY'] || '.splash.SplashActivity',
			  noReset: false,
			  fullReset: false,
			  autoGrantPermissions: true,
			  newCommandTimeout: 60,
			  udid: ENV['DEVICE_UDID'] || 'RF8X10AAL8X',
			  systemPort: ENV['SYSTEM_PORT'] || 8200,
			  uiautomator2ServerLaunchTimeout: 60000,
			  disableWindowAnimation: true,
			  skipUnlock: true,
			  ignoreHiddenApiPolicyError: true,
			  enforceAppInstall: false
			}


For the PC used in the tests:

	1:The entire project was developed on Linux (Debian-based distributions). If you are using another OS, the necessary adjustments must be applied accordingly.
