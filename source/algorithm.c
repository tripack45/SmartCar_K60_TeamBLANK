#include "includes.h"

BoundaryDetector boundary_detector;
GuideGenerator guide_generator;
DirectionPID dir_pid;

void t(){
  boundary_detector.LBound[1]=0;
}