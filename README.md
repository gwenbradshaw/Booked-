README.md
Booked! 📅

Booked! is a high-performance lifestyle manager designed to bridge the gap between your fitness goals, academic or professional responsibilities, and daily life. Built natively for iOS, it offers a sleek, intuitive interface to help you stay organized without the clutter.

🌟 Key Features
The Iron Room (Fitness Tracking)
Stop using notes apps for your PRs. The Gym Module is built for serious training.

Custom Workout Logs: Track every lift, set, and rep with ExerciseView.

Dynamic Split Selection: Quickly choose between your workout days (like Quads, Glutes, or Upper Body).

Progressive Loading: Use SetRowView to log your intensity and ensure you're hitting your goals.

🧠 The Task Matrix (Smart Prioritization)
Not all tasks are created equal. Instead of a boring list, Booked! uses a Priority Matrix to help you visualize what actually matters.

Urgent vs. Important: Automatically sort your to-dos so you focus on high-impact work first.

The "Brain Dump": Got a million things on your mind? Toss them into the BrainDumpView instantly and organize them later when you have the headspace.

🎓 Academic & Career Dashboards
Keep your "Student Life" and "Work Life" separate but accessible.

School Dashboard: A dedicated space for your classes, assignments, and due dates.

Work Dashboard: Track professional projects and milestones in a focused environment.

Calendar: Classic IOS calendar. Toggle "Mark as Special Event" to have it come up in "Events" as a list of your most important events coming up!

🛒 Smart Groceries & Custom Routines
Self-Organizing Lists: Add items to Dairy, Meat, or Produce. Need a "Supplements" or "Home Goods" section? Create your own categories on the fly.

Timeline Routine: Map out your day-to-day timeline (e.g., 7:00 AM: Pre-workout) so your habits become second nature.

📝 Notes & Recommendations
Quick Notes: Use NoteDetailView for everything from lecture points to sociological analyses of your favorite shows.

🛠 Built With
SwiftUI: For a smooth, "buttery" native feel.

SwiftData & AppStorage: Your data stays on your device—fast, private, and always available.

SF Symbols: A clean, modern look that matches the iOS aesthetic.

Consumer use:
You will need a Mac with Xcode 26 and a USB cable.

1. Clone the Project
Open Terminal on your Mac and run:

Bash
git clone https://github.com/gwenbradshaw/Booked-
Or, simply download the ZIP from this GitHub page and unzip it.

2. Open in Xcode
Double-click Booked!.xcodeproj to open the project.

If Xcode asks to "Trust and Open," click Trust.

3. Set Up Your Signing
Because this code was written by me, you need to tell Xcode to run it under your identity:

In the left sidebar, click the blue Booked! project icon at the very top.

Go to the Signing & Capabilities tab.

Under Team, click "Add Account" and sign in with your Apple ID.

Change the Bundle Identifier to something unique (e.g., com.yourname.booked.app) so it doesn't clash with my version.

4. Run on Your iPhone
Connect your iPhone to your Mac via cable.

In the top toolbar of Xcode, click the "Device" menu and select your physical iPhone.

Press the Play (Run) button (or Cmd + R).

On your iPhone:

Go to Settings > Privacy & Security > Developer Mode and turn it On (requires a restart).

Go to Settings > General > VPN & Device Management, tap your Apple ID, and select "Trust".

⚠️ The Only Rule
Since you are using a free Apple ID, the app will expire every 7 days. When it stops opening, just plug your phone back into your Mac and hit the Play button in Xcode again. Your data (workouts, groceries, etc.) will not be deleted when you do this!

Developer Use: 
Clone the Repo: git clone https://github.com/yourusername/booked.git

Open in Xcode: Ensure you are using Xcode 26 to support the latest iOS features.

1. Prerequisites
Hardware: An iPhone running iOS 19 or later and a Mac with Xcode 26.

3. Enable Developer Mode on iPhone
Apple requires an explicit "opt-in" to run custom apps:

On your iPhone, go to Settings > Privacy & Security.

Scroll to the bottom and tap Developer Mode.

Toggle the switch On and restart your phone when prompted.

After the restart, tap Turn On and enter your passcode.

3. Connect and Configure Xcode
Connect your iPhone to your Mac via USB-C or Lightning cable.

Open the Booked!.xcodeproj project in Xcode.

Setup Signing: * Select the Booked! project in the Project Navigator (the blue icon at the top left).

Go to the Signing & Capabilities tab.

Under "Team," click Add Account and sign in with your Apple ID.

Xcode will automatically generate a "Development Provisioning Profile."

Select Target: In the top toolbar of Xcode, click the "Device" menu (next to the Play button) and select your physical iPhone.

4. Build and Run
Press Command + R or click the Play button.

Trust the Developer: The first time you run it, the app might not open. Go to Settings > General > VPN & Device Management, tap your Apple ID, and select "Trust [Your Email]".

The app will now launch and stay on your phone!

⚠️ Note on Expiration: Using a free Apple ID means the app will "expire" every 7 days. To keep using it, simply plug your phone back into your Mac once a week and hit Run in Xcode again to refresh the certificate.
