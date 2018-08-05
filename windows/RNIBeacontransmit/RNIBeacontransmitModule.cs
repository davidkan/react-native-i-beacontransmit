using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace I.Beacontransmit.RNIBeacontransmit
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNIBeacontransmitModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNIBeacontransmitModule"/>.
        /// </summary>
        internal RNIBeacontransmitModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNIBeacontransmit";
            }
        }
    }
}
