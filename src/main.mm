/*
 *  RetroScreen
 *
 *  Created by Mike Tucker http://www.mike-tucker.com
 *  Published 2011 CreativeApplications.Net http://www.creativeapplications.net
 *  
 *	licensed under a Creative Commons License – Attribution 3.0 Unported (CC BY 3.0)
 *  http://creativecommons.org/licenses/by/3.0/
 *  
 */

#include "ofMain.h"
#include "testApp.h"

int main(){
	//ofSetupOpenGL(1024,768, OF_FULLSCREEN);			// <-------- setup the GL context
	//
	//	ofRunApp(new testApp);
	
	ofAppiPhoneWindow * iOSWindow = new ofAppiPhoneWindow();
	
	iOSWindow->enableRetinaSupport();
	
	ofSetupOpenGL(iOSWindow, 480, 320, OF_FULLSCREEN);
	ofRunApp(new testApp);
}
