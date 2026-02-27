namespace Watchdoggy;

[Register ("AppDelegate")]
public class AppDelegate : UIApplicationDelegate {
	public override bool FinishedLaunching (UIApplication application, NSDictionary? launchOptions)
	{
		Console.WriteLine ("Watchdoggy: FinishedLaunching — exiting with code 0");
		Environment.Exit (0);
		return true;
	}
}
