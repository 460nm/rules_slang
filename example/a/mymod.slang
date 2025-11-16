module mymod;

import b.othermod;

public float2 make_triangle(uint vertexId) {
  float half = get_half();
  float x = (vertexId == 0) ? -half : ((vertexId == 1) ? half : 0.0);
  float y = (vertexId == 2) ? half : -half;
  return float2(x, y);
}
