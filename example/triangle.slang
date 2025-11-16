import a.mymod;

[shader("vertex")]
float4 main(uint vertexID: SV_VertexID) : SV_Position {
  return float4(make_triangle(vertexID), 0.0, 1.0);
}
