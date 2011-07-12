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

#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"

typedef struct {
	float vx;
	float vy;
	float r;
	float 	x;
	float 	y;
	int 	touchId;
	bool	mouseDown;
	
}	Vertex;


class testApp : public ofxiPhoneApp {
	
public:
	int style;
	int totalStyles;
	
	float width;
	float height;
	
	void setupCurves();
	void setup();
	
	void update();
	void doMovement(int i);
	
	void exit();
	
	void draw();	
	void drawButton();
	void drawCircles();
	void drawAngles();
	void drawCenterAngles();
	void drawCurves(bool doFill);
	void drawBG(int r);
	
	void incrementStyle();
	void slower();
	
	bool checkTap(float x1,float y1,float x2, float y2);	
	bool checkButton(ofTouchEventArgs &touch);
	
	void touchDown(ofTouchEventArgs &touch);
	void touchDownStyle1(ofTouchEventArgs &touch);
	
	void touchMoved(ofTouchEventArgs &touch);
	void touchUp(ofTouchEventArgs &touch);
	void touchDoubleTap(ofTouchEventArgs &touch);
	
	
	void killTap(int t);
	
	int colorAr[99];
	int count;
	ofImage bg;
	
	int nVertices;
	Vertex vertices[32];
	
	int nSwarm;
	Vertex swarm[500];
	
	Vertex nextButton;
	Vertex minusButton;

};


