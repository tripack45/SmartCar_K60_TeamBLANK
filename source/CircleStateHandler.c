void CircleStateHandler(struct controlStateStruct* state){
  if (state->lineMSE < MSE_RATIO * state->circleMSE){
    //TODO: LinearStateHandler(state);
    //return;
  }else{
    s32 offset;
    s16 theta;
    s16 speed;
    s8 direction = 1;
    offset=Isqrt((state->carPosX-state->circleX)^2+(state->carPosY-state->circleY)^2)-state->circleRadius;
    if (offset < OFFSET_THRES && offset > -OFFSET_THRES){
      theta = direction * CURVE_DIR_RATIO / state->circleRadius + OFFSET_DIR_RATIO * offset;
      if (theta > DIR_MAX || theta < -DIR_MAX){
        currdir = direction * DIR_MAX;
        currspd = BASIC_SPD;
        return;
      }
	  speed = floor(CURVE_SPD_RATIO * state->circleRadius - OFFSET_SPD_RATIO * offset + BASIC_SPD);
      if (speed > SPD_MAX) speed = SPD_MAX;
      if (speed < SPD_MIN) speed = SPD_MIN;
      currdir = theta;
      currspd = speed;
      return;
    }
    if (offset < 0){
      currdir = 0;
      currspd = SPD_MAX;
      return;
    }else{
      currdir = direction * DIR_MAX;
      currspd = SPD_MIN;
      return;
    }
  }
}