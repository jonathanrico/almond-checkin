Check-In Expansion Pack for Almond
===

This expansion pack enables Check-In Learning Activities for Almond

---
###Installation :

1. Install the latest managed version of almond in your org from [here](https://appexchange.salesforce.com/listingDetail?listingId=a0N3000000B5kQTEAZ)
2. Install this expansion pack by using the following [link](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t1a000000TtM0)
3. Update your Custom Almond Permission Set with the following permissions:

  ---
  #####Record type permissions

  - Read access to the CheckIn Record Type in the Learning Object
  - Update the Learning Page Layout Assignments. Make sure the CheckIn record type is associated to the Learning CheckIn layout

  ---
  #####Object, Field and Visualforce permissions

  - CRUD, View all and Modify all access to the CheckIn object
  - Read/Edit access to all fields in the CheckIn object
  - Read/Edit access to the CheckIn field in the Learning Version object
  - Access to the almondcheckins.CheckInViewer Visualforce page

###How to use the expansion pack :

Go to the Learnings tab, click "New" and select the CheckIn record type

![Step1](http://googledrive.com/host/0B9dTGJKm2yPVfmRhYzNHUWxneGo5MEtqdURsZ2ljVGVKQURWUGJCb293ZFNHTENvcG9NYU0/s1.png)

Set the name and duration for your Check-In learning

![Step2](http://googledrive.com/host/0B9dTGJKm2yPVfmRhYzNHUWxneGo5MEtqdURsZ2ljVGVKQURWUGJCb293ZFNHTENvcG9NYU0/s2.png)

Proceed to create the Check-In learning content using the related list under the Learning object

![Step3](http://googledrive.com/host/0B9dTGJKm2yPVfmRhYzNHUWxneGo5MEtqdURsZ2ljVGVKQURWUGJCb293ZFNHTENvcG9NYU0/s3.png)

Set the latitude, longitude and mile radius for the Check-In location

![Step4](http://googledrive.com/host/0B9dTGJKm2yPVfmRhYzNHUWxneGo5MEtqdURsZ2ljVGVKQURWUGJCb293ZFNHTENvcG9NYU0/s4.png)

Go back to the Learning object and click the Preview button to test your check-in activity

![Step5](http://googledrive.com/host/0B9dTGJKm2yPVfmRhYzNHUWxneGo5MEtqdURsZ2ljVGVKQURWUGJCb293ZFNHTENvcG9NYU0/s5.png)

Click "Preview" in the Check-In content you just created

![Step6](http://googledrive.com/host/0B9dTGJKm2yPVfmRhYzNHUWxneGo5MEtqdURsZ2ljVGVKQURWUGJCb293ZFNHTENvcG9NYU0/s6.png)

Once the page loads, make sure you allow access to your computer's location

![Step7a](http://googledrive.com/host/0B9dTGJKm2yPVfmRhYzNHUWxneGo5MEtqdURsZ2ljVGVKQURWUGJCb293ZFNHTENvcG9NYU0/s7a.png)

The check-in viewer will load showing your location and the location at which you must check-in

![Step7b](http://googledrive.com/host/0B9dTGJKm2yPVfmRhYzNHUWxneGo5MEtqdURsZ2ljVGVKQURWUGJCb293ZFNHTENvcG9NYU0/s7b.png)

You can proceed to publish and add this learning as usual. Expansion pack learnings will display a "Play" icon in the Training Plan detail page

![Step8](http://googledrive.com/host/0B9dTGJKm2yPVfmRhYzNHUWxneGo5MEtqdURsZ2ljVGVKQURWUGJCb293ZFNHTENvcG9NYU0/s8.png)

---

###Developers :

#### How to deploy the application :

1. Make sure ant is installed in your local box
2. Update your credentials

Make a copy of the sample-sfdc-build.properties file and rename it to "sfdc-build.properties"

#### How to deploy the application using Ant :

1. Update the local-build.properties with your credentials.
   **NOTE: If you're building against a Sandbox or Production environment, set the "guestLicense" property to empty**
2. Navigate to the build folder using the terminal or command prompt
3. If you're using **OS X** run the following command : `sh build.sh`
5. If you want to run the ant target directly use the following command : `ant deploy -DrunAllTests=false -DcheckOnly=false
