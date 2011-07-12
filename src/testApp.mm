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

#include "testApp.h"
#define MAX_SPEED 15.0f

//--------------------------------------------------------------
void testApp::setup(){	
	// register touch events
	//ofRegisterTouchEvents(this);
	
	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	//iPhoneAlerts will be sent to this.
	//ofxiPhoneAlerts.addListener(this);
	
	//If you want a landscape oreintation 
	//iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	
	CGSize s = [[[UIApplication sharedApplication] keyWindow] bounds].size;
	width = ofGetScreenWidth();
	height = ofGetScreenHeight();
	
	count = 0;
	
	//ofRegisterTouchEvents(this);
	ofSetFrameRate(50);
	ofBackground(0,0,0);	
	ofSetBackgroundAuto(false);
	bg.loadImage("bg.gif");
	setupCurves();
	
	totalStyles = 5;
	
	nSwarm = 500;
	int i;
	for (i = 0; i < nSwarm; i++){		
		swarm[i].x = ofRandom(50.0f, width-50.0f);
		swarm[i].y = ofRandom(50.0f, height-50.0f);
		swarm[i].touchId 	= -1;
		swarm[i].vx = 0.0f;
		swarm[i].vy = 0.0f;
		swarm[i].r = .2;
	}
	
	
	nextButton.x = width - 30;
	nextButton.y = 30;
	
	minusButton.x = 30;
	minusButton.y = 30;
	
	for (i=0; i<99; i++) {
		colorAr[i] = ofRandom(0, 255);
	}
	
}

void testApp::doMovement(int i){
	// HANDLE VELOCITY IF NOT DRAGGING
	if(!vertices[i].mouseDown){
		// LIMIT TO MAX SPEED
		if (vertices[i].vy > MAX_SPEED) vertices[i].vy = MAX_SPEED;
		else if (vertices[i].vy < -MAX_SPEED) vertices[i].vy = -MAX_SPEED;
		
		if (vertices[i].vx > MAX_SPEED) vertices[i].vx = MAX_SPEED;
		else if (vertices[i].vx < -MAX_SPEED) vertices[i].vx = -MAX_SPEED;
		
		
		// APPLY VELOCITIY
		vertices[i].x += vertices[i].vx;
		vertices[i].y += vertices[i].vy;
		
		// DAMPEN
		//vertices[i].vx *= .999;
		//vertices[i].vy *= .999;
		
		
		// BOUNCE OFF WALLS IF OUT OF BOUNDS
		if (vertices[i].x > width || vertices[i].x < 0.0f)  vertices[i].vx *= -1;
		if (vertices[i].y > height || vertices[i].y < 0.0f)  vertices[i].vy *= -1;
	}		
}


void testApp::setupCurves(){
	nVertices = 3;
	for (int i = 0; i < nVertices; i++){		
		vertices[i].x = ofRandom(50.0f, width-50.0f);
		vertices[i].y = ofRandom(50.0f, height-50.0f);
		vertices[i].touchId 	= -1;
		vertices[i].vx = ofRandom(-1.0f, 1.0f);
		vertices[i].vy = ofRandom(-1.0f, 1.0f);
	}
}

void testApp::drawButton(){
	ofSetColor(0x666666);
	
	// NEXT
	ofFill();
	ofCircle(nextButton.x, nextButton.y, 3);
	
	// MINUS
	ofLine(minusButton.x-3, minusButton.y-3, minusButton.x+3, minusButton.y+3);
	ofLine(minusButton.x+3, minusButton.y-3, minusButton.x-3, minusButton.y+3);
}

void testApp::drawAngles(){
	ofNoFill();	
	//ofSetColor(0xFFFFFF * rand());
	ofSetColor(ofRandom(0,255), ofRandom(0,255), ofRandom(0,255));
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_COLOR);
	int i;
	for (i = 0; i < nVertices; i++){
		
		doMovement(i);
		
		if(i > 0) ofLine(vertices[i-1].x, vertices[i-1].y, vertices[i].x, vertices[i].y);
	}
	ofLine(vertices[0].x, vertices[0].y, vertices[nVertices-1].x, vertices[nVertices-1].y);
	
}

void testApp::drawCenterAngles(){
	ofNoFill();	
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_COLOR);
	int i;
	for (i = 0; i < nVertices; i++){
		ofSetColor(colorAr[i],colorAr[i*2],colorAr[i*3]);
		
		doMovement(i);
		ofLine(vertices[i].x, vertices[i].y, width * .5f, height * .5f);
	}	
}

void testApp::drawCircles(){
	int i;
	
	ofFill();
	for (i = 0; i < nVertices; i++){
		//ofSetColor(0xFFFFFFFF * rand());
		ofSetColor(ofRandom(0,255), ofRandom(0,255), ofRandom(0,255));
		doMovement(i);
		ofCircle(vertices[i].x, vertices[i].y,2);
	}
}

void testApp::drawCurves(bool doFill){
	//ofSetColor(0xFFFFFF * rand());
	ofSetColor(ofRandom(0,255), ofRandom(0,255), ofRandom(0,255));
	ofBeginShape();
	if(doFill){
		ofFill();
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	} else {
		ofNoFill();
		glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_COLOR);
	}
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	for (int i = 0; i < nVertices; i++){
		
		doMovement(i);
		
		// DRAW CURVES
		if (i == 0){
			ofCurveVertex(vertices[nVertices-1].x, vertices[nVertices-1].y); 
			ofCurveVertex(vertices[0].x, vertices[0].y);
		} else if (i == nVertices-1){
			ofCurveVertex(vertices[i].x, vertices[i].y);
			ofCurveVertex(vertices[0].x, vertices[0].y);
			ofCurveVertex(vertices[1].x, vertices[1].y);
		} else {
			ofCurveVertex(vertices[i].x, vertices[i].y);
		}
	}
	
	ofEndShape();
	
	if(!doFill){
		ofDisableAlphaBlending();	
		ofSetColor(255,255,255);
		for (int i = 0; i < nVertices; i++){	
			ofVertex(vertices[i].x, vertices[i].y);
		}
	}
	
}

//--------------------------------------------------------------
void testApp::update(){
count ++;
}

//--------------------------------------------------------------
void testApp::draw(){
	
	ofEnableAlphaBlending();
	drawButton();
	
	// LOGO
	if(count < 200){
		glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_COLOR);
		bg.draw(0, height - bg.height);
	}
	
	
	switch (style) {
		case 4:
			drawBG(10);
			drawCenterAngles();
			break;	
			
		case 3:
			drawBG(10);
			drawCurves(true);
			break;
			
		case 2:
			drawBG(10);
			drawCircles();
			break;
			
		case 1:
			drawBG(5);
			drawAngles();
			break;
			
		default:
			drawBG(1);
			drawCurves(false);
			break;
			
	}
	
}

void testApp::drawBG(int r){
	if (count % r == 0) {	
		ofSetColor(240,240,240);
		ofFill();
		glBlendFunc(GL_DST_COLOR, GL_ZERO); // MULTIPLY
		ofRect(0,0,width,height);
	}
}

//--------------------------------------------------------------
void testApp::exit(){

}

bool testApp::checkButton(ofTouchEventArgs &touch){
	if (checkTap(touch.x, touch.y, nextButton.x, nextButton.y)){
		incrementStyle();
		return true;
	} 
	
	if (checkTap(touch.x, touch.y, minusButton.x, minusButton.y)){
		killTap(nVertices);
		slower();
		return true;
	} 
	
	return false;
	
}

void testApp::slower(){
	for (int i=0; i<nVertices; i++) {
		vertices[i].vx *= .5;
		vertices[i].vy *= .5;
	}
}

void testApp::incrementStyle(){
	style++;
	if (style >= totalStyles) style = 0;
	
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	ofSetColor(0,0,0);
	ofFill();
	ofRect(0,0,width,height);
	
}

bool testApp::checkTap(float x1,float y1,float x2, float y2){
	float diffx = x1 - x2;
	float diffy = y1 - y2;
	
	if(sqrt(diffx*diffx + diffy*diffy) < 40) return true;
	else return false;
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs &touch){
	
	if(checkButton(touch)) return;
	touchDownStyle1(touch);

}

void testApp::touchDownStyle1(ofTouchEventArgs &touch){
	
	float touchAr[nVertices+1];
	int i;
	
	for (i = 0; i < nVertices; i++){
		
		float diffx = touch.x - vertices[i].x;
		float diffy = touch.y - vertices[i].y;
		float dist = sqrt(diffx*diffx + diffy*diffy);
		
		// IGNORE POINTS FAR AWAY OR ONES ALREADY IN USE
		if (dist > 100 || vertices[i].touchId != -1)
			dist = 1000.0f;
		touchAr[i] = dist;
	}
	
	touchAr[nVertices] = 1000.0f;
	
	// FIND THE NEAREST POINT TO GRAB
	int shortest = nVertices;
	for (i = 0; i < nVertices; i++)
		if (touchAr[i] < touchAr[shortest]) shortest = i;
	
	if (shortest != nVertices){
		vertices[shortest].touchId = touch.id;
		vertices[shortest].vx = 0.0f;
		vertices[shortest].vy = 0.0f;
		vertices[shortest].mouseDown = true;
	}
}


//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs &touch){
	
	for (int i = 0; i < nVertices; i++){
		if (vertices[i].touchId == touch.id){
			
			vertices[i].vx *= .2;
			vertices[i].vy *= .2;
			
			vertices[i].vx += (touch.x - vertices[i].x) * .3f;
			vertices[i].vy += (touch.y - vertices[i].y) * .3f;
			
			vertices[i].x = touch.x;
			vertices[i].y = touch.y;			
			
			
		}
	}

}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs &touch){
	if(nVertices>20) return;
	
	for (int i = 0; i < nVertices; i++){
		if(vertices[i].touchId == touch.id){
			vertices[i].touchId = -1;	
			vertices[i].mouseDown = false;
		}
	}
}

//--------------------------------------------------------------

void testApp::killTap(int t){
	if (nVertices < 4) return;
	
	
	for (int i=0; i < nVertices; i++) {
		if (i > t) {
			vertices[i].x = vertices[i-1].x;
			vertices[i].y = vertices[i-1].y;
			vertices[i].touchId = -1;
			vertices[i].vx = vertices[i-1].vx;
			vertices[i].vy = vertices[i-1].vy;
		}
	}
	nVertices --;
}

void testApp::touchDoubleTap(ofTouchEventArgs &touch){
	for (int i = 0; i < nVertices; i++){
		if(checkTap(touch.x, touch.y, vertices[i].x, vertices[i].y)){
			killTap(i);
			return;
		}
	}
	
	nVertices ++;
	vertices[nVertices-1].touchId 	= -1;
	vertices[nVertices-1].x = touch.x;
	vertices[nVertices-1].y = touch.y;
}

//--------------------------------------------------------------
//void testApp::lostFocus(){
//
//}
//
//--------------------------------------------------------------
//void testApp::gotFocus(){
//
//}
//
//--------------------------------------------------------------
//void testApp::gotMemoryWarning(){
//
//}
//
//--------------------------------------------------------------
//void testApp::deviceOrientationChanged(int newOrientation){
//
//}
//
//
//--------------------------------------------------------------
//void testApp::touchCancelled(ofTouchEventArgs& args){
//
//}

