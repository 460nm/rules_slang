module mymod;

public float2 make_triangle(uint vertexId) {
  float x = (vertexId == 0) ? -0.5 : ((vertexId == 1) ? 0.5 : 0.0);
  float y = (vertexId == 2) ? 0.5 : -0.5;
  return float2(x, y);
}
